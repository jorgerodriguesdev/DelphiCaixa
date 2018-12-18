{***********************************************************}
{                    Systec Sistemas Ltda                   }
{                                                           }
{  Funçõs para numeros                                      }
{  Sergio Luis Censi  01/09/98                              }
{***********************************************************}

unit FunNumeros;

interface

uses
  SysUtils;

function Max(A, B: Longint): Longint;
function Min(A, B: Longint): Longint;
function MaxInteger(const Values: array of Longint): Longint;
function MinInteger(const Values: array of Longint): Longint;
function MaxFloat(const Values: array of Extended): Extended;
function MinFloat(const Values: array of Extended): Extended;
function MaxDateTime(const Values: array of TDateTime): TDateTime;
function MinDateTime(const Values: array of TDateTime): TDateTime;
function RetornaInteiro( valor : Double ) : integer;
function RetornaFracao( valor : double; Qdadedecimais : integer) : integer;

function Gerapercentual(valor:real;Percent:Real):real;
function ArredontaFloat(x : Real): Real;
function ArredondaDecimais(Valor:Extended;Decimais:Integer):Extended;
function ArredondaPraMaior( valor : double ) : integer;

function DecimalToRoman( Decimal: LongInt ): String;
function InteiroPrimo(Value: Integer): Boolean;

procedure TrocaLong(var Int1, Int2: Longint);
procedure TrocaInt(var Int1, Int2: Integer);

Function NumeroExtenso(Valor : Double): String;
Function Extenso(Valor : Double; moedaPlural : string; MoedaSingular : String): String;

function HoraParaDecimal( Hora : double) : double;
function MinutosParaDecimal( Hora : double) : double;

Const Unidades : Array [1..9] of String = ('um', 'dois', 'três', 'quatro', 'cinco', 'seis', 'sete', 'oito', 'nove');
      Dez      : Array [1..9] of String = ('onze', 'doze', 'treze', 'quatorze', 'quinze', 'dezesseis', 'dezessete', 'dezoito', 'dezenove');
      Dezenas  : Array [1..9] of String = ('dez', 'vinte', 'trinta', 'quarenta', 'cinquenta', 'sessenta', 'setenta', 'oitenta', 'noventa');
      Centenas : Array [1..9] of String = ('cento', 'duzentos', 'trezentos', 'quatrocentos', 'quinhentos', 'seiscentos', 'setecentos', 'oitocentos', 'novecentos');

implementation

{*****************************************************************************
           inverte inteiros
****************************************************************************** }
procedure TrocaInt(var Int1, Int2: Integer);
var
  I: Integer;
begin
  I := Int1; Int1 := Int2; Int2 := I;
end;

{*****************************************************************************
           inverte  Longint
****************************************************************************** }
procedure TrocaLong(var Int1, Int2: Longint);
var
  I: Longint;
begin
  I := Int1; Int1 := Int2; Int2 := I;
end;

{*****************************************************************************
                  maior  entre dois numeros
****************************************************************************** }
function Max(A, B: Longint): Longint;
begin
  if A > B then Result := A
  else Result := B;
end;

{*****************************************************************************
                  menor  entre dois numeros
****************************************************************************** }
function Min(A, B: Longint): Longint;
begin
  if A < B then Result := A
  else Result := B;
end;

{*****************************************************************************
                  maior  entre um array
****************************************************************************** }
function MaxInteger(const Values: array of Longint): Longint;
var
  I: Cardinal;
begin
  Result := Values[0];
  for I := 0 to High(Values) do
    if Values[I] > Result then Result := Values[I];
end;

{*****************************************************************************
                  menor entre um array
****************************************************************************** }
function MinInteger(const Values: array of Longint): Longint;
var
  I: Cardinal;
begin
  Result := Values[0];
  for I := 0 to High(Values) do
    if Values[I] < Result then Result := Values[I];
end;

{*****************************************************************************
                  maior entre um array
****************************************************************************** }
function MaxFloat(const Values: array of Extended): Extended;
var
  I: Cardinal;
begin
  Result := Values[0];
  for I := 0 to High(Values) do
    if Values[I] > Result then Result := Values[I];
end;

{*****************************************************************************
                  menor entre um array
****************************************************************************** }
function MinFloat(const Values: array of Extended): Extended;
var
  I: Cardinal;
begin
  Result := Values[0];
  for I := 0 to High(Values) do
    if Values[I] < Result then Result := Values[I];
end;

{*****************************************************************************
                  maior entre um array
****************************************************************************** }
function MaxDateTime(const Values: array of TDateTime): TDateTime;
var
  I: Cardinal;
begin
  Result := Values[0];
  for I := 0 to High(Values) do
    if Values[I] < Result then Result := Values[I];
end;


{*****************************************************************************
                  menor entre um array
****************************************************************************** }
function MinDateTime(const Values: array of TDateTime): TDateTime;
var
  I: Cardinal;
begin
  Result := Values[0];
  for I := 0 to High(Values) do
    if Values[I] < Result then Result := Values[I];
end;


{*****************************************************************************
                  Gera o percentual de um valor
****************************************************************************** }
function Gerapercentual(valor:real;Percent:Real):real;
begin
percent := percent / 100;
try
  valor := valor * Percent;
finally
   result := valor;
end;
end;


{*****************************************************************************
                     Arredonda um número float inteiro
****************************************************************************** }
function ArredontaFloat(x : Real): Real;
Begin
  if x > 0 Then
     begin
     if Frac(x) > 0.5 Then
        begin
        x := x + 1 - Frac(x);
        end
     else
        begin
        x := x - Frac(x);
        end;
     end
  else
     begin
     x := x - Frac(x);
     end;
     result := x
end;

{*****************************************************************************
                Retorna um numero inteiro extraido do real
****************************************************************************** }
function RetornaInteiro( valor : Double ) : integer;
begin
result := Trunc(int(valor));
end;


{*****************************************************************************
          restorna a parte fracionaria de um numero real
****************************************************************************** }
function RetornaFracao( valor : double; Qdadedecimais : integer) : integer;
var
  laco, multiplicador : integer;
begin
multiplicador := 1;
  for laco:=1 to QdadeDecimais do
     Multiplicador := Multiplicador*10;

result := round(frac(valor) * Multiplicador);
end;


{*****************************************************************************
                  Arredonda  casa decimal em uma variável
****************************************************************************** }
function ArredondaDecimais(Valor:Extended;Decimais:Integer):Extended;
var
  I:Integer;
  Multiplicador:Integer;
begin
  if Decimais > 15 then
     begin
     Decimais := 15;
     end
  else if Decimais < 0 then
          begin
          Decimais := 0;
          end;
  Multiplicador := 1;
  for I:=1 to Decimais do
      begin
      Multiplicador := Multiplicador*10;
      end;
Result := round(Valor*Multiplicador)/Multiplicador;
end;

{ arredonda o numero para o valor proximo = 2.2 -> 3 ********************* }
function ArredondaPraMaior( valor : double ) : integer;
begin
result := trunc(valor);
 if frac(valor) <> 0 then
   result := result + 1
end;


{*****************************************************************************
            Converte um numero decimal em algarismos romanos
****************************************************************************** }
function DecimalToRoman( Decimal: LongInt ): String;
const
Romans:  Array[1..13] of String = ( 'I', 'IV', 'V', 'IX', 'X', 'XL', 'L', 'XC', 'C', 'CD', 'D', 'CM', 'M' );
Arabics: Array[1..13] of Integer =( 1, 4, 5, 9, 10, 40, 50, 90, 100, 400, 500, 900, 1000);
var
i: Integer;
scratch: String;
begin
  scratch := '';
  for i := 13 downto 1 do
    while ( Decimal >= Arabics[i] ) do
           begin
           Decimal := Decimal - Arabics[i];
           scratch := scratch + Romans[i];
           end;
   Result := scratch;
end;


{****************************************************************************
           Testa se um numero é primo ou não
***************************************************************************** }
function InteiroPrimo(Value: Integer): Boolean;
var
i : integer;
begin
Result := False;
Value := Abs(Value);
if Value mod 2 <> 0 then
   begin
   i := 1;
   repeat
   i := i + 2;
   Result:= Value mod i = 0
   until Result or ( i > Trunc(sqrt(Value)) );
         Result:= not Result;
   end;
end;







{****************************************************************************
               Funçoes internas do extenso e numero extenso
***************************************************************************** }
Function Ifs( Expressao: Boolean; CasoVerdadeiro, CasoFalso: String): String;
Begin
   If Expressao Then Result := CasoVerdadeiro Else Result := CasoFalso;
End;

Function MiniExtenso( Valor: ShortString ): String;
Var Unidade, Dezena, Centena: String;
Begin
   If (Valor[2] = '1') And (Valor[3] <> '0') Then Begin
      Unidade := Dez[StrToInt(Valor[3])];
      Dezena := '';
   End Else Begin
       If Valor[2] <> '0' Then Dezena := Dezenas[StrToInt(Valor[2])];
       If Valor[3] <> '0' Then unidade := Unidades[StrToInt(Valor[3])];
   End;
   If (Valor[1] = '1') And (Unidade = '') And (Dezena = '') Then Centena := 'cem'
   Else If Valor[1] <> '0' Then Centena := Centenas[StrToInt(Valor[1])]
   Else Centena := '';
   Result := Centena + Ifs( (Centena <> '') And ((Dezena <> '') Or (Unidade <> '')), ' e ', '') + Dezena + Ifs( (Dezena <> '') And (Unidade <> ''), ' e ', '') + Unidade;
End;

{******************************************************************************
                              Numero Extenso
{ *****************************************************************************}
Function NumeroExtenso(Valor : Double): String;

Var Centavos, Centena, Milhar, Milhao, Bilhao, Texto : String;
Begin

   If Valor = 0 Then Begin
      Result := 'Zero';
      Exit;
   End;

   if valor <= 999999999999 then
   begin

     Texto := FormatFloat( '000000000000.00', Valor );
     Centavos := MiniExtenso( '0' + Copy( Texto, 14, 2 ) );
     Centena := MiniExtenso( Copy( Texto, 10, 3 ) );
     Milhar := MiniExtenso( Copy( Texto, 7, 3 ) );

     If Milhar <> '' Then Milhar := Milhar + ' mil';
     Milhao := MiniExtenso( Copy( Texto, 4, 3 ) );
     If Milhao <> '' Then Milhao := Milhao + Ifs( Copy( Texto, 4, 3 ) = '001', ' milhão', ' milhões');
     Bilhao := MiniExtenso( Copy( Texto, 1, 3 ) );
     If Bilhao <> '' Then Bilhao := Bilhao + Ifs( Copy( Texto, 1, 3 ) = '001', ' bilhão', ' bilhões');

     If (Bilhao <> '') And (Milhao + Milhar + Centena = '') Then Result := Bilhao
     Else If (Milhao <> '') And (Milhar + Centena = '') Then Result := Milhao
     Else Result := Bilhao + Ifs( (Bilhao <> '') And (Milhao + Milhar + Centena <> ''), Ifs((Pos(' e ', Bilhao) > 0) Or (Pos( ' e ', Milhao + Milhar + Centena ) > 0 ), ', ', ' e '), '') + Milhao + Ifs( (Milhao <> '') And (Milhar + Centena <> ''), Ifs((Pos(' e ', Milhao) > 0) Or (Pos( ' e ', Milhar + Centena ) > 0 ), ', ', ' e '), '') + Milhar + Ifs( (Milhar <> '') And (Centena <> ''), Ifs(Pos( ' e ', Centena ) > 0, ',  ',  ' e '), '') + Centena;

     If Centavos <> '' Then
     begin
       if valor  > 1 then
         Result := Result + ' e ' + Centavos
       else
         Result := Centavos;
     end;
  end
  else
  result := ' sem tradução ';
End;


{******************************************************************************
                               Extenso
{ *****************************************************************************}

Function Extenso(Valor : Double; moedaPlural : string; MoedaSingular : String): String;

Var Centavos, Centena, Milhar, Milhao, Bilhao, Texto : String;
begin

   If Valor = 0 Then Begin
      Result := '######';
      Exit;
   End;

  if valor <= 999999999999 then
  begin

     Texto := FormatFloat( '000000000000.00', Valor );
     Centavos := MiniExtenso( '0' + Copy( Texto, 14, 2 ) );
     Centena := MiniExtenso( Copy( Texto, 10, 3 ) );
     Milhar := MiniExtenso( Copy( Texto, 7, 3 ) );

     If Milhar <> '' Then Milhar := Milhar + ' mil';
     Milhao := MiniExtenso( Copy( Texto, 4, 3 ) );
     If Milhao <> '' Then Milhao := Milhao + Ifs( Copy( Texto, 4, 3 ) = '001', ' milhão', ' milhões');
     Bilhao := MiniExtenso( Copy( Texto, 1, 3 ) );
     If Bilhao <> '' Then Bilhao := Bilhao + Ifs( Copy( Texto, 1, 3 ) = '001', ' bilhão', ' bilhões');

     If (Bilhao <> '') And (Milhao + Milhar + Centena = '') Then Result := Bilhao + ' de ' + MoedaPlural
     Else If (Milhao <> '') And (Milhar + Centena = '') Then Result := Milhao + ' de ' + MoedaPlural
     Else Result := Bilhao + Ifs( (Bilhao <> '') And (Milhao + Milhar + Centena <> ''), Ifs((Pos(' e ', Bilhao) > 0) Or (Pos( ' e ', Milhao + Milhar + Centena ) > 0 ), ', ', ' e '), '') + Milhao + Ifs( (Milhao <> '') And (Milhar + Centena <> ''), Ifs((Pos(' e ', Milhao) > 0) Or (Pos( ' e ', Milhar + Centena ) > 0 ), ', ', ' e '), '') + Milhar + Ifs( (Milhar <> '') And (Centena <> ''), Ifs(Pos( ' e ', Centena ) > 0, ', ', ' e '), '') + Centena + Ifs( Int(Valor) = 1, ' ' + MoedaSingular, ' ' + MoedaPlural );

     If Centavos <> '' Then
     begin
       if valor  > 1 then
         Result := Result + ' e ' + Centavos + Ifs( Copy( Texto, 14, 2 )= '01', ' centavo', ' centavos' )
       else
         Result := Centavos + Ifs( Copy( Texto, 14, 2 )= '01', ' centavo', ' centavos' );
     end;
   end
   else
     result := ' sem tradução ';
End;


{******************************************************************************
                               trunca Numero
{ *****************************************************************************}

function HoraParaDecimal( Hora : double) : double;
begin
  result :=  ((RetornaInteiro(Hora) * 60) + RetornaFracao(hora, 2)) / 60;
end;


function MinutosParaDecimal( Hora : double) : double;
var
  aux : double;
begin
  result := RetornaInteiro(hora / 60);
  aux := abs(( result - (hora / 60))) * 0.6;
  result := ArredondaDecimais((result + aux),2);
end;
end.



