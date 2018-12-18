unit FunPrinter;


interface


uses
Windows, Dialogs, Messages, SysUtils, Classes, Controls, StdCtrls, Graphics,
Printers, shellapi, MMSystem;

function IsPrinter : Boolean;
function CorrentPrinter :String;


implementation



function IsPrinter : Boolean;
Const
    PrnStInt  : Byte = $17;
    StRq      : Byte = $02;
    PrnNum    : Word = 0;  { 0 para LPT1, 1 para LPT2, etc. }
Var
  nResult : byte;
Begin  (* IsPrinter*)
Asm
   mov ah,StRq;
   mov dx,PrnNum;
   Int $17;
   mov nResult,ah;
end;
result := (nResult = 144);
End;



function CorrentPrinter :String;
// Retorna a impressora padrão do windows
// Requer a unit printers declarada na clausula uses da unit
var
Device : array[0..255] of char;
Driver : array[0..255] of char;
Port   : array[0..255] of char;
hDMode : THandle;
begin
Printer.GetPrinter(Device, Driver, Port, hDMode);
Result := Device+' na porta '+Port;
end;

end.
