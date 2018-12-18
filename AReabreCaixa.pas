unit AReabreCaixa;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Formularios, UnCaixa, StdCtrls, LabelCorMove, ExtCtrls, Componentes1,
  PainelGradiente, Localizacao, Buttons, Mask, Db, DBTables, numericos,
  DBKeyViolation, UnComandosAUT;

type
  TFReabreCaixa = class(TFormularioPermissao)
    PTitulo: TPainelGradiente;
    PanelColor2: TPanelColor;
    Label3D1: TLabel3D;
    Localiza: TConsultaPadrao;
    BFechar: TBitBtn;
    Tempo: TPainelTempo;
    PAbertura: TPanel;
    Label1: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label2: TLabel;
    CaixaLabel: TLabel;
    LAbertura: TLabel;
    BABCaixa: TSpeedButton;
    LIndicador: TLabel3D;
    ECaixa: TEditLocaliza;
    EUsuario: TEditLocaliza;
    ESenha: TEditColor;
    EDataAbertura: TMaskEditColor;
    BAbrirCaixaGeral: TBitBtn;
    Label3: TLabel;
    EAlteracao: TEditLocaliza;
    SpeedButton1: TSpeedButton;
    Label4: TLabel;
    BBAjuda: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure UsuarioSelect(Sender: TObject);
    procedure ECaixaSelect(Sender: TObject);
    procedure EUsuarioRetorno(Retorno1, Retorno2: String);
    procedure ESenhaExit(Sender: TObject);
    procedure BAbrirCaixaGeralClick(Sender: TObject);
    procedure ValidaChange(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
  private
    { Private declarations }
    VprCaixaAtivo: Integer;
    VprSenhaUsuarioAtual: string;
    Caixa: TFuncoesCaixa;
    Flag_abertura : string;

    procedure ValidaCampos;
  public
    procedure ReabreCaixa;
  end;

var
  FReabreCaixa: TFReabreCaixa;
  AUT : TFuncoesAUT;
implementation

{$R *.DFM}

uses FunSql, APrincipal, ConstMsg, Constantes, FunData, FunValida, APermiteAlterar;

{ ****************** Na criação do Formulário ******************************** }
procedure TFReabreCaixa.FormCreate(Sender: TObject);
begin
  AUT := TFuncoesAut.Create;
  Caixa := TFuncoesCaixa.Criar(Self, FPrincipal.BaseDados);
  Self.HelpFile := Varia.PathHelp + 'MCAIXA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFReabreCaixa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { fecha tabelas }
  Caixa.Destroy;
  Action := CaFree;
end;

{ *************** Registra a classe para evitar duplicidade ****************** }
procedure TFReabreCaixa.BFecharClick(Sender: TObject);
begin
  Close;
end;

{****************** cahamada externa para a reabertura de caixa ************** }
procedure TFReabreCaixa.ReabreCaixa;
begin
  flag_abertura := caixa.VerificaAbreUltimoCaixa(varia.CaixaPadrao);
  if Flag_abertura = 'T' then
    self.close
  else
  begin

    EDataAbertura.EditMask := FPrincipal.CorFoco.AMascaraData;
    EDataAbertura.Text := DateToStr(Date);
    ECaixa.Text := IntTostr(varia.CaixaPadrao);

    if Flag_abertura = 'P' then
      LIndicador.Caption:='Reabertura do Caixa parcial : ' + IntToStr(VprCaixaAtivo) + ' .'
    else
      LIndicador.Caption:='Reabertura de Caixa.';

    // Verifica se é log direto ou se deve pedir o usuário ou senha.
    if Config.LogDireto then
    begin
      EUsuario.Text:=IntToStr(Varia.CodigoUsuario);
      EUsuario.Atualiza;
      ESenha.Text:=VprSenhaUsuarioAtual;
      EUsuario.Enabled:=False;
      ESenha.Enabled:=False;
      BABCaixa.Enabled:=False;
    end;
    self.ShowModal;
 end;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                      Localiza
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{*********************** select Usuarios ************************************ }
procedure TFReabreCaixa.UsuarioSelect(Sender: TObject);
begin
  (Sender as TEditLocaliza).ASelectLocaliza.Clear;
  (Sender as TEditLocaliza).ASelectLocaliza.Add(' SELECT * FROM CADUSUARIOS ' +
                                            ' WHERE I_EMP_FIL = ' + IntToStr(Varia.CodigoEmpFil) +
                                            ' AND C_NOM_USU LIKE ''@%''');
  (Sender as TEditLocaliza).ASelectValida.Clear;
  (Sender as TEditLocaliza).ASelectValida.Add(' SELECT * FROM CADUSUARIOS ' +
                                          ' WHERE I_EMP_FIL = ' + IntToStr(Varia.CodigoEmpFil) +
                                          ' AND I_COD_USU = @');
end;

{********************** Select Caixa **************************************** }
procedure TFReabreCaixa.ECaixaSelect(Sender: TObject);
begin
  (Sender as TEditLocaliza).ASelectLocaliza.Clear;
  (Sender as TEditLocaliza).ASelectLocaliza.Add(' SELECT * FROM CAD_CAIXA ' +
                                                ' WHERE EMP_FIL = ' + IntToStr(Varia.CodigoEmpFil) +
                                                ' AND DES_CAIXA LIKE ''@%''');
  (Sender as TEditLocaliza).ASelectValida.Clear;
  (Sender as TEditLocaliza).ASelectValida.Add('SELECT * FROM CAD_CAIXA ' +
                                              ' WHERE EMP_FIL = ' + IntToStr(Varia.CodigoEmpFil) +
                                              ' AND NUM_CAIXA = @');
end;

{******************** retorno usuarios ************************************** }
procedure TFReabreCaixa.EUsuarioRetorno(Retorno1,
  Retorno2: String);
begin
  if (Retorno1 <> '') then
    VprSenhaUsuarioAtual:=Descriptografa(Retorno1)
  else
    VprSenhaUsuarioAtual:='';
end;

{*************************** senha ******************************************* }
procedure TFReabreCaixa.ESenhaExit(Sender: TObject);
begin
  if (UpperCase((Trim(VprSenhaUsuarioAtual))) <> (UpperCase(Trim(ESenha.Text)))) then
  begin
    ESenha.Text:='';
  end;
end;

{***************** avalida abertura ***************************************** }
procedure TFReabreCaixa.ValidaCampos;
begin
  BAbrirCaixaGeral.Enabled := (EUsuario.Text <> '') and (ESenha.Text <> '') and (EAlteracao.Text <> '') and    (ECaixa.Text <> '');
end;

{********************** reabre ultimo caixa ********************************* }
procedure TFReabreCaixa.BAbrirCaixaGeralClick(Sender: TObject);
var
  VpfFechar: Boolean;
  VpfAlteracao: string;
begin
  // verifica permisao para alterar
  VpfAlteracao := EAlteracao.Text;
  FPermiteAlterar := TFPermiteAlterar.CriarSDI(Application, '', FPrincipal.VerificaPermisao('FPermiteAlterar'));
  if FPermiteAlterar.CarregaTipoAlterar('R', EUsuario.text, VpfAlteracao, config.SenhaAlteracao) then
  begin
    if Flag_abertura = 'C' then
    begin
      Caixa.ReabreUltimoCaixaGeral( varia.CaixaPadrao, StrToInt(EAlteracao.Text), StrToInt(EUsuario.Text));
      Caixa.ReabreUltimoCaixaParcial( Varia.CaixaPadrao, StrToInt(EAlteracao.Text),StrToInt(EUsuario.Text));
    end
    else
      Caixa.ReabreUltimoCaixaParcial(varia.CaixaPadrao, StrToInt(EAlteracao.Text), StrToInt(EUsuario.Text));
    Self.Close;
    Case varia.TipoImpressoraAUT of
      0 : begin end;
      1 : begin
            AUT.AbrePorta;
            AUT.ImprimeFormato('___________________________________');
            AUT.ImprimeFormato(eusuario.text
                               + ' - ' + labertura.caption);
            AUT.ImprimeFormato('Reabertura de Caixa : ' + ecaixa.text
                               + '  ' + edataabertura.text
                               + '  ' + timetostr(time));
            AUT.ImprimeFormato('Alteração : ' + ealteracao.text
                               + '  ' +  CaixaLabel.caption);
            AUT.ImprimeFormato('___________________________________');
          end;
    end;
  end;
end;

procedure TFReabreCaixa.ValidaChange(Sender: TObject);
begin
  ValidaCampos;
end;

procedure TFReabreCaixa.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FReabreCaixa.HelpContext);
end;

Initialization
  RegisterClasses([TFReabreCaixa]);
end.
