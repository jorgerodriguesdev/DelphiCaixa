unit AAbreCaixa;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Formularios, UnCaixa, StdCtrls, LabelCorMove, ExtCtrls, Componentes1,
  PainelGradiente, Localizacao, Buttons, Mask, Db, DBTables, numericos,
  DBKeyViolation, UnComandosAUT;

type
  TFAbreCaixa = class(TFormularioPermissao)
    PTitulo: TPainelGradiente;
    PanelColor2: TPanelColor;
    Label3D1: TLabel3D;
    Localiza: TConsultaPadrao;
    BFechar: TBitBtn;
    Tempo: TPainelTempo;
    PAbertura: TPanelColor;
    Label1: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label13: TLabel;
    Label16: TLabel;
    CaixaLabel: TLabel;
    LAbertura: TLabel;
    BABCaixa: TSpeedButton;
    LIndicador: TLabel3D;
    ECaixaAbertura: TEditLocaliza;
    EUsuarioAbertura: TEditLocaliza;
    ESenhaAbertura: TEditColor;
    EDataAbertura: TMaskEditColor;
    EValorDinheiroAbertura: Tnumerico;
    EValorChequeAbertura: Tnumerico;
    EValorOutrosAbertura: Tnumerico;
    EValorAbertura: Tnumerico;
    BAbrirCaixaGeral: TBitBtn;
    Label3: TLabel;
    ValidaGravacao1: TValidaGravacao;
    BBAjuda: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure BAbrirCaixaGeralClick(Sender: TObject);
    procedure UsuarioSelect(Sender: TObject);
    procedure EUsuarioRetorno(Retorno1, Retorno2: String);
    procedure ECaixaAberturaChange(Sender: TObject);
    procedure ESenhaAberturaExit(Sender: TObject);
    procedure ECaixaAberturaRetorno(Retorno1, Retorno2: String);
    procedure EUsuarioAberturaChange(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
  private
    { Private declarations }
    VprTipoAbertura : integer; // 0  - caixa,  1 parcial
    VprSenhaUsuarioAtual: string;
    Caixa: TFuncoesCaixa;
    procedure ConfiguraAbertura;
  public
    function AbreCaixa : Boolean;
    function AbreParcial : Boolean;
  end;

var
  FAbreCaixa: TFAbreCaixa;
  AUT : TFuncoesAut;
implementation

{$R *.DFM}

uses FunSql, APrincipal, ConstMsg, funObjeto, Constantes, FunData, FunValida;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                  funcoes do formulario
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{ ****************** Na criação do Formulário ******************************** }
procedure TFAbreCaixa.FormCreate(Sender: TObject);
begin
  AUT := TFuncoesAut.Create;
  Caixa := TFuncoesCaixa.Criar(Self, FPrincipal.BaseDados);
  Self.HelpFile := Varia.PathHelp + 'MCAIXA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
  EDataAbertura.EditMask:=FPrincipal.CorFoco.AMascaraData;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFAbreCaixa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FPrincipal.BaseDados.InTransaction then
    FPrincipal.BaseDados.Rollback;
  Caixa.Destroy;
  Action := CaFree;
end;

{ *************** Registra a classe para evitar duplicidade ****************** }
procedure TFAbreCaixa.BFecharClick(Sender: TObject);
begin
  Close;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                  permite a abertura de caixas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{************** verifica se pode abrir o caixa ******************************* }
function TFAbreCaixa.AbreCaixa : boolean;
begin
  result := false;
  if varia.CaixaPadrao <> 0 then
  begin
    result := caixa.VerificaAbreCaixa(Varia.CaixaPadrao);
    if result then
    begin
      VprTipoAbertura := 0;
      ConfiguraAbertura;
      self.ShowModal;
    end
   end
   else
     aviso(CT_FaltaCaixa);

  if not result then
    self.close;
end;

{*************** verifica se pode abrir parcial ***************************** }
function TFAbreCaixa.AbreParcial : Boolean;
begin
  result := caixa.VerificaAbreParcial(Varia.CaixaPadrao);
  if result then
  begin
    VprTipoAbertura := 1;
    ConfiguraAbertura;
    self.ShowModal
  end
  else
    self.close;
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                  funcoes dos Localizas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{***************** select Usuarios ******************************************* }
procedure TFAbreCaixa.UsuarioSelect(Sender: TObject);
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


{********************* senha do usuario ************************************** }
procedure TFAbreCaixa.EUsuarioRetorno(Retorno1,
  Retorno2: String);
begin
  if (Retorno1 <> '') then
    VprSenhaUsuarioAtual:=Descriptografa(Retorno1)
  else
    VprSenhaUsuarioAtual:='';
end;

{************ verifica se precisa calcular saldo anterior ******************* }
procedure TFAbreCaixa.ECaixaAberturaRetorno(Retorno1, Retorno2: String);
Var
  ValorCheque, ValorDinheiro, ValorOutros : Double;
begin
  if (VprTipoAbertura = 0) then // só carrega quando é geral;
    if (Retorno1 <> '') then
    begin
        Caixa.SaldoUltimoCaixa(Retorno1,ValorCheque, ValorDinheiro, ValorOutros);
        EValorDinheiroAbertura.AValor := ValorDinheiro;
        EValorChequeAbertura.AValor := ValorCheque;
        EValorOutrosAbertura.AValor := ValorOutros;
    end
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                  funcoes gerais
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{*************** valida a abertura do caixa ********************************* }
procedure TFAbreCaixa.EUsuarioAberturaChange(Sender: TObject);
begin
  ValidaGravacao1.execute;
  if BAbrirCaixaGeral.Enabled then
    if (EUsuarioAbertura.Text = '') or (ECaixaAbertura.Text = '' ) then
      BAbrirCaixaGeral.Enabled := false;
end;

{**************** calcula o valor total ************************************* }
procedure TFAbreCaixa.ECaixaAberturaChange(Sender: TObject);
begin
  EValorAbertura.AValor:= EValorOutrosAbertura.AValor +
                          EValorChequeAbertura.AValor +
                          EValorDinheiroAbertura.AValor;
end;

{***************** na saida do campo senha *********************************** }
procedure TFAbreCaixa.ESenhaAberturaExit(Sender: TObject);
begin
  if (ESenhaAbertura.Text <> '') then
    if (UpperCase((Trim(VprSenhaUsuarioAtual))) <> (UpperCase(Trim(ESenhaAbertura.Text)))) then
    begin
      Aviso(CT_SenhaInvalida);
      ESenhaAbertura.Text:='';
      ESenhaAbertura.SetFocus;
    end;
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                  funcoes do Caixa
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{ ****************** Abre caixa ********************************************** }
procedure TFAbreCaixa.ConfiguraAbertura;
var
  VpfDinheiro, VpfCheque, VpfOutros: Double;
begin
  EDataAbertura.Text:=DateToStr(Date);
  // Verifica se é log direto ou se deve pedir o usuário ou senha.
  if Config.LogDireto then
  begin
    EUsuarioAbertura.Text := IntToStr(Varia.CodigoUsuario);
    EUsuarioAbertura.Atualiza;
    ESenhaAbertura.Text := VprSenhaUsuarioAtual;
    AlterarEnabledDet([ EUsuarioAbertura, ESenhaAbertura, BABCaixa ], false);
  end;

  if VprTipoAbertura  = 1 then  // abre caixa parcial
  begin
    // desativa a escolha de caixa.
    LIndicador.Caption := 'Abertura parcial Nro : ' + IntToStr(varia.CaixaPadrao) + ' .';
    ECaixaAbertura.Text := IntToStr(varia.CaixaPadrao);
    ECaixaAbertura.Atualiza;
    // preenche os valores do caixa anterior para a abertura.
    Caixa.CarregaParcialAnterior( Caixa.SequencialGeralAberto(varia.CaixaPadrao), VpfDinheiro, VpfCheque, VpfOutros);
    EValorDinheiroAbertura.AValor := VpfDinheiro;
    EValorChequeAbertura.AValor := VpfCheque;
    EValorOutrosAbertura.AValor := VpfOutros;
    AlterarEnabledDet([ EValorDinheiroAbertura, EValorChequeAbertura,  EValorOutrosAbertura, EValorAbertura ] , false);
  end
  else
  begin
    if (Varia.CaixaPadrao <> 0) then // caso o caixa padrao seja <> 0
    begin
      ECaixaAbertura.Text := IntToStr(Varia.CaixaPadrao);
      ECaixaAbertura.Atualiza;
      LIndicador.Caption:='Abre caixa geral : ' + IntToStr(Varia.CaixaPadrao) + '.';
      AlterarEnabledDet([ Label13, label4, label16, EValorDinheiroAbertura, EValorChequeAbertura, EValorOutrosAbertura], false);
    end;
  end;
  EUsuarioAberturaChange(nil);
end;

{***************************** botao abre caixa ***************************** }
procedure TFAbreCaixa.BAbrirCaixaGeralClick(Sender: TObject);
begin
  if not FPrincipal.BaseDados.InTransaction then
   FPrincipal.BaseDados.StartTransaction;

  try
    if  VprTipoAbertura = 0 then
    begin
      Tempo.Execute('Abrindo Caixa ...');
      Caixa.AbreCaixaGeral(StrToInt(ECaixaAbertura.Text),
                           StrToInt(EUsuarioAbertura.Text),
                           EValorDinheiroAbertura.AValor,
                           EValorChequeAbertura.AValor,
                           EValorOutrosAbertura.AValor,
                           EValorAbertura.AValor);
    end
    else
    begin
      Tempo.Execute('Abrindo Parcial ...');
      Caixa.AbreCaixaParcial( StrToInt(ECaixaAbertura.Text),
                              caixa.SequencialGeralAberto(varia.CaixaPadrao),
                              StrToInt(EUsuarioAbertura.Text),
                              EValorDinheiroAbertura.AValor,
                              EValorChequeAbertura.AValor,
                              EValorOutrosAbertura.AValor,
                              EValorAbertura.AValor);
    end;

    Case varia.TipoImpressoraAUT of
      0 : begin end;
      1 : begin
            AUT.AbrePorta;
            AUT.Imprime('___________________________________');
            AUT.ImprimeFormato(eusuarioabertura.text
                               + ' - ' + labertura.caption);
            AUT.ImprimeFormato('Abertura de Caixa : ' + ecaixaabertura.text
                               + '  ' + edataabertura.text
                               + '  ' + timetostr(time));
            AUT.Imprime('___________________________________');
          end;
    end;
   if FPrincipal.BaseDados.InTransaction then
    FPrincipal.BaseDados.Commit;

  except
    if FPrincipal.BaseDados.InTransaction then
      FPrincipal.BaseDados.Rollback;
  end;

  Tempo.fecha;
  Self.Close;
end;


procedure TFAbreCaixa.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FAbreCaixa.HelpContext);
end;

Initialization
  RegisterClasses([TFAbreCaixa]);
end.
