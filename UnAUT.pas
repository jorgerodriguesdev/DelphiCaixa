unit UnAut;

interface

uses
 SysUtils, Classes, StdCtrls, UnComandosAUT, DBTables, Registry;

// suporte
// 021 41 356-3233
// 021 41 356-2324
//

type
    TAUT = class
  private
    UnBMP2032 : TAUTBematechMP_2032;
    Tabela : TQuery;
  public
    constructor criar( aowner : TComponent; ADataBase : TDataBase  ); //
    destructor Destroy; override; //
    procedure AbrePorta; //
    procedure FecharPorta;
    function Imprime(texto : string) : Boolean;
    procedure ImprimeFormato(Texto : string);
    procedure Autentica(texto : string); //
    function VerificaImpressora : boolean;
    procedure AcionarGaveta;
    function DocumentoInserido : boolean;
end;
implementation

uses constmsg, funstring, funnumeros, fundata, funBases, constantes, funsql;


{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                   Atividades na impressora
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

constructor TAUT.criar( aowner : TComponent; ADataBase : TDataBase  );
begin
inherited;
  Tabela := TQuery.Create(aowner);
  Tabela.DatabaseName := ADataBase.DatabaseName;

end;

destructor TAUT.Destroy;
begin
  tabela.free;
  inherited;
end;


procedure TAUT.AbrePorta;
begin
  case varia.TipoImpressoraAUT of
    1 : UnBMP2032.AbrePorta;
  end;
end;

procedure TAUT.FecharPorta;
begin
  case varia.TipoImpressoraAUT of
    1 : UnBMP2032.FecharPorta;
  end;
end;

function TAUT.Imprime(texto : string) : Boolean;
begin
  case varia.TipoImpressoraAUT of
    1 : UnBMP2032.imprime(texto);
  end;
end;

procedure TAUT.ImprimeFormato(Texto : string);
begin
  case varia.TipoImpressoraAut of
    1 : UnBMP2032.imprimeformato(texto);
  end;
end;

procedure TAUT.Autentica(texto : string);
begin
  case varia.TipoImpressoraAUT of
    1 : begin UnBMP2032.Autentica(texto) end;
  end;
end;

procedure TAUT.VerificaImpressora;
begin
  case varia.TipoImpressoraAUT of
    1 : begin UnBMP2032.VerificaImpressora end;
  end;
end;


procedure TAUT.AcionarGaveta; //
begin
   case varia.TipoImpressoraAUT of
    1 : begin UnBMP2032.AcionaGaveta; end;
  end;
end;

function TAUT.DocumentoInserido : boolean; //
begin
   case varia.TipoImpressoraAUT of
    1 : begin result := UnBMP2032.DocumentoInserido; end;
  end;
end;


end.
