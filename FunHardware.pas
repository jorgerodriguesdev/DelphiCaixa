// systec sistemas ltda
unit FunHardware;


interface


uses
Windows, Dialogs, Messages, SysUtils, Classes, Controls, StdCtrls, Graphics,
Printers, shellapi, MMSystem;

Function TestaPlaca : Boolean;
function DiscoNoDrive(const drive : char): boolean;
function NumeroSerie(Unidade:PChar):String; // indicar C:/
function DetectaDrv(const drive : char): boolean;
function PercentLivreDisk(unidade: byte): Integer;  //1=A, 2=B, 3=C..etc
function DataBios: String;
function MemoriaComputador(Categoria: integer): integer;
function RetornaCPU : String;
function RetornaTamanhoHD( drive : string ) : Double;

implementation

{*****************************************************************************
          Testa se existe uma placa de som no seu computador
***************************************************************************** }
Function TestaPlaca : Boolean;
begin
if WaveOutGetNumDevs > 0 then
   begin
   result := True
   end
else
   begin
   Result := False;
   end;
end;


{*****************************************************************************
             Detecta se há disco no Drive
***************************************************************************** }
function DiscoNoDrive(const drive : char): boolean;
var
  DriveNumero : byte;
  EMode : word;
begin
EMode := 0;
result := false;
DriveNumero := ord(Drive);
if DriveNumero >= ord('a') then
   begin
   dec(DriveNumero,$20);
   EMode := SetErrorMode(SEM_FAILCRITICALERRORS);
   end;
   try
      if DiskSize(DriveNumero-$40) = -1 then
         begin
         Result := False;
         end
      else
         begin
         Result := True;
         end;
   Except
         SetErrorMode(EMode);
   end;
end;

{*****************************************************************************
              Retorna o Número serial da unidade especificada
***************************************************************************** }
function NumeroSerie(Unidade:PChar):String;
var
VolName,SysName : AnsiString;
SerialNo,MaxCLength,FileFlags : DWord;
begin
try
  SetLength(VolName,255);
  SetLength(SysName,255);
  GetVolumeInformation(Unidade,PChar(VolName),255,@SerialNo,
  MaxCLength,FileFlags,PChar(SysName),255);
  result := IntToHex(SerialNo,8);
except
  result := ' ';
end;
end;

{*****************************************************************************
          Detecta se possui a unidade no computador
***************************************************************************** }
function DetectaDrv(const drive : char): boolean;
var
  Letra: string;
begin
  Letra := drive + ':\';
  if GetDriveType(PChar(Letra)) < 2 then
     begin
     result := False;
     end
  else
     begin
     result := True;
     end;
end;

{*****************************************************************************
    Retorna a porcentagem de espaço livre em uma unidade de disco
***************************************************************************** }
function PercentLivreDisk(unidade: byte): Integer;
var
A,B, Percentual : longint;
begin
if DiskFree(Unidade)<> -1 then
   begin
   A := DiskFree(Unidade) div 1024;
   B := DiskSize(Unidade) div 1024;
   Percentual:=(A*100) div B;
   result := Percentual;
   end
else
   begin
   result := -1;
   end;
end;

{*****************************************************************************
            Retorna a data da fabricação do Chip da Bios do sistema
***************************************************************************** }
function DataBios : String;
begin
   result := string(pchar(ptr($FFFF5)));
end;

{*****************************************************************************
       Retorna a memoria do sistema
       voce pode usar a tabela abaixo para fazer as devidas modificações
***************************************************************************** }
function MemoriaComputador(Categoria: integer): integer;
var
MemoryStatus: TMemoryStatus;
Retval : Integer;
begin
Retval := 0;
MemoryStatus.dwLength:= sizeof(MemoryStatus);
GlobalMemoryStatus(MemoryStatus);
   if categoria > 8 then
   begin
     Retval := 0;
   end;
case categoria of
     1: Retval := MemoryStatus.dwTotalPhys;     // bytes de memória física
     2: Retval := MemoryStatus.dwLength;        // sizeof(MEMORYSTATUS)
     3: Retval := MemoryStatus.dwMemoryLoad;    // percentual de memória em uso
     4: Retval := MemoryStatus.dwAvailPhys;     // bytes livres de memória física
     5: Retval := MemoryStatus.dwTotalPageFile; // bytes de paginação de arquivo
     6: Retval := MemoryStatus.dwAvailPageFile; // bytes livres de paginação de arquivo
     7: Retval := MemoryStatus.dwTotalVirtual;  // bytes em uso de espaço de endereço
     8: Retval := MemoryStatus.dwAvailVirtual;  // bytes livres
     end;
result := Retval;
end;

{******************* retorna  tipo de cpu do computador ***********************}
function RetornaCPU : String;
var
  a : _SYSTEM_INFO;
begin
  GetSystemInfo(a);
  result := 'Micro Computador ';
  case a.dwProcessorType of
    386 : result := result + 'Intel 80386';
    486 : result := result + 'Intel 80486';
    586 : result := result + 'Pentium';
  end;
  result := result + ' com ' + IntToStr(a.dwNumberOfProcessors) + ' processador '
end;

{********************** retorna o tamanho do hd *******************************}
function RetornaTamanhoHD( drive : string ) : Double;
var
  SetoresPorCluster,BytesPorSetor, NumLivreClusters, TotalClusters : DWord;
begin
  //  result := ( DiskSize(drive) / 1024 / 1024 / 1024 );
  Drive := Drive + ':\';
  GetDiskFreeSpace(PChar(Drive), SetoresPorCluster,
        BytesPorSetor, NumLivreClusters, TotalClusters);
  result := ((SetoresPorCluster * BytesPorSetor * TotalClusters));
end;


end.
