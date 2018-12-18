unit APermiteAlterar;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Formularios, UnCaixa, StdCtrls, LabelCorMove, ExtCtrls, Componentes1,
  PainelGradiente, Localizacao, Buttons, Mask, Db, DBTables, numericos,
  DBKeyViolation;

type
  TFPermiteAlterar = class(TFormularioPermissao)
    PTitulo: TPainelGradiente;
    Label3D1: TLabel3D;
    Localiza: TConsultaPadrao;
    PAbertura: TPanel;
    LAbertura: TLabel;
    BConfirmarAlteracao: TBitBtn;
    Label3: TLabel;
    EAlteracao: TEditLocaliza;
    SpeedButton1: TSpeedButton;
    BCancelar: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    EUsuarioCaixa: TEditLocaliza;
    Label4: TLabel;
    ESenhaUsuarioCaixa: TEditColor;
    AUX: TQuery;
    BBAjuda: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ValidaChange(Sender: TObject);
    procedure EUsuarioCaixaRetorno(Retorno1, Retorno2: String);
    procedure BConfirmarAlteracaoClick(Sender: TObject);
    procedure BCancelarClick(Sender: TObject);
    procedure ESenhaUsuarioCaixaExit(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
  private
    { Private declarations }
    Caixa: TFuncoesCaixa;
    SenhaUsuario :  string;
    Acao : Boolean;
    procedure ValidaConfirmacao;
  public
    { Public declarations }
  function CarregaTipoAlterar( VpaTipo: string; VpaUsuario : String; var VpaAlteracao : string; SenhaLib : Boolean): boolean;
  end;

var
  FPermiteAlterar: TFPermiteAlterar;

implementation

{$R *.DFM}

uses FunSql, APrincipal, ConstMsg, Constantes, FunData, FunValida, funstring, funobjeto;

{ ****************** Na criação do Formulário ******************************** }
procedure TFPermiteAlterar.FormCreate(Sender: TObject);
begin
  Caixa := TFuncoesCaixa.Criar(Self, FPrincipal.BaseDados);
  Self.HelpFile := Varia.PathHelp + 'MCAIXA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFPermiteAlterar.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { fecha tabelas }
  Caixa.Destroy;
  Action := CaFree;
end;


{****************** valida a senha do usuario ******************************* }
procedure TFPermiteAlterar.ESenhaUsuarioCaixaExit(Sender: TObject);
begin
  if UpperCase(trim(ESenhaUsuarioCaixa.Text)) <> UpperCase(trim(SenhaUsuario)) then
    if not BCancelar.Focused then
    begin
      Aviso('Senha Inválida !!!');
      ESenhaUsuarioCaixa.Text := '';
      ESenhaUsuarioCaixa.SetFocus;
      abort;
    end;
end;

{ ******************************* carrega permissao ************************* }
function TFPermiteAlterar.CarregaTipoAlterar( VpaTipo: string; VpaUsuario : String; var VpaAlteracao : string; SenhaLib : Boolean): boolean;
begin
  if VpaTipo <> '' then
  begin
    EAlteracao.ASelectLocaliza.Clear;
    EAlteracao.ASelectLocaliza.Add(' SELECT * FROM CAD_ALTERACAO ' +
                                   ' WHERE DES_ALTERACAO LIKE ''@%'' ' +
                                   ' AND FLA_TIPO = ''' + VpaTipo + '''');
    EAlteracao.ASelectValida.Clear;
    EAlteracao.ASelectValida.Add(' SELECT * FROM CAD_ALTERACAO ' +
                                 ' WHERE COD_ALTERACAO = @ ' +
                                 ' AND FLA_TIPO = ''' + VpaTipo + '''');
  end
  else
  begin
    EAlteracao.Enabled := false;
    SpeedButton1.Enabled := false;
    label3.Enabled := false;
  end;

  EUsuarioCaixa.Text := VpaUsuario;
  EUsuarioCaixa.Atualiza;
  if VpaAlteracao <> '' then
  begin
    EAlteracao.Text := VpaAlteracao;
    EAlteracao. Atualiza;
  end;

  Self.ShowModal;
  result := acao;
  VpaAlteracao := EAlteracao.Text;
end;

{******************* valida gravacao ***************************************** }
procedure TFPermiteAlterar.ValidaConfirmacao;
begin
  BConfirmarAlteracao.Enabled := (EUsuarioCaixa.Text <> '' ) and (ESenhaUsuarioCaixa.Text <> '' ) ;
   if EAlteracao.Enabled then
      if (EAlteracao.Text = '' ) then
        BConfirmarAlteracao.Enabled := false;
end;

{******************** valida gravacao *************************************** }
procedure TFPermiteAlterar.ValidaChange(Sender: TObject);
begin
  ValidaConfirmacao;
end;

{************** retorna a senha do usuario ********************************** }
procedure TFPermiteAlterar.EUsuarioCaixaRetorno(Retorno1,
  Retorno2: String);
begin
  if Retorno1 <> '' then
    SenhaUsuario := Descriptografa(Retorno1);
end;

procedure TFPermiteAlterar.BConfirmarAlteracaoClick(Sender: TObject);
begin
  if SenhaDeLiberacaoCaixa then
  begin
    acao := true;
    self.close;
  end;
end;

procedure TFPermiteAlterar.BCancelarClick(Sender: TObject);
begin
  acao := false;
  self.close;
end;


procedure TFPermiteAlterar.BBAjudaClick(Sender: TObject);
begin
 Application.HelpCommand(HELP_CONTEXT,FPermiteAlterar.HelpContext);
end;

Initialization
  RegisterClasses([TFPermiteAlterar]);
end.
