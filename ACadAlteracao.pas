unit ACadAlteracao;

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
  TFCadAlteracao = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    MoveBasico1: TMoveBasico;
    BotaoCadastrar1: TBotaoCadastrar;
    BAlterar: TBotaoAlterar;
    BotaoExcluir1: TBotaoExcluir;
    BotaoGravar1: TBotaoGravar;
    BotaoCancelar1: TBotaoCancelar;
    DataCadAlteracao: TDataSource;
    Label2: TLabel;
    Label3: TLabel;
    DBEditColor2: TDBEditColor;
    Bevel1: TBevel;
    KCodigoAlteracao: TDBFilialColor;
    Label1: TLabel;
    EConsulta: TLocalizaEdit;
    CadAlteracao: TSQL;
    BFechar: TBitBtn;
    GGrid: TGridIndice;
    CadAlteracaoCOD_ALTERACAO: TIntegerField;
    CadAlteracaoDES_ALTERACAO: TStringField;
    CadAlteracaoDES_OBSERVACAO: TStringField;
    DBMemoColor1: TDBMemoColor;
    Label4: TLabel;
    TipoRadio: TDBRadioGroup;
    CadAlteracaoFLA_TIPO: TStringField;
    ValidaGravacao: TValidaGravacao;
    CadAlteracaoD_ULT_ALT: TDateField;
    BBAjuda: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CadAlteracaoAfterInsert(DataSet: TDataSet);
    procedure CadAlteracaoBeforePost(DataSet: TDataSet);
    procedure CadAlteracaoAfterPost(DataSet: TDataSet);
    procedure CadAlteracaoAfterEdit(DataSet: TDataSet);
    procedure BFecharClick(Sender: TObject);
    procedure CadAlteracaoAfterCancel(DataSet: TDataSet);
    procedure GGridOrdem(Ordem: String);
    procedure KCodigoAlteracaoChange(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
  private
    procedure ConfiguraConsulta( acao : Boolean);
  public
    { Public declarations }
  end;

var
  FCadAlteracao: TFCadAlteracao;

implementation

uses APrincipal;

{$R *.DFM}


{ ****************** Na criação do Formulário ******************************** }
procedure TFCadAlteracao.FormCreate(Sender: TObject);
begin
   KCodigoAlteracao.ACodFilial := varia.CodigoFilCadastro;
   CadAlteracao.open;
   Self.HelpFile := Varia.PathHelp + 'MCAIXA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFCadAlteracao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CadAlteracao.close; { fecha tabelas }
  { chamar a rotina de atualização de menus }
  Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações da Tabela
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{***********************Gera o proximo codigo disponível***********************}
procedure TFCadAlteracao.CadAlteracaoAfterInsert(DataSet: TDataSet);
begin
   KCodigoAlteracao.ReadOnly := False;
   KCodigoAlteracao.ProximoCodigo;
   TipoRadio.ItemIndex:=0;   
   ConfiguraConsulta(False);   
end;

{********Verifica se o codigo ja foi utilizado por algum usuario da rede*******}
procedure TFCadAlteracao.CadAlteracaoBeforePost(DataSet: TDataSet);
begin
  //atualiza a data de alteracao para poder exportar
  CadAlteracaoD_ULT_ALT.AsDateTime := Date;

  if CadAlteracao.State = dsinsert then
    KCodigoAlteracao.VerificaCodigoRede;
end;

{******************************Atualiza a tabela*******************************}
procedure TFCadAlteracao.CadAlteracaoAfterPost(DataSet: TDataSet);
begin
  EConsulta.AtualizaTabela;
  ConfiguraConsulta(True);  
end;

{*********************Coloca o campo chave em read-only************************}
procedure TFCadAlteracao.CadAlteracaoAfterEdit(DataSet: TDataSet);
begin
   KCodigoAlteracao.ReadOnly := true;
   ConfiguraConsulta(False);   
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****************************Fecha o Formulario corrente***********************}
procedure TFCadAlteracao.BFecharClick(Sender: TObject);
begin
  Close;
end;

{****** configura a consulta, caso edit ou insert enabled = false *********** }
procedure TFCadAlteracao.ConfiguraConsulta( acao : Boolean);
begin
   Label1.Enabled := acao;
   EConsulta.Enabled := acao;
   GGrid.Enabled := acao;
end;


procedure TFCadAlteracao.CadAlteracaoAfterCancel(DataSet: TDataSet);
begin
  ConfiguraConsulta(True);
end;

procedure TFCadAlteracao.GGridOrdem(Ordem: String);
begin
  EConsulta.AOrdem:=Ordem;
end;

procedure TFCadAlteracao.KCodigoAlteracaoChange(Sender: TObject);
begin
  if (CadAlteracao.State in [dsInsert, dsEdit]) then
  ValidaGravacao.Execute;
end;

procedure TFCadAlteracao.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FCadAlteracao.HelpContext);
end;

Initialization
 RegisterClasses([TFCadAlteracao]);
end.
 