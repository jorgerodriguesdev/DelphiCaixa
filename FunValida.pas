{***********************************************************}
{                    Systec Sistemas Ltda                   }
{                                                           }
{  Funçõs para verificação, tipo cgc e extenso              }
{  Sergio Luis Censi  01/09/98                              }
{***********************************************************}

unit FunValida;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TConsisteInscricaoEstadual  = function (const Insc, UF: String): Integer; stdcall;


    Function VerificaCGC( CGC : String ) : Boolean;
    Function VerificaCPF( CPF : string ): Boolean;
    Function VerificarIncricaoEstadual(VpaNroInscricao,VpaUF : String; VpaMessagemErro, VpaTrancar : Boolean) : boolean;
    function validaPIS(Dado : String) : boolean;
    Function Criptografa(Texto:String):String;
    Function Descriptografa(Texto:String):String;
    function ValidaDesconto( valorVenda, ValorModificado, PercentualPermitido : double; CorForm, CorCaixa : TColor;  AlterarValorUnitarioComSenha : Boolean; SenhaLiberacao : string; MascaraMoeda : string ) : boolean;
    function CriptografaSerie( texto : string ) : string;
    function DesCriptografaSerie( texto : string ) : string;
implementation

uses constmsg, funstring;

{******************************************************************************
                               Verifica CGC
{ *****************************************************************************}

Function VerificaCGC( CGC : string ) : Boolean;
Var i, code : Integer;
    d2 : Array[1..12] of Integer;
    DF4, DF5, DF6, RESTO1, Pridig, Segdig : Integer;
    Pridig2, Segdig2 : String;
    t_texto : String;
begin
 Begin
   t_texto:= '';
   t_texto:=copy(CGC,1,2);
   t_texto:=t_texto+copy(CGC,4,3);
   t_texto:=t_texto+copy(CGC,8,3);
   t_texto:=t_texto+copy(CGC,12,4);
   t_texto:=t_texto+copy(CGC,17,2);

      For i := 1 to 12 do Val(t_texto[i],D2[i],Code);
      DF4 := 5 * D2[1] + 4 * D2[2] + 3 * D2[3] + 2 * D2[4] + 9 * D2[5] + 8 * D2[6] + 7 * D2[7]
      + 6 * D2[8] + 5 * D2[9] + 4 * D2[10] + 3 * D2[11] + 2 * D2[12];
      DF5 := DF4 div 11;
      DF6 := DF5 * 11;
      Resto1 := Df4 - DF6;
      If (Resto1=0) or (Resto1=1) then Pridig:=0 else Pridig:=11 - Resto1;

      For i := 1 to 12 do Val(t_texto[i],D2[i],Code);
      DF4 := 6 * D2[1] + 5 * D2[2] + 4 * D2[3] + 3 * D2[4] + 2 * D2[5]
      + 9 * D2[6] + 8 * D2[7] + 7 * D2[8] + 6 * D2[9] + 5 * D2[10] +4 * D2[11]
      + 3 * D2[12] + 2 * Pridig;
      DF5 := DF4 div 11;
      DF6 := DF5 * 11;
      Resto1 := Df4 - DF6;
      If (Resto1=0) or (Resto1=1) then Segdig:=0 else Segdig:=11 - Resto1;

      Str(Pridig, Pridig2);
      Str(Segdig, Segdig2);
      If not (Pridig2=t_texto[13]) or not (SegDig2=t_texto[14]) then
        result := false
      else
        result := true;
end;
end;


{******************************************************************************
                                VerificaCPF
{ *****************************************************************************}
Function VerificaCPF( CPF : string ) : Boolean;
Var i, code : Integer;
    d2 : Array[1..12] of Integer;
    DF4, DF5, DF6, RESTO1, Pridig, Segdig : Integer;
    Pridig2, Segdig2 : String;
    t_texto : String;
begin

   t_texto:='';
   t_texto:=copy(CPF,1,3);
   t_texto:=t_texto+copy(CPF,5,3);
   t_texto:=t_texto+copy(CPF,9,3);
   t_texto:=t_texto+copy(CPF,13,2);

      For i := 1 to 9 do Val(t_texto[i],D2[i],Code);
      DF4 := 10 * D2[1] + 9 * D2[2] + 8 * D2[3] + 7 * D2[4] + 6 * D2[5] + 5 * D2[6] + 4 * D2[7] + 3 * D2[8] + 2 * D2[9];
      DF5 := DF4 div 11;
      DF6 := DF5 * 11;
      Resto1 := Df4 - DF6;
      If (Resto1=0) or (Resto1=1) then
         Pridig:=0
      else
         Pridig:=11 - Resto1;
      For i := 1 to 9 do Val(t_texto[i],D2[i],Code);
      DF4 := 11 * D2[1] + 10 * D2[2] + 9 * D2[3] + 8 * D2[4] + 7 * D2[5] + 6 * D2[6] + 5 * D2[7] + 4 * D2[8] + 3 *
      D2[9] + 2 * Pridig;
      DF5 := DF4 div 11;
      DF6 := DF5 * 11;
      Resto1 := Df4 - DF6;
      If (Resto1=0) or (Resto1=1) then
         Segdig:=0
      else
         Segdig:=11 - Resto1;
      Str(Pridig, Pridig2);
      Str(Segdig, Segdig2);
      If not (Pridig2=t_texto[10]) or not (SegDig2=t_texto[11]) then
         result := false
      else
         result := true;
   end;



Function VerificarIncricaoEstadual(VpaNroInscricao,VpaUF : String; VpaMessagemErro, VpaTrancar : Boolean) : boolean;
var
  VpfResultado : Integer;
  LibHandle : THandle;
  ConsisteInscricaoEstadual : TConsisteInscricaoEstadual;
begin
  result := false;
  try
    // carrega a dll dinamicamente;
    LibHandle :=  LoadLibrary (PChar (Trim ('DllInscE32.Dll')));
    // verifica se existe a dll
    if  LibHandle <=  HINSTANCE_ERROR then
      raise Exception.Create ('Dll  de validação da Inscrição Estadual - "DllInscE32.dll" - não carregada');

    @ConsisteInscricaoEstadual  :=  GetProcAddress (LibHandle,
                                                    'ConsisteInscricaoEstadual');
    if  @ConsisteInscricaoEstadual  = nil then
      raise Exception.Create('Funcao de validação da Inscrição Estadual não encontrado na Dll');

    VpaNroInscricao := DeletaChars(VpaNroInscricao,'.');
    VpaNroInscricao := DeletaChars(VpaNroInscricao,'/');
    VpaNroInscricao := DeletaChars(VpaNroInscricao,'\');
    VpaNroInscricao := DeletaChars(VpaNroInscricao,'-');
    VpaNroInscricao := DeletaChars(VpaNroInscricao,' ');
    VpaUF := UpperCase(VpaUF);

    VpfResultado := ConsisteInscricaoEstadual(VpaNroInscricao,VpaUF);
    Result := VpfResultado = 0;

    if VpaMessagemErro then
      case VpfResultado of
        1 : aviso('Inscrição inválida para ' + VpaUF);
        2 : aviso('Parâmetros inválidos');
      end;

    if not VpaTrancar then
      result := true;

  finally
    FreeLibrary (LibHandle);
  end;
end;

{******************************************************************************
             valida PIS
{ *****************************************************************************}
function validaPIS(Dado : String) : boolean;
{Testa se o número do pis é válido ou não}
var
i, wsoma, Wm11, Wdv,wdigito : Integer;
begin
result := true;
if DeletaEspacoDE(Dado) <> '' Then
   begin
   wdv := strtoint(copy(Dado, 11, 1));
   wsoma := 0;
   wm11 := 2;
   for i := 1 to 10 do
       begin
       wsoma := wsoma + (wm11 *strtoint(copy(Dado,11 - I, 1)));
       if wm11 < 9 then
          begin
          wm11 := wm11+1
          end
       else
          begin
          wm11 := 2;
          end;
       end;
   wdigito := 11 - (wsoma MOD 11);
   if wdigito > 9 then
      begin
      wdigito := 0;
      end;
   if wdv = wdigito then
      begin
      validapis := true;
      end
   else
      begin
      validapis := false;
      end;
   end;
end;

{  descricao da criptografação:
     pega o primeiro caracter da string e converte para ascii, a partir daí
     multiplica esse valor por 7 e soma 7777 para que indeterminado do valor
     ascii o numero ocupe 4 casas, repete esse processo com os 3 primeiros
     caracteres, e o restante dos caracteres converte um a um para ascii adiciona
     2 em seu valor, e o converte de novo para char;
     Exemplo:
       A String 'rafael' é criptografada para 857584568491cgn

       r -valor ascii = 114 - Multiplicado por 7 = 798 - Adicionado 7777 = 8575
       a -valor ascii =  97 - Multiplicado por 7 = 679 - Adicionado 7777 = 8456
       f -valor ascii = 102 - Multiplicado por 7 = 714 - Adicionado 7777 = 8491
       a -valor ascii =  97 - Adicionado 2 =  99 - Convertido para Char  = c
       e -valor ascii = 101 - Adicionado 2 = 103 - Convertido para Char  = g
       l -valor ascii = 108 - Adicionado 2 = 111 - Convertido para Char  = n
                                                            RESULTADO ------------
                                                                      857584568491cgn
      A String 'Sergio' é criptografada para 835884848575ikg
      A String 'L' é criptografada para 838977778575


      Descriptografação é o processo inverso da criptação


      OBSERVAÇÃO - O Campo onde é guardado a criptogração tem que possuir obrigatóriamento
                   9 casas a mais que um campo não Criptografado }


{******************************************************************************
              Recebe uma string e a devolve criptografada
{ *****************************************************************************}
Function Criptografa( Texto : String) : String;
var
x,WValLet : Integer;
WSenha : String;
begin
WSenha:='';
if length(texto) = 1 Then
   texto[3] := Char(0);

if Texto <> '' then
begin
   for x:=1 to 3 do
   begin
      WValLet := ord(Texto[x]) * 7 + 7777;
      WSenha := WSenha + IntToStr(WValLet);
   end;
   for x:=4 to length(Texto) do
      WSenha:= WSenha + Char(ord(Texto[x]) + 2);
end;
   Result := WSenha;
end;


{******************************************************************************
             Recebe uma string e a devolve Descriptografada
{ *****************************************************************************}
Function Descriptografa(Texto:String):String;
var
x, y : ShortInt;
WValLet : Cardinal;
WSenha:String;
begin
WSenha:='';
y := 1;
if Texto <> '' then
begin
   for x:=1 to 3 do
   begin
      WValLet := StrToInt(copy(Texto,y,4)) - 7777;
      WValLet := WValLet div 7;
      y := y + 4;
      WSenha := WSenha + Char(WValLet);
   end;
   for x:=13 to Length(Texto) do
      WSenha := WSenha + Char(ord(Texto[x]) - 2);
end;
   Result := WSenha;
end;


{******************************************************************************
             valida Desconto somente com senha
{ *****************************************************************************}
function ValidaDesconto( valorVenda, ValorModificado, PercentualPermitido : double; CorForm, CorCaixa : TColor; AlterarValorUnitarioComSenha : Boolean; SenhaLiberacao : string; MascaraMoeda : string ) : boolean;
var
  Desconto : double;
  senha : string;
begin
result := true;
   Desconto :=  valorVenda -  ValorModificado; // verifica o desconto concedido
   if Desconto >(PercentualPermitido / 100) * ValorVenda then  // se o desconto for maior
   begin
    if AlterarValorUnitarioComSenha then
         if ConfirmacaoFormato(CT_DescontoInvalido, [FormatFloat(mascaraMoeda, (PercentualPermitido / 100) * valorVenda)] ) then  // mensagem de desconto maior
           result := false
         else
          if entrada( 'Digite senha', 'Digite a senha de permissão', senha,true, CorCaixa, CorForm) then  // senha de permissao para liberar o desconto
          begin
             if senhaLiberacao <> senha then     // verifica a senha de autorizacao....
             begin
               aviso('permissao negada');
               result := false;
             end
         end
          else
            result := false;
       end
  end;



function CriptografaSerie( texto : string ) : string;
var
  laco : integer;
begin
  result := '';
  texto := Maiusculas(texto);
  for laco := 1 to length(texto) do
  begin
    result := result + IntTostr(100-ord(texto[laco]));
  end;
  Result := InverteString(result);
end;

function DesCriptografaSerie( texto : string ) : string;
begin
  result := '';
  texto := InverteString(texto);
  while texto <> '' do
  begin
    try
      result := result + (chr(100-StrToInt(copiaDireita(texto,2))));
      if length(texto) > 2 then
        texto := copy(texto, 3, length(texto))
      else
        texto := '';
    except
      result := '';
      exit;
    end;      
  end;
end;

end.
