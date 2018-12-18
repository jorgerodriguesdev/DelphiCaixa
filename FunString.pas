{***********************************************************}
{                    Systec Sistemas Ltda                   }
{                                                           }
{  Funçõs para string                                       }
{  Sergio Luis Censi  01/09/98                              }
{***********************************************************}

unit FunString;

interface
uses
  SysUtils, classes, graphics;

// Novo.
procedure InicializaTString(VarTString: TStringList; Quantidade: Integer; Texto: string);
procedure InsereTString(VarTString: TStringList; Linha: Integer; Texto: string);
procedure AdicionaLinhaTString(VarTString: TStringList; Quantidade: Integer; Texto: string);

function SeparaFrases(Texto: string; TamanhoFrase: Integer; TextoFrases: TStringList): Integer;

function RetiraAcentuacao( texto : string) : string;
function SubstituiStr(const S, ASubstituir, Novo: string): string;
function InverteString(Texto:String):String;

function AlinhaDireita(const S: string; Tamanho: Integer): string;
function AlinhaEsquerda(const S: string; Tamanho: Integer): string;

function InsereAlinhaD(const S, SInserir: string; PosInicio, Qtd: Integer): string;
function InsereAlinhaE(const S, SInserir: string; PosInicio, Qtd: Integer): string;

function DeletaChars(const S: string; Chr: Char): string;
function DeletaCharE(const S: String; Chr: Char): String;
function DeletaCharD(const S: String; Chr: Char): String;
function DeletaEspaco(const S: String): string;
function DeletaEspacoE(const S: string): string; // deleta os espacos a esquerda
function DeletaEspacoD(const S: string): string;
function DeletaEspacoDE(const S: string): string;
function DeleteAteChar( const S : string; Chr: Char): string;

function ReplicaChar(Chr: Char; N: Integer): string;
function NPosicao(C: Char; S: string; N: Byte): Byte;  // retorna a posicao de um char, depois de n duplicações

function AdicionaCharE(Chr: Char; const S: string; N: Integer): string;
function AdicionaCharD(Chr: Char; const S: string; N: Integer): string;
function AdicionaCharDE(Chr: Char; const S: String; N: Integer): String;
function AdicionaBrancoD(const S: string; N: Integer): string;
function AdicionaBrancoE(const S: string; N: Integer): string;
function AdicionaBrancoDE(const S: String; Qdade: Integer): String;

function AscParaPalavra(StringAsc: string; CDelimitador: Char): string;

function CopiaAteChar(const S: string; Chr: Char): string;
function SeparaAteChar(var S: String; Chr: Char): String;
function CopiaDireita(const S: String; Qdade: Integer): String;
function CopiaEsquerda(const S: String; Qdade: Integer): String;

function SeparaMilhar(const S: string): string;

function CentraStr(const S: string; Tamanho: Integer): string;

function PrimeiraMaiuscula(Texto:String): String;
function Minusculas(const S: String): String;
function Maiusculas(const S: String): String;

function StrToPChar(const Str: string): PChar;
Function ContaPalavra(str : string) : integer;
function ExisteInteiro(Texto:String): Boolean;

function DecHex(N: LongInt; A: Byte): string;
function HexDec(const S: string): Longint;
function DivideString( texto : string; Qdade : integer) : TStringList;
function CortaString( texto : string; Qdade : integer) : string;
function CortaStringDireita( texto : string; Qdade : integer) : string;

function RomanoToInt(const S: string): Longint;
function IntToRomano(Value: Longint): string;

function DesmontaMascara(var Vetor : array of byte; mascara:string): byte;
function SeparaFraseChar( texto : string; separador : char ) : TStringList;

procedure DivideTextoDois(var Texto1, Texto2: string; Texto: string; Tamanho: Integer);
function ExisteLetraString(VpaLetra : Char; VpaString : String) : Boolean;


implementation

{******************************************************************************
               Recebe um texto e divide este texto colocando-o em dois edits
****************************************************************************** }
procedure DivideTextoDois(var Texto1, Texto2: string; Texto: string; Tamanho: Integer);
var
  Frases: TStringList;
begin
  Frases := TStringList.Create;
  // Mais de uma linha.
  if SeparaFrases(Texto, Tamanho, Frases) > 1 then
  begin
    Texto1 := Frases[0];
    Texto2 := DeletaEspacoDE(SubstituiStr(Texto, Texto1, ''));
  end
  else
  begin
    // Somente uma linha.
    Texto1 := Texto;
    Texto2 := '';
  end;
  // Primeira linha.
  Frases.Free;
end;


function ExisteLetraString(VpaLetra : Char; VpaString : String) : Boolean;
var
  Vpflaco : Integer;
begin
  Result := False;
  for VpfLaco := 1 to length(VpaString) do
    if UpperCase(vpastring[VpfLaco]) = UpperCase(VpaLetra) then
    begin
      result := true;
      break;
    end;

end;




{*****************************************************************************
       Inicaliza o TString com o texto e quantidade passadas.
****************************************************************************** }
procedure InicializaTString(VarTString: TStringList; Quantidade: Integer; Texto: string);
var
  Index : Integer;
begin
  VarTString.Clear;
  for Index:= 0 to Quantidade do
    VarTString.Add(Texto);
end;

procedure AdicionaLinhaTString(VarTString: TStringList; Quantidade: Integer; Texto: string);
var
  Index : Integer;
begin
  for Index:= 1 to Quantidade do
    VarTString.Add(Texto);
end;

{*****************************************************************************
       Insere um texto na linha do TString passado.
****************************************************************************** }
procedure InsereTString(VarTString: TStringList; Linha: Integer; Texto: string);
begin
    VarTString.Delete(Linha);
    VarTString.Insert(Linha, Texto);
end;

{*****************************************************************************
                            Retira a Acentuação
****************************************************************************** }
function RetiraAcentuacao( texto : string) : string;
  var
   laco : integer;

  function mudaCaracter( caracter : char ) : char;
  var
    novo : char;
  begin
  novo := '?';
    case caracter of
       'à'..'ä' : novo := 'a';
       'À'..'Ä' : novo := 'A';
       'è'..'ë' : novo := 'e';
       'È'..'Ë' : novo := 'E';
       'ì'..'ï' : novo := 'i';
       'Ì'..'Ï' : novo := 'I';
       'ò'..'ö' : novo := 'o';
       'Ò'..'Ö' : novo := 'E';
       'ù'..'ü' : novo := 'u';
       'Ù'..'Ü' : novo := 'U';
       'ç'      : novo := 'c';
       'Ç'      : novo := 'C';
    end;
    result := novo;
  end;

begin
if texto > '' then
 for laco := 0 to length(texto) do
 begin
   if ord(texto[laco]) in [192..255] then
     texto[laco] := mudaCaracter(texto[laco]);
 end;
result := texto;
end;


{*****************************************************************************
      Substitui em um texto os caracteres passado, para os novos
****************************************************************************** }
function SubstituiStr(const S, ASubstituir, novo: string): string;
var
  I: Integer;
  Aux: string;
begin
  Aux := S;
  Result := '';
  repeat
    I := Pos(ASubstituir, Aux);
    if I > 0 then begin
      Result := Result + Copy(Aux, 1, I - 1) + Novo;
      Aux := Copy(Aux, I + Length(ASubstituir), MaxInt);
    end
    else Result := Result + Aux;
  until I <= 0;
end;

{*****************************************************************************
                      Inverte String
****************************************************************************** }
Function InverteString(Texto:String):String;
Var
X: Integer;
S: String;
Begin
S:='';
For X := Length(Texto) DownTo 1 do
    begin
    S := S + Copy(Texto,X,1);
    end;
Result := S
End;

{*****************************************************************************
       Deleta todos os char igual ao passado como parametro de uma string
****************************************************************************** }
function DeletaChars(const S: string; Chr: Char): string;
var
  I: Integer;
begin
  Result := S;
  for I := Length(Result) downto 1 do begin
    if Result[I] = Chr then Delete(Result, I, 1);
  end;
end;

{*****************************************************************************
           Deleta char a esquerda
****************************************************************************** }
function DeletaCharE(const S: String; Chr: Char): String;
begin
  Result:=S;
  while (Length(Result)>0) and (Result[1]=Chr) do Delete(Result,1,1);
end;

{*****************************************************************************
           Deleta char a Direita
****************************************************************************** }
function DeletaCharD(const S: String; Chr: Char): String;
begin
  Result:=S;
  while (Length(Result)> 0) and (Result[Length(Result)]=Chr) do
    Delete(Result,Length(Result),1);
end;

{*****************************************************************************
           Deleta todos os espacos em branco
****************************************************************************** }
function DeletaEspaco(const S: String): string;
begin
  Result := DeletaChars(S, ' ');
end;


{*****************************************************************************
           Deleta todos os espacos em branco a esquerda
****************************************************************************** }
function DeletaEspacoE(const S: string): string;
var
  I, L: Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I] = ' ') do Inc(I);
  Result := Copy(S, I, MaxInt);
end;


{*****************************************************************************
           Deleta todos os espacos em branco a Direita
****************************************************************************** }
function DeletaEspacoD(const S: string): string;
var
  I : Integer;
begin
  I := Length(S);
  while (I <> 0) and (S[I] = ' ') do Dec(I);
  Result := Copy(S, 1, I);
end;

{*****************************************************************************
           Deleta todos os espacos em branco a esquerda  e direita
****************************************************************************** }
function DeletaEspacoDE(const S: string): string;
begin
  Result := DeletaEspacoE(DeletaEspacoD(S));
end;

{*****************************************************************************
  Deleta todos os caracteres ate o passado como paramentro, inclusive ele
****************************************************************************** }
function DeleteAteChar( const S : string; Chr: Char): string;
var
  aux : string;
begin
  aux := CopiaAteChar(S,chr);
  result := copy(S, Length(aux) + 2, Length(S));
end;


{*****************************************************************************
       Replica um char de acordo com a quantidade passado com paramentro
****************************************************************************** }
function ReplicaChar(Chr: Char; N: Integer): string;
begin
  if N < 1 then Result := ''
  else begin
    if N > 255 then N := 255;
    SetLength(Result, N);
    FillChar(Result[1], Length(Result), Chr);
  end;
end;


{*****************************************************************************
          retorna a posicao de um char, depois de n duplicações
****************************************************************************** }
function NPosicao(C: Char; S: string; N: Byte): Byte;
var
  I, P, K: Integer;
begin
  Result := 0;
  K := 0;
  for I := 1 to N do begin
    P := Pos(C, S);
    Inc(K, P);
    if (I = N) and (P > 0) then begin
      Result := K;
      Exit;
    end;
    if P > 0 then Delete(S, 1, P)
    else Exit;
  end;
end;


{*****************************************************************************
   Adiciona um chars a esquerda ate preencher o tamanho da string dato por N
****************************************************************************** }
function AdicionaCharE(Chr: Char; const S: string; N: Integer): string;
begin
  if Length(S) < N then
    Result := ReplicaChar(Chr, N - Length(S)) + S
  else Result := S;
end;

{*****************************************************************************
   Adiciona um chars a direita ate preencher o tamanho da string dato por N
****************************************************************************** }
function AdicionaCharD(Chr: Char; const S: string; N: Integer): string;
begin
  if Length(S) < N then
    Result := S + ReplicaChar(Chr, N - Length(S))
  else Result := S;
end;

{*****************************************************************************
 Adiciona um chars a direita e esquerda ate preencher o tamanho da string dato por N
****************************************************************************** }
function AdicionaCharDE(Chr: Char; const S: String; N: Integer): String;
begin
  Result:=S;
  while Length(Result) < N do
  begin
    Result:=Result+Chr;
    if Length(Result) < N then Result:=Chr + Result;
  end;
end;

{*****************************************************************************
   Adiciona um Brancos a Direita ate preencher o tamanho da string dato por N
****************************************************************************** }
function AdicionaBrancoD(const S: string; N: Integer): string;
begin
  Result := AdicionaCharD(' ', S, N);
end;

{*****************************************************************************
   Retorna a string com o tamanho informado e alinhada a direita
****************************************************************************** }
function AlinhaDireita(const S: string; Tamanho: Integer): string;
begin
  Result := DeletaEspacoDE(S);
  Result := AdicionaCharE(' ', Result, Tamanho);
end;

{*****************************************************************************
   Retorna a string com o tamanho informado e alinhada a esquerda
****************************************************************************** }
function AlinhaEsquerda(const S: string; Tamanho: Integer): string;
begin
  Result := DeletaEspacoDE(S);
  Result := AdicionaCharD(' ', Result, Tamanho);
end;

function InsereAlinhaD(const S, SInserir: string; PosInicio, Qtd: Integer): string;
begin
  Result := S;
  Delete(Result, PosInicio, Qtd);
  Insert((AlinhaDireita(SInserir, Qtd)), Result, PosInicio);
end;

function InsereAlinhaE(const S, SInserir: string; PosInicio, Qtd: Integer): string;
var
  T : string;
begin
  Result := S;
  Delete(Result, PosInicio, Qtd);
  T := (AlinhaEsquerda(SInserir, Qtd));
  Insert(T, Result, PosInicio);
end;

{*****************************************************************************
   Adiciona um brancos a esquerda ate preencher o tamanho da string dato por N
****************************************************************************** }
function AdicionaBrancoE(const S: string; N: Integer): string;
begin
  Result := AdicionaCharE(' ', S, N);
end;

{*****************************************************************************
Adiciona um brancos a esquerda e direita ate preencher o tamanho da string dato por N
****************************************************************************** }
function AdicionaBrancoDE(const S: String; Qdade: Integer): String;
begin
 result := AdicionaCharDE(' ', s ,Qdade);
end;

{*****************************************************************************
      copia uma string até encontrar determinado caracter
****************************************************************************** }
function CopiaAteChar(const S: string; Chr: Char): string;
var
  P: Integer;
begin
  P := Pos(chr, S);
  if P = 0 then P := Length(S) + 1;
  Result := Copy(S, 1, P - 1);
end;

{*****************************************************************************
                Separa uma frase em duas ate determinado char
****************************************************************************** }
function SeparaAteChar(var S: String; Chr: Char): String;
var
  I : Word;
begin
  I:=Pos(chr,S);
  if I<>0 then
  begin
    Result:=System.Copy(S,1,I-1);
    System.Delete(S,1,I);
  end else
  begin
    Result:=S;
    S:='';
  end;
end;

// DELETAR.
function AscParaPalavra(StringAsc: string; CDelimitador: Char): string;
var
  S: string;
begin
  S := StringAsc;
  Result := '';
  while (pos(CDelimitador, S) <> 0) do
  begin
    try
      Result := Result + char(StrToInt(SeparaAteChar(S, CDelimitador)));
    except
      Result := Result + '';
    end;
  end;
  // Transforma e suma o último pedaço também;
  try
    Result := Result + char(StrToInt(SeparaAteChar(S, CDelimitador)));;
  except
    Result := Result + '';
  end;
end;


{*****************************************************************************
                  Copia Qdade de caracteres a direita
****************************************************************************** }
function CopiaDireita(const S: String; Qdade: Integer): String;
begin
  Result:=Copy(S,1,Qdade);
end;

{  ***** separa um texto em frases e retorna o numero de linhas ****** }
function SeparaFrases(Texto: string; TamanhoFrase: Integer; TextoFrases: TStringList): Integer;
var
  S: string;
  Pos: Integer;
begin
  S := Texto;
  TextoFrases.Clear;
  Pos := 1;
  while Length(S) > TamanhoFrase do
  begin
    Pos := TamanhoFrase;
    if (S[TamanhoFrase] <> ' ') and (S[TamanhoFrase + 1] <> ' ') then
      while (S[Pos] <> ' ') and (Pos <> 0)  do
        Dec(Pos);
    if Pos = 0 then
      Pos := TamanhoFrase;
    TextoFrases.Add(Trim(Copy(S, 0, Pos)));
    if Pos = 0 then
      S := Trim(Copy(S, Pos + 1, TamanhoFrase))
    else
      S := Trim(Copy(S, Pos + 1, Length(S)));
  end;
  if (Length(S) > 0) then
    TextoFrases.Add(S);
  Result := TextoFrases.Count;
end;

{*****************************************************************************
                  Copia Qdade de caracteres a esquerda
****************************************************************************** }
function CopiaEsquerda(const S: String; Qdade: Integer): String;
begin
  if Qdade>=Length(S) then
    Result:=S
  else
    Result:=Copy(S,Succ(Length(S))-Qdade,Qdade);
end;

{*****************************************************************************
           coloca virgulas na esting em milhares
****************************************************************************** }
function SeparaMilhar(const S: string): string;
var
  I, NA: Integer;
begin
  I := Length(S);
  Result := S;
  NA := 0;
  while (I > 0) do begin
    if ((Length(Result) - I + 1 - NA) mod 3 = 0) and (I <> 1) then
    begin
      Insert(',', Result, I);
      Inc(NA);
    end;
    Dec(I);
  end;
end;

{*****************************************************************************
                          centra uma string
****************************************************************************** }
function CentraStr(const S: string; Tamanho: Integer): string;
begin
  if Length(S) < Tamanho then begin
    Result := ReplicaChar(' ', (Tamanho div 2) - (Length(S) div 2)) + S;
    Result := Result + ReplicaChar(' ', Tamanho - Length(Result));
  end
  else Result := S;
end;


{*****************************************************************************
     Converte decimal em Hexadicimal, A é o numero de 0 mostrado
****************************************************************************** }
function DecHex(N: LongInt; A: Byte): string;
begin
  Result := IntToHex(N, A);
end;

{*****************************************************************************
     Converte  Hexadicimal em decimal, A é o numero de 0 mostrado
****************************************************************************** }
function HexDec(const S: string): Longint;
var
  HexStr: string;
begin
  if Pos('$', S) = 0 then HexStr := '$' + S
  else HexStr := S;
  Result := StrToIntDef(HexStr, 0);
end;

{*****************************************************************************
     Converte romano em inteiro, A é o numero de 0 mostrado
****************************************************************************** }
function RomanoToInt(const S: string): Longint;
const
  RomanChars = ['C','D','I','L','M','V','X'];
  RomanValues: array['C'..'X'] of Word =
    (100,500,0,0,0,0,1,0,0,50,1000,0,0,0,0,0,0,0,0,5,0,10);
var
  Index, Next: Char;
  I: Integer;
  Negative: Boolean;
begin
  Result := 0;
  I := 0;
  Negative := (Length(S) > 0) and (S[1] = '-');
  if Negative then Inc(I);
  while (I < Length(S)) do begin
    Inc(I);
    Index := UpCase(S[I]);
    if Index in RomanChars then begin
      if Succ(I) <= Length(S) then Next := UpCase(S[I + 1])
      else Next := #0;
      if (Next in RomanChars) and (RomanValues[Index] < RomanValues[Next]) then
      begin
        Inc(Result, RomanValues[Next]);
        Dec(Result, RomanValues[Index]);
        Inc(I);
      end
      else Inc(Result, RomanValues[Index]);
    end
    else begin
      Result := 0;
      Exit;
    end;
  end;
  if Negative then Result := -Result;
end;

{*****************************************************************************
     Converte  inteiro em romano, A é o numero de 0 mostrado
****************************************************************************** }
function IntToRomano(Value: Longint): string;
Label
  A500, A400, A100, A90, A50, A40, A10, A9, A5, A4, A1;
begin
  Result := '';
{$IFNDEF WIN32}
  if (Value > MaxInt * 2) then Exit;
{$ENDIF}
  while Value >= 1000 do begin
    Dec(Value, 1000); Result := Result + 'M';
  end;
  if Value < 900 then goto A500
  else begin
    Dec(Value, 900); Result := Result + 'CM';
  end;
  goto A90;
A400:
  if Value < 400 then goto A100
  else begin
    Dec(Value, 400); Result := Result + 'CD';
  end;
  goto A90;
A500:
  if Value < 500 then goto A400
  else begin
    Dec(Value, 500); Result := Result + 'D';
  end;
A100:
  while Value >= 100 do begin
    Dec(Value, 100); Result := Result + 'C';
  end;
A90:
  if Value < 90 then goto A50
  else begin
    Dec(Value, 90); Result := Result + 'XC';
  end;
  goto A9;
A40:
  if Value < 40 then goto A10
  else begin
    Dec(Value, 40); Result := Result + 'XL';
  end;
  goto A9;
A50:
  if Value < 50 then goto A40
  else begin
    Dec(Value, 50); Result := Result + 'L';
  end;
A10:
  while Value >= 10 do begin
    Dec(Value, 10); Result := Result + 'X';
  end;
A9:
  if Value < 9 then goto A5
  else begin
    Result := Result + 'IX';
  end;
  Exit;
A4:
  if Value < 4 then goto A1
  else begin
    Result := Result + 'IV';
  end;
  Exit;
A5:
  if Value < 5 then goto A4
  else begin
    Dec(Value, 5); Result := Result + 'V';
  end;
  goto A1;
A1:
  while Value >= 1 do begin
    Dec(Value); Result := Result + 'I';
  end;
end;

{*****************************************************************************
         corta uma string conforme qdade passada
****************************************************************************** }
function CortaString( texto : string; Qdade : integer) : string;
begin
result := copy(texto,0,qdade);
end;

function CortaStringDireita( texto : string; Qdade : integer) : string;
begin
result := texto;
 if Length(texto) > qdade then
   result := copy(texto,length(texto)-qdade+1,qdade);
end;

{*****************************************************************************
         divide uma string conforme qdade passada
****************************************************************************** }
function DivideString( texto : string; Qdade : integer) : TStringList;
var
  frase : string;
  corte : integer;
  conta : integer;
  Frases : TStringList;
begin

corte := 0;
Frases := TStringList.Create;

while (length(texto) > corte) do
begin
  frase := copy(texto,corte,qdade);

     conta := 0;
     while (frase[length(frase) - conta] <>  ' ') and (length(frase) > conta) do
      inc(conta);

  if (length(frase) > conta) then
  begin
    frase := copy(texto,corte,qdade - conta);
    corte := corte + qdade - conta;
  end
  else
    corte := corte + qdade;
  Frases.Add(DeletaEspacoE(frase));
end;
result := frases;
end;


{*****************************************************************************
      Converte a primeira letra do texto especificado para
            maiuscula e as restantes para minuscula
****************************************************************************** }
function PrimeiraMaiuscula(Texto:String): String;
begin
if Texto <> '' then
    begin
    Texto := UpperCase(Copy(Texto,1,1))+LowerCase(Copy(Texto,2,Length(Texto)));
    Result := Texto;
    end;
end;

{*****************************************************************************
                     Converte para minusculas
****************************************************************************** }
function Minusculas(const S: String): String;
begin
  Result:=AnsiLowerCase(S);
end;

{*****************************************************************************
                     Converte para maisculas
****************************************************************************** }
function Maiusculas(const S: String): String;
begin
  Result:=AnsiUpperCase(S);
end;

{*****************************************************************************
                     Converte String em Pchar
****************************************************************************** }
function StrToPChar(const Str: string): PChar;
type
  TRingIndex = 0..7;
var
  Ring: array[TRingIndex] of PChar;
  RingIndex: TRingIndex;
  Ptr: PChar;
begin
  RingIndex := 0;
  Ptr := @Str[Length(Str)];
  Inc(Ptr);
  if Ptr^ = #0 then
     begin
     Result := @Str[1];
     end
  else
     begin
     Result := StrAlloc(Length(Str)+1);
     RingIndex := (RingIndex + 1) mod (High(TRingIndex) + 1);
     StrPCopy(Result,Str);
     StrDispose(Ring[RingIndex]);
     Ring[RingIndex]:= Result;
     end;
end;

{*****************************************************************************
           Retorna o número de palavras que contem em uma string
****************************************************************************** }
Function ContaPalavra(str : string) : integer;
var
count : integer;
i : integer;
len : integer;
begin
len := length(str);
count := 0;
i := 1;
while i <= len do
      begin
      while ((i <= len) and ((str[i] = #32) or (str[i] = #9) or (Str[i] = ';'))) do
            inc(i);
            if i <= len then
               inc(count);
             while ((i <= len) and ((str[i] <> #32) and (str[i] <> #9) and (Str[i] <> ';'))) do
                   inc(i);
      end;
      ContaPalavra := count;
end;

{*****************************************************************************
          Testa se em uma string existe um numero inteiro valido ou não
****************************************************************************** }
function ExisteInteiro(Texto:String): Boolean;
var
i:integer;
begin
try
  i := StrToInt(Texto);
  Result := True;
except
  Result := False;
end;
end;

{******* desmonta uma mascara do tipo 99.999.9999 **************************** }
function DesmontaMascara(var Vetor : array of byte; mascara:string): byte;
var x:byte;
    posicao:byte;
begin
  FillChar(Vetor, SizeOf(Vetor), 0);
  posicao:=0;
  x:=0;
  while Pos('.', mascara) > 0 do
  begin
    vetor[x]:=(Pos('.', mascara)-posicao)-1;
    inc(x);
    posicao:=Pos('.', mascara);
    mascara[Pos('.', mascara)] := '*';
  end;
  vetor[x]:=length(mascara)-posicao;
  vetor[x+1] := 1;
  DesmontaMascara:=x+1;
end;


function SeparaFraseChar( texto : string; separador : char ) : TStringList;
var
  laco, ultimo : integer;
  adiciona : string;
begin
  result := TStringList.Create;
  laco := 1;
  ultimo := 1;
  while (Length(texto) > laco) do
  begin
    while (texto[laco] <> separador) and (Length(texto) > laco) do
      inc(laco);
    adiciona := copy(texto, ultimo, laco - ultimo);
    if adiciona <> '' then
    result.Add(adiciona);
    inc(laco);
    ultimo := laco;
 end;
end;

end.
