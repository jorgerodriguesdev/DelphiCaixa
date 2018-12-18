unit AMovimentoCaixa;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Buttons, Grids, DBGrids, Tabela, DBKeyViolation, DBCtrls,
  Localizacao, Db, DBTables, ComCtrls, Componentes1, ExtCtrls,
  PainelGradiente, Mask, UnCaixa, numericos;

type
  TFMovimentoCaixa = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    Localiza: TConsultaPadrao;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    BFechar: TBitBtn;
    ITECAIXA: TQuery;
    DATAITECAIXA: TDataSource;
    ITECAIXAVAL_MOVIMENTO: TFloatField;
    ITECAIXAEMP_FIL: TIntegerField;
    ITECAIXASEQ_DIARIO: TIntegerField;
    ITECAIXASEQ_PARCIAL: TIntegerField;
    ITECAIXASEQ_CAIXA: TIntegerField;
    ITECAIXACOD_OPERACAO: TIntegerField;
    ITECAIXACOD_FRM: TIntegerField;
    ITECAIXADAT_MOVIMENTO: TDateField;
    ITECAIXAHOR_MOVIMENTO: TTimeField;
    ITECAIXAVAL_PAGO_RECEBIDO: TFloatField;
    ITECAIXACREDITO_DEBITO: TStringField;
    ITECAIXAFLA_ESTORNADO: TStringField;
    ITECAIXAFLA_TIPO: TStringField;
    ITECAIXADES_OPERACAO: TStringField;
    ITECAIXACOD_CLI: TIntegerField;
    ITECAIXAI_COD_CLI: TIntegerField;
    ITECAIXAC_NOM_CLI: TStringField;
    ITECAIXAVAL_TROCO: TFloatField;
    BBAjuda: TBitBtn;
    GAlteraItem: TDBGridColor;
    Label1: TLabel;
    ECaixaAbertura: TEditLocaliza;
    Label2: TLabel;
    BABCaixa: TSpeedButton;
    numerico1: Tnumerico;
    numerico2: Tnumerico;
    Valores: Tbitbtn;
    Label3: TLabel;
    Label4: TLabel;
    ITECAIXAC_NOM_FRM: TStringField;
    EValorDinheiroAbertura: Tnumerico;
    EValorChequeAbertura: Tnumerico;
    EValorOutrosAbertura: Tnumerico;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    EtotalAbertura: Tnumerico;
    Label8: TLabel;
    Label9: TLabel;
    numerico3: Tnumerico;
    numerico4: Tnumerico;
    numerico5: Tnumerico;
    numerico6: Tnumerico;
    numerico7: Tnumerico;
    numerico8: Tnumerico;
    numerico11: Tnumerico;
    Shape1: TShape;
    Label12: TLabel;
    numerico12: Tnumerico;
    numerico13: Tnumerico;
    numerico14: Tnumerico;
    Label10: TLabel;
    numerico15: Tnumerico;
    Label11: TLabel;
    Label13: TLabel;
    numerico9: Tnumerico;
    numerico10: Tnumerico;
    Label14: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
    procedure ECaixaAberturaRetorno(Retorno1, Retorno2: String);
    procedure ValoresClick(Sender: TObject);
    procedure ECaixaAberturaEnter(Sender: TObject);
  private
    Caixa: TFuncoesCaixa;
    SeqGeral, SeqParcial : integer;
    CodigoEntrada : string;
    procedure PosicionaItensMovimento(VpaSequencialDiario, VpaSequencialParcial : string);
  public
    procedure MovimentoCaixa( NumeroCaixa : Integer );
  end;

var
  FMovimentoCaixa: TFMovimentoCaixa;

implementation

{$R *.DFM}

uses
  Constantes, Fundata, Funstring, Funsql, APrincipal, ConstMsg ;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                   formulario
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{******************* na criacao do formulario ****************************** }
procedure TFMovimentoCaixa.FormCreate(Sender: TObject);
begin
  Caixa := TFuncoesCaixa.Criar(Self, FPrincipal.BaseDados);
  Self.HelpFile := Varia.PathHelp + 'MCAIXA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
  if configmodulos.academico then
    GAlteraItem.Columns[2].Title.caption := 'Nome do aluno';
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFMovimentoCaixa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FechaTabela(ITECAIXA);
  Action := CaFree;
end;

{*************************** fecha formualrio ******************************* }
procedure TFMovimentoCaixa.BFecharClick(Sender: TObject);
begin
  Close;
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                estorno de caixa
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}


{*************** chamada externa para alteracao de caixa ********************* }
procedure TFMovimentoCaixa.MovimentoCaixa( NumeroCaixa : Integer ) ;
begin
  if caixa.CaixaAtivo(NumeroCaixa) then
  begin
    ECaixaAbertura.Text := IntToStr(NumeroCaixa);
    ECaixaAbertura.Atualiza;
  end;
  Self.ShowModal;
end;

{ ****************** Na criação do Formulário ******************************** }
procedure TFMovimentoCaixa.PosicionaItensMovimento(VpaSequencialDiario, VpaSequencialParcial : string);
begin
  LimpaSQLTabela(ITECAIXA);
  ITECAIXA.SQL.Add(' SELECT * FROM ITE_CAIXA ITE, CAD_TIPO_OPERA CAD, CADFORMASPAGAMENTO FRM, CADCLIENTES CLI ' +
                   ' WHERE ITE.EMP_FIL = ' + IntToStr(Varia.CodigoEmpFil));
  ITECAIXA.SQL.Add(' AND ITE.SEQ_DIARIO = ' + VpaSequencialDiario +
                   ' AND ITE.SEQ_PARCIAL = ' + VpaSequencialParcial +
                   ' AND ITE.COD_OPERACAO = CAD.COD_OPERACAO ' +
                   ' AND ITE.COD_FRM = FRM.I_COD_FRM ');
  ITECAIXA.SQL.Add(' AND ITE.COD_CLI *= CLI.I_COD_CLI ' +
                   ' order by ite.seq_caixa' );
  AbreTabela(ITECAIXA);
end;




procedure TFMovimentoCaixa.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FMovimentoCaixa.HelpContext);
end;

procedure TFMovimentoCaixa.ECaixaAberturaRetorno(Retorno1,
  Retorno2: String);
var
  PodeConsultar : boolean;
begin
  if CodigoEntrada <> ECaixaAbertura.text  then
    if not BFechar.Focused then
    begin
      PodeConsultar := true;
      if inttostr(varia.CaixaPadrao) <> (Retorno1) then
        PodeConsultar := SenhaDeLiberacaocaixa;

      if PodeConsultar  then
      begin
        if  Retorno1 <> '' then
        begin
          SeqGeral := Caixa.SequencialGeralAberto(Strtoint(retorno1));
          SeqParcial := Caixa.SequencialParcialAberto(Strtoint(retorno1));
          PosicionaItensMovimento( IntToStr(SeqGeral),IntToStr(SeqParcial));
          numerico1.AValor := 0;
          numerico2.AValor := 0;
          numerico3.AValor := 0;
          numerico4.AValor := 0;
          numerico5.AValor := 0;
          numerico6.AValor := 0;
          numerico7.AValor := 0;
          numerico8.AValor := 0;
          EValorDinheiroAbertura.AValor := 0;
          EValorChequeAbertura.AValor := 0;
          EValorOutrosAbertura.AValor := 0;
          numerico11.AValor := 0;
          numerico12.AValor := 0;
          numerico13.AValor := 0;
          numerico14.AValor := 0;
          CodigoEntrada := ECaixaAbertura.text;
        end;
      end
      else
      begin
        ECaixaAbertura.Text := Inttostr(varia.CaixaPadrao);
        ECaixaAbertura.Atualiza;
      end;
    end;
end;

procedure TFMovimentoCaixa.ValoresClick(Sender: TObject);
var
  VpfDinheiro, VpfCheque, VpfOutros, VpfTroco : Double;
begin
  if SenhaDeLiberacaocaixa then
  begin
    Caixa.ValoresAberturaAtual( Caixa.SequencialGeralAberto( strtoint(ECaixaAbertura.text)), VpfDinheiro, VpfCheque, VpfOutros);
      EValorDinheiroAbertura.AValor := VpfDinheiro;
      EValorChequeAbertura.AValor := VpfCheque;
      EValorOutrosAbertura.AValor := VpfOutros;
      EtotalAbertura.AValor :=VpfDinheiro + VpfCheque + VpfOutros;
    Caixa.SomaCreditoParcial(SeqGeral,SeqParcial,VpfDinheiro, VpfCheque, VpfOutros,VpfTroco);
      numerico9.AValor := VpfTroco;
      numerico15.AValor := (0 - VpfTroco);  // troco negativo
      numerico2.AValor := VpfDinheiro;
      numerico6.AValor := VpfCheque;
      numerico7.AValor := VpfOutros;
      numerico8.AValor := numerico2.AValor + numerico6.AValor + numerico7.AValor;
    Caixa.SomaDebitoParcial(SeqGeral,SeqParcial,VpfDinheiro, VpfCheque, VpfOutros,VpfTroco);
      numerico10.AValor := VpfTroco;
      numerico15.AValor := (numerico15.AValor + VpfTroco);  // troco negativo
      numerico1.AValor := VpfDinheiro;
      numerico3.AValor := VpfCheque;
      numerico4.AValor := VpfOutros;
      numerico5.AValor := numerico1.AValor + numerico3.AValor + numerico4.AValor;
    numerico11.AValor :=  EValorDinheiroAbertura.avalor - numerico1.AValor + numerico2.avalor + numerico15.AValor;
    numerico12.AValor :=  EValorChequeAbertura.avalor - numerico3.AValor + numerico6.avalor;
    numerico13.AValor :=  EValorOutrosAbertura.avalor - numerico4.AValor + numerico7.avalor;
    numerico14.AValor := numerico11.AValor + numerico12.AValor + numerico13.AValor;
   end;
end;

procedure TFMovimentoCaixa.ECaixaAberturaEnter(Sender: TObject);
begin
  CodigoEntrada := ECaixaAbertura.Text;
end;

Initialization
 RegisterClasses([TFMovimentoCaixa]);
end.
 