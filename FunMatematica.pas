{***********************************************************}
{                    Systec Sistemas Ltda                   }
{                                                           }
{  Funçõs matematicas                                       }
{  Sergio Luis Censi  01/09/98                              }
{***********************************************************}

unit FunMatematica;

interface

function Raiz(const I: SmallInt): SmallInt; assembler;
function InverteSinal (B: LongInt): ShortInt;
function Potencia(Base: Real; Exponent: Real): Real;
function Exponencial(x, y: Real): Real;
function areaCilindro(radius,height:single):extended;
function volCilindro(radius,height:single):extended;
function volEsfera(radius:single):extended;
function areaEsfera(radius:single):extended;

function RadianosDecimal(Numero: double): double;
function DecimalRadianos(Numero: double): double;
function LogaritmoNatural(Numero: double): double;
function Tangente(Numero: double): double;
function Coseno(Numero: double): double;
function Seno(Numero: double): double;

implementation

{ ********************** Retorna a raiz quadrada de um valor **************** }
function Raiz(const I: SmallInt): SmallInt; assembler;
asm
push ebx
MOV   CX, AX  { load argument }
MOV   AX, -1  { init result }
CWD           { init odd numbers to -1 }
XOR   BX, BX  { init perfect squares to 0 }
@loop:
INC   AX      { increment result }
INC   DX      { compute }
INC   DX      {  next odd number }
ADD   BX, DX  { next perfect square }
CMP   BX, CX  { perfect square > argument ? }
JBE   @loop   { until square greater than argument }
pop ebx
end;

{ ************************** Inverte o sinal de um valor ******************** }
function InverteSinal (B: LongInt): ShortInt;
begin
if B < 0 then
   begin
   Result := -1;
   end
else if B = 0 then
        begin
        Result := 0;
        end
     else
        begin
	Result := 1;
        end;
end;

{ ******************* Retorna um valor elevado ao outro ********************** }
function Potencia(Base: Real; Exponent: Real): Real;
var
Count: Integer;
OutCome: Real;
begin
OutCome := 1;
for Count := 1 to Trunc(Exponent) do
    begin
    OutCome := OutCome * Base;
    end;
Result := OutCome;
end;

{  *******************  Retorna um exponencial ******************************* }
function Exponencial(x, y: Real): Real;
var
retval : Real;
begin
  if y <> 0 then
     begin
     Retval := Ln(x) / Ln(y);
     end
  else
     begin
     Retval := 0;
     end;
result := Retval;
end;

{   ***************** Calcula a area de um cilindro ************************* }
function areaCilindro(radius,height:single):extended;
begin
result:=(2*pi*radius*height);
end;


{ *****************  Calcula o volume de um cilíndro ************************ }
function volCilindro(radius,height:single):extended;
begin
result:=(pi*radius*radius*height);
end;

{ ****************  Calcula o volume de uma esfera ************************** }
function volEsfera(radius:single):extended;
begin
result:=((4/3)*pi*radius*radius*radius);
end;

{ ********************* Calcula a area de uma esfera *********************** }
function areaEsfera(radius:single):extended;
begin
result:=(4*pi*radius*radius);
end;


{ *********** de decimal para radianos *************************************** }
function DecimalRadianos(Numero: double): double;
begin
  result := Numero * (PI / 180);
end;

{ *************** de radioanos para decimal ********************************* }
function RadianosDecimal(Numero: double): double;
begin
 result := Numero * (180 / PI);
end;

{ ******************* Logaritmo Natural ************************************ }
function LogaritmoNatural(Numero: double): double;
begin
 result := LN(Numero);
end;


function Coseno(Numero: double): double;
begin
 result := Sin(Numero);
end;

function Seno(Numero: double): double;
begin
 result := Cos(Numero);
end;


{ *************** tangente de um numero ************************************** }
function Tangente(Numero: double): double;
begin
 result := Sin(Numero) / Cos(Numero);
end;

end.
