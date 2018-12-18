{***********************************************************}
{                    Systec Sistemas Ltda                   }
{                                                           }
{  Funçõs para arquivos                                      }
{  Sergio Luis Censi  01/09/98                              }
{***********************************************************}

unit FunArquivos;

interface

uses
  Windows, SysUtils, Classes, shellapi, FileCtrl;

function ExisteArquivo(const Path : String) : Boolean;
function ExisteDiretorio(Path: string): Boolean;
function NaoExisteCriaDiretorio(VpaPath : String;VpaPerguntar :Boolean):Boolean;
function NormalDiretorio(const DirName: string): string;
function RetornaDiretorioCorrente : String;
procedure CriaDiretorio(VpaDiretorio : String);

function TamanhoArquivoByte(const Path : String): LongInt;
function TamanhoArquivoKB(const Path : String): Double;
function TamanhoArquivoMB(const Path : String): Double;
function DataArquivo(const Path : string): string;
function DataHoraArquivo(const Path : String): String;
function RetornaArquivosMascara(Const PathMascara: string): TStringList;
function ExecutaArquivoEXE(Path:String; Visibility : integer ):integer;
Procedure DeletaArquivo(PathMascara : String);
Function DeletaArquivoLixeira(Path : string ) : boolean;
function DeletaArquivoDiretorio(const Path: string; Delete: Boolean): Boolean;
function NumLinhasArquivo(Path : String): integer;
function CopiaArquivo(PathOrigem,PathDestino: String): Boolean;
procedure MoveArquivo(const PathOrigem, PathDestino : TFileName);
function RetornaNomeSemExtensao(const Path : String): String;
function RetonarTipoArquivo(const aFile: String): String;

function ConverteParaNomeLongo(const path : string): string;
function ConverteParaPathLongo(const Path: string): string;
function ConverteParaNomeTruncado(const Path : string): string;
function ConverteParaPathTruncado(const Path: string): string;

implementation

Uses ConstMsg;

{*****************************************************************************
             verifica se o arquivo existe
***************************************************************************** }
function ExisteArquivo(const Path : String) : Boolean;
begin
result := true;
if not fileexists(Path) then
  Result := false;
end;

{*****************************************************************************
             verifica se o diretorio existe
***************************************************************************** }
function ExisteDiretorio(Path: string): Boolean;
{$IFDEF WIN32}
var
  Code: Integer;
begin
  Code := GetFileAttributes(PChar(Path));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;
{$ELSE}
var
  SR: TSearchRec;
begin
  if Name[Length(Path)] = '\' then Dec(Path[0]);
  if (Length(Path) = 2) and (Name[2] = ':') then
    Path := Path + '\*.*';
  Result := FindFirst(Name, faDirectory, SR) = 0;
  Result := Result and (SR.Attr and faDirectory <> 0);
end;
{$ENDIF}

{***************** verifica se existe o diretorio *****************************}
function NaoExisteCriaDiretorio(VpaPath : String;VpaPerguntar :Boolean):Boolean;
begin
  result := ExisteDiretorio(VpaPAth);
  if not result then
  begin
    result := true;
    if VpaPerguntar Then
    begin
      if Confirmacao('DIRETÓRIO INVALIDO!!!O diretório "' + VpaPath +'" não existe '+
                     'deseja criá-lo?') Then
        CriaDiretorio(VpaPath)
      else
        result := False;
    end
    else
     CriaDiretorio(VpaPath);
  end;
end;
{*****************************************************************************
             retorna o nome normal de um diretorio. ]
             Ex: parametro c:\windows
                 retorna c:\windows\
***************************************************************************** }
function NormalDiretorio(const DirName: string): string;
begin
  Result := DirName;
  if (Result <> '') and not (Result[Length(Result)] in [':', '\']) then
  begin
    if (Length(Result) = 1) and (UpCase(Result[1]) in ['A'..'Z']) then
      Result := Result + ':\'
    else Result := Result + '\';
  end;
end;

{******************* retorna o diretorio corrente *****************************}
function RetornaDiretorioCorrente : String;
Var
  Buffer : Array[0..144] of Char;
Begin
  GetCurrentDirectory(144,Buffer);
  Result := StrPas(Buffer);
end;

{************************** cria o diretorio **********************************}
procedure CriaDiretorio(VpaDiretorio : String);
begin
  ForceDirectories(VpaDiretorio);
end;

{*****************************************************************************
                Retorna o tamanho de um arquivo em byte
***************************************************************************** }
function TamanhoArquivoByte(const Path : String): LongInt;
var
  SearchRec       : TSearchRec;
begin
  if FindFirst(Path,faAnyFile,SearchRec)=0
    then Result:=SearchRec.Size
    else Result:=0;
  FindClose(SearchRec);
end;

{*****************************************************************************
                Retorna o tamanho de um arquivo em KB
***************************************************************************** }
function TamanhoArquivoKB(const Path : String): double;
begin
result := TamanhoArquivoByte(path) / 1024;
end;

{*****************************************************************************
                Retorna o tamanho de um arquivo em GB
***************************************************************************** }
function TamanhoArquivoMB(const Path : String): double;
begin
result := TamanhoArquivoByte(path) / 1024 /1024;
end;

{*****************************************************************************
                Retorna a date de um arquivo
***************************************************************************** }
function DataArquivo(const Path :  string): string;
var
FHandle: integer;
begin
result := '00/00/0000';
if ExisteArquivo(path) then
begin
  FHandle := FileOpen(path, 0);
  result := DateToStr((FileDateToDateTime(FileGetDate(FHandle))));
  FileClose(FHandle);
end;
end;

{*****************************************************************************
               Retorna a data e a hora de um arquivo
***************************************************************************** }
function DataHoraArquivo(const Path : String): String;
var
FHandle: integer;
begin
result := '00/00/0000';
if ExisteArquivo(path) then
begin
   FHandle := FileOpen(path, 0);
   try
     Result := DateTimeToStr(FileDateToDateTime(FileGetDate(FHandle)));
   finally
     FileClose(FHandle);
   end;
   end;
end;

{*****************************************************************************
               Retorna a data e a hora de um arquivo
***************************************************************************** }
function RetornaArquivosMascara(Const PathMascara: string): TStringList;
{Retorna uma TStringlist de todos os arquivos localizados
 no path corrente , Esta função trabalha com mascaras}
var
  SearchRec  : TSearchRec;
  intControl : integer;
begin
  Result := TStringList.create;
  intControl := FindFirst( PathMascara, faAnyFile, SearchRec );
  if intControl = 0 then
     begin
     while (intControl = 0) do
           begin
           Result.Add( SearchRec.Name );
           intControl := FindNext( SearchRec );
           end;
     FindClose( SearchRec );
     end;
end;


{*****************************************************************************
               Retorna a data e a hora de um arquivo
***************************************************************************** }
function ExecutaArquivoEXE(Path:String; Visibility : integer ):integer;
{ Tenta executar o aplicativo finalizando-o corretamente apos o uso. Retorna -1 em caso de falha}
var
zAppName:array[0..512] of char;
zCurDir:array[0..255] of char;
WorkDir:String;
StartupInfo:TStartupInfo;
ProcessInfo:TProcessInformation;
begin
if ExisteArquivo(path) then
begin
    result := 0;
    StrPCopy(zAppName,Path);
    GetDir(0,WorkDir);
    StrPCopy(zCurDir,WorkDir);
    FillChar(StartupInfo,Sizeof(StartupInfo),#0);
    StartupInfo.cb := Sizeof(StartupInfo);
    StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
    StartupInfo.wShowWindow := Visibility;
    if not CreateProcess(nil,zAppName,nil,nil,false,CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS,nil, nil,StartupInfo,ProcessInfo) then
       begin
       Result := -1;
       end
    else
       WaitforSingleObject(ProcessInfo.hProcess,INFINITE);
end
else
  result := -1;
end;

{*****************************************************************************
               Retorna a data e a hora de um arquivo
***************************************************************************** }
Procedure DeletaArquivo(PathMascara : String);
{Apaga arquivos usando mascaras tipo: *.zip, *.* }
Var Dir : TsearchRec;
    Erro: Integer;
Begin
   Erro := FindFirst(PathMascara,faArchive,Dir);
   While Erro = 0 do Begin
      DeleteFile( ExtractFilePAth(PathMascara)+Dir.Name );
      Erro := FindNext(Dir);
   End;
   FindClose(Dir);
End;


{*****************************************************************************
               Retorna a data e a hora de um arquivo
***************************************************************************** }
function DeletaArquivoDiretorio(const Path: string; Delete: Boolean): Boolean;
var
  FileInfo: TSearchRec;
  DosCode: Integer;
begin
  Result := ExisteDiretorio(Path);
  if not Result then Exit;
  DosCode := FindFirst(NormalDiretorio(Path) + '*.*', faAnyFile, FileInfo);
  try
    while DosCode = 0 do begin
      if (FileInfo.Name[1] <> '.') and (FileInfo.Attr <> faVolumeID) then
      begin
        if (FileInfo.Attr and faDirectory = faDirectory) then
          Result := deletaArquivoDiretorio(NormalDiretorio(Path) + FileInfo.Name, Delete) and Result
        else if (FileInfo.Attr and faVolumeID <> faVolumeID) then begin
          if (FileInfo.Attr and faReadOnly = faReadOnly) then
            FileSetAttr(NormalDiretorio(Path) + FileInfo.Name, faArchive);
          Result := DeleteFile(NormalDiretorio(Path) + FileInfo.Name) and Result;
        end;
      end;
      DosCode := FindNext(FileInfo);
    end;
    if Delete and Result and (DosCode = -18) and
      not ((Length(Path) = 2) and (Path[2] = ':')) then
    begin
      RmDir(Path);
      Result := (IOResult = 0) and Result;
    end;
  finally
    FindClose(FileInfo);
  end;
end;



{*****************************************************************************
               Retorna a data e a hora de um arquivo
***************************************************************************** }
Function DeletaArquivoLixeira(Path : string ) : boolean;
// Envia um arquivo para a lixeira ( requer a unit Shellapi.pas)
var
fos : TSHFileOpStruct;
Begin
if ExisteArquivo(path) then
begin
  FillChar( fos, SizeOf( fos ), 0 );
  With fos do
  begin
  wFunc := FO_DELETE;
  pFrom := PChar( Path );
  fFlags := FOF_ALLOWUNDO
  or FOF_NOCONFIRMATION
  or FOF_SILENT;
  end;
  Result := (0 = ShFileOperation(fos));
end
else
  result := false;
end;

{*****************************************************************************
               Retorna a data e a hora de um arquivo
***************************************************************************** }
function NumLinhasArquivo(Path : String): integer;
// Retorna o número de linhas que um arquivo possui
Var
   f: Textfile;
    cont:integer;
Begin
result := 0;
if ExisteArquivo(path) then
begin
  cont := 0;
  AssignFile(f,Path);
  Reset(f);
  While not eof(f) Do
        begin
        ReadLn(f);
        Cont := Cont + 1;
        end;
  Closefile(f);
  result := cont;
end;
end;


{*****************************************************************************
               Retorna a data e a hora de um arquivo
***************************************************************************** }
function CopiaArquivo(PathOrigem,PathDestino: String): Boolean;
{copia um arquivo de um lugar para outro. Retornando falso em caso de erro
no path de destino deve ser informado o nome do novo arquivo}
Var
  S, T: TFileStream;
Begin
result := false;
if ExisteArquivo(PathOrigem) then
begin
  result := true;
  S := TFileStream.Create( PathOrigem, fmOpenRead );
  try
    T := TFileStream.Create( PathDestino, fmOpenWrite or fmCreate );
    try
      T.CopyFrom(S, S.Size ) ;
    except
      result := false;
    end;
   except
      result := false;
   end;
    S.Free;
    T.Free;
  end;
end;


{*****************************************************************************
               Retorna a data e a hora de um arquivo
***************************************************************************** }
procedure MoveArquivo(const PathOrigem, PathDestino: TFileName);
var
  Destination: TFileName;
  Attr: Integer;
begin
  Destination := ExpandFileName(PathDestino);
  if not RenameFile(PathOrigem, Destination) then begin
    Attr := FileGetAttr(PathOrigem);
    if Attr < 0 then Exit;
    if (Attr and faReadOnly) <> 0 then
      FileSetAttr(PathOrigem, Attr and not faReadOnly);
    CopiaArquivo(PathOrigem, Destination);
    DeleteFile(PathOrigem);
  end;
end;

{*****************************************************************************
              Retorna o nome do Arquivo sem extensão
***************************************************************************** }
function RetornaNomeSemExtensao(const Path : String): String;
var
aExt : String;
aPos : Integer;
begin
aExt := ExtractFileExt(Path);
Result := ExtractFileName(Path);
if aExt <> '' then
   begin
   aPos := Pos(aExt,Result);
   if aPos > 0 then
      begin
      Delete(Result,aPos,Length(aExt));
      end;
   end;
end;


{*****************************************************************************
               Retorna o tipo de arquivo
               Ex: WinZip File
***************************************************************************** }
function RetonarTipoArquivo(const aFile: String): String;
{Retorna descrição do tipo do arquivo. Requer a unit ShellApi}
var
  aInfo: TSHFileInfo;
begin
  if SHGetFileInfo(PChar(aFile),0,aInfo,Sizeof(aInfo),SHGFI_TYPENAME)<>0 then
     Result := StrPas(aInfo.szTypeName)
  else begin
     Result := ExtractFileExt(aFile);
     Delete(Result,1,1);
     Result := Result +' File';
  end;
end;


{*****************************************************************************
           Converte o nome do arquivo truncado para o nome longo
***************************************************************************** }
function ConverteParaNomeLongo(const path : string): string;
var
  Temp: TWIN32FindData;
  SearchHandle: THandle;
begin
  SearchHandle := FindFirstFile(PChar(path), Temp);
  if SearchHandle <> ERROR_INVALID_HANDLE then begin
    Result := string(Temp.cFileName);
    if Result = '' then Result := string(Temp.cAlternateFileName);
  end
  else Result := '';
  Windows.FindClose(SearchHandle);
end;

{*****************************************************************************
         Converte o nome do diretorio truncado para o nome longo
***************************************************************************** }
function ConverteParaPathLongo(const Path: string): string;
var
  LastSlash: PChar;
  TempPathPtr: PChar;
begin
  Result := '';
  TempPathPtr := PChar(Path);
  LastSlash := StrRScan(TempPathPtr, '\');
  while LastSlash <> nil do begin
    Result := '\' + ConverteParaNomeLongo(TempPathPtr) + Result;
    if LastSlash <> nil then begin
      LastSlash^ := char(0);
      LastSlash := StrRScan(TempPathPtr, '\');
    end;
  end;
  Result := TempPathPtr + Result;
end;

{*****************************************************************************
            Converte o nome do arquivo longo para o nome truncado
***************************************************************************** }
function ConverteParaNomeTruncado(const Path : string): string;
var
  Temp: TWIN32FindData;
  SearchHandle: THandle;
begin
  SearchHandle := FindFirstFile(PChar(Path), Temp);
  if SearchHandle <> ERROR_INVALID_HANDLE then begin
    Result := string(Temp.cAlternateFileName);
    if Result = '' then Result := string(Temp.cFileName);
  end
  else Result := '';
  Windows.FindClose(SearchHandle);
end;


{*****************************************************************************
            Converte o nome do diretorio longo para o nome truncado
***************************************************************************** }
function ConverteParaPathTruncado(const Path: string): string;
var
  LastSlash: PChar;
  TempPathPtr: PChar;
begin
  Result := '';
  TempPathPtr := PChar(Path);
  LastSlash := StrRScan(TempPathPtr, '\');
  while LastSlash <> nil do begin
    Result := '\' + ConverteParaNomeTruncado(TempPathPtr) + Result;
    if LastSlash <> nil then begin
      LastSlash^ := char(0);
      LastSlash := StrRScan(TempPathPtr, '\');
    end;
  end;
  Result := TempPathPtr + Result;
end;


end.
