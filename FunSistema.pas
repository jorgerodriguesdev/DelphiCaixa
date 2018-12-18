unit FunSistema;

interface

uses
  Windows, SysUtils, Shellapi, Registry, ComObj, Dialogs, DDEman, messages, forms;

function AlteraDataHoraSistema(tDate: TDateTime; tTime: TDateTime): Boolean;
function NumeroDeCoresMonitor : Integer;
function SairWindows(acao : integer ) : boolean;
function NumLockAtivo : Boolean;
function CapsLockAtivo : Boolean;
function ScrollLockAtivo : Boolean;
function DiretorioWindows : String;
function DiretorioSystem : String;
function DiretorioTemp : String;
procedure AlteraBarraTarefa(Visivel: Boolean);
function VerificaBarraTarefaOculta : boolean;
procedure AlterarPapelParede(PathBitmap : String; Estado : boolean );
function ExecutaPainelControle(NomeCOntrole : string) : integer;
procedure AbreInternetExplorer( URL : string );
procedure ExecutaNetscape( URL : string );
function PathBrowserPadrao: String;
function Executa(Arquivo : String; Estado : Integer) : Integer;
procedure FechaPrograma(Programa: Pchar);
function VerificaFormCriado( NomeClassForm : string ) : Boolean;

implementation

{*****************************************************************************
Retorna a quantidade atual de cores no Windows (16, 256, 65536 = 16 ou 24 bit
***************************************************************************** }
function NumeroDeCoresMonitor : Integer;
var
  DC : HDC;
  BitsPorPixel: Integer;
begin
Dc := GetDc(0); // 0 = vídeo
BitsPorPixel := GetDeviceCaps(Dc,BitsPixel);
Result := 2 shl (BitsPorPixel - 1);
end;

{*****************************************************************************
            Permite que você altere a data e a hora do sistema
***************************************************************************** }
function AlteraDataHoraSistema(tDate: TDateTime; tTime: TDateTime): Boolean;
var
   tSetDate: TDateTime;
   vDateBias: Variant;
   tSetTime: TDateTime;
   vTimeBias: Variant;
   tTZI: TTimeZoneInformation;
   tST: TSystemTime;
begin
GetTimeZoneInformation(tTZI);
vDateBias := tTZI.Bias / 1440;
tSetDate := tDate + vDateBias;
vTimeBias := tTZI.Bias / 1440;
tSetTime := tTime + vTimeBias;
with tST do
     begin
     wYear := StrToInt(FormatDateTime('yyyy', tSetDate));
     wMonth := StrToInt(FormatDateTime('mm', tSetDate));
     wDay := StrToInt(FormatDateTime('dd', tSetDate));
     wHour := StrToInt(FormatDateTime('hh', tSettime));
     wMinute := StrToInt(FormatDateTime('nn', tSettime));
     wSecond := StrToInt(FormatDateTime('ss', tSettime));
     wMilliseconds := 0;
     end;
result := SetSystemTime(tST);
end;


{*****************************************************************************
            Permite Shutdown no equipamento
***************************************************************************** }
function SairWindows(acao : integer ) : boolean;
//  external 'user32.dll' name 'ExitWindowsEx';

const
  CT_LOGOFF         = 0; // Dá "logoff" no usuário atual
  CT_SHUTDOWN       = 1; // "Shutdown" padrão do sistema
  CT_REBOOT         = 2; // Dá "reboot" no equipamento
  CT_FORCTERMINO    = 4; // Força o término dos processos
  CT_DESLIGA        = 8; // Desliga o equipamento

begin
case acao of
 0 : result := ExitWindowsEx(CT_LOGOFF, 0);
 1 : result := ExitWindowsEx(CT_SHUTDOWN, 0);
 2 : result := ExitWindowsEx(CT_REBOOT, 0);
 4 : result := ExitWindowsEx(CT_FORCTERMINO, 0);
 8 : result := ExitWindowsEx(CT_DESLIGA, 0);
end;
end;


{*****************************************************************************
            Verifica se o NumLock esta acesso
***************************************************************************** }
function NumLockAtivo : Boolean;
Var
  KeyState  :  TKeyboardState;
begin
result := false;
GetKeyboardState(KeyState);
if (KeyState[VK_NUMLOCK] = 1) then
  result := true;
end;

{*****************************************************************************
            Verifica se o CapsLock esta acesso
***************************************************************************** }
function CapsLockAtivo : Boolean;
Var
KeyState  :  TKeyboardState;
begin
result := false;
GetKeyboardState(KeyState);
if (KeyState[VK_CAPITAL] = 1) then
  result := true;
end;

{*****************************************************************************
            Verifica se o ScrollLock esta acesso
***************************************************************************** }
function ScrollLockAtivo : Boolean;
Var
KeyState  :  TKeyboardState;
begin
result := false;
GetKeyboardState(KeyState);
if (KeyState[VK_SCROLL] = 1) then
 result := true;
end;

{*****************************************************************************
         Retorna o diretorio onde o windows está instalado
***************************************************************************** }
function DiretorioWindows : String;
Var
  Buffer : Array[0..144] of Char;
Begin
GetWindowsDirectory(Buffer,144);
Result := StrPas(Buffer);
End;

{*****************************************************************************
               Retorna o subdiretorio system do windows
***************************************************************************** }
function DiretorioSystem : String;
Var
  Buffer : Array[0..144] of Char;
Begin
GetSystemDirectory(Buffer,144);
Result := StrPas(Buffer);
End;

{*****************************************************************************
                 Retorna o Diretorio Temp do Windows
***************************************************************************** }
function DiretorioTemp : String;
Var
  Buffer : Array[0..144] of Char;
Begin
GetTempPath(144,Buffer);
Result := StrPas(Buffer);
end;

{*****************************************************************************
                       Oculta A Barra de Tarefas
***************************************************************************** }
procedure AlteraBarraTarefa(Visivel: Boolean);
var
  wndHandle : THandle;
  wndClass  : array[0..50] of Char;
begin
StrPCopy(@wndClass[0],'Shell_TrayWnd');
wndHandle := FindWindow(@wndClass[0], nil);
If Visivel Then
   ShowWindow(wndHandle, SW_RESTORE)
else
   ShowWindow(wndHandle, SW_HIDE);
end;


{*****************************************************************************
           Testa se a barra de tarefas está ocultada ou não
***************************************************************************** }
function VerificaBarraTarefaOculta : boolean;
var
ABData : TAppBarData;
begin
ABData.cbSize := sizeof(ABData);
Result := (SHAppBarMessage(ABM_GETSTATE, ABData) and ABS_AUTOHIDE) > 0;
end;

{*****************************************************************************
           Permite que voce troque o papel de parede do Windows
           Requer a unit Registry na clausula Uses
           ex: SetWallpaper('c:\windows\win95.bmp',False );
           onde:  True - Lado a Lado
                  False - Centralizado
***************************************************************************** }
procedure AlterarPapelParede(PathBitmap : String; Estado : boolean );
var
 reg : TRegIniFile;
begin
reg := TRegIniFile.Create('Control Panel\Desktop' );
with reg do
     begin
     WriteString( '', 'Wallpaper', PathBitmap );
     if( estado )then
       begin
       WriteString('', 'TileWallpaper', '1' );
       end
     else
       begin
       WriteString('', 'TileWallpaper', '0' );
       end;
     end;
reg.Free;
SystemParametersInfo(SPI_SETDESKWALLPAPER,0,Nil, SPIF_SENDWININICHANGE );
end;


{*****************************************************************************
     Executa um módulo do painel de controle
     Ex: RunControlPanelApplet('Access.cpl');
***************************************************************************** }
function ExecutaPainelControle(NomeCOntrole : string) : integer;
begin
  Result := WinExec(PChar('rundll32.exe shell32.dll,'+ 'Control_RunDLL '+NomeCOntrole),SW_SHOWNORMAL);
end;

{*****************************************************************************
       Executa o Internet Explorer a partir de uma Url especificada
       ex: OpenInternetExplorer('http://www.geocities.com/Broadway/3367');
       Requer a unit ComObj na clausula Uses
***************************************************************************** }
procedure AbreInternetExplorer( URL : string );
const
csOLEObjName = 'InternetExplorer.Application';
var
  IE : Variant;WinHanlde : HWnd;
begin
if( VarIsEmpty( IE ) )then
   begin
   IE := CreateOleObject( csOLEObjName );
   IE.Visible := true;
   IE.Navigate( URL );
   end
else
   begin
   WinHanlde := FindWIndow( 'IEFrame', nil );
   if( 0 <> WinHanlde )then
      begin
      IE.Navigate( URL );
      SetForegroundWindow( WinHanlde );
      end
   else
      begin
      Showmessage('Ocorreu um erro não informado!');
      end;
  end;
end;
{*****************************************************************************
   Executa uma Url a partir do Netscape mesmo que ele não seje o Browser
   padrão
   ex: NetscapeGotoURL('http://www.ChamisPlace.com/' );
   requer a unit DDEman na clausula Uses
***************************************************************************** }
procedure ExecutaNetscape( URL : string );
var
dde : TDDEClientConv;
begin
dde   := TDDEClientConv.Create( nil );
with dde do
     begin
     ServiceApplication :='C:\Arquivos de Programas\Netscape\Communicator\Program\netscape.exe';
     SetLink( 'Netscape', 'WWW_Activate' );
     RequestData('0xFFFFFFFF');
     SetLink( 'Netscape', 'WWW_OpenURL' );
     RequestData(URL+',,0xFFFFFFFF,0x3,,,' );
     CloseLink;
     end;
dde.Free;
end;

{*****************************************************************************
     Retorna o Path de seu Browser padrão
     Requer a Registry declarada na clausual Uses da unit
***************************************************************************** }
function PathBrowserPadrao: String;
var
Browser: String;
I: Integer;
Reg: TRegistry;
begin
Reg := TRegistry.Create;
with Reg do
     begin
     try
       RootKey := HKEY_CLASSES_ROOT;
       if not OpenKey('http\shell\open\command',False) then
          begin
          Browser := '';
          end
       else
          begin
          Browser := ReadString('');
          end;
       CloseKey;
     finally
       Free;
       Reg := nil;
     end;
     I := Pos('.exe',LowerCase(Browser));
     if I > 0 then
        begin
        Browser := Copy(Browser, 1, (I+3));
        end;
     I := Pos('"',Browser);
     while I > 0 do
           begin
           Delete(Browser,1,I);
           I := Pos('"',Browser);
           end;
     end;
Result := Browser;
end;


{*****************************************************************************
   executa um programa e espera sua finalização
   Valores para Estdo: SW_SHOWNORMAL   Janela em modo normal
                       SW_MAXIMIZE     Janela maximizada
                       SW_MINIMIZE     Janela minimizada
                       SW_HIDE         Janela Escondida
***************************************************************************** }
function Executa(Arquivo : String; Estado : Integer) : Integer;
var
Programa : array [0..512] of char;
CurDir   : array [0..255] of char;
WorkDir  : String;
StartupInfo : TStartupInfo;
ProcessInfo : TProcessInformation;
begin
StrPCopy (Programa, Arquivo);
GetDir (0, WorkDir);
StrPCopy (CurDir, WorkDir);
FillChar (StartupInfo, Sizeof (StartupInfo), #0);
StartupInfo.cb := sizeof (StartupInfo);
StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
StartupInfo.wShowWindow := Estado;
if not CreateProcess (nil, Programa, nil, nil, false, CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInfo) then
   begin
   Result := -1;
   end
else
   begin
   WaitForSingleObject (ProcessInfo.hProcess, Infinite);
//   GetExitCodeProcess (ProcessInfo.hProcess, Result);
    end;
end;

{*****************************************************************************
     Fecha um aplicativo via Delphi
     Esta procedure não fecha aplicativos TSR's (Que ficam na barra de
     Tarefas ao lado do relógio)
     Para colocar o nome do programa, voce deve dar um Alt+Ctrl+del e ver
     Como aparece o nome deste programa na lista de tarefas.
     Ex: Se voce abrir o bloco de notas, ele será exibido na lista de tarefas
     como "Sem Nome - Bloco de Notas"  e é deste  jeito que voce deverá colocar
     na variável "Programa"
***************************************************************************** }
procedure FechaPrograma(Programa: Pchar);
var
hHandle : THandle;
begin
hHandle := FindWindow( nil, Programa);
if hHandle <> 0 then
SendMessage( hHandle, WM_CLOSE, 0, 0);
end;

{**************** localiza um formulario se ele esta ou naum criado ********* }
function VerificaFormCriado( NomeClassForm : string ) : Boolean;
var
  laco : integer;
begin
result := false;
For laco := 0 To Screen.FormCount-1 Do                   // screen.count -> retorna qdade de formulario instanciados
  If Screen.Forms[laco].ClassName = NomeClassForm  then       // Localiza o formulário
     result := true;
end;


end.
