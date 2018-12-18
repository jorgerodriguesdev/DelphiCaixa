{***********************************************************}
{                    Systec Sistemas Ltda                   }
{                                                           }
{  Funçõs para tratamentos de ativiades gerais de obetos    }
{  Sergio Luis Censi  01/09/98                              }
{***********************************************************}

unit FunObjeto;

interface
uses
  StdCtrls, Forms, Classes,  Messages, buttons,Localizacao,
  Windows, SysUtils,  Graphics, Controls, Dialogs,
  Menus, ComCtrls, ToolWin, ExtCtrls,  Db, DBTables,
  dbctrls, Qrctrls, dbgrids, Componentes1, Vcf1, Registry;

  function AbreBancoDados( base : TDataBase ) : Boolean;
  function AbreBancoDadosAlias( base : TDataBase; Alias : String ) : Boolean;
  Procedure AlterarEnabled( componentes : array of TComponent);
  procedure AlterarVisible( componentes : array of TComponent);
  procedure EscondeComponentes( componentes : array of TComponent);
  procedure MostraComponentes( componentes : array of TComponent);
  procedure AtualizaLocalizas(VpaLocalizas : Array of TComponent);

  procedure AlterarEnabledDet( componentes : array of TComponent; valor : Boolean);
  Procedure AlterarVisibleDet( componentes : array of TComponent; valor : Boolean);

  procedure CarregaCombo( combo : TCustomComboBox; itens : array of string );

  procedure Desfazer(Formulario : TForm );  // desazer
  procedure Recortar(Formulario : TForm );  // recortar
  procedure Copiar(Formulario : TForm );    // copiar
  procedure Colar(Formulario : TForm );     // colar

  function verificaUsoSistema(Form : PChar; NomeForm : Pchar) : Boolean;

  function retornaPicture(mas : string; cod : String; caracter : Char) : string;

  procedure IniciallizaCheckBox( check : array of TDBCheckBox; Char_Verdadeiro, Char_Falso : string  );

  procedure MudaVisibleTodasColunasGrid( Grid : TDBGrid; Acao : Boolean );
  procedure MudaVisibleDetColunasGrid( Grid : TDBGrid; colunas : array of Integer; Acao : Boolean );

  procedure DivideTextoDoisComponentes(Edit1, Edit2: TComponent; Texto: string);
  procedure LimpaEdits(ComponentePai: TWinControl);
  procedure LimpaEditsNumericos(ComponentePai: TComponent);
  procedure LimpaStringList(VpaListas : Array of TStringList);

  // para TF1Book
  procedure LimpaGrade(Grade : TF1Book; colInicio,colFim,linInicio,linFim : integer);
  procedure RedesenhaFluxo(Grade : TF1Book; CorInicial, NovaCor : TColor; Fundo : Boolean; AteLinha, TamFonte : Integer);
  procedure SelecionaCelula(Grade : TF1Book; colInicio,colFim,linInicio,linFim : integer);
  procedure FormataCelula(Grade : TF1Book; colInicio,colFim,linInicio,linFim, TamFonte : integer; corFundo, corFonte : Tcolor; negrito, Italico : boolean; NomeFonte : String);
  procedure FormataBordaCelula(Grade : TF1Book; colInicio,colFim,linInicio,linFim : integer; CorBorda : TColor; Moeda : Boolean);
  procedure FormataBordaCelulaContorno(Grade : TF1Book; colInicio,colFim,linInicio,linFim : integer);
  procedure FormataNegativo(Grade : TF1Book; Coluna, Linha, TamFonte : Integer; negrito, Italico : Boolean; CorFundo, CorNegativo : TColor; valor : Double; NomeFonte : String );
  procedure MudaZoomGrade(Grade : TF1Book; Zoom : Integer);
  procedure MudaTamanhoColunaGrade(Grade : TF1Book; ColunaInicial, ColunaFinal, Tamanho : Integer);
  procedure MudaTamanhoLinhaGrade(Grade : TF1Book; LinhaInicial, LinhaFinal, Tamanho : Integer);
  procedure MudaTamnhaFonte(Grade : TF1Book; colInicio,colFim,linInicio,linFim,TamanhoFonte : integer);
  procedure MudaFonte(Grade : TF1Book; colInicio,colFim,linInicio,linFim, TamanhoFonte : Integer; Fonte : string);
  procedure ConfigImpressoraGrade(Grade : TF1Book);
  procedure ImprimeGrade(Grade : TF1Book);
  procedure SalvarGrade(Grade : TF1Book);
  procedure AbreGrade(Grade : TF1Book);

  procedure ResetaMenu( Menu : TMainMenu; Barra : TToolBar  );
  procedure LimpaMenu( MenuOrigem : TMainMenu );
  procedure LimpaLabel(Vpacomponentes : array of TComponent);
  function PossuiFoco(Pai: TWinControl): Boolean;

implementation

uses
   Numericos,ConstMsg, funstring, funvalida;

{******************************************************************************
               Abre a base da dados atraves de um DataBase
****************************************************************************** }
function AbreBancoDados( base : TDataBase ) : Boolean;
begin
result := true;
try
  if not Base.Connected then
     Base.Connected := true;
  except
    erro(CT_AberturaBaseDados);
    result := false;
  end;

end;

{******************************************************************************
           Abre a base da dados atraves de um DataBase  e alias
****************************************************************************** }
function AbreBancoDadosAlias( base : TDataBase; Alias : String ) : Boolean;
var
  ini : TRegIniFile;
  senha : string;
  acao, SenhaVazia : Boolean;
begin
  result := false;
  SenhaVazia := false;
  acao := true;
  try
    Ini := TRegIniFile.Create('Software\Systec\Sistema');
    senha := Ini.ReadString('SENHAS','BANCODADOS', '');  // carrega senha do banco
    if senha = '' then
    begin
      // entrada manual de senha
      acao := Entrada('Senha','Digite senha de atualização, ligue para o suporte',senha,true,clWhite, clsilver);
      SenhaVazia := true;
    end
    else
      senha := Descriptografa(senha);    // senha no regedit

    if acao then // caso cancele a entrada manual de senha
    begin
      Base.AliasName :=  Alias;
      base.Params.Clear;
      base.Params.Add('USER NAME=DBA');
      base.Params.Add('PASSWORD=' + senha);
      result := AbreBancoDados( base );

      if (Result) and (SenhaVazia) then
        Ini.WriteString('SENHAS','BANCODADOS', Criptografa(senha));  // carrega senha do banco
      ini.free;
    end;
  except
    aviso('Desconecte o DataBase e compile novamente');
  end;
end;


{******************************************************************************
               Alterar o estado da enabled dos componentes de um array
****************************************************************************** }
Procedure AlterarEnabled( componentes : array of TComponent);
var
  laco : integer;
begin
for laco := 0 to high(componentes) do
begin
    if (componentes[laco] is TButton) then
        (componentes[laco] as TButton).Enabled := not (componentes[laco] as TButton).Enabled;
    if (componentes[laco] is TSpeedButton) then
        (componentes[laco] as TSpeedButton).Enabled := not (componentes[laco] as TSpeedButton).Enabled;
    if (componentes[laco] is TMenuItem) then
       (componentes[laco] as TMenuItem).Enabled := not (componentes[laco] as TMenuItem).Enabled;
    if (componentes[laco] is TCheckBox) then
       (componentes[laco] as TCheckBox).Enabled := not (componentes[laco] as TCheckBox).Enabled;
end;
end;


{******************************************************************************
              Alterar o estado de visible dos componentes de um array
****************************************************************************** }
Procedure AlterarVisible( componentes : array of TComponent);
var
  laco : integer;
begin
for laco := Low(componentes) to high(componentes) do
begin
    if (componentes[laco] is TButton) then
        (componentes[laco] as TButton).visible := not (componentes[laco] as TButton).visible;
    if (componentes[laco] is TSpeedButton) then
        (componentes[laco] as TSpeedButton).visible := not (componentes[laco] as TSpeedButton).visible;
    if (componentes[laco] is TMenuItem) then
       (componentes[laco] as TMenuItem).visible := not (componentes[laco] as TMenuItem).visible;
end;
end;

{***************** esconte os componentes passado como parametro **************}
procedure EscondeComponentes( componentes : array of TComponent);
var
  laco : integer;
begin
  for laco := Low(componentes) to high(componentes) do
  begin
    if (componentes[laco] is TWinControl) then   // WinControl
     (componentes[laco] as TWinControl).visible := false
     else
      if (componentes[laco] is TCustomLabel) then   //Custom label
       (componentes[laco] as TCustomLabel).visible := false
      else
        if (componentes[laco] is TButton) then       // Button
           (componentes[laco] as TButton).visible := false
        else
          if (componentes[laco] is TGraphicControl) then  // Speed Button
              (componentes[laco] as TGraphicControl).visible := false
          else
            if (componentes[laco] is TMenuItem) then     // Menu Item
               (componentes[laco] as TMenuItem).visible :=false;

  end;
end;

{************** mostra os componentes passados como parametro ****************}
procedure MostraComponentes( componentes : array of TComponent);
var
  laco : integer;
begin
  for laco := Low(componentes) to high(componentes) do
  begin
    if (componentes[laco] is TCustomEdit) then   //Custom Edit
     (componentes[laco] as TCustomEdit).visible := true
     else
      if (componentes[laco] is TCustomLabel) then   //Custom Edit
       (componentes[laco] as TCustomLabel).visible := true
      else
        if (componentes[laco] is TButton) then       // Button
           (componentes[laco] as TButton).visible := true
        else
          if (componentes[laco] is TGraphicControl) then  // Speed Button
              (componentes[laco] as TGraphicControl).visible := true
          else
            if (componentes[laco] is TMenuItem) then     // Menu Item
               (componentes[laco] as TMenuItem).visible :=true;
  end;
end;

{********************* atualiza os localizas **********************************}
procedure AtualizaLocalizas(VpaLocalizas : Array of TComponent);
var
  laco : integer;
begin
  for laco := Low(VpaLocalizas) to high(VpaLocalizas) do
  begin
    if (VpaLocalizas[laco] is TEditLocaliza) then   //Edit localiza
     (VpaLocalizas[laco] as TEditLocaliza).Atualiza
     else
      if (VpaLocalizas[laco] is TDBEditLocaliza) then   //DBEdit localiza
       (VpaLocalizas[laco] as TDBEditLocaliza).Atualiza;
  end;
end;


{******************************************************************************
    Alterar o estado da enabled dos componentes de um array para o tipo determinado
****************************************************************************** }
Procedure AlterarEnabledDet( componentes : array of TComponent; valor : Boolean);
var
  laco : integer;
begin
for laco := 0 to high(componentes) do
begin
   if (componentes[laco] is TButton) then
      (componentes[laco] as TButton).Enabled := valor
   else
      if (componentes[laco] is TSpeedButton) then
         (componentes[laco] as TSpeedButton).Enabled := valor
      else
        if (componentes[laco] is TMenuItem) then
           (componentes[laco] as TMenuItem).Enabled := valor
        else
{          if (componentes[laco] is TNumerico) then
             (componentes[laco] as TNumerico).Enabled := valor
          else}
            if (componentes[laco] is Tlabel) then
               (componentes[laco] as TLabel).Enabled := valor
             {else
               if (componentes[laco] is TCheckBox) then
                  (componentes[laco] as TCheckBox).Enabled := valor}
               else
                  if (componentes[laco] is TQRShape) then
                     (componentes[laco] as TQRShape).Enabled := valor
                  else
                    if (componentes[laco] is TWinControl) then
                        TWinControl(componentes[laco]).Enabled := valor;

end;
end;


{******************************************************************************
   Alterar o estado de visible dos componentes de um array com valor determinado
****************************************************************************** }
Procedure AlterarVisibleDet( componentes : array of TComponent; valor : Boolean);
var
  laco : integer;
begin
for laco := Low(componentes) to high(componentes) do
begin
    if (componentes[laco] is TButton) then
       (componentes[laco] as TButton).visible := valor;
    if (componentes[laco] is TSpeedButton) then
       (componentes[laco] as TSpeedButton).visible := valor;
    if (componentes[laco] is TMenuItem) then
       (componentes[laco] as TMenuItem).visible := valor;
    if (componentes[laco] is Tlabel) then
       (componentes[laco] as TLabel).visible := valor;
    if (componentes[laco] is TWinControl) then
       TWinControl(componentes[laco]).visible := valor;
end;
end;



procedure CarregaCombo( combo : TCustomComboBox; itens : array of string );
var
  laco : integer;
begin
   for laco := low(itens) to high(itens) do
   begin
    combo.Items.Add(itens[laco]);
   end;
end;

{ ************************ Desfaz a ultima ação do Usuário ****************** }
procedure desfazer( Formulario : TForm );
begin
if Formulario.ActiveMDIChild.ActiveControl <> nil then
      // Chamada da API do Windows para desfazer a ultima açao.
    SendMessage(Formulario.ActiveMDIChild.ActiveControl.Handle, EM_UNDO, 0, 0);
end;


{ **** Recorta o Texto Selecionado e manda para a área de Transferência ***** }
procedure Recortar(Formulario : TForm );
begin
  if Formulario.ActiveMDIChild.ActiveControl<>nil then
      // Chamada da API do Windows para Recortar
    SendMessage(Formulario.ActiveMDIChild.ActiveControl.Handle, WM_CUT, 0, 0);

end;

{ ****** Copia o Texto Selecionado e manda para a area de Transferência ***** }
procedure Copiar(Formulario : TForm );
begin
  if Formulario.ActiveMDIChild.ActiveControl<>nil then
             // Chamada da API do Windows para Copiar
    SendMessage(Formulario.ActiveMDIChild.ActiveControl.Handle, WM_COPY, 0, 0);
end;


{ ************** Cola o Texto da área de Transferência ********************* }
procedure Colar(Formulario : TForm );
begin
  if Formulario.ActiveMDIChild.ActiveControl<>nil then
             // Chamada da API do Windows para Colar
    SendMessage(Formulario.ActiveMDIChild.ActiveControl.Handle, WM_PASTE, 0, 0);
end;



function RetornaPicture(mas : string; cod : String; caracter : Char) : string;
begin
 mas := copy(mas,0,NPosicao('9',mas,length(cod)));
 result :=  SubstituiStr(mas,'9','#') + ';0;' + Caracter;
end;


function verificaUsoSistema(Form : PChar; NomeForm : Pchar) : Boolean;
{var
  verifica : THandle;}
begin
result := false;
{verifica := FindWindow(Form, NomeForm);
if verifica <> 0 then
begin
  MessageDlg(CT_SistemaUso,mtWarning,[mbok],0);
  SetForegroundWindow(Verifica);
  result := true;
end;}
end;


{ ***** LIMPA OS EDITS DE UM COMPONENTE ***** }
procedure LimpaEdits(ComponentePai: TWinControl);
var
 I: Integer;
begin
  for I := 0 to (ComponentePai.ControlCount -1) do
    if ((ComponentePai.Controls[I] is TEditColor) or
        (ComponentePai.Controls[I] is TEdit) or
        (ComponentePai.Controls[I] is TEditLocaliza)) then
      (ComponentePai.Controls[I] as TEdit).Clear;
end;

{ ***** VERIFICA SE O COMPONENTE POSSUI FOCO ***** }
function PossuiFoco(Pai: TWinControl): Boolean;
var
 I: Integer;
begin
  Result := Pai.Focused;
  for I := 0 to (Pai.ControlCount -1) do
  begin
    if (Pai.Controls[I] is TWinControl) then
    begin
      if (Pai.Controls[I] as TWinControl).ControlCount > 0 then
      Result := PossuiFoco(Pai.Controls[I] as TWinControl);
      if (not Result) then
        Result := (Pai.Controls[I] as TWinControl).Focused;
      if Result then
        Break;
    end;
  end;
end;

{ ***** LIMPA OS EDITS NUMERICOS DE UM COMPONENTE ***** }
procedure LimpaEditsNumericos(ComponentePai: TComponent);
var
 I: Integer;
begin
  for I := 0 to (ComponentePai.ComponentCount -1) do
    if (ComponentePai.Components[I] is TNumerico) then
    begin
      (ComponentePai.Components[I] as TNumerico).AValor := 0;
      (ComponentePai.Components[I] as TNumerico).Clear;
    end;
end;

{************************ limpa os string list ********************************}
procedure LimpaStringList(VpaListas : Array of TStringList);
var
  laco : integer;
begin
   for laco := low(VpaListas) to High(VpaListas) do
     VpaListas[laco].Clear;
end;

{**********************Carrega os check box com true ou falso******************}
procedure IniciallizaCheckBox( check : array of TDBCheckBox; Char_Verdadeiro, Char_Falso : string );
var
  laco : integer;
begin
   for laco := low(check) to High(check) do
   begin
     check[laco].ValueChecked :=  Char_Verdadeiro;
     check[laco].ValueUnchecked :=  Char_falso;
   end;
end;

{************** Mostra todas as colunas de um grid ************************** }
procedure MudaVisibleTodasColunasGrid( Grid : TDBGrid; Acao : Boolean );
var
  laco : integer;
begin
  for laco := 0 to grid.Columns.Count - 1 do
    if grid.Columns[laco].Visible <> acao then
      grid.Columns[laco].Visible := acao;
end;

{*********** muda o visible de um  determinado conjunto de colunas do grid ****}
procedure MudaVisibleDetColunasGrid( Grid : TDBGrid; colunas : array of Integer; Acao : Boolean );
var
  laco : integer;
begin
  for laco := low(colunas) to high(colunas) do
   if grid.Columns[colunas[laco]].Visible <> acao then
     grid.Columns[colunas[laco]].Visible := acao;
end;

{******************************************************************************
               Recebe um texto e divide este texto colocando-o em dois edits
****************************************************************************** }
procedure DivideTextoDoisComponentes(Edit1, Edit2: TComponent; Texto: string);
var
  Frases: TStringList;
begin
  if ((Edit1 is TEdit) or (Edit1 is TEditColor)) then
  begin
    Frases := TStringList.Create;
    // Mais de uma linha.
    if SeparaFrases(Texto, (Edit1 as TEdit).MaxLength, Frases) > 1 then
    begin
      (Edit1 as TEdit).Text := Frases[0];
      (Edit2 as TEdit).Text := CortaString(DeletaEspacoDE(SubstituiStr(Texto, (Edit1 as TEdit).Text, '')), (Edit2 as TEdit).MaxLength);
    end
    else
    begin
      // Somente uma linha.
      (Edit1 as TEdit).Text := Texto;
      (Edit2 as TEdit).Text := '';
    end;
    // Primeira linha.
    Frases.Free;
  end
  else
    Erro('Os componentes não são edits.');
end;


{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                               para TF1Book
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{****************** limpa grade ********************************************** }
procedure LimpaGrade(Grade : TF1Book; colInicio,colFim,linInicio,linFim : integer);
begin
  Grade.ClearRange( linInicio, colInicio, linFim, colFim, F1ClearAll);
end;


{************** desenha os dados e informacoes no fluxo ******************** }
procedure RedesenhaFluxo(Grade : TF1Book; CorInicial, NovaCor : TColor; Fundo : Boolean; AteLinha, TamFonte : Integer);
var lacoCol, LacoLin : integer;
    BG, FG : Tcolor;
    num : smallInt;
    NomeFonte : WideString;
    Negrito,italico,Sublinhado,riscado,outline,sombra : WordBool;
    corFon : TColor;
begin

for lacoLin := 1 to AteLinha do
  for lacoCol := 1 to grade.MaxCol do
  begin
    Grade.SelStartCol := lacoCol;
    Grade.SelEndCol := LacoCol;
    Grade.SelStartRow := LacoLin;
    Grade.SelEndRow := LacoLin;
    if Fundo then
    begin
      grade.GetPattern(num, fg, bg); // busca a cor de fundo
      if fg = CorInicial then
        Grade.SetPattern(2,NovaCor,NovaCor);
    end
    else
    begin
      grade.GetFont( NomeFonte,num,Negrito,italico,Sublinhado,riscado,corFon,outline,sombra);
      if (corFon = CorInicial) then
        Grade.SetFont(NomeFonte, TamFonte, Negrito, false, false, false,
                      NovaCor, false, false); // busca a cor da fonte
    end;
  end;
  // caso tenha que mudar a cor de fundo
  if grade.BackColor = CorInicial then
    grade.BackColor := NovaCor;
end;

{*********************** seleciona uma celula ******************************** }
procedure SelecionaCelula(Grade : TF1Book; colInicio,colFim,linInicio,linFim : integer);
begin
  Grade.SelStartCol := colInicio;
  Grade.SelEndCol := colFim;
  Grade.SelStartRow := linInicio;
  Grade.SelEndRow := linFim;
end;

{ *********** formata uma celula conforme fundo, fonte *********************** }
procedure FormataCelula(Grade : TF1Book; colInicio,colFim,linInicio,linFim, TamFonte : integer; corFundo, corFonte : Tcolor; negrito, Italico : boolean; NomeFonte : String);
begin
  Grade.SelStartCol := colInicio;
  Grade.SelEndCol := colFim;
  Grade.SelStartRow := linInicio;
  Grade.SelEndRow := linFim;
  Grade.SetPattern(2,CorFundo,CorFundo);
  Grade.SetFont( NomeFonte, TamFonte, Negrito, italico, false, false,
                CorFonte, false, false);
end;

{************** adiciona borda na celula ************************************ }
procedure FormataBordaCelula(Grade : TF1Book; colInicio,colFim,linInicio,linFim : integer; CorBorda : TColor; Moeda : Boolean);
begin
  SelecionaCelula( Grade, colinicio,colfim,linInicio,linFim);
  Grade.SetBorder(1,1,1,1,1,1,CorBorda,CorBorda,CorBorda,CorBorda, CorBorda);
  if Moeda then
    Grade.FormatCurrency2;
end;

{************** adiciona borda em torno da selecao ************************** }
procedure FormataBordaCelulaContorno(Grade : TF1Book; colInicio,colFim,linInicio,linFim : integer);
begin
  SelecionaCelula( grade, colinicio,colfim,linInicio,linFim);
  Grade.SetBorder(1,0,0,0,0,0,clGray,clGray,clGray,clGray,clGray);
end;

{************ para valores negativos **************************************** }
procedure FormataNegativo(Grade : TF1Book; Coluna, Linha, TamFonte : Integer; negrito, Italico : Boolean; CorFundo, CorNegativo : TColor; valor : Double; NomeFonte : String );
begin
  if valor < 0 then
    FormataCelula(grade, coluna,Coluna,Linha, linha,TamFonte, CorFundo, CorNegativo,negrito, Italico, NomeFonte);
end;

{************** muda zoom da grade ******************************************* }
procedure MudaZoomGrade(Grade : TF1Book; Zoom : Integer);
begin
  Grade.ViewScale := zoom;
end;

{*********************** Tamanho das colunas ********************************* }
procedure MudaTamanhoColunaGrade(Grade : TF1Book; ColunaInicial, ColunaFinal, Tamanho : Integer);
begin
  Grade.SetColWidth(ColunaInicial, ColunaFinal, tamanho, true );
end;

{*********************** Tamanho das colunas ********************************* }
procedure MudaTamanhoLinhaGrade(Grade : TF1Book; LinhaInicial, LinhaFinal, Tamanho : Integer);
begin
  Grade.SetRowHeight(LinhaInicial, LinhaFinal, tamanho, true );
end;

{************ muda tamanho da fonte ****************************************** }
procedure MudaTamnhaFonte(Grade : TF1Book; colInicio,colFim,linInicio,linFim, TamanhoFonte : integer);
var
    lacoCol, LacoLin : integer;
    TamFonte : smallInt;
    NomeFonte : WideString;
    Negrito,italico,Sublinhado,riscado,outline,sombra : WordBool;
    corFon : TColor;
begin
  for lacoLin := linInicio to linFim do
    for lacoCol := colInicio to colFim do
    begin
      Grade.SelStartCol := lacoCol;
      Grade.SelEndCol := LacoCol;
      Grade.SelStartRow := LacoLin;
      Grade.SelEndRow := LacoLin;
      grade.GetFont( NomeFonte,TamFonte, Negrito, italico, Sublinhado, riscado, corFon, outline, sombra);
      if (TamFonte <> TamanhoFonte) then
        Grade.SetFont( NomeFonte, TamanhoFonte, Negrito,Italico, sublinhado, riscado,
                       CorFon, outline, sombra);
   end;
end;

{************ muda fonte **************************************************** }
procedure MudaFonte(Grade : TF1Book; colInicio,colFim,linInicio,linFim, TamanhoFonte : Integer; Fonte : string);
var
    lacoCol, LacoLin : integer;
    TamFonte : smallInt;
    NomeFonte : WideString;
    Negrito,italico,Sublinhado,riscado,outline,sombra : WordBool;
    corFon : TColor;
begin
  for lacoLin := linInicio to linFim do
    for lacoCol := colInicio to colFim do
    begin
      Grade.SelStartCol := lacoCol;
      Grade.SelEndCol := LacoCol;
      Grade.SelStartRow := LacoLin;
      Grade.SelEndRow := LacoLin;
      grade.GetFont( NomeFonte,TamFonte, Negrito, italico, Sublinhado, riscado, corFon, outline, sombra);
      if (NomeFonte <> Fonte) then
        Grade.SetFont( Fonte, TamanhoFonte, Negrito,Italico, sublinhado, riscado,
                       CorFon, outline, sombra);
   end;
end;

{*************** configura a impressora da grade ***************************** }
procedure ConfigImpressoraGrade(Grade : TF1Book);
begin
   Grade.FilePrintSetupDlg;
end;

{ ******************* imprime a grade **************************************** }
procedure ImprimeGrade(Grade : TF1Book);
begin
  Grade.FilePrint(true);
end;

{****************** salva a grade atual ************************************* }
procedure SalvarGrade(Grade : TF1Book);
var
  Nome : Widestring;
  Tipo : smallint;
begin
  Grade.SaveFileDlg('Salvar Arquivo', Nome, Tipo);
  Grade.Write(Nome, Tipo);
end;

{************* abre uma grade existente ************************************* }
procedure AbreGrade(Grade : TF1Book);
var
  Buf : Widestring;
  Tipo : smallint;
begin
  grade.OpenFileDlg( 'Abrir Arquivo', grade.hWnd , buf);
  grade.Read(buf, Tipo);
end;


procedure ResetaMenu( Menu : TMainMenu; Barra : TToolBar );
var
  laco1, laco2, laco3, laco4 : integer;
  Item : TMenuItem;
begin

  for laco1 := 0 to Menu.Items.Count - 1 do
  begin
     Menu.Items[laco1].Visible := true;

    for laco2 := 0 to  Menu.Items[laco1].Count - 1 do
    begin
        Menu.Items[laco1].items[laco2].Visible := true;

      for laco3 := 0 to Menu.Items[laco1].Items[laco2].Count - 1 do
      begin
        Menu.Items[laco1].items[laco2].items[laco3].Visible := true;

        for laco4 := 0 to  Menu.Items[laco1].Items[laco2].Items[laco3].Count - 1 do
        begin
          Menu.items[laco1].items[laco2].items[laco3].items[laco4].Visible := true;
        end;
      end;
    end;
  end;

  for laco1 := 0 to Barra.ButtonCount - 1 do
     barra.Buttons[laco1].Visible := true;

end;



procedure LimpaMenu( MenuOrigem : TMainMenu );
var
  laco1, laco2, laco3, laco4, ContaItem : integer;
  Item : TMenuItem;
  TextoVisivel2, AnteriorVisivel2,TextoVisivel3, AnteriorVisivel3 : string;
begin

  for laco1 := 0 to MenuOrigem.Items.Count - 1 do
  begin

  TextoVisivel2 := '';
  AnteriorVisivel2 := '';

    for laco2 := 0 to  MenuOrigem.Items[laco1].Count - 1 do
    begin
      if MenuOrigem.Items[laco1].items[laco2].Visible  then
      begin
        AnteriorVisivel2  := TextoVisivel2;
        TextoVisivel2 := MenuOrigem.Items[laco1].items[laco2].Caption;
      end;

      if ((AnteriorVisivel2 = '')  and ( TextoVisivel2 =  '-')) or
         ((AnteriorVisivel2 = '-')  and ( TextoVisivel2 =  '-')) then
      begin
        MenuOrigem.Items[laco1].items[laco2].Visible := false;
        TextoVisivel2 := '';
      end;

      TextoVisivel3 := '';
      AnteriorVisivel3 := '';

      for laco3 := 0 to MenuOrigem.Items[laco1].Items[laco2].Count - 1 do
      begin
        if MenuOrigem.Items[laco1].items[laco2].items[laco3].Visible  then
        begin
          AnteriorVisivel3  := TextoVisivel3;
          TextoVisivel3 := MenuOrigem.Items[laco1].items[laco2].items[laco3].Caption;
        end;

        if ((AnteriorVisivel3 = '')  and ( TextoVisivel3 =  '-')) or
           ((AnteriorVisivel3 = '-')  and ( TextoVisivel3 =  '-')) then
        begin
          MenuOrigem.Items[laco1].items[laco2].items[laco3].Visible := false;
          TextoVisivel3 := '';
        end;
      end;
    end;

    ContaItem := 0;  // soma se a itens visivel no menu
    for laco2 :=  MenuOrigem.Items[laco1].Count - 1 downto 0  do
    begin
      if MenuOrigem.Items[laco1].items[laco2].Visible  then
      begin
        inc(ContaItem);
        if MenuOrigem.Items[laco1].items[laco2].Caption = '-' then
          MenuOrigem.Items[laco1].items[laco2].Visible := false;
        break;
      end;
   end;

   if ContaItem = 0 then  // caso naum tenha itens visivel esconde menu
     MenuOrigem.Items[laco1].Visible := false;

  end;
end;

{******************** limpa os componentes  label *****************************}
procedure LimpaLabel(Vpacomponentes : array of TComponent);
var
  Vpflaco : integer;
begin
  for Vpflaco := 0 to high(Vpacomponentes) do
  begin
    if (Vpacomponentes[Vpflaco] is TLabel) then
      (Vpacomponentes[Vpflaco] as TLabel).Caption := '';
  end;


end;

end.
