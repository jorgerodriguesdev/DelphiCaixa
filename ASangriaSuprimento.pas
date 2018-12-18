unit ASangriaSuprimento;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  formularios, StdCtrls, Buttons, ExtCtrls, Componentes1, Localizacao,
  LabelCorMove, PainelGradiente, UnCaixa, Mask, numericos, DBKeyViolation,
  DBCtrls, Tabela, Db, DBTables, UnBancario, UnECF, UnComandosAUT;

type
  TFSangriaSuprimento = class(TFormularioPermissao)
    PanelColor2: TPanelColor;
    BFechar: TBitBtn;
    Localiza: TConsultaPadrao;
    LCaixa: TLabel;
    PTitulo: TPainelGradiente;
    CaixaPanel: TPanel;
    ETipoOperacao: TEditLocaliza;
    Label1: TLabel;
    LCaixaAtivo: TLabel3D;
    LTipoOpera: TLabel;
    BConfirmaOperacao: TBitBtn;
    TTempo: TPainelTempo;
    BTipoOpera: TSpeedButton;
    Label24: TLabel;
    Label27: TLabel;
    SpeedButton4: TSpeedButton;
    Label29: TLabel;
    ESangriaSuprimentoValor: Tnumerico;
    EFormaPagtoSangriaSuprimento: TEditLocaliza;
    Badiciona: TBitBtn;
    BBAjuda: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure ETipoOperacaoRetorno(Retorno1, Retorno2: String);
    procedure BConfirmaOperacaoClick(Sender: TObject);
    procedure ETipoOperacaoSelect(Sender: TObject);
    procedure EFormaPagtoSangriaSuprimentoChange(Sender: TObject);
    procedure BadicionaClick(Sender: TObject);
    procedure EFormaPagtoSangriaSuprimentoRetorno(Retorno1,
      Retorno2: String);
    procedure BBAjudaClick(Sender: TObject);
    procedure ESangriaSuprimentoValorEnter(Sender: TObject);
    procedure ESangriaSuprimentoValorExit(Sender: TObject);
  private
    { Private declarations }
    VprSeqDiario,  // Alteração.
    VprSeqParcial, LancamentoBancario : Integer; // Alteração.
    Caixa: TFuncoesCaixa;
    ECF : TECF;
    VprCreditoDebito, gaveta : string;
    UsarECF : Boolean;
    ApenasSangria, Acao : Boolean;
    valor : Double;
    procedure lancaItemCaixa;
  public
    { Public declarations }
    procedure ValidaCarregaAbertura;
    function SangriaFechamento(Valor : Double ) : Double;
  end;

var
  FSangriaSuprimento: TFSangriaSuprimento;
  AUT : TFuncoesAut;
implementation

{$R *.DFM}

  uses ConstMsg, APrincipal, Constantes, FunSQL,
      ATransferencia,FunObjeto, FunNumeros, APermiteAlterar, funstring;


{ ****************** Na criação do Formulário ******************************** }
procedure TFSangriaSuprimento.FormCreate(Sender: TObject);
begin
  AUT := TFuncoesAut.Create;
  ApenasSangria := False;
  acao := false;
  Caixa := TFuncoesCaixa.Criar(self, FPrincipal.BaseDados);
  ECF := TECF.criar(self, FPrincipal.BaseDados);
  Self.HelpFile := Varia.PathHelp + 'MCAIXA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
  UsarECF := false;
  if (Caixa.CaixaUsaEcf( varia.CaixaPadrao )) or (not ConfigModulos.Caixa) then
  begin
    if not ECF.AbrePorta then
    begin
      CaixaPanel.Enabled := false;
      BConfirmaOperacao.Enabled := false;
    end
    else
      UsarECF := true;
  end;

  Badiciona.Visible := ConfigModulos.Caixa;
end;

{************** valida abertura da tela **************************************}
procedure TFSangriaSuprimento.ValidaCarregaAbertura;
begin
   if ConfigModulos.Caixa then
   begin
     if caixa.CaixaAtivo(varia.CaixaPadrao) then
     begin
        LCaixaAtivo.Caption := 'Caixa Nro ' + IntToStr(varia.CaixaPadrao) + '.';
        Self.ShowModal;
     end
     else
       self.close;
   end
   else
   begin
     LCaixaAtivo.Visible := false;
     Self.ShowModal;
   end;
end;

{ ************************* Sangria e suprimento *****************************}
function TFSangriaSuprimento.SangriaFechamento(Valor : Double) : Double;
begin
   Badiciona.Visible := false;
   result := 0;
   ApenasSangria := true;
   if caixa.CaixaAtivo(varia.CaixaPadrao) then
   begin
      LCaixaAtivo.Caption := 'Caixa Nro ' + IntToStr(varia.CaixaPadrao) + '.';
      ESangriaSuprimentoValor.AValor := Valor;
      Self.ShowModal;
      if acao then
        Result := self.valor;
   end
   else
     self.close;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFSangriaSuprimento.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FPrincipal.BaseDados.InTransaction then
    FPrincipal.BaseDados.Rollback;
  ECF.FecharPorta;
  Caixa.Free;
  ECF.Free;
  Action := CaFree;
end;

{ *************** Registra a classe para evitar duplicidade ****************** }
procedure TFSangriaSuprimento.BFecharClick(Sender: TObject);
begin
  Close;
end;

{ ***** Carrega o flag de baixar movimento bancário S/N ***** }
procedure TFSangriaSuprimento.ETipoOperacaoRetorno(Retorno1, Retorno2: String);
begin
  if (Retorno1 <> '') and (not ApenasSangria) then
     ESangriaSuprimentoValor.AValor := 0;

  if (Retorno2 <> '') then
    case UpperCase(Retorno2)[1] of
      'C' : VprCreditoDebito:='C';
      'D' : VprCreditoDebito:='D';
    end;
end;

procedure TFSangriaSuprimento.ETipoOperacaoSelect(Sender: TObject);
begin
  ETipoOperacao.ASelectLocaliza.Clear;
  ETipoOperacao.ASelectLocaliza.Add( ' SELECT * FROM CAD_TIPO_OPERA ' +
                                     ' WHERE DES_OPERACAO LIKE ''@%'' '+
                                     ' and FLA_TIPO = ''S'' ');
  ETipoOperacao.ASelectValida.Clear;
  ETipoOperacao.ASelectValida.Add( ' SELECT * FROM CAD_TIPO_OPERA ' +
                                   ' WHERE COD_OPERACAO = @ ' +
                                   ' and FLA_TIPO = ''S'' ');
  if ApenasSangria then
  begin
    ETipoOperacao.ASelectLocaliza.Add(' and CREDITO_DEBITO = ''D''');
    ETipoOperacao.ASelectValida.Add(' and CREDITO_DEBITO = ''D''');
  end;
end;


{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                        EFETUA OPERAÇÃO
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

procedure TFSangriaSuprimento.BConfirmaOperacaoClick(Sender: TObject);
var
  Dados: TDadosBaixaMovBan;
  MB: TFuncoesBancario;
  VpfOperacao,
  VpfNumeroCaixa,
  VpfTipoTranferencia  : integer;
  VpfOperacaoBanc,
  VpfNumeroConta : string;
  VpfDocumento : string;
  VpfDataComp: TDateTime;
  VpfPlano, texto : string;
begin
  LancamentoBancario := 0;
  // neste momento guarda o valor da baixa
  valor := ESangriaSuprimentoValor.AValor;

  // obrigatorio caixa
  if (ConfigModulos.Caixa) then
  begin

    if not FPrincipal.BaseDados.InTransaction then
      FPrincipal.BaseDados.StartTransaction;

     // Carrega o geral e parcial abertos.
    VprSeqDiario := Caixa.SequencialGeralAberto(varia.CaixaPadrao);
    VprSeqParcial := Caixa.SequencialParcialAberto(varia.CaixaPadrao);

     // verifica o valor <> 0
    if (ESangriaSuprimentoValor.AValor = 0) then
    begin
      Aviso('O Valor para esta operação não poder ser 0.');
      ESangriaSuprimentoValor.SetFocus;
      TTempo.Fecha;
      Exit;
    end;

    // naum permite um debito maior que o caixa naum possua
    if (VprCreditoDebito = 'D') then
     if not caixa.VerificaSaldodeCaixa(ESangriaSuprimentoValor.AValor,VprSeqDiario, VprSeqParcial) then
     begin
        TTempo.Fecha;
        Exit;
      end;

    ////// GERA TRANSFERÊNCIA //////
    FTransferencia := TFTransferencia.CriarSDI(Application, '', true);
    if FTransferencia.CarregaTransferencia( VprCreditoDebito,
                                            VpfTipoTranferencia, VpfNumeroCaixa, VpfOperacao,
                                            VpfNumeroConta, VpfDocumento, VpfDataComp, VpfPlano, VpfOperacaoBanc) then
    begin
      if (VpfTipoTranferencia = 1) then // Transferência para outro caixa aberto.
      begin
        TTempo.Execute('Efetuando Transferência ...');
        Caixa.LancaItemCaixa(
          caixa.InverteCreDeb(VprCreditoDebito),'', Date,
          VpfOperacao,
          StrToInt(EFormaPagtoSangriaSuprimento.Text),
          0,0, Caixa.SequencialGeralAberto(VpfNumeroCaixa),
          Caixa.SequencialParcialAberto(VpfNumeroCaixa),
          ESangriaSuprimentoValor.AValor,
          0, ESangriaSuprimentoValor.AValor, 0, 'N');
      end
      else
        if (VpfTipoTranferencia = 2) then // Transferência para banco
        begin    // Tranferência para banco.
          Dados := TDadosBaixaMovBan.Create;
          MB := TFuncoesBancario.criar(self, FPrincipal.BaseDados);
          Dados.NumeroConta := VpfNumeroConta;
          Dados.DataComp := VpfDataComp;
          Dados.NroDocumento := VpfDocumento;
          Dados.OperacaoBancaria := VpfOperacaoBanc;
          Dados.CodigoPlano := VpfPlano;
          if (VprCreditoDebito = 'C') then
          begin
            Dados.ValorEntrada := 0;
            Dados.ValorSaida := ESangriaSuprimentoValor.AValor;
          end
          else
          begin
            Dados.ValorEntrada := ESangriaSuprimentoValor.AValor;
            Dados.ValorSaida := 0;
          end;
          LancamentoBancario := MB.AdicionaMovbancario(Dados, 0, False, false);
          Dados.Free;
          MB.Destroy;
        end;

      // lanca no caixa
      LancaItemCaixa;
      if VprCreditoDebito = 'C' then
         texto := 'de'
      else
         texto := 'para';
      Case varia.TipoImpressoraAUT of
        0 : begin end;
        1 : begin
              AUT.AbrePorta;
              AUT.Imprime('___________________________________');
              Aut.ImprimeFormato(' SANGRIA/SUPRIMENTO DE CAIXA ');
              AUT.Imprime('___________________________________');
              AUT.ImprimeFormato(lCaixaAtivo.caption
                                 + ' Data : ' +  datetostr(date)
                                 + ' Hora : ' +  timetostr(time));
              AUT.ImprimeFormato(etipoOperacao.text + ' - ' +
                                 LTipoOpera.caption);
              AUT.ImprimeFormato('Valor : ' + AdicionaCharE('.',' ' + formatfloat(varia.MascaraValor,ESangriaSuprimentoValor.avalor), 16)
                                 + '  ' + label27.caption);
              if (VpfTipoTranferencia = 1) then
                 AUT.ImprimeFormato('Transferido ' + texto + ' Caixa: ' + inttostr(VpfNumeroCaixa))
              else
                if (VpfTipoTranferencia = 2) then
                  AUT.ImprimeFormato('Transferido ' + texto + ' Conta: ' + VpfNumeroConta);
              AUT.Imprime('___________________________________');
            end;
      end;
      TTempo.Fecha;
      if FPrincipal.BaseDados.InTransaction then
        FPrincipal.BaseDados.Commit;
      acao := true;
    end
    else
    begin
      Aviso('Tranferência não foi efetuada.');
      TTempo.Fecha;
    end;
  end
  else
   VpfTipoTranferencia := 1; // caso naum utiliza caixa

  // aciona gaveta
   if (varia.UsarGaveta = 'S') and (gaveta = 'S') and (VpfTipoTranferencia <> 0) then
      ECF.AcionaGaveta;

  // lanca no ecf
  if (UsarECF) and (VpfTipoTranferencia <> 0)  then
    ECF.Sangria_Suprimento( ESangriaSuprimentoValor.AValor, VprCreditoDebito = 'D' );


  ETipoOperacao.Text := '';
  EFormaPagtoSangriaSuprimento.Text := '';
  ESangriaSuprimentoValor.AValor := 0;
  self.close;
end;

{**************************** valida a gravacao **************************** }
procedure TFSangriaSuprimento.EFormaPagtoSangriaSuprimentoChange(
  Sender: TObject);
begin
  if (EFormaPagtoSangriaSuprimento.Text = '') or (ETipoOperacao.text = '')  then
  begin
    BConfirmaOperacao.Enabled := false;
    Badiciona.Enabled := false;
  end
  else
  begin
    BConfirmaOperacao.Enabled := true;
    Badiciona.Enabled := true;
  end;
end;

{************************* lanca item de caixa ****************************** }
procedure TFSangriaSuprimento.lancaItemCaixa;
begin
  // lanca no caixa
  Caixa.LancaItemCaixa( VprCreditoDebito,'', date,
  StrToInt(ETipoOperacao.text),
  StrToInt(EFormaPagtoSangriaSuprimento.Text),
  0,0, Caixa.SequencialGeralAberto(varia.CaixaPadrao),
  Caixa.SequencialParcialAberto(varia.CaixaPadrao),
  ESangriaSuprimentoValor.AValor,
  0, ESangriaSuprimentoValor.AValor, LancamentoBancario, 'N');
end;

procedure TFSangriaSuprimento.BadicionaClick(Sender: TObject);
var
  Alteracao : string;
begin
  LancamentoBancario := 0;
  alteracao := '';
  FPermiteAlterar := TFPermiteAlterar.CriarSDI(application, '', true);
  if FPermiteAlterar.CarregaTipoAlterar( '', intTostr(varia.CodigoUsuario),Alteracao, config.SenhaEstorno ) then
  begin
    lancaItemCaixa;

    // aciona gaveta
    if (varia.UsarGaveta = 'S') and (gaveta = 'S')  then
      ECF.AcionaGaveta;

      // lanca no ecf
    if (UsarECF) then
      ecf.Sangria_Suprimento(ESangriaSuprimentoValor.AValor, VprCreditoDebito = 'D' );

    self.close;
  end;
end;

procedure TFSangriaSuprimento.EFormaPagtoSangriaSuprimentoRetorno(Retorno1,
  Retorno2: String);
begin
  if retorno2 <> '' then
    gaveta := retorno2;
end;

procedure TFSangriaSuprimento.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FSangriaSuprimento.HelpContext);
end;

procedure TFSangriaSuprimento.ESangriaSuprimentoValorEnter(
  Sender: TObject);
begin
  valor := ESangriaSuprimentoValor.AValor;
end;

procedure TFSangriaSuprimento.ESangriaSuprimentoValorExit(Sender: TObject);
begin
  if ApenasSangria then
    if ESangriaSuprimentoValor.AValor > valor then
    begin
      aviso(' O valor não poder ser maior que ' + FormatFloat(varia.MascaraMoeda,valor));
      ESangriaSuprimentoValor.AValor :=  valor;
    end;
end;

Initialization
  RegisterClasses([TFSangriaSuprimento]);
end.

