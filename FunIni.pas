unit FunIni;

interface

uses
  graphics, PainelGradiente, classes, funString;

function LeAtributosFonte( fonte : TFont) : String;
function MontaAtributosFonte( texto : String) : TFontStyles;
function RetornaEfeitoTexto(item : Integer) : TTextEffect;
function ConfiguraEfeitoTexto(texto : TTextEffect) : Integer;
function RetornaAlinhamentoTexto(item : Integer) : TAlignment;
function ConfiguraAlinhamentoTexto(texto : TAlignment) : Integer;
function RetornaFundoTitulo(item : integer) : TDirection;
function ConfiguraFundoTitulo(texto : TDirection) : Integer;
function RetornaSituacaoImagem( item : integer ) : string;
function ConfiguraSituacaoImagem( texto : string ) : integer;

implementation

function LeAtributosFonte( fonte : TFont) : String;
begin
 result := '';
  if fsBold in fonte.Style then result := 'fsBold' + ';';
  if fsItalic in Fonte.Style then  result := result + 'fsItalic' + ';';
  if fsUnderline in fonte.Style then result := result + 'fsUnderline' + ';';
  if fsStrikeOut in fonte.Style then  result := result + 'fsStrikeOut' + ';';
end;


function MontaAtributosFonte( texto : String) : TFontStyles;
var
  procurado : string;
begin
if texto <> '' then
begin
   while length(texto) > 1 do
   begin
       procurado := CopiaAteChar(texto,';');
       texto := copy(texto,NPosicao(';',texto,1)+1,length(texto));
     if procurado = 'fsBold' then
       result := [fsBold];
     if procurado = 'fsItalic' then
       result := result + [fsItalic];
     if procurado = 'fsUnderline' then
       result := result + [fsUnderline];
     if procurado = 'fsStrikeOut' then
        result := result + [fsStrikeOut];
   end;
end
else
  result := [];
end;

function RetornaEfeitoTexto(item : integer) : TTextEffect;
begin
case item of
  0 : result := teSombraAcima;
  1 : result := teSombraAbaixo;
  2 : result := teSombra;
  3 : result := teContorno;
  else result := teNenhum;
end;
end;

function ConfiguraEfeitoTexto(texto : TTextEffect) : Integer;
begin
case texto of
  teSombraAcima  : result := 0;
  teSombraAbaixo : result := 1;
  teSombra       : result := 2;
  teContorno     : result := 3;
   else result := 4;
end;
end;

function RetornaAlinhamentoTexto(item : Integer) : TAlignment;
begin
case item of
  0 : result := taRightJustify;
  1 : result := taCenter;
  else result := taLeftJustify;
end;
end;

function ConfiguraAlinhamentoTexto(texto : TAlignment) : integer;
begin
case texto of
  taRightJustify   : result := 0;
  taCenter         : result := 1;
  else result := 2;
end;
end;

function RetornaFundoTitulo(item : integer) : TDirection;
begin
case item of
  0 : result := bdTopo;
  1 : result := bdAbaixo;
  2 : result := bdDireita;
  3 : result :=bdEsquerda;
  4 : result := bdVertDentro;
  5 : result :=  bdHorzDentro;
  else result := bdNenhum;
end;
end;

function ConfiguraFundoTitulo(texto : TDirection ) : integer;
begin
case texto of
  bdTopo       : result := 0;
  bdAbaixo     : result := 1;
  bdDireita    : result := 2;
  bdEsquerda   : result := 3;
  bdVertDentro : result := 4;
  bdHorzDentro : result := 5;
  else result := 6;
end;
end;



function RetornaSituacaoImagem( item : integer ) : string;
begin
case item of
  0 : result := 'LADOALADO';
  1 : result := 'CENTRALIZADO';
  2 : result := 'NENHUM';
  else
    result := 'ESTICADO';
end;
end;

function ConfiguraSituacaoImagem( texto : string ) : integer;
begin
if texto = 'LADOALADO' then
  result := 0
else
  if texto = 'CENTRALIZADO' then
    result := 1
  else
    if texto = 'ESTICADO' then
      result := 3
    else
      result := 2
end;

end.
