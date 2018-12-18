unit APrincipal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, DBTables, ComCtrls, ExtCtrls, StdCtrls, Buttons,  formulariosFundo, Formularios,
  ToolWin, ExtDlgs, Inifiles, constMsg, FunObjeto, Db, DBCtrls, Grids,
  DBGrids, Componentes1, PainelGradiente, Tabela, Localizacao,
  Mask, Registry, UnPrincipal, LabelCorMove;

const
  CampoPermissaoModulo = 'c_mod_cai';
  CampoFormModulos = 'c_mod_cai';
  NomeModulo = 'Caixa';

type
  TFPrincipal = class(TFormularioFundo)
    Menu: TMainMenu;
    MFAlteraSenha: TMenuItem;
    MAjuda: TMenuItem;
    BaseDados: TDatabase;
    BarraStatus: TStatusBar;
    MArquivo: TMenuItem;
    MSair: TMenuItem;
    MSobre: TMenuItem;
    MFAlterarFilialUso: TMenuItem;
    CorFoco: TCorFoco;
    CorForm: TCorForm;
    CorPainelGra: TCorPainelGra;
    MFAbertura: TMenuItem;
    N6: TMenuItem;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    Caixa1: TMenuItem;
    MFAlteraCaixa: TMenuItem;
    MFConsultaAlteracao: TMenuItem;
    MFConsultaCaixa: TMenuItem;
    MFItensCaixa: TMenuItem;
    MFFechaCaixa: TMenuItem;
    MFAbreCaixa: TMenuItem;
    MFCadAlteracao: TMenuItem;
    MFCadTipoOperacao: TMenuItem;
    MFCadCaixas: TMenuItem;
    MOperacao: TMenuItem;
    MConsulta: TMenuItem;
    N1: TMenuItem;
    BMFFechaCaixa1: TSpeedButton;
    MFCidades: TMenuItem;
    MFCadEstados: TMenuItem;
    MFCadPaises: TMenuItem;
    N3: TMenuItem;
    MFContas: TMenuItem;
    MFBancos: TMenuItem;
    MFClientes: TMenuItem;
    N5: TMenuItem;
    MFSituacoesClientes: TMenuItem;
    MFProfissoes: TMenuItem;
    MFEventos: TMenuItem;
    N7: TMenuItem;
    BMFAlteraItemCaixa: TSpeedButton;
    BMFAbreCaixa1: TSpeedButton;
    N2: TMenuItem;
    MFCondicoesPagamentos: TMenuItem;
    MFFormasPagamento: TMenuItem;
    MFPlanoConta: TMenuItem;
    N4: TMenuItem;
    MFReabreCaixa: TMenuItem;
    BSaida: TSpeedButton;
    BMFMovimentoCaixa: TSpeedButton;
    MFUsuarioMenu: TMenuItem;
    BaseEndereco: TDatabase;
    MFAbreCaixa1: TMenuItem;
    MFFechaCaixa1: TMenuItem;
    MFSangriaSuprimento: TMenuItem;
    MFAlteraItemCaixa: TMenuItem;
    BMFItensCaixa: TSpeedButton;
    BMFSangriaSuprimento: TSpeedButton;
    MFMovimentoCaixa: TMenuItem;
    MAcionaGaveta: TMenuItem;
    BMFClientes: TSpeedButton;
    Ajuda1: TMenuItem;
    ndice1: TMenuItem;
    MForarNovoUsurio: TMenuItem;
    MFBackup: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    MRelatorios: TMenuItem;
    Cadastro1: TMenuItem;
    Caixa2: TMenuItem;
    Clientes1: TMenuItem;
    procedure MostraHint(Sender : TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure MenuClick(Sender: TObject);
    procedure Ajuda1Click(Sender: TObject);
    procedure ndice1Click(Sender: TObject);
    procedure MRelatoriosClick(Sender: TObject);
   
  private
    TipoSistema : string;
    UnPri : TFuncoesPrincipal;
    procedure CriaRelatorio(Sender: TObject);
    procedure CriaRelatorioGeral(Sender: TObject);
  public
     function AbreBaseDados( Alias : string ) : Boolean;
     procedure AlteraNomeEmpresa;
     Function  VerificaPermisao( nome : string ) : Boolean;
     procedure erro(Sender: TObject; E: Exception);
     procedure abre(var Msg: TMsg; var Handled: Boolean);
     procedure VerificaMoeda;
     procedure ValidaBotoesGrupos( botoes : array of TComponent);
     procedure AcionaGaveta;
     procedure ConfiguracaoModulos;
     procedure OrganizaBotoes;
end;

var
  FPrincipal: TFPrincipal;
  Ini : TInifile;

implementation

uses funstring,UnECF, Abertura, AAlterarSenha, ASobre, FunIni, AAlterarFilialUso, funsistema,
     Constantes, UnRegistro, ACadCaixas, ACadTipoOpera, ACadAlteracao,
  AAbreCaixa, AFechaCaixa, AItensCaixa, AConsultaCaixa, AAlteraCaixa,
  AConsultaAlteracao, ATransferencia, AProfissoes, ASituacoesClientes,
  AClientes, ACadPaises, ACadEstados, ACadCidades, APlanoConta, ABancos,
  AContas, AEventos, ACondicoesPgtos, AFormasPagamento,
  AReabreCaixa, UsuarioMenu, funsql, ASangriaSuprimento, AAlteraItens,
  AMovimentoCaixa, ABackup, AInicio, ARelatoriosCaixa, ARelatoriosGeral,
  AMostraMensages;

{$R *.DFM}

// ----- Verifica a permissão do formulários conforme tabela MovGrupoForm -------- //
Function TFPrincipal.VerificaPermisao( nome : string ) : Boolean;
begin
  result := UnPri.VerificaPermisao(nome);
  if not result then
    abort;
end;

// ------------------ Mostra os comentarios ma barra de Status ---------------- }
procedure TFPrincipal.MostraHint(Sender : TObject);
begin
  BarraStatus.Panels[3].Text := Application.Hint;
end;

// ------------------ Na criação do Formulário -------------------------------- }
procedure TFPrincipal.FormCreate(Sender: TObject);
begin
 UnPri := TFuncoesPrincipal.criar(self, BaseDados, NomeModulo);
 Varia := TVariaveis.Create;   // classe das variaveis principais
 Config := TConfig.Create;     // Classe das variaveis Booleanas
 ConfigModulos := TConfigModulo.create; // classe que configura os modulos.
 Application.OnHint := MostraHint;
 Application.HintColor := $00EDEB9E;        // cor padrão dos hints
 Application.Title := 'Caixa';  // nome a ser mostrado na barra de tarefa do Windows
 Application.OnException := Erro;
 Application.OnMessage := Abre;
end;

{************ abre base de dados ********************************************* }
function TFPrincipal.AbreBaseDados( Alias : string ) : Boolean;
begin
  BaseDados.AliasName :=  Alias;
  result := AbreBancoDadosAlias(BaseDados,alias);
end;

procedure TFPrincipal.erro(Sender: TObject; E: Exception);
begin
  FMostraMensagens := TFMostraMensagens.CriarSDI(application,'',true);
  FMostraMensagens.MostraErro(E.Message);
end;

// ------------------- Quando o formulario e fechado -------------------------- }
procedure TFPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  BaseDados.Close;
  Varia.Free;
  Config.Free;
  ConfigModulos.Free;
  UnPri.free;
  Action := CaFree;
end;

// -------------------- Quando o Formulario é Iniciado ------------------------ }
procedure TFPrincipal.FormShow(Sender: TObject);
begin
 // configuracoes do usuario
 UnPri.ConfigUsu(varia.CodigoUsuario, CorFoco, CorForm, CorPainelGra, Self );
  // configura modulos
 ConfiguracaoModulos;
 AlteraNomeEmpresa;
 FPrincipal.WindowState := wsMaximized;  // coloca a janela maximizada;
 // conforme usuario, configura menu
 UnPri.EliminaItemsMenu(self, Menu);
 MAcionaGaveta.Visible := varia.UsarGaveta = 'S';
 OrganizaBotoes;
 Self.HelpFile := Varia.PathHelp + 'MCAIXA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
 VerificaVersaoSistema(CampoPermissaoModulo);
 if VerificaFormCriado('TFInicio') then
 begin
   finicio.close;
   finicio.free;
 end;
end;

{****************** organiza os botoes do formulario ************************ }
procedure TFPrincipal.OrganizaBotoes;
begin
 UnPri.OrganizaBotoes(0, [ BMFClientes, BMFAbreCaixa1, BMFFechaCaixa1,
                           BMFItensCaixa, BMFAlteraItemCaixa, BMFMovimentoCaixa, BMFSangriaSuprimento, BSaida]);
end;

// -------------------- Altera o Caption da Jabela Proncipal ------------------ }
procedure TFPrincipal.AlteraNomeEmpresa;
begin
  UnPri.AlteraNomeEmpresa(self, BarraStatus, NomeModulo, TipoSistema );
end;

// -------------Quando é enviada a menssagem de criação de um formulario------------- //
procedure TFPrincipal.abre(var Msg: TMsg; var Handled: Boolean);
begin
  if (Msg.message = CT_CRIAFORM) or (Msg.message = CT_DESTROIFORM) then
  begin
    UnPri.ConfiguraMenus(screen.FormCount,[],[MFAbertura,MFAlterarFilialUso,MForarNovoUsurio]);
    if (Msg.message = CT_CRIAFORM) and (config.AtualizaPermissao) then
      UnPri.CarregaNomeForms(Screen.ActiveForm.Name, Screen.ActiveForm.Hint, CampoFormModulos, Screen.ActiveForm.Tag);
    if (Msg.message = CT_CRIAFORM) then
      Screen.ActiveForm.Caption := Screen.ActiveForm.Caption + ' [ ' + varia.NomeFilial + ' ] ';
  end;
end;

// --------- Verifica moeda --------------------------------------------------- }
procedure TFPrincipal.VerificaMoeda;
begin
if (varia.DataDaMoeda <> date) and (Config.AvisaDataAtualInvalida)  then
  aviso(CT_DataMoedaDifAtual)
else
  if (varia.MoedasVazias <> '') and (Config.AvisaIndMoeda) then
  avisoFormato(CT_MoedasVazias, [ varia.MoedasVazias]);
end;


// -------------  Valida ou naum Botoes para ususario master ou naum ------------- }
procedure TFPrincipal.ValidaBotoesGrupos( botoes : array of TComponent);
begin
  if Varia.GrupoUsuarioMaster <> Varia.GrupoUsuario then
    AlterarEnabledDet(botoes,false);
end;

{************************  M E N U   D O   S I S T E M A  ********************* }
procedure TFPrincipal.MenuClick(Sender: TObject);
begin
 if  ValidaDataFormulario(date) then
  if Sender is TComponent  then
  case ((Sender as TComponent).Tag) of
    0001 : begin
             // ----- cadastro de caixas ----- //
             FCadCaixas := TFCadCaixas.CriarSDI(Application, '', VerificaPermisao('FCadCaixas'));
             FCadCaixas.ShowModal;
           end;
    0002 : begin
             // ----- cadastro de tipos de operações ----- //
             FCadTipoOperacao := TFCadTipoOperacao.CriarSDI(Application, '', VerificaPermisao('FCadTipoOperacao'));
             FCadTipoOperacao.ShowModal;
           end;
    0003 : begin
             // ----- cadastro de de alterações no caixa ----- //
             FCadAlteracao := TFCadAlteracao.CriarSDI(Application, '', VerificaPermisao('FCadAlteracao'));
             FCadAlteracao.ShowModal;
           end;
   004 : begin
             // ----- abertura de caixa ----- //
             FAbreCaixa := TFAbreCaixa.CriarSDI(Application,'' , VerificaPermisao('FAbreCaixa'));
             FAbreCaixa.AbreCaixa;
           end;
   100 : begin
             // ----- abertura de caixa ----- //
             UnPri.SalvaFormularioEspecial('FAbreCaixa1','Abertura de caixa parcial', CampoFormModulos,'MFAbreCaixa1');
             FAbreCaixa := TFAbreCaixa.CriarSDI(Application,'' , VerificaPermisao('FAbreCaixa1'));
             FAbreCaixa.AbreParcial;
            end;
   020 : begin
           UnPri.SalvaFormularioEspecial('FAcionaGaveta','Acionamento da gaveta manual',CampoFormModulos,'MAcionaGaveta');
           AcionaGaveta;
         end;
   005 : begin
             // ----- fechamento de caixa ----- //
             FFechaCaixa := TFFechaCaixa.CriarSDI(Application,'' , VerificaPermisao('FFechaCaixa'));
             FFechaCaixa.FechaCaixa;
           end;
   110 : begin
             // ----- fechamento de caixa ----- //
             UnPri.SalvaFormularioEspecial('FFechaCaixa1','Fechamento de caixa parcial',CampoFormModulos,'MFFechaCaixa1');
             FFechaCaixa := TFFechaCaixa.CriarSDI(Application,'' , VerificaPermisao('FFechaCaixa1'));
             FFechaCaixa.FechaParcial;
           end;
    120 : begin
             FSangriaSuprimento := TFSangriaSuprimento.CriarSDI(Application,'' , VerificaPermisao('FSangriaSuprimento'));
             FSangriaSuprimento.ValidaCarregaAbertura;
           end;
    130 : begin
             FAlteraItemCaixa := TFAlteraItemCaixa.CriarSDI(Application,'' , VerificaPermisao('FAlteraItemCaixa'));
             FAlteraItemCaixa.EstornaCaixa;
           end;
    0006 : begin
             // ----- lançamentos de itens de caixa ----- //
             FItensCaixa := TFItensCaixa.CriarSDI(Application,'' , VerificaPermisao('FItensCaixa'));
             FItensCaixa.ValidaCarregaAbertura;
           end;
           // ----- consulta movimentação de caixa ----- //
    0007 : FConsultaCaixa := TFConsultaCaixa.CriarMDI(Application, Varia.CT_AreaX,Varia.CT_AreaY, VerificaPermisao('FConsultaCaixa'));
    0008 : begin
             // ----- alterações de caixa ----- //
             FAlteraCaixa := TFAlteraCaixa.CriarMDI(Application,Varia.CT_AreaX,Varia.CT_AreaY, VerificaPermisao('FAlteraCaixa'));
           end;
    0009 : begin
             // ----- consulta alterações nos caixas ----- //
             FConsultaAlteracao := TFConsultaAlteracao.CriarSDI(Application,'' , FPrincipal.VerificaPermisao('FConsultaAlteracao'));
             FConsultaAlteracao.ShowModal;
           end;
    0015 : begin
             // ----- consulta Movimento do  caixa atual ----- //
             FMovimentoCaixa := TFMovimentoCaixa.CriarSDI(Application,'' , FPrincipal.VerificaPermisao('FMovimentoCaixa'));
             FMovimentoCaixa.MovimentoCaixa(varia.CaixaPadrao);
           end;
    0010 : begin
             // ----- reabre último caixa ----- //
             FReabreCaixa := TFReabreCaixa.CriarSDI(Application,'' , FPrincipal.VerificaPermisao('FReabreCaixa'));
             FReabreCaixa.ReabreCaixa;
           end;
    1100 : begin
             FAlterarFilialUso := TFAlterarFilialUso.CriarSDI(application,'', VerificaPermisao('FAlterarFilialUso'));
             FAlterarFilialUso.ShowModal;
           end;
    1200, 1210 : begin
             // ----- Formulario para alterar o usuario atual ----- //
             FAbertura := TFAbertura.Create(Application);
             FAbertura.ShowModal;
             if Varia.StatusAbertura = 'OK' then
             begin
               AlteraNomeEmpresa;
               ResetaMenu(Menu, ToolBar1);
               UnPri.EliminaItemsMenu(self, menu);
               UnPri.ConfigUsu(varia.CodigoUsuario, CorFoco, CorForm, CorPainelGra, Self );
               ConfiguracaoModulos;
               OrganizaBotoes;
             end
             else
               if  ((Sender as TComponent).Tag) = 1210 then
                 FPrincipal.close;
           end;
  1250 : begin
           FUsuarioMenu := TFUsuarioMenu.CriarSDI(application,'',VerificaPermisao('FUsuarioMenu'));
           FUsuarioMenu.AbreFormulario(1);
         end;
  1270 : begin
           FBackup := TFBackup.CriarSDI(application,'',VerificaPermisao('FBackup'));
           FBackup.ShowModal;
         end;

           // ----- Sair do Sistema ----- //
    1300 : Close;
           // ----- Formulario de Empresas ----- //
    2300 : begin
             FEventos := TFEventos.CriarSDI(application, '', VerificaPermisao('FEventos'));
             FEventos.ShowModal;
           end;
    2400 : begin
             // ------- As profissões do Cliente ------- //
             FProfissoes := TFProfissoes.CriarSDI(application,'',VerificaPermisao('FProfissoes'));
             FProfissoes.ShowModal;
           end;
    2500 : begin
             // ------ As Situções do Cliente ------- //
             FSituacoesClientes := TFSituacoesClientes.CriarSDI(Application,'',VerificaPermisao('FSituacoesClientes'));
             FSituacoesClientes.ShowModal;
           end;
           // ------- Cadastro de Clientes ------- //
    2600 : FClientes := TFClientes.criarMDI(application, varia.CT_AreaX, varia.CT_AreaY,VerificaPermisao('FClientes'));
    2920 : begin
             // ------ Cadastro de Paises ------ //
             FCadPaises := TFCadPaises.CriarSDI(Application,'',VerificaPermisao('FCadPaises'));
             FCadPaises.ShowModal;
           end;
    2930 : begin
             // ------ Cadastro de Estados ------ //
             FCadEstados := TFCadEstados.CriarSDI(Application,'',VerificaPermisao('FCadEstados'));
             FCadEstados.ShowModal;
           end;
    2940 : begin
             // ------ Cadastro de Cidades ------ //
             FCidades := TFCidades.CriarSDI(Application,'',VerificaPermisao('FCidades'));
             FCidades.ShowModal;
           end;
    4110 : begin
             // ------ Cadastro de Condições de Pagamento ------ //
             FCondicoesPagamentos := TFCondicoesPagamentos.CriarSDI(Application,'',VerificaPermisao('FCondicoesPagamentos'));
             FCondicoesPagamentos.ShowModal;
           end;
    4120 : begin
             // ------ Cadastra formas de pagamento ------ //
             FFormasPagamento := TFFormasPagamento.CriarSDI(Application,'',VerificaPermisao('FFormasPagamento'));
             FFormasPagamento.ShowModal;
           end;
    4140 : begin
             FPlanoConta := TFPlanoConta.criarSDI(Application, '', True);
             FPlanoConta.CarregaPlanoContas('');
           end;
    4150 : begin
             // ------ Cadastro de Bancos ------ //
             FBancos := TFBancos.CriarSDI(Application,'',VerificaPermisao('FBancos'));
             FBancos.ShowModal;
           end;
    4160 : begin
             // ------ Cadastro de Contas Correntes ------ //
             FContas := TFContas.CriarSDI(Application,'',VerificaPermisao('FContas'));
             FContas.Showmodal;
           end;
    6100 : begin
             FAlteraSenha := TFAlteraSenha.CriarSDI(Application,'',VerificaPermisao('FAlteraSenha'));
             FAlteraSenha.ShowModal;
           end;
    9100 : begin
             FSobre := TFSobre.CriarSDI(application,'', VerificaPermisao('FSobre'));
             FSobre.ShowModal;
           end;
  end;
end;

{********************* aciona gaveta ************************************** }
procedure TFPrincipal.AcionaGaveta;
var
  ECF : TECF;
  senha : string;
begin
   // verifica aciona gaveta
  if (varia.UsarGaveta = 'S') then
   if Entrada('Senha:','Digite senha de Liberação:', senha, true, CorFoco.AFundoComponentes, CorForm.ACorPainel) then
     if senha = Varia.SenhaLiberacao then
     begin
       if ECF.AbrePorta then
        begin
          ECF := TECF.criar(nil, FPrincipal.BaseDados);
          ECF.AcionaGaveta;
          ECF.FecharPorta;
          Ecf.Free;
        end;
     end
     else
       aviso('Senha inválida!');
end;

{******************* configura os modulos do sistema ************************* }
procedure TFPrincipal.ConfiguracaoModulos;
var
  Reg : TRegistro;
begin
  Reg := TRegistro.create;
  reg.ValidaModulo( TipoSistema, [ MOperacao, MConsulta, MFClientes, BMFClientes, BMFAbreCaixa1, BMFFechaCaixa1, BMFItensCaixa, BMFMovimentoCaixa ] );
  reg.ConfiguraModulo( CT_Caixa, [ MOperacao, MConsulta, BMFAbreCaixa1, BMFFechaCaixa1, BMFItensCaixa ] );
  reg.ConfiguraModulo( CT_SENHAGRUPO, [ MFUsuarioMenu ] );
  reg.Free;
end;


procedure TFPrincipal.Ajuda1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_FINDER,0);
end;

procedure TFPrincipal.ndice1Click(Sender: TObject);
begin
   Application.HelpCommand(HELP_KEY,0);
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                              Relatorios
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{**************************** Gera os menus de relatorios ********************}
procedure TFPrincipal.MRelatoriosClick(Sender: TObject);
begin
 if  ValidaDataFormulario(date) then
  if (sender is TMenuItem) then
    if MRelatorios.Tag <> 1 then
    begin
//      UnPri.GeraMenuRelatorios(Menu,CriaRelatorioGeral,'Cadastro\Geral',(sender as TMenuItem).MenuIndex,0);
      UnPri.GeraMenuRelatorios(Menu,CriaRelatorioGeral,'Cliente',(sender as TMenuItem).MenuIndex,1,99);
      if ConfigModulos.Caixa then
        UnPri.GeraMenuRelatorios(Menu,CriaRelatorio,'Caixa',(sender as TMenuItem).MenuIndex,2,99);
      MRelatorios.Tag := 1;
    end;
end;

{******************* chama um relatorio **************************************}
procedure TFPrincipal.CriaRelatorio(Sender: TObject);
begin
  if VerificaPermisao((sender as TMenuItem).Name) then
  begin
    UnPri.SalvaFormularioEspecial((sender as TMenuItem).Name, DeletaChars((sender as TMenuItem).Caption,'&'),'c_mod_fat',(sender as TMenuItem).Name);
    FRelatoriosCaixa := TFRelatoriosCaixa.CriarSDI(application,'',true);
    FRelatoriosCaixa.CarregaConfig((sender as TMenuItem).Hint, (sender as TMenuItem).Caption);
    FRelatoriosCaixa.ShowModal;
  end;
end;

{******************* chama um relatorio **************************************}
procedure TFPrincipal.CriaRelatorioGeral(Sender: TObject);
begin
  if VerificaPermisao((sender as TMenuItem).Name) then
  begin
    UnPri.SalvaFormularioEspecial((sender as TMenuItem).Name, DeletaChars((sender as TMenuItem).Caption,'&'),'c_mod_fat',(sender as TMenuItem).Name);
    FRelatoriosGeral := TFRelatoriosGeral.CriarSDI(application,'',true);
    FRelatoriosGeral.CarregaConfig((sender as TMenuItem).Hint, (sender as TMenuItem).Caption);
    FRelatoriosGeral.ShowModal;
  end;
end;



end.
