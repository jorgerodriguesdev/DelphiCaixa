unit AReportRecibos;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Qrctrls, QuickRpt, ExtCtrls, Geradores, Db, DBTables;

type
  TFReportRecibos = class(TFormularioPermissao)
    ReportRecibos: TQuickRepNovo;
    PageHeaderBand2: TQRBand;
    QRLabel1: TQRLabel;
    QRShape1: TQRShape;
    DetailBand1: TQRBand;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    Valor: TQRLabel;
    referente: TQRLabel;
    Nome: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    CPF: TQRLabel;
    QRLabel7: TQRLabel;
    Assinatura: TQRLabel;
    Texto: TQRLabel;
    Data1: TQRLabel;
    Filial: TQuery;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRShape3: TQRShape;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    procedure ImprimeRecibos(Valor : Double; Nome, CPF, referente : string);
  end;

var
  FReportRecibos: TFReportRecibos;

implementation

uses
  Aprincipal,Fundata,Funsql,funobjeto,Constantes,funnumeros;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFReportRecibos.FormCreate(Sender: TObject);
begin
  AdicionaSQLAbreTabela(Filial,' Select * from cadFiliais where i_emp_fil = ' + Inttostr(varia.CodigoEmpFil));
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFReportRecibos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  filial.close;
  Action := CaFree;
end;

{******************** PASSA O TEXTO DOS EDIT'S COMO PARAMETRO *******************}
procedure TFReportRecibos.ImprimeRecibos(Valor : Double; Nome, CPF, referente : string);
Var
ValorExtenso : string ;
begin
  self.Valor.Caption := FormatFloat(varia.MascaraMoeda, valor);
  self.referente.Caption := referente;
  ValorExtenso := '( ' + Extenso(Valor,'reais','real') + ' )';
  Texto.Caption := ValorExtenso ;
  self.Nome.Caption := Nome;
  Assinatura.Caption := nome;
  self.CPF.caption := cpf;
  Data1.Caption := 'Data : ' + DateToStr(date);
  ReportRecibos.Preview;
  Self.Close;
end;

{ *************** Registra a classe para evitar duplicidade ****************** }
Initialization
 RegisterClasses([TFReportRecibos]);
end.
