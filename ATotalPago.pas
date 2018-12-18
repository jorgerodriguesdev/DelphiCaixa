unit ATotalPago;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  StdCtrls, Mask, numericos, Componentes1, ExtCtrls, PainelGradiente,
  DBCtrls, Tabela, Db, DBTables, UnCaixa, Buttons;

type
  TFTotalPago = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    ItemCaixa: TQuery;
    DataItemCaixa: TDataSource;
    DBEditNumerico1: TDBEditNumerico;
    DBEditNumerico2: TDBEditNumerico;
    DBEditNumerico3: TDBEditColor;
    ItemCaixaVAL_MOVIMENTO: TFloatField;
    ItemCaixaVAL_PAGO_RECEBIDO: TFloatField;
    ItemCaixaVAL_TROCO: TFloatField;
    BOk: TBitBtn;
    BBAjuda: TBitBtn;
    Fundo: TPanelColor;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    numerico1: Tnumerico;
    numerico2: Tnumerico;
    numerico3: Tnumerico;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BOkClick(Sender: TObject);
    procedure DBEditNumerico2Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BBAjudaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure numerico2Change(Sender: TObject);
  private
    Caixa : TLocalizaCaixa;
  public
    function Item( lancamentoCR, SeqDiario, SeqPArcial : Integer ) : double;
    procedure ValorTroco(ValorPago : Double);
  end;

var
  FTotalPago: TFTotalPago;

implementation

uses APrincipal, constantes;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFTotalPago.FormCreate(Sender: TObject);
begin
  Caixa := TLocalizaCaixa.Criar(self, FPrincipal.BaseDados);
  Self.HelpFile := Varia.PathHelp + 'MCAIXA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFTotalPago.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Caixa.free;
 Action := CaFree;
end;

{********************** chamada externa ************************************ }
function TFTotalPago.Item( lancamentoCR, SeqDiario, SeqPArcial : Integer ) : Double;
begin
 caixa.LocalizaItemCaixaCR( ItemCaixa, SeqPArcial, SeqDiario, lancamentoCR);
 ItemCaixa.edit;
 self.ShowModal;
 result := DBEditNumerico3.Field.AsCurrency;
 itemCAixa.close;
end;

{****************** no fechamento do formulario ***************************** }
procedure TFTotalPago.BOkClick(Sender: TObject);
begin
  if ItemCaixa.State = dsEdit then
    ItemCaixa.Post;
  self.close;
end;

{***************** calcula troco ********************************************* }
procedure TFTotalPago.DBEditNumerico2Change(Sender: TObject);
begin
  if (ItemCaixa.State = dsEdit) and (DBEditNumerico2.Focused) and (DBEditNumerico2.text <> '') then
    DBEditNumerico3.Field.AsCurrency := strtoFloat(DBEditNumerico2.text) - ItemCaixaVAL_MOVIMENTO.AsCurrency ;
  bok.Enabled := DBEditNumerico2.Text <> '';
end;


procedure TFTotalPago.FormActivate(Sender: TObject);
begin
  DBEditNumerico2.SelectAll;
end;

procedure TFTotalPago.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    if (DBEditNumerico2.text = '') and (not fundo.Visible) then
      canclose := false
    else
      canclose := true;  
end;

procedure TFTotalPago.ValorTroco(ValorPago : Double);
begin
  fundo.visible := true;
  numerico1.AValor := ValorPago;
  numerico2.AValor := ValorPago;
  self.ShowModal;
end;


procedure TFTotalPago.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FTotalPago.HelpContext);
end;



procedure TFTotalPago.FormShow(Sender: TObject);
begin
  if fundo.Visible then
  begin
    numerico2.setFocus;
    numerico2.SelectAll;
 end;
end;

procedure TFTotalPago.numerico2Change(Sender: TObject);
begin
  numerico3.avalor := numerico2.avalor - numerico1.avalor;
end;

Initialization
 RegisterClasses([TFTotalPago]);
end.
