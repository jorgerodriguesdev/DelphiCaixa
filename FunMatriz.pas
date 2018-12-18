unit FunMatriz;

interface

uses
  SysUtils,Dialogs;


  procedure PreencheMatizString( var matriz :array of string; texto : string);


implementation

procedure PreencheMatizString( var matriz : array of string; texto : string);
var
  laco : integer;
begin
for laco := low(matriz) to High(matriz) do
   matriz[laco] := texto;
end;

end.
