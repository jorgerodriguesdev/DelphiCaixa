unit FunSQL;

interface

Uses
   DBTables,Classes,db, sysUtils;


// geral
// funcoes basicas
procedure LimpaSQLTabela( tabela : TQuery );
function  AbreTabela( tabela : TDataset ) : Boolean;
procedure AdicionaSQLTabela( tabela : TQuery; select : string );
function  AdicionaSQLAbreTabela( tabela : TQuery; select : string ) : Boolean;
procedure FechaTabela( Tabela : TDataSet );
procedure FechaTabelaGrava( Tabela : TDataSet );
procedure AtualizaSQLTabela( tabela : TQuery );
function  EditarReg( tabela : TDataSet ) : Boolean;
function  InserirReg( Tabela : TDataSet ) : Boolean;
function  GravaReg( Tabela : TDataSet ) : Boolean;
function  DeletarRegAtual( Tabela :TDataSet ) : Boolean;
Procedure VerificaAtesGravar( Tabela : TDataSet );
Procedure ExecutaComandoSql(Tabela : TQuery; Comando : String);
// linha sql
procedure InseriLinhaSQL( tabela : TQuery; Linha : integer; Texto : string );
procedure DeletaLinhaSQL( tabela : TQuery; Linha : integer );
procedure SubstituiLinhaSQL( tabela : TQuery; Linha : integer; Texto : string );
// textos select
function SQLTextoDataAAAAMMMDD( data : TDateTime ) : string;
function SQLTextoDataEntreAAAAMMDD( Campo : string; data1, data2 : TDateTime; andInicio : boolean ) : string;
function SQLRetornaValorTipoCampo(VpaValor : Variant):String;
//funcoes
function ProximoCodigo(NomeTabela : string; NomeCampo : string; DataBase : TDataBase) : integer;
function ProximoCodigoFilial(NomeTabela : string; NomeCampo : String; NomeCampoFilial : string; CodFilial : Integer; DataBase : TDataBase) : Integer;
function ProximoCodigoFilialCampo(NomeTabela : string; NomeCampo : String; NomeCampoFilial, NomeCampoChave : string; CodFilial, ValorCampoChave : Integer; DataBase : TDataBase) : Integer;
function VazioString( Texto : string; SeNuloTexto : string) : String;
procedure ImprimeSqlArq( tabela : TQuery; Path : string );
function ContaRegistro( tabela: TQuery ) : Integer;
function CampoNumeroFormatodecimal( CampoTabela, CampoRetorno : string; VirgulaFinal : boolean) : string;
function CampoNumeroFormatodecimalMoeda( CampoTabela, CampoRetorno, Cifrao : string; VirgulaFinal : boolean) : string;
function RetornaNomeTabelaSql(VpaSelect : TStrings): String;
function ContaLinhasTabela( Tab : TQuery ) : Integer;

implementation

uses
   ConstMsg, funTrataErro, funStringList, funData, FunString;


{ ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                           Funcoes Basica de sql
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{ ****************** limpa a tabela sql ******************************** }
procedure LimpaSQLTabela( tabela : TQuery );
begin
tabela.close;
tabela.sql.Clear;
end;

{ ******************* Adiciona uma sql ********************************* }
procedure AdicionaSQLTabela( tabela : TQuery; select : string );
begin
  tabela.sql.Add(select);
end;

{ ********************* Abre a tabela ******************************** }
function AbreTabela( tabela : TDataset ) : Boolean;
begin
  result := true;
//    try
      tabela.open;
{    except
      TrataErroTabela(tabela, CT_AberturaTabela, 4 );
      result := false;
   end;}
end;

{ ******************* adiciona e abre uma sql *************************** }
function AdicionaSQLAbreTabela( tabela : TQuery; select : string ) : Boolean;
begin
  LimpaSQLTabela(tabela);
  AdicionaSQLTabela(tabela, select);
//  tabela.sql.savetofile('c:\x\produto.sql');
  result := AbreTabela(tabela);
end;

{**************** fecha uma tabela *************************************** }
procedure FechaTabela( Tabela : TDataSet );
begin
  if Tabela.State in [ dsInsert, dsEdit ] then
    Tabela.Cancel;
  Tabela.close;
end;

{**************** fecha uma tabela *************************************** }
procedure FechaTabelaGrava( Tabela : TDataSet );
begin
  if Tabela.State in [ dsInsert, dsEdit ] then
    Tabela.post;
  Tabela.close;
end;

{**************** atualiza uma tabela ************************************* }
procedure AtualizaSQLTabela( tabela : TQuery );
begin
  fechaTabela(tabela);
  abreTabela(tabela);
end;

{ ************** edtita tabela ****************************************** }
function EditarReg( tabela : TDataSet ) : Boolean;
begin
result := true;
//try
  tabela.Edit;
//except
//  TrataErroTabela(tabela, CT_ErroEdicaoTabela, 2);
//  result := false;
//end;
end;

{********************** inseri na tabela ********************************** }
function InserirReg( Tabela : TDataSet ) : Boolean;
begin
result := true;
//try
  tabela.Insert;
//except
//  TrataErroTabela(tabela, CT_ErroInsertTabela, 1);
//  result := false;
//end;
end;

{********************* grava um registro ************************************ }
function GravaReg( Tabela : TDataSet ) : boolean;
begin
  result := true;
//  try
    tabela.post;
//  except
//    TrataErroTabela(tabela, CT_ErroGravacaoTabela, 6);
//    result := false;
//  end;
end;

{ *************** deleta um registro atual ********************************* }
function DeletarRegAtual( Tabela :TDataSet ) : Boolean;
begin
result := true;
try
  tabela.delete;
except
  TrataErroTabela(tabela, CT_ErroDeletaTabela, 3);
  result := false;
end;
end;

{ caso a tabela esteja em insert ou edit grava o registro ****************** }
Procedure VerificaAtesGravar( Tabela : TDataSet );
begin
if tabela.State in [ dsInsert, dsEdit ] then
  GravaReg(tabela);
end;

{*******************Executa o comando passado como parâmetro*******************}
Procedure ExecutaComandoSql(Tabela : TQuery; Comando : String);
begin
  LimpaSQLTabela(tabela);
  AdicionaSQLTabela(tabela, Comando);
  Tabela.Sql.Savetofile('c:\comando.sql');
  Tabela.ExecSQL;
end;

{ ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                           Funcoes Strings SQl
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{*********** adiciona uma linha na sql ************************************** }
procedure InseriLinhaSQL( tabela : TQuery; Linha : integer; Texto : string );
begin
InseriLinhalista( tabela.sql,linha, texto );
end;

{ *************** Deleta uma linha na sql *********************************** }
procedure DeletaLinhaSQL( tabela : TQuery; Linha : integer );
begin
DeletaLinhaLista( tabela.sql,linha );
end;

{ ************* substitui uma linha na sql *********************************** }
procedure SubstituiLinhaSQL( tabela : TQuery; Linha : integer; Texto : string );
begin
SubstituiLinhaLista( tabela.SQL, linha, texto );
end;


{ ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                           Funcoes Texto SQL
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

function SQlTextoDataAAAAMMMDD( data : TDateTime ) : string;
begin
  result := '''' + DataToStrFormato(AAAAMMDD,data,'/') + '''';
end;

function SQLTextoDataEntreAAAAMMDD( Campo : string; data1, data2 : TDateTime;  andInicio : boolean ) : string;
begin
result := '';
if andInicio then
  result := ' and ';
result := result + Campo + ' between ' + SQLTextoDataAAAAMMMDD(data1) +  ' and ' + SQLTextoDataAAAAMMMDD(data2);
end;

function SQLRetornaValorTipoCampo(VpaValor : Variant):String;
begin
    if VarType(VpaValor)= varInteger Then
       result := VarToStr(VpaValor)
    else
       if VarType(VpaValor) = varString Then
          Result := '''' +SubstituiStr(VpaValor,Char(39),'`')  + ''''
       else
          if VarType(VpaValor) = varDouble Then
             Result :=  SubstituiStr(VarToStr(VpaValor),',','.')
          else
             if VarType(VpaValor) = varDate Then
                result := SQLTextoDataAAAAMMMDD(VarToDateTime(VpaValor));
end;


{ ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                                  Funcoes
))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{*******************  gera proximo codigo *********************************** }
function ProximoCodigo(NomeTabela : string; NomeCampo : String; DataBase : TDataBase) : Integer;
var
  tab : TQuery;
begin
  result := 0;
  tab := TQuery.Create(nil);
  tab.DatabaseName := DataBase.DatabaseName;
  if AdicionaSQLAbreTabela(tab,'select max(' + NomeCampo + ') as maximo from ' + NomeTabela ) then
  begin
    result := Tab.FieldByName('maximo').AsInteger + 1;
    FechaTabela(tab);
  end;
  tab.Destroy;
end;

{*******************  gera proximo codigo Filial **************************** }
function ProximoCodigoFilial(NomeTabela : string; NomeCampo : String; NomeCampoFilial : string; CodFilial : Integer; DataBase : TDataBase) : Integer;
var
  tab : TQuery;
begin
  result := 0;
  tab := TQuery.Create(nil);
  tab.DatabaseName := DataBase.DatabaseName;
  if AdicionaSQLAbreTabela(tab,'select max(' + NomeCampo + ') as maximo from ' + NomeTabela  + ' where ' + NomeCampoFilial + ' = ' +
                            IntToStr(codFilial)) then
  begin
    result := Tab.FieldByName('maximo').AsInteger + 1;
    FechaTabela(tab);
  end;
  tab.Destroy;
end;

{*******************  gera proximo codigo Filial **************************** }
function ProximoCodigoFilialCampo(NomeTabela : string; NomeCampo : String; NomeCampoFilial, NomeCampoChave : string; CodFilial, ValorCampoChave : Integer; DataBase : TDataBase) : Integer;
var
  tab : TQuery;
begin
  result := 0;
  tab := TQuery.Create(nil);
  tab.DatabaseName := DataBase.DatabaseName;
  if AdicionaSQLAbreTabela(tab,'select max(' + NomeCampo + ') as maximo from ' + NomeTabela  +
                               ' where ' + NomeCampoFilial + ' = ' + IntToStr(codFilial) +
                               ' and ' + NomeCampoChave + ' = ' + IntToStr(ValorCampoChave) )  then
  begin
    result := Tab.FieldByName('maximo').AsInteger + 1;
    FechaTabela(tab);
  end;
  tab.Destroy;
end;


function VazioString( Texto : string; SeNuloTexto : string) : String;
begin
result := Texto;
if result = '' then
  result := SeNuloTexto;
end;


procedure ImprimeSqlArq( tabela : TQuery; Path : string );
begin
 try
  tabela.sql.SaveToFile(path);
 except
 end;
end;

function ContaRegistro( tabela: TQuery ) : Integer;
begin
  result := 0;
  tabela.DisableControls;
  tabela.First;
  while not tabela.Eof do
  begin
    inc(result);
    tabela.next;
  end;
  tabela.EnableControls;
  tabela.First;
end;

function CampoNumeroFormatodecimal( CampoTabela, CampoRetorno : string; VirgulaFinal : boolean) : string;
var
  decimal : string;
begin
  decimal := '00';
  if CurrencyDecimals = 3 then
    decimal := '000';
  result :=  ' cast(FLOOR(' + CampoTabela + ') as char) + '','' + ' +
             ' LEFT(SubStr(cast(round(' + CampoTabela + ' - FLOOR(' + CampoTabela +
             '),' + IntToStr(CurrencyDecimals) + ') as char),2) + ''' + decimal + ''',' +
             IntToStr(CurrencyDecimals) + ')' + CampoRetorno;
  if VirgulaFinal then
    result := result + ',';
end;

function CampoNumeroFormatodecimalMoeda( CampoTabela, CampoRetorno, Cifrao : string; VirgulaFinal : boolean) : string;
begin
result := Cifrao + ' + '' '' + ' +
          CampoNumeroFormatodecimal(CampoTabela,CampoRetorno, VirgulaFinal);
end;

{***************** retorna o nome da tabela Sql *******************************}
function RetornaNomeTabelaSql(VpaSelect : TStrings): String;
var
  VpfLaco, VpfLacoAux : Integer;
  VpfTabela, VpfStringAux,VpfFrom : String;
  VpfAchouFrom : Boolean;
begin
  VpfAchouFrom := False;
  VpfTabela := '';
  for VpfLaco := 0 to VpaSelect.Count -1 do
  begin
    VpfStringAux := VpaSelect.Strings[Vpflaco];
    VpfFrom := '';
    for VpfLacoAux := 1 to Length(VpfStringAux) do
    begin
      if not VpfAchouFrom then
        if (UpperCase(VpfStringAux[VpfLacoAux]) = 'F') and (VpfFrom = '') then
          VpfFrom := 'F'
        else
          if (UpperCase(VpfStringAux[VpfLacoAux]) = 'R') and (VpfFrom = 'F') then
            VpfFrom := VpfFrom +'R'
          else
            if (UpperCase(VpfStringAux[VpfLacoAux]) = 'O') and (VpfFrom = 'FR') then
              VpfFrom := VpfFrom +'O'
            else
              if (UpperCase(VpfStringAux[VpfLacoAux]) = 'M') and (VpfFrom = 'FRO') then
                VpfFrom := VpfFrom +'M'
              else
                if (UpperCase(VpfStringAux[VpfLacoAux]) = ' ') and (VpfFrom = 'FROM') then
                  VpfAchouFrom := true
                else
                  VpfFrom := '';
        if VpfAchouFrom then
          if (VpfStringAux[VpfLacoAux] = ' ') and (VpfTabela <> '') then
            break
          else
            if VpfStringAux[VpfLacoAux] <> ' ' then
              VpfTabela := VpfTabela + VpfStringAux[VpfLAcoAux];
    end;
    if VpfTabela <>'' then
      break;
  end;
  result := VpfTabela;
end;

{*********** conta linhas de uma tabela ************************************* }
function ContaLinhasTabela( Tab : TQuery ) : Integer;
begin
  result := 0;
  tab.DisableControls;
  tab.First;
  while not tab.Eof do
  begin
    inc(result);
    tab.Next;
  end;
  tab.EnableControls;
end;

end.
