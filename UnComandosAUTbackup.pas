unit UnComandosAUT;
// suporte
// 021 41 356-3233
// 021 41 356-2324
//

interface

uses
 SysUtils, Classes, StdCtrls, UnComandosECF, DBTables, Registry, ConstMsg, constantes;

type
  TFuncoesAut = class
  private
     buffer, cmd: String;
     envia, porta, comando, fecha, modo: Integer;
     negrito, italico, sublinhado, expandido: Integer;

  public
    procedure AbrePorta;
    procedure FecharPorta;
    function Imprime(Texto : string) : Boolean;
    procedure ImprimeFormato(Texto : string);

    procedure Autentica(texto : string);
    procedure AcionaGaveta;
    function DocumentoInserido : boolean;
    function VerificaImpressora : boolean;
    procedure ImprimeDesenho;
    { Private declarations }
  end;

var
  comunica: String;

function IniciaPorta(Porta:string):integer; stdcall; external 'Mp2032.dll';
function FechaPorta:integer; stdcall; external 'Mp2032.dll';
function BematechTX(BufTrans:string):integer; stdcall; external 'Mp2032.dll';
function FormataTX(BufTras:string; TpoLtra:integer; Italic:integer; Sublin:integer; expand:integer; enfat:integer):integer; stdcall; far; external 'Mp2032.dll';
function ComandoTX (BufTrans:string;TamBufTrans:integer):integer; stdcall; external 'Mp2032.dll';
function DocumentInserted: integer; stdcall; far; external 'MP2032.DLL';
function Le_Status: integer; stdcall; far; external 'MP2032.DLL';
function AutenticaDoc(texto: string; tempo: integer): integer; stdcall; far; external 'MP2032.DLL';

implementation

procedure TFuncoesAut.AbrePorta;
var
  porta : integer;
begin
  comunica := uppercase(Varia.PortaComunicacaoAUT);
  porta := IniciaPorta(Pchar(comunica));
  If porta <= 0 Then
     Aviso('Problemas ao abrir a porta de Comunicação. Verifique.');
end;

// fechar porta
procedure TFuncoesAut.FecharPorta;
begin
  FechaPorta;
end;

// Imprime Texto sem Formatação.
function TFuncoesAut.Imprime(Texto : string) : boolean;
begin
  result := true;
  while result do
  begin
    buffer  := texto +  Chr(10);
    comando := FormataTX(buffer, 3, 0, 0, 0, 0);
    if comando = 0 then
    begin
      if not Confirmacao('A autenticadora não está respondendo, tentar novamente ? ' ) then
        result := false;
    end
    else
      result := false;
  end;
end;


// Imprime Texto com Formatação.
procedure TFuncoesAut.ImprimeFormato(Texto : string);
begin
  // Verifica modo NORMAL, ELITE ou CONDENSADO.
  Case varia.ModoImpressaoAUT of
    0 : modo := 1;
    1 : modo := 2;
    2 : modo := 3;
  end;

  if varia.FonteNegritoAUT then
     Negrito := 1
  else
     negrito := 0;
  if varia.fonteItalicoAut then
     italico := 1
  else
     italico := 0;
  if varia.fontesublinhadoAut then
     sublinhado := 1
  else
     sublinhado := 0;
  if varia.FonteExpandidoAUT  then
     expandido := 1
  else
     expandido := 0;

  buffer  := texto + Chr(13) + Chr(10);
  comando := FormataTX(buffer, modo, Italico, Sublinhado, Expandido, Negrito);
end;

// Autentica Documento
procedure TFuncoesAut.Autentica(texto : string);
var
  retorno : integer;
begin
  //comando := BematechTX(chr(27)+chr(97)+chr(1));
  //envia   := FormataTX (texto + chr(13) + chr(10), 2, 0, 0, 0, 0);
  retorno := Autenticadoc(texto, 6000);
  if retorno = 0 then
     aviso('Documento não foi autenticado');
  comando := BematechTX(chr(27)+chr(97)+chr(0));
end;

// Aciona Gaveta
procedure TFuncoesAut.AcionaGaveta;
begin
  // Comando para Acionamento da GAVETA de Dinheiro
   buffer := Chr(27) + Chr(118) + Chr(140);
   envia := ComandoTX(buffer, Length(buffer));
end;

// Verifica Documento inserido
function TFuncoesAut.DocumentoInserido : boolean;
begin
  while DocumentInserted() = 0 do
    begin
      result := false;
      aviso('Deve ser inserido o documento para autenticação');
    end;
  result := true;
end;

// verifica impressora
function TFuncoesAut.VerificaImpressora : boolean;
begin
  if (comunica = 'LPT1') or (comunica = 'LPT2') or (comunica = 'LPT3') then
  begin
    while Le_Status() <> 144 do
    begin
     case le_status() of
       79 : begin
             result := false;
             aviso('Verifique se a impressora está On_line');
            end;
       0 : begin
             result := false;
             aviso('Verifique se a impressora está desligada');
           end;
      40 : begin
             result := false;
             aviso('Verifique se a impressora está sem papel');
           end;
     end;
    end;
  end
  else
  begin
    if (comunica = 'COM1') or (comunica = 'COM2') or (comunica = 'COM3') then
    begin
      while Le_Status() <> 24 do
      begin
       case le_status() of
         0 : begin
               result := false;
               aviso('Verifique se a impressora está On_line');
             end;

        32 : begin
               result := false;
               aviso('Verifique se a impressora está sem papel');
             end;
       end;
      end;
    end;
  end;

  result := true;
end;

// Comando para Imprimir Caracter de Autenticação.
procedure TFuncoesAut.ImprimeDesenho;
{
                  DESENHO

             1 2 3 4 5 6 7 8 9
bit 7 = 128  *               *
bit 6 = 064  * *             *
bit 5 = 032  * * *           *
bit 4 = 016  * * * *         *
bit 3 = 008  * * * * *       *
bit 2 = 004  * * * * * *     *
bit 1 = 002  * * * * * * *   *
bit 0 = 001  * * * * * * * * *
}

begin
  // Comando que habilita o modo grafico com 9 pinos (9 colunas)
  cmd := chr(27) + chr(94) + chr(18) + chr(0);
  envia := ComandoTX(cmd, Length(cmd));

  // Sequencia de bytes para a montagem do desenho acima
  cmd := chr(255) + chr(0) + chr(0) + chr(0) + chr(127) + chr(0)
         + chr(0) + chr(0) + chr(063) + chr(0) + chr(0) + chr(0)
         + chr(031) + chr(0) + chr(0) + chr(0) + chr(015) + chr(0) + chr(0)
         + chr(0) + chr(007) + chr(0) + chr(0) + chr(0) + chr(003) + chr(0)
         + chr(0) + chr(0) + chr(001) + chr(0) + chr(0) + chr(0) + chr(255)
         + chr(0) + chr(0) + chr(0);
  envia := ComandoTX(cmd, Length(cmd));

  // Descarrega o buffer na impressora.
  cmd := chr(13) + chr(10);
  envia := ComandoTX(cmd, Length(cmd));
end;

end.
