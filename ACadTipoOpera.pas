unit ACadTipoOpera;

{          Autor: Jorge Eduardo
    Data Criação: 19/10/1999;
          Função: Cadastrar um novo Caixa
  Data Alteração: 03 de outubro de 2001
    Alterado por: 
Motivo alteração:
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  Componentes1, ExtCtrls, PainelGradiente, BotaoCadastro,
  StdCtrls, Buttons, Db, DBTables, Tabela, Mask, DBCtrls, Grids, DBGrids,
  DBKeyViolation, Localizacao;

type
  TFCadTipoOperacao = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor1: TPanelColor;
    PanelColor2: TPanelColor;
    MoveBasico1: TMoveBasico;
    BotaoCadastrar1: TBotaoCadastrar;
    BAlterar: TBotaoAlterar;
    BotaoExcluir1: TBotaoExcluir;
    BotaoGravar1: TBotaoGravar;
    BotaoCancelar1: TBotaoCancelar;
    DataCadTipoOpera: TDataSource;
    Label2: TLabel;
    Label3: TLabel;
    DBEditColor2: TDBEditColor;
    Bevel1: TBevel;
    Label1: TLabel;
    EConsulta: TLocalizaEdit;
    CadTipoOpera: TSQL;
    BFechar: TBitBtn;
    GGrid: TGridIndice;
    CadTipoOperaCOD_OPERACAO: TIntegerField;
    CadTipoOperaCREDITO_DEBITO: TStringField;
    TipoDBRadio: TDBRadioGroup;
    DBRadio: TDBRadioGroup;
    CadTipoOperaFLA_TIPO: TStringField;
    ValidaGravacao: TValidaGravacao;
    CadTipoOperaFLA_CP_CR_OUT: TStringField;
    CadTipoOperaDES_OPERACAO: TStringField;
    CadTipoOperaD_ULT_ALT: TDateField;
    BBAjuda: TBitBtn;
    DBKeyViolation1: TDBKeyViolation;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CadTipoOperaAfterInsert(DataSet: TDataSet);
    procedure CadTipoOperaBeforePost(DataSet: TDataSet);
    procedure CadTipoOperaAfterPost(DataSet: TDataSet);
    procedure CadTipoOperaAfterEdit(DataSet: TDataSet);
    procedure BFecharClick(Sender: TObject);
    procedure GGridDblClick(Sender: TObject);
    procedure CadTipoOperaAfterCancel(DataSet: TDataSet);
    procedure GGridOrdem(Ordem: String);
    procedure DBRadioChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
    procedure BotaoCadastrar1Click(Sender: TObject);
    procedure DBKeyViolation1Change(Sender: TObject);
  private
    procedure ConfiguraConsulta( acao : Boolean);
    procedure CodigoOperacao;
  public
    { Public declarations }
  end;

var
  FCadTipoOperacao: TFCadTipoOperacao;

implementation

{$R *.DFM}

uses APrincipal,Constantes,fundata, funstring,constmsg,funObjeto,
     FunSql,funnumeros;

{ ****************** Na criação do Formulário ******************************** }
procedure TFCadTipoOperacao.FormCreate(Sender: TObject);
begin
  CadTipoOpera.open;
  Self.HelpFile := Varia.PathHelp + 'MCAIXA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFCadTipoOperacao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CadTipoOpera.close; { fecha tabelas }
  Action := CaFree;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações da Tabela
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{***********************Gera o proximo codigo disponível***********************}
procedure TFCadTipoOperacao.CadTipoOperaAfterInsert(DataSet: TDataSet);
begin
   DBRadio.ItemIndex:=2;
   TipoDBRadio.ItemIndex:=1;
   DBKeyViolation1.ReadOnly := false;
   ConfiguraConsulta(False);
   CodigoOperacao;
end;

{********Verifica se o codigo ja foi utilizado por algum usuario da rede*******}
procedure TFCadTipoOperacao.CadTipoOperaBeforePost(DataSet: TDataSet);
begin
  //atualiza a data de alteracao para poder exportar
  CadTipoOperaD_ULT_ALT.AsDateTime := Date;
  if CadTipoOpera.State = dsinsert then
end;

{******************************Atualiza a tabela*******************************}
procedure TFCadTipoOperacao.CadTipoOperaAfterPost(DataSet: TDataSet);
begin
  EConsulta.AtualizaTabela;
  ConfiguraConsulta(True);
end;

{*********************Coloca o campo chave em read-only************************}
procedure TFCadTipoOperacao.CadTipoOperaAfterEdit(DataSet: TDataSet);
begin
   ConfiguraConsulta(False);
   DBRadioChange(nil);
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Ações Diversas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****************************Fecha o Formulario corrente***********************}
procedure TFCadTipoOperacao.BFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFCadTipoOperacao.GGridDblClick(Sender: TObject);
begin
end;

{****** configura a consulta, caso edit ou insert enabled = false *********** }
procedure TFCadTipoOperacao.ConfiguraConsulta( acao : Boolean);
begin
   Label1.Enabled := acao;
   EConsulta.Enabled := acao;
   GGrid.Enabled := acao;
end;

procedure TFCadTipoOperacao.CadTipoOperaAfterCancel(DataSet: TDataSet);
begin
  ConfiguraConsulta(True);
end;

procedure TFCadTipoOperacao.GGridOrdem(Ordem: String);
begin
  EConsulta.AOrdem:=Ordem;
end;

procedure TFCadTipoOperacao.DBRadioChange(Sender: TObject);
begin
  if (CadTipoOpera.State in [dsInsert, dsEdit]) then
  begin
    TipoDBRadio.Enabled := true;
    TipoDBRadio.Controls[2].Enabled := false;
    case DBRadio.ItemIndex of
      0 : begin
            TipoDBRadio.ItemIndex:=1;
            TipoDBRadio.Enabled := False;
          end;
      1 : begin
            TipoDBRadio.ItemIndex:=0;
            TipoDBRadio.Enabled := False;
          end;
      4 :  begin
            TipoDBRadio.ItemIndex:=1;
            TipoDBRadio.Enabled := False;
          end;
      5 :  begin
            TipoDBRadio.ItemIndex:=2;
            TipoDBRadio.Enabled := False;
          end;
      6 :  begin
            TipoDBRadio.ItemIndex:=2;
            TipoDBRadio.Enabled := False;
          end;
    end;
   end
   else TipoDBRadio.Enabled := True;
end;

procedure TFCadTipoOperacao.FormShow(Sender: TObject);
begin
  DBRadio.Controls[1].Enabled := ConfigModulos.ContasAPagar;
  DBRadio.Controls[0].Enabled := ConfigModulos.ContasAReceber;
  if (not ConfigModulos.ContasAPagar) and ( not ConfigModulos.ContasAReceber) then
    DBRadio.Controls[3].Enabled := false;
end;

procedure TFCadTipoOperacao.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FCadTipoOperacao.HelpContext);
end;

procedure TFCadTipoOperacao.CodigoOperacao;
var
  Codigo : integer;
begin
  Codigo := ProximoCodigo('Cad_Tipo_Opera','Cod_Operacao',FPrincipal.BaseDados);
  CadTipoOperaCOD_OPERACAO.AsInteger := Codigo;
end;

procedure TFCadTipoOperacao.BotaoCadastrar1Click(Sender: TObject);
begin
  CodigoOperacao;
end;

procedure TFCadTipoOperacao.DBKeyViolation1Change(Sender: TObject);
begin
  if (CadTipoOpera.State in [dsInsert, dsEdit]) then
  ValidaGravacao.Execute;
end;

Initialization
  RegisterClasses([TFCadTipoOperacao]);
end.
