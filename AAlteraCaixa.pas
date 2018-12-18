unit AAlteraCaixa;
{          Autor: Jorge Eduardo
    Data Criação: 19/10/1999;
          Função: Alterar Caixa
  Data Alteração:
    Alterado por:
Motivo alteração:
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Buttons, Grids, DBGrids, Tabela, DBKeyViolation, DBCtrls,
  Localizacao, Db, DBTables, ComCtrls, Componentes1, ExtCtrls,
  PainelGradiente, Mask, UNBancario, numericos, UnCaixa;

type
  TFAlteraCaixa = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    Localiza: TConsultaPadrao;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    BFechar: TBitBtn;
    CRPPARCIAL: TQuery;
    DATACRPPARCIAL: TDataSource;
    MOVDIARIO: TQuery;
    DATAMOVDIARIO: TDataSource;
    MOVDIARIOEMP_FIL: TIntegerField;
    MOVDIARIOSEQ_DIARIO: TIntegerField;
    MOVDIARIONUM_CAIXA: TIntegerField;
    MOVDIARIOCOD_USUARIO_ABERTURA: TIntegerField;
    MOVDIARIODAT_ABERTURA: TDateField;
    MOVDIARIOHOR_ABERTURA: TTimeField;
    MOVDIARIOVAL_DINHEIRO_ABERTURA: TFloatField;
    MOVDIARIOVAL_CHEQUE_ABERTURA: TFloatField;
    MOVDIARIOVAL_OUTROS_ABERTURA: TFloatField;
    MOVDIARIOVAL_TOTAL_ABERTURA: TFloatField;
    MOVDIARIOCOD_USUARIO_FECHAMENTO: TIntegerField;
    MOVDIARIODAT_FECHAMENTO: TDateField;
    MOVDIARIOHOR_FECHAMENTO: TTimeField;
    MOVDIARIOVAL_DINHEIRO_FECHAMENTO: TFloatField;
    MOVDIARIOVAL_CHEQUE_FECHAMENTO: TFloatField;
    MOVDIARIOVAL_OUTROS_FECHAMENTO: TFloatField;
    MOVDIARIOVAL_TOTAL_FECHAMENTO: TFloatField;
    MOVDIARIOI_EMP_FIL: TIntegerField;
    MOVDIARIOI_COD_USU: TIntegerField;
    MOVDIARIOI_COD_GRU: TIntegerField;
    MOVDIARIOC_NOM_USU: TStringField;
    MOVDIARIOC_NOM_LOG: TStringField;
    MOVDIARIOC_SEN_USU: TStringField;
    MOVDIARIOC_USU_ATI: TStringField;
    MOVDIARIOC_OBS_USU: TStringField;
    MOVDIARIOD_DAT_MOV: TDateField;
    MOVDIARIOL_INI_USU: TMemoField;
    MOVDIARIOC_EFO_COR: TStringField;
    MOVDIARIOI_EFO_TAM: TIntegerField;
    MOVDIARIOC_EFO_NOM: TStringField;
    MOVDIARIOC_EFO_ATR: TStringField;
    MOVDIARIOC_EFU_COR: TStringField;
    MOVDIARIOC_EFF_COR: TStringField;
    MOVDIARIOC_EFF_FCO: TStringField;
    MOVDIARIOC_EFO_FCO: TStringField;
    MOVDIARIOC_GFO_COR: TStringField;
    MOVDIARIOI_GFO_TAM: TIntegerField;
    MOVDIARIOC_GFO_NOM: TStringField;
    MOVDIARIOC_GFO_ATR: TStringField;
    MOVDIARIOC_GTI_COR: TStringField;
    MOVDIARIOC_SFO_COR: TStringField;
    MOVDIARIOI_SFO_TAM: TIntegerField;
    MOVDIARIOC_SFO_NOM: TStringField;
    MOVDIARIOC_SFO_ATR: TStringField;
    MOVDIARIOC_SPA_COR: TStringField;
    MOVDIARIOI_TIT_ALI: TIntegerField;
    MOVDIARIOI_TIT_TEX: TIntegerField;
    MOVDIARIOI_TIT_FUN: TIntegerField;
    MOVDIARIOC_TCO_SOM: TStringField;
    MOVDIARIOC_TCO_INI: TStringField;
    MOVDIARIOC_TCO_FIM: TStringField;
    MOVDIARIOC_TFO_COR: TStringField;
    MOVDIARIOI_TFO_TAM: TIntegerField;
    MOVDIARIOC_TFO_NOM: TStringField;
    MOVDIARIOC_TFO_ATR: TStringField;
    MOVDIARIOC_SIS_COR: TStringField;
    MOVDIARIOC_SIS_PAP: TStringField;
    MOVDIARIOC_SIS_IMA: TStringField;
    CRPPARCIALEMP_FIL: TIntegerField;
    CRPPARCIALSEQ_PARCIAL: TIntegerField;
    CRPPARCIALSEQ_DIARIO: TIntegerField;
    CRPPARCIALCOD_USUARIO: TIntegerField;
    CRPPARCIALDAT_ABERTURA: TDateField;
    CRPPARCIALHOR_ABERTURA: TTimeField;
    CRPPARCIALVAL_DINHEIRO_ABERTURA: TFloatField;
    CRPPARCIALVAL_CHEQUE_ABERTURA: TFloatField;
    CRPPARCIALVAL_OUTROS_ABERTURA: TFloatField;
    CRPPARCIALVAL_ABERTURA_PARCIAL: TFloatField;
    CRPPARCIALVAL_FECHAMENTO_PARCIAL: TFloatField;
    CRPPARCIALVAL_DESCONTO_FUNCIONARIO: TFloatField;
    CRPPARCIALFLA_ESTADO: TStringField;
    CRPPARCIALVAL_DINHEIRO_FECHAMENTO: TFloatField;
    CRPPARCIALVAL_CHEQUE_FECHAMENTO: TFloatField;
    CRPPARCIALVAL_OUTROS_FECHAMENTO: TFloatField;
    CRPPARCIALI_EMP_FIL: TIntegerField;
    CRPPARCIALI_COD_USU: TIntegerField;
    CRPPARCIALI_COD_GRU: TIntegerField;
    CRPPARCIALC_NOM_USU: TStringField;
    MOVDIARIOVAL_IDEAL_FECHAMENTO: TFloatField;
    CRPPARCIALVAL_IDEAL_FECHAMENTO: TFloatField;
    MOVDIARIODIFERENCA: TFloatField;
    CRPPARCIALDIFERENCA: TFloatField;
    MOVDIARIODES_CAIXA: TStringField;
    AUX: TQuery;
    BAlterar: TBitBtn;
    GCaixa: TGridIndice;
    ParcialGridIndice: TGridIndice;
    CRPPARCIALVAL_CORRIGIDO: TFloatField;
    BitBtn1: TBitBtn;
    BBAjuda: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure ECaixaChange(Sender: TObject);
    procedure MOVDIARIOAfterScroll(DataSet: TDataSet);
    procedure MOVDIARIOCalcFields(DataSet: TDataSet);
    procedure CRPPARCIALCalcFields(DataSet: TDataSet);
    procedure MOVDIARIONUM_CAIXAGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure BAlterarClick(Sender: TObject);
    procedure GCaixaOrdem(Ordem: String);
    procedure ParcialGridIndiceOrdem(Ordem: String);
    procedure GCaixaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GCaixaKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn1Click(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
  private
    VprTeclaPressionada: Boolean;
    Caixa: TFuncoesCaixa;
    VprOrdemCaixa,
    VprOrdemParcial: string;
    procedure PosicionaMovimentoGeralDiario;
    procedure PosicionaMovimentoParcial;
  public
  end;

var
  FAlteraCaixa: TFAlteraCaixa;

implementation

{$R *.DFM}

uses
  constantes, fundata, funstring, funsql, APrincipal, ConstMsg,
  AAlteraItens, AReabreCaixa, AReFechaCaixa;

{ ****************** Na criação do Formulário ******************************** }
procedure TFAlteraCaixa.FormCreate(Sender: TObject);
begin
  Caixa := TFuncoesCaixa.Criar(Self, FPrincipal.BaseDados);
  Self.HelpFile := Varia.PathHelp + 'MCAIXA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
  VprTeclaPressionada := True;
  VprOrdemCaixa := ' ORDER BY MOV.SEQ_DIARIO ';
  VprOrdemParcial := ' ORDER BY CRP.SEQ_DIARIO, CRP.SEQ_PARCIAL ';
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFAlteraCaixa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Caixa.Destroy;
  FechaTabela(CRPPARCIAL);
  FechaTabela(MOVDIARIO);
  Action := CaFree;
end;

{******************** fecha formulario *************************************** }
procedure TFAlteraCaixa.BFecharClick(Sender: TObject);
begin
  Close;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                Consultas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{******************* posiciona o caixa geral ********************************* }
procedure TFAlteraCaixa.PosicionaMovimentoGeralDiario;
begin
  LimpaSQLTabela(MOVDIARIO);
  MOVDIARIO.SQL.Add( ' SELECT * FROM MOV_DIARIO MOV, CADUSUARIOS CAD, CAD_CAIXA CAI, CRP_PARCIAL CRP ' +
                     ' WHERE MOV.EMP_FIL = ' + IntToStr(Varia.CodigoEmpFil) );
  MOVDIARIO.SQL.Add( ' AND CAI.EMP_FIL = MOV.EMP_FIL ' +
                     ' AND MOV.NUM_CAIXA  =  CAI.NUM_CAIXA ' +
                     ' AND MOV.COD_USUARIO_ABERTURA  =  CAD.I_COD_USU ' +
                     ' AND MOV.EMP_FIL = CRP.EMP_FIL ' +
                     ' AND MOV.SEQ_DIARIO = CRP.SEQ_DIARIO ' +
                     ' AND CRP.FLA_ESTADO = ''S'' ');
  MOVDIARIO.SQL.Add(VprOrdemCaixa);
  AbreTabela(MOVDIARIO);
end;

{********************** posiciona os parciais ****************************** }
procedure TFAlteraCaixa.PosicionaMovimentoParcial;
begin
  if (VprTeclaPressionada and (not MOVDIARIO.EOF))then
  begin
    LimpaSQLTabela(CRPPARCIAL);
    LimpaSQLTabela(AUX);
    CRPPARCIAL.SQL.Add(' SELECT * FROM CRP_PARCIAL CRP, CADUSUARIOS CAD ' +
                       ' WHERE CRP.EMP_FIL = ' + IntToStr(Varia.CodigoEmpFil) +
                       ' AND CRP.SEQ_DIARIO = ' + MOVDIARIOSEQ_DIARIO.AsString);
    CRPPARCIAL.SQL.Add(' AND CRP.FLA_ESTADO = ''S'' ');
    CRPPARCIAL.SQL.Add(' AND CRP.COD_USUARIO  =  CAD.I_COD_USU ');
    CRPPARCIAL.SQL.Add(VprOrdemParcial);
    AbreTabela(CRPPARCIAL);
  end;
end;



procedure TFAlteraCaixa.ECaixaChange(Sender: TObject);
begin
  PosicionaMovimentoGeralDiario;
end;

procedure TFAlteraCaixa.MOVDIARIOAfterScroll(DataSet: TDataSet);
begin
  PosicionaMovimentoParcial;
end;

procedure TFAlteraCaixa.MOVDIARIOCalcFields(DataSet: TDataSet);
begin
    MOVDIARIODIFERENCA.Value:=(MOVDIARIOVAL_TOTAL_FECHAMENTO.Value - MOVDIARIOVAL_IDEAL_FECHAMENTO.Value);
end;

procedure TFAlteraCaixa.CRPPARCIALCalcFields(DataSet: TDataSet);
begin
    CRPPARCIALDIFERENCA.Value:=(CRPPARCIALVAL_FECHAMENTO_PARCIAL.Value - CRPPARCIALVAL_IDEAL_FECHAMENTO.Value);
end;


procedure TFAlteraCaixa.MOVDIARIONUM_CAIXAGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if (not MOVDIARIO.EOF) then
    Text:=MOVDIARIONUM_CAIXA.AsString + ' - ' + MOVDIARIODES_CAIXA.AsString;
end;


procedure TFAlteraCaixa.BAlterarClick(Sender: TObject);
begin
  if (not CRPPARCIAL.EOF) then
  begin
    FAlteraItemCaixa := TFAlteraItemCaixa.CriarSDI(Application,'' , FPrincipal.VerificaPermisao('FEstornaItemCaixa'));
    FAlteraItemCaixa.AlteraCaixa( CRPPARCIALSEQ_DIARIO.AsInteger, CRPPARCIALSEQ_PARCIAL.AsInteger  );

    // SE O CAIXA PARCIAL FOI ANTERADO RECALCULAR O VALOR DE FECHAMENTO E RE-FECHAR;
    caixa.RecalculaFechamento( CRPPARCIALSEQ_DIARIO.AsInteger, CRPPARCIALSEQ_PARCIAL.AsInteger,
                               CRPPARCIALVAL_FECHAMENTO_PARCIAL.AsCurrency, CRPPARCIALVAL_IDEAL_FECHAMENTO.AsCurrency);
    AtualizaSQLTabela(CRPPARCIAL);
  end;
end;


procedure TFAlteraCaixa.GCaixaOrdem(Ordem: String);
begin
  VprOrdemCaixa:=Ordem;
end;

procedure TFAlteraCaixa.ParcialGridIndiceOrdem(Ordem: String);
begin
  VprOrdemParcial:=Ordem;
end;

procedure TFAlteraCaixa.GCaixaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  VprTeclaPressionada:= False;
end;

procedure TFAlteraCaixa.GCaixaKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  VprTeclaPressionada:= True;
  if Key in [37 .. 40 ] then
    PosicionaMovimentoParcial;
end;

procedure TFAlteraCaixa.BitBtn1Click(Sender: TObject);
begin
  FReFechaCaixa := TFReFechaCaixa.CriarSDI(application, '', true);
  FReFechaCaixa.ReFechaParcial( CRPPARCIALSEQ_DIARIO.AsInteger, CRPPARCIALSEQ_PARCIAL.AsInteger  );
  AtualizaSQLTabela(CRPPARCIAL);
end;

procedure TFAlteraCaixa.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FAlteraCaixa.HelpContext);
end;

Initialization
 RegisterClasses([TFAlteraCaixa]);
end.
