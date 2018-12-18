unit AConsultaCaixa;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Buttons, Grids, DBGrids, Tabela, DBKeyViolation, DBCtrls,
  Localizacao, Db, DBTables, ComCtrls, Componentes1, ExtCtrls,
  PainelGradiente, Mask, UNBancario, numericos;

type
  TFConsultaCaixa = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor3: TPanelColor;
    Localiza: TConsultaPadrao;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    BFechar: TBitBtn;
    Label5: TLabel;
    EDataDe: TCalendario;
    CaixaLabel: TLabel;
    BConsultaCaixa: TSpeedButton;
    ECaixa: TEditLocaliza;
    Label3: TLabel;
    CRPPARCIAL: TQuery;
    DATACRPPARCIAL: TDataSource;
    Label1: TLabel;
    EDataAte: TCalendario;
    ITECAIXA: TQuery;
    DATAITECAIXA: TDataSource;
    ITECAIXAEMP_FIL: TIntegerField;
    ITECAIXASEQ_DIARIO: TIntegerField;
    ITECAIXASEQ_PARCIAL: TIntegerField;
    ITECAIXASEQ_CAIXA: TIntegerField;
    ITECAIXACOD_OPERACAO: TIntegerField;
    ITECAIXACOD_FRM: TIntegerField;
    ITECAIXADAT_MOVIMENTO: TDateField;
    ITECAIXAHOR_MOVIMENTO: TTimeField;
    ITECAIXAVAL_MOVIMENTO: TFloatField;
    ITECAIXAVAL_PAGO_RECEBIDO: TFloatField;
    ITECAIXACREDITO_DEBITO: TStringField;
    ITECAIXACOD_OPERACAO_1: TIntegerField;
    ITECAIXACREDITO_DEBITO_1: TStringField;
    ITECAIXAI_COD_FRM: TIntegerField;
    ITECAIXAC_NOM_FRM: TStringField;
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
    CRPPARCIALVAL_ABERTURA_PARCIAL: TFloatField;
    CRPPARCIALVAL_FECHAMENTO_PARCIAL: TFloatField;
    CRPPARCIALI_EMP_FIL: TIntegerField;
    CRPPARCIALI_COD_USU: TIntegerField;
    CRPPARCIALC_NOM_USU: TStringField;
    MOVDIARIOVAL_IDEAL_FECHAMENTO: TFloatField;
    CRPPARCIALVAL_IDEAL_FECHAMENTO: TFloatField;
    MOVDIARIODIFERENCA: TFloatField;
    CRPPARCIALDIFERENCA: TFloatField;
    Label2: TLabel;
    EUsuarioAbertura: TEditLocaliza;
    BABCaixa: TSpeedButton;
    Label4: TLabel;
    CIncorreto: TCheckBox;
    ITECAIXAFLA_ESTORNADO: TStringField;
    MOVDIARIODES_CAIXA: TStringField;
    ETotalFechamento: Tnumerico;
    ETotalDiferenca: Tnumerico;
    ETotalIdeal: Tnumerico;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    CParciaisEstornados: TCheckBox;
    AUX: TQuery;
    ITECAIXADES_OPERACAO: TStringField;
    ITECAIXACOD_CLI: TIntegerField;
    ITECAIXAI_COD_CLI: TIntegerField;
    ITECAIXAC_NOM_CLI: TStringField;
    ITECAIXAI_LAN_BAC: TIntegerField;
    CaixaPage: TPageControl;
    CaixaGeralTab: TTabSheet;
    CaixaParcialTab: TTabSheet;
    ItemTab: TTabSheet;
    GCaixa: TGridIndice;
    GridIndice1: TGridIndice;
    GridIndice2: TGridIndice;
    BFechamento: TBitBtn;
    BBAjuda: TBitBtn;
    ITECAIXAC_NRO_NOT: TStringField;
    ITECAIXAD_DAT_NOT: TDateField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure ECaixaChange(Sender: TObject);
    procedure MOVDIARIOCalcFields(DataSet: TDataSet);
    procedure CRPPARCIALCalcFields(DataSet: TDataSet);
    procedure EUsuarioAberturaSelect(Sender: TObject);
    procedure EUsuarioAberturaChange(Sender: TObject);
    procedure MOVDIARIONUM_CAIXAGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure ITECAIXADES_OPERACAOGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure BFechamentoClick(Sender: TObject);
    procedure GCaixaOrdem(Ordem: String);
    procedure GridIndice1Ordem(Ordem: String);
    procedure GridIndice2Ordem(Ordem: String);
    procedure GCaixaKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GCaixaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridIndice1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CaixaPageChange(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
  private
    VprTeclaPressionada: Boolean;
    VprOrdemItem,
    VprOrdemCaixa,
    VprOrdemParcial: string;
    procedure PosicionaMovimentoParcial;
    procedure PosicionaItensMovimento;
    procedure PosicionaMovimentoGeralDiario;
  public
  end;

var
  FConsultaCaixa: TFConsultaCaixa;

implementation

{$R *.DFM}

uses
  constantes, fundata, funstring, funsql, APrincipal, ConstMsg, AConsultaFechaParcial;

{ ****************** Na criação do Formulário ******************************** }
procedure TFConsultaCaixa.FormCreate(Sender: TObject);
begin
  EDataDe.Date := date;
  EDataAte.Date := Date;
  CaixaPage.ActivePage := CaixaGeralTab;
  VprTeclaPressionada := True;
  Self.HelpFile := Varia.PathHelp + 'MCAIXA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
  VprOrdemCaixa   := ' ORDER BY MOV.SEQ_DIARIO ';
  VprOrdemParcial :=' ORDER BY CRP.SEQ_DIARIO, CRP.SEQ_PARCIAL ';
  VprOrdemItem    := ' ORDER BY ITE.SEQ_CAIXA ';
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFConsultaCaixa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FechaTabela(CRPPARCIAL);
  FechaTabela(ITECAIXA);
  FechaTabela(MOVDIARIO);
  Action := CaFree;
end;

{**************** fecha o formulario ****************************************}
procedure TFConsultaCaixa.BFecharClick(Sender: TObject);
begin
  Close;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                   caixa Principal - seq_diario
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{************************ select ********************************************* }
procedure TFConsultaCaixa.PosicionaMovimentoGeralDiario;
begin
  CaixaPage.ActivePage := CaixaGeralTab;
  LimpaSQLTabela(MOVDIARIO);
  MOVDIARIO.SQL.Add(' SELECT * FROM MOV_DIARIO MOV, CADUSUARIOS CAD, CAD_CAIXA CAI ' +
                    ' WHERE MOV.EMP_FIL = ' + IntToStr(Varia.CodigoEmpFil) +
                    SQLTextoDataEntreAAAAMMDD( 'MOV.DAT_ABERTURA', EDataDe.date, EDataAte.date, true ));
  if (ECaixa.Text <> '') then
    MOVDIARIO.SQL.Add(' AND MOV.NUM_CAIXA = ' + Trim(ECaixa.Text))
  else
    MOVDIARIO.SQL.Add( ' ' );

  MOVDIARIO.SQL.Add( ' AND CAI.EMP_FIL = MOV.EMP_FIL ' +
                     ' AND CAI.NUM_CAIXA  =  MOV.NUM_CAIXA ' +
                     ' AND CAD.I_COD_USU  =  MOV.COD_USUARIO_ABERTURA ');
  MOVDIARIO.SQL.Add(VprOrdemCaixa);
  AbreTabela(MOVDIARIO);
end;

{****************** calcula diferenca **************************************** }
procedure TFConsultaCaixa.MOVDIARIOCalcFields(DataSet: TDataSet);
begin
  MOVDIARIODIFERENCA.Value:=(MOVDIARIOVAL_TOTAL_FECHAMENTO.Value - MOVDIARIOVAL_IDEAL_FECHAMENTO.Value);
end;




{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                   caixa parcial - seq_parcial
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }


{************************ select ********************************************* }
procedure TFConsultaCaixa.PosicionaMovimentoParcial;
begin
  if (VprTeclaPressionada) and (not MOVDIARIO.Eof ) then
  begin
    LimpaSQLTabela(CRPPARCIAL);
    LimpaSQLTabela(AUX);
    CRPPARCIAL.SQL.Add(' SELECT CRP.EMP_FIL, CRP.SEQ_DIARIO, CRP.SEQ_PARCIAL, CRP.COD_USUARIO, ' +
                       ' CRP.DAT_ABERTURA, CRP.HOR_ABERTURA, CRP.VAL_ABERTURA_PARCIAL, ' +
                       ' CRP.VAL_FECHAMENTO_PARCIAL, CRP.VAL_IDEAL_FECHAMENTO, ' +
                       ' CAD.I_EMP_FIL, CAD.C_NOM_USU, CAD.I_COD_USU ' +
                       ' FROM CRP_PARCIAL CRP, CADUSUARIOS CAD ' +
                       ' WHERE ');
    CRPPARCIAL.SQL.Add(' CRP.SEQ_DIARIO = ' + MOVDIARIOSEQ_DIARIO.AsString +
                       ' AND CRP.COD_USUARIO  =  CAD.I_COD_USU ');
    if (EUsuarioAbertura.Text <> '') then
      CRPPARCIAL.SQL.Add(' AND CRP.COD_USUARIO = ' + Trim(EUsuarioAbertura.Text))
    else CRPPARCIAL.SQL.Add(' ');
    if (CIncorreto.Checked) then
      CRPPARCIAL.SQL.Add(' AND CRP.FLA_ESTADO = ''S'' ')
    else CRPPARCIAL.SQL.Add(' ');
    CRPPARCIAL.SQL.Add(VprOrdemParcial);
    AUX.SQL.Add(' SELECT SUM(VAL_FECHAMENTO_PARCIAL) TOTFECHAMENTO, SUM(VAL_IDEAL_FECHAMENTO) TOTIDEAL, ' +
                ' SUM(VAL_FECHAMENTO_PARCIAL - VAL_IDEAL_FECHAMENTO) DIFERE FROM CRP_PARCIAL ' +
                ' WHERE ' +
                ' DAT_ABERTURA >= ''' + DataToStrFormato(AAAAMMDD, EDataDe.Date,'/') + '''' +
                ' AND   DAT_ABERTURA <= ''' + DataToStrFormato(AAAAMMDD, EDataAte.Date,'/') + '''');
    if (EUsuarioAbertura.Text <> '') then
      AUX.SQL.Add(' AND COD_USUARIO = ' + Trim(EUsuarioAbertura.Text));
    if (CIncorreto.Checked) then
      AUX.SQL.Add(' AND FLA_ESTADO = ''S'' ');
    AbreTabela(CRPPARCIAL);
    AbreTabela(AUX);
    ETotalFechamento.AValor := AUX.FieldByName('TOTFECHAMENTO').AsFloat;
    ETotalDiferenca.AValor := AUX.FieldByName('DIFERE').AsFloat;
    ETotalIdeal.AValor := AUX.FieldByName('TOTIDEAL').AsFloat;
    if MOVDIARIO.EOF then
    begin
      FechaTabela(CRPPARCIAL);
      FechaTabela(ITECAIXA);
    end;
  end;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                   caixa Items
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{************************ select ********************************************* }
procedure TFConsultaCaixa.PosicionaItensMovimento;
begin
  if VprTeclaPressionada then
  begin
    if not(CRPPARCIAL.EOF) then
    begin
      LimpaSQLTabela(ITECAIXA);
      ITECAIXA.SQL.Add(' SELECT * FROM ITE_CAIXA ITE, CAD_TIPO_OPERA CAD, CADFORMASPAGAMENTO FRM, CADCLIENTES CLI ' +
                       ' WHERE ' );
      ITECAIXA.SQL.Add(' ITE.SEQ_DIARIO = ' + CRPPARCIAL.FieldByName('SEQ_DIARIO').AsString +
                       ' AND ITE.SEQ_PARCIAL = ' + CRPPARCIAL.FieldByName('SEQ_PARCIAL').AsString +
                       ' AND ITE.COD_OPERACAO = CAD.COD_OPERACAO ' +
                       ' AND ITE.COD_FRM = FRM.I_COD_FRM ' );
      ITECAIXA.SQL.Add(' AND ITE.COD_CLI *= CLI.I_COD_CLI ');

      if CParciaisEstornados.Checked then
        ITECAIXA.SQL.Add(' AND ITE.FLA_ESTORNADO = ''S''');
      ITECAIXA.SQL.Add(VprOrdemItem);
      AbreTabela(ITECAIXA);
    end
    else FechaTabela(ITECAIXA);
  end;
end;

procedure TFConsultaCaixa.ECaixaChange(Sender: TObject);
begin
  PosicionaMovimentoGeralDiario;
end;

procedure TFConsultaCaixa.CRPPARCIALCalcFields(DataSet: TDataSet);
begin
  CRPPARCIALDIFERENCA.Value:=(CRPPARCIALVAL_FECHAMENTO_PARCIAL.Value - CRPPARCIALVAL_IDEAL_FECHAMENTO.Value);
end;

procedure TFConsultaCaixa.EUsuarioAberturaSelect(Sender: TObject);
begin
  (Sender as TEditLocaliza).ASelectLocaliza.Clear;
  (Sender as TEditLocaliza).ASelectLocaliza.Add(' SELECT * FROM CADUSUARIOS ' +
                                                ' WHERE  ' +
                                                '  C_NOM_USU LIKE ''@%''' +
                                                ' and c_usu_ati = ''S'' ');
  (Sender as TEditLocaliza).ASelectValida.Clear;
  (Sender as TEditLocaliza).ASelectValida.Add(' SELECT * FROM CADUSUARIOS ' +
                                              ' WHERE I_COD_USU = @ '+
                                               ' and c_usu_ati = ''S'' ');
end;

procedure TFConsultaCaixa.EUsuarioAberturaChange(Sender: TObject);
begin
  PosicionaMovimentoParcial;
end;

procedure TFConsultaCaixa.MOVDIARIONUM_CAIXAGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text:=MOVDIARIONUM_CAIXA.AsString + ' - ' + MOVDIARIODES_CAIXA.AsString;
end;

procedure TFConsultaCaixa.ITECAIXADES_OPERACAOGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text:=ITECAIXACOD_OPERACAO.AsString + ' - ' + ITECAIXADES_OPERACAO.AsString;
end;

procedure TFConsultaCaixa.BFechamentoClick(Sender: TObject);
begin
  FConsultaFechamentosParciais := TFConsultaFechamentosParciais.CriarSDI(Application,'' , FPrincipal.VerificaPermisao('FConsultaFechamentosParciais'));
  FConsultaFechamentosParciais.PosicionaFechamento( CRPPARCIALSEQ_DIARIO.AsString, CRPPARCIALSEQ_PARCIAL.AsString, CaixaPage.ActivePage = CaixaParcialTab);
end;

procedure TFConsultaCaixa.GCaixaOrdem(Ordem: String);
begin
  VprOrdemCaixa:=Ordem;
end;

procedure TFConsultaCaixa.GridIndice1Ordem(Ordem: String);
begin
  VprOrdemParcial:=Ordem;
end;

procedure TFConsultaCaixa.GridIndice2Ordem(Ordem: String);
begin
  VprOrdemItem:=Ordem;
end;

procedure TFConsultaCaixa.GCaixaKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  VprTeclaPressionada:= True;
  if Key in [37 .. 40 ] then
    PosicionaMovimentoParcial;
end;

procedure TFConsultaCaixa.GCaixaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  VprTeclaPressionada:= False;
end;

procedure TFConsultaCaixa.GridIndice1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  VprTeclaPressionada:= True;
  if Key in [37 .. 40 ] then
    PosicionaItensMovimento;
end;

procedure TFConsultaCaixa.CaixaPageChange(Sender: TObject);
begin
if CaixaPage.ActivePage = CaixaGeralTab then
  PosicionaMovimentoGeralDiario
else
  if CaixaPage.ActivePage = CaixaParcialTab then
    PosicionaMovimentoParcial
  else
    PosicionaItensMovimento;

  BFechamento.Enabled := (CaixaPage.ActivePage = CaixaParcialTab) and (not CRPPARCIAL.EOF);
end;


procedure TFConsultaCaixa.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FConsultaCaixa.HelpContext);
end;

Initialization
 RegisterClasses([TFConsultaCaixa]);
end.
