unit ATransferencia;

{          Autor: Sergio
    Data Criação: 19/10/1999;
          Função: Cadastrar um novo Caixa
  Data Alteração:
    Alterado por:
Motivo alteração:
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Componentes1, ExtCtrls, PainelGradiente, BotaoCadastro, Constantes,
  StdCtrls, Buttons, Db, DBTables, Tabela, Mask, DBCtrls, Grids, DBGrids,
  DBKeyViolation, Localizacao, UnCaixa, UnBancario, ComCtrls, UnComandosAUT;

type
  TFTransferencia = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    Localiza: TConsultaPadrao;
    PanelColor2: TPanelColor;
    NTransfere: TNotebook;
    PanelColor1: TPanelColor;
    CaixaLabel: TLabel;
    BCaixa: TSpeedButton;
    Label1: TLabel;
    LTipoOpera: TLabel;
    BTipoOpera: TSpeedButton;
    Label3: TLabel;
    ECaixa: TEditLocaliza;
    BTransfereCaixa: TBitBtn;
    BitBtn1: TBitBtn;
    ETipoOperacao: TEditLocaliza;
    PBancos: TPanelColor;
    Label32: TLabel;
    Label28: TLabel;
    BConta: TSpeedButton;
    Label26: TLabel;
    Label4: TLabel;
    SpeedButton1: TSpeedButton;
    LPlano: TLabel;
    SpeedButton2: TSpeedButton;
    Label6: TLabel;
    BTransfereBanco: TBitBtn;
    EConta: TEditLocaliza;
    ENumeroDocumento: TEditColor;
    EData: TCalendario;
    BitBtn2: TBitBtn;
    EOBancaria: TEditLocaliza;
    EPlano: TEditColor;
    Label2: TLabel;
    CTransfere: TComboBoxColor;
    Label5: TLabel;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BBAjuda: TBitBtn;
    Aux: TQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ECaixaSelect(Sender: TObject);
    procedure BTransfereCaixaClick(Sender: TObject);
    procedure BTransfereBancoClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ETipoOperacaoSelect(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EPlanoExit(Sender: TObject);
    procedure EPlanoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CTransfereChange(Sender: TObject);
    procedure ECaixaChange(Sender: TObject);
    procedure EContaChange(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
    procedure ECaixaRetorno(Retorno1, Retorno2: String);
  private
    Caixa: TFuncoesCaixa;
    TipoTransferencia: Integer;
    VprCreditoDebito: string;
    Diario, Parcial : integer;
  public
    { Public declarations }
    function CarregaTransferencia(VpaCreditoDebito: string;
      var VpaTipoTranfer, VpaNumeroCaixa, VpaOperacao : Integer;
      var VpaNumeroConta, VpaDocumento: string;
      var VpaDataComp: TDateTime;
      var VpaPlano: string; var OPBanc: string): Boolean;
  end;

var
  FTransferencia: TFTransferencia;
  AUT : TFuncoesAut;
implementation

uses APrincipal, ConstMsg, APlanoConta, funsql, funvalida;

{$R *.DFM}

{ ****************** Na criação do Formulário ******************************** }
procedure TFTransferencia.FormCreate(Sender: TObject);
begin
  AUT := TFuncoesAut.Create;
  Caixa := TFuncoesCaixa.Criar(Self, FPrincipal.BaseDados);
Self.HelpFile := Varia.PathHelp + 'MCAIXA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
  TipoTransferencia := 0;
  NTransfere.PageIndex := 0;
  EData.DateTime := Date;
  CTransfere.Items.Clear;
  if ConfigModulos.Caixa then
    CTransfere.Items.add('Entre caixa');
  if ConfigModulos.Bancario then
    CTransfere.Items.add('Bancária');
  if (not ConfigModulos.Bancario ) or ( not ConfigModulos.Caixa) then
    CTransfere.Items.add('Nenhum');
  CTransfere.ItemIndex := 0;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFTransferencia.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Caixa.Destroy;
  Action := CaFree;
end;

{********************* na abertura do formulario ***************************** }
procedure TFTransferencia.FormShow(Sender: TObject);
begin
  PBancos.Visible := ConfigModulos.Bancario;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                               Localiza
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{************************** select localiza caixa *************************** }
procedure TFTransferencia.ECaixaSelect(Sender: TObject);
begin
  (Sender as TEditLocaliza).ASelectLocaliza.Clear;
  (Sender as TEditLocaliza).ASelectLocaliza.Add(
    ' SELECT NUM_CAIXA, DES_CAIXA, FLA_SALDO_ANTERIOR,Seq_parcial,Seq_Diario ' +
    ' from CAD_CAIXA ' +
    ' where EMP_FIL = ' + IntToStr(Varia.CodigoEmpFil) +
    ' AND DES_CAIXA LIKE ''@%''' +
    ' and FLA_CAIXA_ABERTO = ''S''' + // Aberto.
    ' and FLA_PARCIAL_ABERTO = ''S'' ' +
    ' and NUM_CAIXA <> ' + IntToStr(varia.CaixaPadrao)); // Aberto.
  (Sender as TEditLocaliza).ASelectValida.Clear;
  (Sender as TEditLocaliza).ASelectValida.Add(
    ' SELECT NUM_CAIXA, DES_CAIXA, FLA_SALDO_ANTERIOR,Seq_parcial,Seq_Diario ' +
    ' from CAD_CAIXA CAD' +
    ' where EMP_FIL = ' + IntToStr(Varia.CodigoEmpFil) +
    ' and NUM_CAIXA = @' +
    ' and FLA_CAIXA_ABERTO = ''S''' + // Aberto.
    ' and FLA_PARCIAL_ABERTO = ''S'' ' +
    ' and NUM_CAIXA <> ' + IntToStr(varia.CaixaPadrao) ); // Aberto.
end;

{************************** select operacao bancaria ************************* }
procedure TFTransferencia.ETipoOperacaoSelect(Sender: TObject);
begin
  ETipoOperacao.ASelectLocaliza.Clear;
  ETipoOperacao.ASelectLocaliza.Add(
    ' SELECT * FROM CAD_TIPO_OPERA ' +
    ' WHERE DES_OPERACAO LIKE ''@%'' ' +
    ' AND FLA_TIPO = ''S'' ' + // SANGRIA OU SUPRIMENTO;
    ' AND CREDITO_DEBITO = ''' + VprCreditoDebito + '''');
  ETipoOperacao.ASelectValida.Clear;
  ETipoOperacao.ASelectValida.Add(
    ' SELECT * FROM CAD_TIPO_OPERA ' +
    ' WHERE COD_OPERACAO = @ ' +
    ' AND FLA_TIPO = ''S'' ' + // SANGRIA OU SUPRIMENTO;
    ' AND CREDITO_DEBITO = ''' + VprCreditoDebito + '''');
end;

{******************* localiza plano de conta ******************************** }
procedure TFTransferencia.EPlanoExit(Sender: TObject);
var
  VpfCodigo : string;
begin
  FPlanoConta := TFPlanoConta.criarSDI(Self, '', True);
  VpfCodigo := EPlano.Text;
  if not FPlanoConta.verificaCodigo( VpfCodigo, '', LPlano, false,(Sender is TSpeedButton)) then
    EPlano.SetFocus;
  EPlano.text := VpfCodigo;
end;

{************** botao que localiza plano de conta **************************** }
procedure TFTransferencia.EPlanoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 114 then
    EPlanoExit(SpeedButton2);
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                               Botoes
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{******************** ok na transferencia de caixa *************************** }
procedure TFTransferencia.BTransfereCaixaClick(Sender: TObject);
var
  senha, senhaDigitada : string;
begin
  if Config.SenhaTransfCaixa then
  begin
    AdicionaSQLAbreTabela(aux,' select * from  crp_parcial par, cadusuarios usu ' +
                              ' where  ' +
                              ' seq_diario = ' +  inttostr(Diario) +
                              ' and seq_parcial = ' + inttostr(parcial) +
                              ' and par.cod_usuario = usu.i_cod_usu ');
    senha := aux.fieldbyname('c_sen_usu').AsString;
    senha := Descriptografa(senha);
    if Entrada( 'Digite senha','Digite a senha do usuário do caixa ' + CaixaLabel.caption, senhaDigitada,
                true,FPrincipal.CorFoco.AFundoComponentes, FPrincipal.CorForm.ACorPainel) then
      if Uppercase(trim(senha)) = Uppercase(trim(senhaDigitada)) then
      begin
        TipoTransferencia := 1;
        Close;
      end
      else
        aviso('Senha inválida');
   end
   else
   begin
     TipoTransferencia := 1;
     Close;
   end;
end;

{******************** ok na transferencia de banco *************************** }
procedure TFTransferencia.BTransfereBancoClick(Sender: TObject);
begin
  TipoTransferencia := 2;
  Close;
end;

procedure TFTransferencia.BitBtn3Click(Sender: TObject);
begin
  TipoTransferencia := 3;
  Close;
end;

{******************** cancela a operacao ************************************ }
procedure TFTransferencia.BitBtn1Click(Sender: TObject);
begin
  TipoTransferencia := 0;
  Close;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                            Operacoes
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{ ************* carrega e rotornas os dados ********************************** }
function TFTransferencia.CarregaTransferencia(VpaCreditoDebito: string;
                         var VpaTipoTranfer, VpaNumeroCaixa, VpaOperacao : Integer;
                         var VpaNumeroConta, VpaDocumento: string;
                         var VpaDataComp: TDateTime;
                         var VpaPlano: string; var OPBanc: string): Boolean;
begin
  if (VpaCreditoDebito) = 'C' then
    VprCreditoDebito := 'D'
  else
    VprCreditoDebito := 'C'; // Inverte;
  Self.ShowModal; // Mostra.

  Result := TipoTransferencia <> 0;
  VpaTipoTranfer := TipoTransferencia; // 1 - caixa, 2 - banco 3 nenhum

  if Result then
  begin
    if TipoTransferencia = 1 then
    begin
      VpaNumeroCaixa := StrToInt(ECaixa.Text);
      VpaOperacao := StrToInt(ETipoOperacao.Text);
    end;

    if TipoTransferencia = 2 then
    begin
      OPBanc := EOBancaria.Text;
      VpaPlano := EPlano.Text;
      VpaNumeroConta := EConta.Text;
      VpaDocumento := ENumeroDocumento.Text;
      VpaDataComp := EData.Date;
    end;
  end;
end;

{****************** muda tela de tranferencia ******************************** }
procedure TFTransferencia.CTransfereChange(Sender: TObject);
begin
  if CTransfere.Text = 'Entre caixa' then
    NTransfere.PageIndex := 0
  else
    if CTransfere.Text = 'Bancária' then
      NTransfere.PageIndex := 1
    else
      NTransfere.PageIndex := 2;
end;

{************** valida gravacao do caixa *********************************** }
procedure TFTransferencia.ECaixaChange(Sender: TObject);
begin
  if (ECaixa.Text = '') or ( ETipoOperacao.Text = '') then
    BTransfereCaixa.Enabled := false
  else
    BTransfereCaixa.Enabled := true;
end;

{************** valida gravacao do banco *********************************** }
procedure TFTransferencia.EContaChange(Sender: TObject);
begin
  if (EConta.Text = '' ) or (ENumeroDocumento.Text = '' ) or
    (EOBancaria.Text = '' ) or (EPlano.Text = '' ) then
    BTransfereBanco.Enabled := false
  else
    BTransfereBanco.Enabled := true;
end;

procedure TFTransferencia.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FTransferencia.HelpContext);
end;

procedure TFTransferencia.ECaixaRetorno(Retorno1, Retorno2: String);
begin
  if Retorno1 <> '' then
  begin
    Diario := strtoint(Retorno1);
    parcial := strtoint(Retorno2);
  end;
end;

Initialization
  RegisterClasses([TFTransferencia]);
end.
