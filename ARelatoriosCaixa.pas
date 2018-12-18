unit ARelatoriosCaixa;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, formularios,
  UCrpe32, StdCtrls, Buttons, Componentes1, ComCtrls, ExtCtrls,
  PainelGradiente, Localizacao, Mask, DBCtrls, Tabela, DBTables,
  Db, Grids, DBGrids, numericos;

type
  TFRelatoriosCaixa = class(TFormularioPermissao)
    PainelGradiente1: TPainelGradiente;
    PanelColor2: TPanelColor;
    Rel: TCrpe;
    BBotao: TBitBtn;
    Localiza: TConsultaPadrao;
    BFechar: TBitBtn;
    ScrollBox1: TScrollBox;
    Fundo: TPanelColor;
    PFilial: TPanelColor;
    Label24: TLabel;
    SpeedButton1: TSpeedButton;
    LFilial: TLabel;
    EFIlial: TEditLocaliza;
    PPeriodo: TPanelColor;
    Label4: TLabel;
    Data1: TCalendario;
    Data2: TCalendario;
    PCodClientes: TPanelColor;
    Label18: TLabel;
    SpeedButton2: TSpeedButton;
    LCliente: TLabel;
    Eclientes: TEditLocaliza;
    PignoraPeriodo: TPanelColor;
    IgnorarPeriodo: TCheckBox;
    PForcenecedor: TPanelColor;
    Label1: TLabel;
    SpeedButton3: TSpeedButton;
    Lfornecedor: TLabel;
    EFornecedor: TEditLocaliza;
    PFormaPagto: TPanelColor;
    Label20: TLabel;
    EFormaPgto: TEditLocaliza;
    SpeedButton5: TSpeedButton;
    LFormaPagto: TLabel;
    Pcaixa: TPanelColor;
    Label2: TLabel;
    Ecaixa: TEditLocaliza;
    SpeedButton7: TSpeedButton;
    LCaixa: TLabel;
    PNroCaixa: TPanelColor;
    Label3: TLabel;
    EnroCaixa: Tnumerico;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BBotaoClick(Sender: TObject);
    procedure BFecharClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure IgnorarPeriodoClick(Sender: TObject);
    procedure EcaixaSelect(Sender: TObject);
    procedure RelExecuteBegin(Sender: TObject; var Cancel: Boolean);
    procedure RelExecuteEnd(Sender: TObject);
    procedure EFIlialSelect(Sender: TObject);
  private
    Identificador : string;
    function SomaPainel : integer;
    procedure ConfiguraPainels( NomeParametro : string);
    function RetornaParametro( NomeParametro : string) : string;
    function TextoDosFiltros : string;
  public
    function CarregaConfig(NomeRel, TituloForm : string) : Boolean;
  end;

var
  FRelatoriosCaixa: TFRelatoriosCaixa;

implementation

uses funstring, fundata, constantes, funObjeto, APrincipal, constmsg,
  AInicio;

{$R *.DFM}

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                          Formulario
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{ ****************** Na criação do Formulário ******************************** }
procedure TFRelatoriosCaixa.FormCreate(Sender: TObject);
begin
  EFIlial.APermitirVazio := Varia.FilialUsuario = '';
  data1.DateTime := PrimeiroDiaMes(date);
  data2.DateTime := UltimoDiaMes(date);
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFRelatoriosCaixa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := CaFree;
end;

{****************** no show do formulario *********************************** }
procedure TFRelatoriosCaixa.FormShow(Sender: TObject);
begin
  EFIlial.Text := IntToStr(varia.CodigoEmpFil);
  EFIlial.Atualiza;
end;

{****************** fecha o formulario ************************************** }
procedure TFRelatoriosCaixa.BFecharClick(Sender: TObject);
begin
  self.close;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                    funcoes de configuracao do relatorio
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{************************** Soma altura dos paineis ***************************}
function TFRelatoriosCaixa.SomaPainel : integer;
var
  laco : Integer;
begin
   result := 0;
   for laco := 0 to (Fundo.ControlCount -1) do
     if (Fundo.Controls[laco] is TPanelColor) then
       if (Fundo.Controls[laco] as TPanelColor).Visible then
         result := result + (Fundo.Controls[laco] as TPanelColor).Height;
end;

{*********************** Configura os paineis visiveis ***********************}
procedure TFRelatoriosCaixa.ConfiguraPainels( NomeParametro : string);
begin
  if UpperCase(NomeParametro) = 'FILIAL' then
    PFilial.Visible := true else
  if  UpperCase(NomeParametro) = 'DIAINICIO' then
  begin
    PPeriodo.Visible := true;
    Data1.Visible := true;
  end  else
  if  UpperCase(NomeParametro) = 'DIAFIM' then
  begin
    PPeriodo.Visible := true;
    Data2.Visible := true;
  end else
  if UpperCase(NomeParametro) = 'CODCLIENTE' then
    PCodClientes.Visible := true;
  if UpperCase(NomeParametro) = 'IGNORADATA' then
    PignoraPeriodo.Visible := true;
  if UpperCase(NomeParametro) = 'CODFORNECEDOR' then
    PForcenecedor.Visible := true;
  if UpperCase(NomeParametro) = 'CODFORMAPAGTO' then
    PFormaPagto.Visible := true;
  if UpperCase(NomeParametro) = 'CODCAIXA' then
    PCaixa.Visible := true;
  if UpperCase(NomeParametro) = 'NROCAIXA' then
    PNroCaixa.Visible := true;
end;

{******************** retorna o valor do parametro ***************************}
function  TFRelatoriosCaixa.RetornaParametro( NomeParametro : string) : string;
begin
  result := '@ERRO@';
  if UpperCase(NomeParametro) = 'TITULO' then result := 'Relatório de ' + trim(PainelGradiente1.Caption) else
  if UpperCase(NomeParametro) = 'EMPRESA' then result := inttostr(varia.CodigoEmpresa) else
  if UpperCase(NomeParametro) = 'FILIAL' then result := EFilial.text else
  if UpperCase(NomeParametro) = 'DIAINICIO' then result := inttostr(dia(Data1.DateTime)) else
  if UpperCase(NomeParametro) = 'MESINICIO' then result := inttostr(mes(Data1.DateTime)) else
  if UpperCase(NomeParametro) = 'ANOINICIO' then result := inttostr(ano(Data1.DateTime)) else
  if UpperCase(NomeParametro) = 'DIAFIM' then result := inttostr(dia(Data2.DateTime)) else
  if UpperCase(NomeParametro) = 'MESFIM' then result := inttostr(mes(Data2.DateTime)) else
  if UpperCase(NomeParametro) = 'ANOFIM' then result := inttostr(ano(Data2.DateTime)) else
  if UpperCase(NomeParametro) = 'CODCLIENTE' then result := EClientes.Text else
  if UpperCase(NomeParametro) = 'IGNORADATA' then
      begin if IgnorarPeriodo.Checked then result := '0' else result := '1' end else
  if UpperCase(NomeParametro) = 'CODFORNECEDOR' then result := EFornecedor.Text else
  if UpperCase(NomeParametro) = 'CODFORMAPAGTO' then result := EFormaPgto.Text else
  if UpperCase(NomeParametro) = 'CODCAIXA' then result := Ecaixa.Text else
  if UpperCase(NomeParametro) = 'NROCAIXA' then result := Inttostr(trunc(EnroCaixa.Avalor)) else
    aviso('Parametro não configurado ' + NomeParametro);
end;

function TFRelatoriosCaixa.TextoDosFiltros : string;
begin
  result := Identificador;
  if PPeriodo.Visible then
  begin
    result := result + '-Período de ';
    if (Data1.Enabled) then result := result + datetostr(data1.date) else result := 'Todo';
    if (Data2.visible) then result := result + ' à ' + datetostr(data2.date);
  end;

  if PFilial.Visible then
  begin
    result := result + '-Filial: ';
    if EFIlial.Text <> '' then result := result + LFilial.caption else result := result + 'Todas';
  end;


  if PForcenecedor.Visible then
  begin
    result := result + '-Fornecedor: ';
    if EFornecedor.Text <> '' then result := result + Lfornecedor.caption else result := result + 'Todos';
  end;

  if PFormaPagto.Visible then
  begin
    result := result + '-Forma Pagto: ';
    if EFormaPgto.Text <> '' then result := result + LFormaPagto.caption else result := result + 'Todos';
  end;


  if PCaixa.Visible then
  begin
    result := result + '-Caixa : ';
    if Ecaixa.Text <> '' then result := result + LCaixa.Caption else result := result + 'Todos';
  end;

end;

{******************** Carrega Configuracoes da tela **************************}
function TFRelatoriosCaixa.CarregaConfig(NomeRel, TituloForm : string) : Boolean;
var
  laco : integer;
begin
   result := false;
   PainelGradiente1.Caption := '   ' + copy(TituloForm,6,length(tituloForm)) + '   ';
   Identificador := DeletaChars(copy(TituloForm,1,5),'&');
   if FileExists(varia.PathRel + NomeRel) then
   begin
     rel.ReportName := varia.PathRel + NomeRel;
     rel.Connect.Retrieve;
     rel.Connect.DatabaseName := varia.AliasBAseDados;
     rel.Connect.ServerName := varia.AliasRelatorio;

     rel.ParamFields.Retrieve;
     for laco := 0 to rel.ParamFields.Count -1 do
       ConfiguraPainels(Rel.ParamFields[laco].Name);
     self.ClientHeight := SomaPainel + 95;
     result := true;
     fundo.Align := alClient;
   end
   else
     Aviso('Relatório não encontrado "' + varia.PathRel + NomeRel + '"');
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                    Gera relatorio
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{***************  Gera o relatorio ****************************************** }
procedure TFRelatoriosCaixa.BBotaoClick(Sender: TObject);
var
  laco : integer;
  Parametro : string;
begin
  for laco := 0 to rel.ParamFields.Count -1 do
  begin
    Parametro := RetornaParametro(Rel.ParamFields[laco].Name);
    if Parametro = '@ERRO@' then
     abort;
    if Parametro <> '' then
      rel.ParamFields[laco].value :=  Parametro
    else
      rel.ParamFields[laco].value :=  '0';
  end;
  rel.ReportTitle := TextoDosFiltros;
  rel.Execute;
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                      Filtros
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}


procedure TFRelatoriosCaixa.IgnorarPeriodoClick(Sender: TObject);
begin
  Label4.Enabled := not IgnorarPeriodo.Checked;
  data1.Enabled := not IgnorarPeriodo.Checked;
  data2.Enabled := not IgnorarPeriodo.Checked;
end;

procedure TFRelatoriosCaixa.EcaixaSelect(Sender: TObject);
begin
  ecaixa.ASelectLocaliza.clear;
  Ecaixa.ASelectLocaliza.add(' Select * from Cad_Caixa ' +
                             ' where des_caixa like ''@%'' ' +
                             ' and emp_fil = ' + Inttostr(varia.CodigoEmpFil));
  ecaixa.ASelectValida.clear;
  Ecaixa.ASelectValida.add(' Select * from Cad_Caixa ' +
                           ' where num_caixa = @ ' +
                           ' and emp_fil = ' + Inttostr(varia.CodigoEmpFil));

end;

procedure TFRelatoriosCaixa.RelExecuteBegin(Sender: TObject;
  var Cancel: Boolean);
begin
  FInicio := TFInicio.Create(SELF);
  finicio.MudaTexto('Gerando Relatório...');
  FInicio.show;
  FInicio.Refresh;
end;

procedure TFRelatoriosCaixa.RelExecuteEnd(Sender: TObject);
begin
  Finicio.close;
end;

procedure TFRelatoriosCaixa.EFIlialSelect(Sender: TObject);
begin
   EFIlial.ASelectLocaliza.Text := ' Select * from CadFiliais as fil ' +
                                         ' where c_nom_fan like ''@%'' ' +
                                         ' and i_cod_emp = ' + IntTostr(varia.CodigoEmpresa);
   EFIlial.ASelectValida.Text := ' Select * from CadFiliais where I_EMP_FIL = @% ' +
                                       ' and i_cod_emp = ' + IntTostr(varia.CodigoEmpresa);
   if Varia.FilialUsuario <> '' then
   begin
     EFIlial.ASelectValida.add(' and i_emp_fil not in ( ' + Varia.FilialUsuario + ')');
     EFIlial.ASelectLocaliza.add(' and i_emp_fil not in ( ' + Varia.FilialUsuario + ')');
   end;
end;

Initialization
 RegisterClasses([TFRelatoriosCaixa]);

end.
