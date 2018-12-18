unit AConsultaAlteracao;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Buttons, Grids, DBGrids, Tabela, DBKeyViolation, DBCtrls,
  Localizacao, Db, DBTables, ComCtrls, Componentes1, ExtCtrls,
  PainelGradiente, Mask, UNBancario, UnContasAPagar, UnContasAReceber, UnCaixa;

type
  TFConsultaAlteracao = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    Localiza: TConsultaPadrao;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    BFechar: TBitBtn;
    GridIndice2: TGridIndice;
    ALTERACAO: TQuery;
    DATAITECAIXA: TDataSource;
    PanelColor3: TPanelColor;
    FiltroTipo: TRadioGroup;
    Label5: TLabel;
    EDataDe: TCalendario;
    Label1: TLabel;
    EDataAte: TCalendario;
    Label3: TLabel;
    ECaixa: TEditLocaliza;
    SpeedButton11: TSpeedButton;
    Label2: TLabel;
    EUsuarioAbertura: TEditLocaliza;
    BABCaixa: TSpeedButton;
    Label6: TLabel;
    SpeedButton1: TSpeedButton;
    EAlteracao: TEditLocaliza;
    Label7: TLabel;
    Label4: TLabel;
    Label8: TLabel;
    ALTERACAOEMP_FIL: TIntegerField;
    ALTERACAOSEQ_ALTERACAO: TIntegerField;
    ALTERACAOSEQ_DIARIO: TIntegerField;
    ALTERACAOSEQ_PARCIAL: TIntegerField;
    ALTERACAOCOD_ALTERACAO: TIntegerField;
    ALTERACAOCOD_USUARIO_ALTERACAO: TIntegerField;
    ALTERACAODAT_ALTERACAO: TDateField;
    ALTERACAOHOR_ALTERACAO: TTimeField;
    ALTERACAOFLA_DIARIO_PARCIAL: TStringField;
    ALTERACAONUM_CAIXA: TIntegerField;
    ALTERACAOCOD_ALTERACAO_1: TIntegerField;
    ALTERACAODES_ALTERACAO: TStringField;
    ALTERACAOI_EMP_FIL: TIntegerField;
    ALTERACAOI_COD_USU: TIntegerField;
    ALTERACAOC_NOM_USU: TStringField;
    ALTERACAOEMP_FIL_1: TIntegerField;
    ALTERACAOSEQ_DIARIO_1: TIntegerField;
    ALTERACAONUM_CAIXA_1: TIntegerField;
    ALTERACAODES_CAIXA: TStringField;
    ALTERACAONUM_ITEM: TIntegerField;
    BBAjuda: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FiltroTipoClick(Sender: TObject);
    procedure EUsuarioAberturaSelect(Sender: TObject);
    procedure ALTERACAOCOD_ALTERACAOGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure GridIndice2Ordem(Ordem: String);
    procedure ALTERACAONUM_CAIXAGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure BBAjudaClick(Sender: TObject);
  private
    VprOrdem: string;
    procedure PosicionaAlteracao;
  public
  end;

var
  FConsultaAlteracao: TFConsultaAlteracao;

implementation

{$R *.DFM}

uses
  constantes, fundata, funstring, funsql, APrincipal, ConstMsg;

procedure TFConsultaAlteracao.FormCreate(Sender: TObject);
begin
  EDataDe.Date := date;
  EDataAte.Date := Date;
  Self.HelpFile := Varia.PathHelp + 'MCAIXA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
  VprOrdem := ' ORDER BY CAI.NUM_CAIXA ';
  PosicionaAlteracao;
end;

{ ****************** Na criação do Formulário ******************************** }
procedure TFConsultaAlteracao.PosicionaAlteracao;
begin
  LimpaSQLTabela(ALTERACAO);
  ALTERACAO.SQL.ADD(' SELECT * FROM MOV_ALTERACAO MOV, CAD_ALTERACAO CAD, CADUSUARIOS USU, MOV_DIARIO MVD, CAD_CAIXA CAI ' +
                    ' WHERE MOV.EMP_FIL = ' + IntToStr(Varia.CodigoEmpFil) +
                    ' AND   MVD.DAT_ABERTURA >= ''' + DataToStrFormato(AAAAMMDD, EDataDe.Date,'/') + '''' +
                    ' AND   MVD.DAT_ABERTURA <= ''' + DataToStrFormato(AAAAMMDD, EDataAte.Date,'/') + '''');
  if (EAlteracao.Text <> '')
  then ALTERACAO.SQL.Add(' AND MOV.COD_ALTERACAO = ' + Trim(EAlteracao.Text))
  else ALTERACAO.SQL.Add(' ');
  if (ECaixa.Text <> '')
  then ALTERACAO.SQL.Add(' AND MOV.NUM_CAIXA = ' + Trim(ECaixa.Text))
  else ALTERACAO.SQL.Add('');
  if (EUsuarioAbertura.Text <> '')
  then ALTERACAO.SQL.Add(' AND MOV.COD_USUARIO_ALTERACAO = ' + Trim(EUsuarioAbertura.Text))
  else ALTERACAO.SQL.Add(' ');
  case FiltroTipo.ItemIndex of
    0 : begin
          ALTERACAO.SQL.ADD(' AND MOV.FLA_DIARIO_PARCIAL = ''P'' ');
        end;
    1 : begin
          ALTERACAO.SQL.ADD(' AND MOV.FLA_DIARIO_PARCIAL = ''C'' ');
        end
    else ALTERACAO.SQL.ADD(' ');
  end;
  ALTERACAO.SQL.ADD(' AND MVD.EMP_FIL = MOV.EMP_FIL ' +
                    ' AND MVD.SEQ_DIARIO = MOV.SEQ_DIARIO ' +
                    ' AND CAI.EMP_FIL = MOV.EMP_FIL ' +
                    ' AND CAI.NUM_CAIXA = MVD.NUM_CAIXA ' +
                    ' AND CAI.NUM_CAIXA = MOV.NUM_CAIXA ' +
                    ' AND USU.I_COD_USU = MOV.COD_USUARIO_ALTERACAO ' +
                    ' AND CAD.COD_ALTERACAO = MOV.COD_ALTERACAO ' );
  ALTERACAO.SQL.ADD(VprOrdem);
  AbreTabela(ALTERACAO);
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFConsultaAlteracao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FechaTabela(ALTERACAO);
  Action := CaFree;
end;

procedure TFConsultaAlteracao.BFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFConsultaAlteracao.FiltroTipoClick(Sender: TObject);
begin
  PosicionaAlteracao;
end;

procedure TFConsultaAlteracao.EUsuarioAberturaSelect(Sender: TObject);
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

procedure TFConsultaAlteracao.ALTERACAOCOD_ALTERACAOGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text:=ALTERACAOCOD_ALTERACAO.AsString + ' - ' + ALTERACAODES_ALTERACAO.AsString;
end;

procedure TFConsultaAlteracao.GridIndice2Ordem(Ordem: String);
begin
  VprOrdem:=Ordem;
end;

procedure TFConsultaAlteracao.ALTERACAONUM_CAIXAGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text:=ALTERACAONUM_CAIXA.AsString + ' - ' + ALTERACAODES_CAIXA.AsString;
end;

procedure TFConsultaAlteracao.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FConsultaAlteracao.HelpContext);
end;

Initialization
 RegisterClasses([TFConsultaAlteracao]);
end.
