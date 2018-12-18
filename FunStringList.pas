unit FunStringList;

interface

Uses
   Classes, SysUtils;

procedure InseriLinhaLista( Lista : TStrings; linha : Integer; texto : string );
procedure DeletaLinhaLista( Lista : TStrings; linha : Integer );
procedure SubstituiLinhaLista( Lista : TStrings; linha : Integer; NovoTexto : string );

implementation

uses
   FunTrataErro;

{************** adiciona uma nova linha na lista ************************* }
procedure InseriLinhaLista( Lista : TStrings; linha : Integer; texto : string );
begin
try
 lista.Insert(linha,texto);
except
  TrataErroTStrings(CT_ErroInsercaoLinha, [ IntToStr(lista.count -1), IntToStr(linha)]);
end;
end;

{ ***************** deleta uma linha da lista **************************** }
procedure DeletaLinhaLista( Lista : TStrings; linha : Integer );
begin
try
 lista.Delete(linha);
except
  TrataErroTStrings(CT_ErroDelecaoLinha, [ IntToStr(lista.count -1), IntToStr(linha)]);
end;
end;

{ ***************** substitui uma linha da lista *************************** }
procedure SubstituiLinhaLista( Lista : TStrings; linha : Integer; NovoTexto : string );
begin
  DeletaLinhaLista(lista,linha);
  InseriLinhaLista(lista,linha,NovoTexto);
end;
end.
