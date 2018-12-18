unit AConsultaFechaParcial;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Buttons, Grids, DBGrids, Tabela, DBKeyViolation, DBCtrls,
  Localizacao, Db, DBTables, ComCtrls, Componentes1, ExtCtrls,
  PainelGradiente, Mask, UNBancario, UnContasAPagar, UnContasAReceber, UnCaixa;

type
  TFConsultaFechamentosParciais = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    Localiza: TConsultaPadrao;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    BFechar: TBitBtn;
    GridIndice2: TGridIndice;
    FECHAMENTO: TQuery;
    DATAITECAIXA: TDataSource;
    FECHAMENTOEMP_FIL: TIntegerField;
    FECHAMENTOSEQ_DIARIO: TIntegerField;
    FECHAMENTOSEQ_PARCIAL: TIntegerField;
    FECHAMENTOSEQ_FECHAMENTO: TIntegerField;
    FECHAMENTODAT_FECHAMENTO: TDateField;
    FECHAMENTOHOR_FECHAMENTO: TTimeField;
    FECHAMENTOVAL_DINHEIRO: TFloatField;
    FECHAMENTOVAL_CHEQUE: TFloatField;
    FECHAMENTOVAL_OUTROS: TFloatField;
    FECHAMENTOVAL_FECHAMENTO_PARCIAL: TFloatField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  public
    procedure PosicionaFechamento(VpaSequencialDiario, VpaSequencialParcial: string; Parcial : Boolean);  
  end;

var
  FConsultaFechamentosParciais: TFConsultaFechamentosParciais;

implementation

{$R *.DFM}

uses
  constantes, fundata, funstring, funsql, APrincipal, ConstMsg;

procedure TFConsultaFechamentosParciais.FormCreate(Sender: TObject);
begin
end;

{ ****************** Na criação do Formulário ******************************** }
procedure TFConsultaFechamentosParciais.PosicionaFechamento(VpaSequencialDiario, VpaSequencialParcial: string; Parcial : Boolean);
begin
  LimpaSQLTabela(FECHAMENTO);
  AdicionaSQLTabela(FECHAMENTO, ' SELECT * FROM ITE_FECHAMENTO ' +
                                ' WHERE SEQ_DIARIO = ' + VpaSequencialDiario  );
  if Parcial then
     AdicionaSQLTabela(FECHAMENTO, ' AND SEQ_PARCIAL = ' + VpaSequencialParcial );
  AdicionaSQLTabela(FECHAMENTO, ' ORDER BY SEQ_FECHAMENTO ');
  AbreTabela(FECHAMENTO);
  Self.ShowModal;
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFConsultaFechamentosParciais.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FechaTabela(FECHAMENTO);
  Action := CaFree;
end;

procedure TFConsultaFechamentosParciais.BFecharClick(Sender: TObject);
begin
  Close;
end;

Initialization
 RegisterClasses([TFConsultaFechamentosParciais]);
end.
