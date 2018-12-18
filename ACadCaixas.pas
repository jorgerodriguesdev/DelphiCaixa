unit ACadCaixas;

{          Autor: Jorge Eduardo
    Data Criação: 19/10/1999;
          Função: Cadastrar um novo Caixa
  Data Alteração:
    Alterado por:
Motivo alteração:
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Componentes1, ExtCtrls, PainelGradiente, BotaoCadastro, Constantes,
  StdCtrls, Buttons, Db, DBTables, Tabela, Mask, DBCtrls, Grids, DBGrids,
  DBKeyViolation, Localizacao;

type
  TFCadCaixas = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    MoveBasico1: TMoveBasico;
    BotaoCadastrar1: TBotaoCadastrar;
    BAlterar: TBotaoAlterar;
    BotaoExcluir1: TBotaoExcluir;
    BotaoGravar1: TBotaoGravar;
    BotaoCancelar1: TBotaoCancelar;
    DataCadCaixa: TDataSource;
    Label2: TLabel;
    Label3: TLabel;
    DBEditColor2: TDBEditColor;
    Bevel1: TBevel;
    Label1: TLabel;
    EConsulta: TLocalizaEdit;
    CadCaixa: TSQL;
    BFechar: TBitBtn;
    GGrid: TGridIndice;
    CadCaixaEMP_FIL: TIntegerField;
    CadCaixaNUM_CAIXA: TIntegerField;
    CadCaixaDES_CAIXA: TStringField;
    CadCaixaFLA_SALDO_ANTERIOR: TStringField;
    TipoRadio: TDBRadioGroup;
    ValidaGravacao: TValidaGravacao;
    CadCaixaFLA_USA_ECF: TStringField;
    CadCaixaD_ULT_ALT: TDateField;
    BBAjuda: TBitBtn;
    DBEditColor1: TDBEditColor;
    Label4: TLabel;
    DBFilialColor1: TDBFilialColor;
    CadCaixaFLA_CAD_PAG: TStringField;
    CadCaixaFLA_CAD_REC: TStringField;
    CadCaixaFLA_PAG_PAG: TStringField;
    CadCaixaFLA_REC_REC: TStringField;
    GroupBox1: TGroupBox;
    DBCheckBox1: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    DBCheckBox3: TDBCheckBox;
    DBCheckBox4: TDBCheckBox;
    DBCheckBox5: TDBCheckBox;
    CadCaixaC_CAI_GER: TStringField;
    DBCheckBox6: TDBCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CadCaixaAfterInsert(DataSet: TDataSet);
    procedure CadCaixaBeforePost(DataSet: TDataSet);
    procedure CadCaixaAfterPost(DataSet: TDataSet);
    procedure CadCaixaAfterEdit(DataSet: TDataSet);
    procedure BFecharClick(Sender: TObject);
    procedure CadCaixaAfterCancel(DataSet: TDataSet);
    procedure GGridOrdem(Ordem: String);
    procedure KNumeroCaixaChange(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
  private
    procedure ConfiguraConsulta( acao : Boolean);
  public
    { Public declarations }
  end;

var
  FCadCaixas: TFCadCaixas;

implementation

uses APrincipal, funobjeto, funsql;

{$R *.DFM}

{ ****************** Na criação do Formulário ******************************** }
procedure TFCadCaixas.FormCreate(Sender: TObject);
begin
   DBFilialColor1.ACodFilial := Varia.CodigoFilCadastro;
   AdicionaSQLAbreTabela(CadCaixa, ' Select * from CAD_CAIXA ' +
                                   ' where EMP_FIL = ' + IntTostr(varia.CodigoEmpFil)  +
                                   ' order by NUM_CAIXA ');
   IniciallizaCheckBox([ DBCheckBox1,DBCheckBox2,DBCheckBox3,DBCheckBox4,DBCheckBox5, DBCheckBox6] ,'S','N');
   Self.HelpFile := Varia.PathHelp + 'MCAIXA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFCadCaixas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CadCaixa.close; { fecha tabelas }
  Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações da Tabela
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{***********************Gera o proximo codigo disponível***********************}
procedure TFCadCaixas.CadCaixaAfterInsert(DataSet: TDataSet);
begin
   CadCaixaEMP_FIL.AsInteger:=Varia.CodigoEmpFil;
   CadCaixaC_CAI_GER.AsString := 'N';
   DBFilialColor1.ProximoCodigo;
   DBFilialColor1.ReadOnly := False;
   TipoRadio.ItemIndex := 0;
   ConfiguraConsulta(False);
end;

{********Verifica se o codigo ja foi utilizado por algum usuario da rede*******}
procedure TFCadCaixas.CadCaixaBeforePost(DataSet: TDataSet);
begin
  //atualiza a data de alteracao para poder exportar
  CadCaixaD_ULT_ALT.AsDateTime := Date;
  if CadCaixa.State = dsinsert then
      DBFilialColor1.VerificaCodigoRede;
end;

{******************************Atualiza a tabela*******************************}
procedure TFCadCaixas.CadCaixaAfterPost(DataSet: TDataSet);
begin
  EConsulta.AtualizaTabela;
  ConfiguraConsulta(True);
end;

{*********************Coloca o campo chave em read-only************************}
procedure TFCadCaixas.CadCaixaAfterEdit(DataSet: TDataSet);
begin
   DBFilialColor1.ReadOnly := true;
   ConfiguraConsulta(False);
end;

{ ********************* quando cancela a operacao *************************** }
procedure TFCadCaixas.CadCaixaAfterCancel(DataSet: TDataSet);
begin
  ConfiguraConsulta(True);
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****************************Fecha o Formulario corrente***********************}
procedure TFCadCaixas.BFecharClick(Sender: TObject);
begin
  Close;
end;

{****** configura a consulta, caso edit ou insert enabled = false *********** }
procedure TFCadCaixas.ConfiguraConsulta( acao : Boolean);
begin
   Label1.Enabled := acao;
   EConsulta.Enabled := acao;
   GGrid.Enabled := acao;
end;

procedure TFCadCaixas.GGridOrdem(Ordem: String);
begin
  EConsulta.AOrdem := ordem;
end;

procedure TFCadCaixas.KNumeroCaixaChange(Sender: TObject);
begin
  if (CadCaixa.State in [dsInsert, dsEdit]) then
  ValidaGravacao.Execute;
end;

procedure TFCadCaixas.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FCadCaixas.HelpContext);
end;

Initialization
 RegisterClasses([TFCadCaixas]);
end.
