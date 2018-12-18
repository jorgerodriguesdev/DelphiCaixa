{***********************************************************}
{                    Systec Sistemas Ltda                   }
{                                                           }
{  Funçõs para datas e Horas                                }
{  Sergio Luis Censi  01/09/98                              }
{***********************************************************}

Unit FunData;

interface

uses
  SysUtils,Dialogs;


type
  FormatoData = (MMDDAA,AAMMDD,AADDMM,DDMMAA,MMDDAAAA,AAAAMMDD,AAAADDMM,DDMMAAAA);

 // data
     function Dia(Data:TDateTime) : Word;
     function Mes(Data:TDateTime) : Word;
     function Ano(Data:TDateTime) : Word;
     function Ano4Digito(Data:TDateTime) : Word;

     function IncData(Data: TDateTime; Dias, Meses, anos: Integer): TDateTime;

     function IncDia(Data:TDateTime; Dias : Integer) : TDateTime;
     function DecDia(Data:TDateTime; Dias : Integer) : TDateTime;
     function IncMes(Data:TDateTime; Meses : Integer) : TDateTime;
     function DecMes(Data:TDateTime; meses : word) : TDateTime;
     function IncAno(Data:TDateTime; anos : integer) : TDateTime;
     function DecAno(Data:TDateTime; anos : integer) : TDateTime;

     function AnoBisesto(ano: Integer): Boolean;
     function DiasPorMes(Ano, mes: Integer): Integer;

     function PrimeiroDiaProximoMes: TDateTime;
     function PrimeiroDiaMesAnterior: TDateTime;
     function UltimoDiaMesAnterior: TDateTime;
     function PrimeiroDiaMes(Data:TDateTime) : TDateTime;
     function UltimoDiaMes(Data:TDateTime) : TDateTime;

     function ValidaData(Dia, Mes, Ano: Word): Boolean;
     function DiasPorPeriodo(Data1, Data2: TDateTime): Longint;
     function MesesPorPeriodo(Data1, Data2: TDateTime): Double;

     Function DiasPorPeriodoPagamento(DataVen, DataPag: TDateTime): Longint;
     Function MesPorPeriodoPagamento(DataVen, DataPag: TDateTime): Longint;

     procedure DiferencaData(Data1, Data2: TDateTime; var Dias, Meses, Anos: Word);
     function QdadeDiasUteis(dataini,datafin: TDateTime):integer;

     function MontaData(Dia, Mes, Ano : Word ) : TDateTime;
     function MontaDataTexto( texto : string; Ano4Digito : boolean ) : TDateTime;
     function DiaSemanaNumerico( Data : TDateTime ) : Word;

     function TextoDiaSemana( Data : TDateTime) : String;
     function TextoDia( Data : TDateTime) : String;
     function TextoMes( Data : TDateTime; Abreviado : Boolean ) : String;
     function NumeroMes( Mes: Integer; Abreviado : Boolean ) : string;

     function TextoAno( Data : TDateTime) : String;
     function TextoData( Data : TDateTime) : String;
     function TextoDataDoc( Data : TDateTime; Cidade : string; extenso : Boolean) : String;

// hora
     function Hora(Time:TDateTime) : Word;
     function Minuto(Time:TDateTime) : Word;
     function Segundo(Time:TDateTime) : Word;
     function Milisegundo(Time:TDateTime) : Word;
     function IncHoras(Hora: TDateTime; Horas, Minutos, Segundos,
                       MilSegundos: Integer): TDateTime;
     function IncHora(Hora: TDateTime; Horas: Integer): TDateTime;
     function IncMinuto(Hora: TDateTime; Minutos: Integer): TDateTime;
     function IncSegundo(Hora: TDateTime; Segundos: Integer): TDateTime;
     function IncMilSegundo(Hora: TDateTime; MilSegundos: Integer): TDateTime;
     function DiferencaHora(Inicio,Fim : TDateTime):String;
     function MontaHoraTexto( texto : string ) : string;
     function DiferencaMinutos(VpaInicio,VpaFim : TDateTime) : Integer;

    function DataToStrFormato(Formato : FormatoData; data : TDateTime; charSeparador : char) : string;

implementation

uses
 FunNumeros, ConstMsg;


{#############################################################################
                       Funções  Datas
 #############################################################################}

{ Retorna o dia }
function Dia(Data:TDateTime) : Word;
Var Mes,Ano : Word;
begin
   DecodeDate(Data,Ano,Mes,result);
end;

{*****************************************************************************}
{ Retorna o mês }
function Mes(Data:TDateTime) : Word;
Var Dia,Ano : Word;
begin
   DecodeDate(Data,Ano,result,Dia);
end;

{*****************************************************************************}
{ Retorna o Ano }
function Ano(Data:TDateTime) : Word;
Var Dia,Mes : Word;
begin
   DecodeDate(Data,result,Mes,Dia);
end;

{**************** retorna o ano com 4 digito ****************************** }
function Ano4Digito(Data:TDateTime) : Word;
Var Dia,Mes : Word;
begin
  DecodeDate(Data,result,Mes,Dia);
  if Length(IntToStr(result)) = 2 then
    result := StrToInt('20' + InttoStr(result));
end;

{*****************************************************************************}
{ incrementa data }
function IncData(Data: TDateTime; Dias, Meses, anos: Integer): TDateTime;
var
  D, M, Y: Word;
  Dia, Mes, Ano: Longint;
begin
  DecodeDate(Data, Y, M, D);
  Ano := Y; Mes := M; Dia := D;
  Inc(Ano, Anos);
  Inc(Ano, Meses div 12);
  Inc(Mes, Meses mod 12);
  if Mes < 1 then begin
    Inc(Mes, 12);
    Dec(Ano);
  end
  else if Mes > 12 then begin
    Dec(Mes, 12);
    Inc(Ano);
  end;
  if Dia > DiasPorMes(Ano, Mes) then Dia := DiasPorMes(Ano, Mes);
  Result := EncodeDate(Ano, Mes, Dia) + Dias + Frac(Data);
end;


{*****************************************************************************}
{ Incrementa Dias }
function IncDia(Data:TDateTime; Dias : Integer) : TDateTime;
begin
    Result := Data + Dias;
end;

{*****************************************************************************}
{ Decrementa Dias }
function DecDia(Data:TDateTime; Dias : Integer) : TDateTime;
begin
    Result := Data - Dias;
end;

{*****************************************************************************}
{ Incrementa Meses }
function IncMes(Data:TDateTime; Meses : Integer) : TDateTime;
begin
   Result := IncData(data,0,Meses,0);
end;

{*****************************************************************************}
{ Decrementa Meses }
function DecMes(Data:TDateTime; meses : word) : TDateTime;
Var mesAtual, diaAtual : word;
    NovaData : TDateTime;
    laco : integer;
begin
    diaAtual := dia(data);
    NovaData := data;
    for laco := 1 to meses do
    begin
      mesAtual := mes(Novadata);
      while MesAtual = mes(NovaData) do NovaData := NovaData - 1;
    end;
    while not validadata(diaAtual,mes(NovaData),ano(novaData)) do  dec(diaAtual);
    Result := MontaData(diaAtual,mes(NovaData),ano(novaData));
end;

{*****************************************************************************}
{ Incrementa Ano }
function IncAno(Data:TDateTime; anos : integer) : TDateTime;
begin
result := IncData(data,0,0,anos);
end;

{*****************************************************************************}
{ Decrementa Ano }
function DecAno(Data:TDateTime; anos : integer) : TDateTime;
begin
result := EncodeDate(Ano(data) - anos,mes(data),Dia(data));
end;

{*****************************************************************************}
{ verifica ano bisesto }
function AnoBisesto(ano: Integer): Boolean;
begin
  Result := (ano mod 4 = 0) and ((ano mod 100 <> 0) or (ano mod 400 = 0));
end;

{*****************************************************************************}
{ Quantidade de dias no mes }
function DiasPorMes(Ano, mes: Integer): Integer;
const
  DiaMes: array[1..12] of Integer =
    (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
begin
  Result := DiaMes[Mes];
  if (Mes = 2) and AnoBisesto(Ano) then Inc(Result);
end;

{*****************************************************************************}
{ Primeiro dia do proxima mes }
function PrimeiroDiaProximoMes: TDateTime;
var
  Ano, Mes, Dia: Word;
begin
  DecodeDate(Date, Ano, Mes, Dia);
  Dia := 1;
  if Mes < 12 then Inc(Mes)
  else begin
    Inc(Ano);
    Mes := 1;
  end;
  Result := EncodeDate(Ano, Mes, Dia);
end;

{*****************************************************************************}
{ Primeiro dia do Mes Anterior }
function PrimeiroDiaMesAnterior: TDateTime;
var
  Ano, Mes, Dia: Word;
begin
  DecodeDate(Date, Ano, Mes, Dia);
  Dia := 1;
  if Mes > 1 then Dec(Mes)
  else begin
    Dec(Ano);
    Mes := 12;
  end;
  Result := EncodeDate(Ano, Mes, Dia);
end;

{*****************************************************************************}
{ Ultimo dia do Mes Anterior }
function UltimoDiaMesAnterior: TDateTime;
var
  D: TDateTime;
  Ano, Mes, Dia: Word;
begin
  D := PrimeiroDiaMesAnterior;
  DecodeDate(D, Ano, Mes, Dia);
  Dia := DiasPorMes(Ano, Mes);
  Result := EncodeDate(Ano, Mes, Dia);
end;

{*****************************************************************************}
{ Retorna o primeiro dia do Mes Corrente }
function PrimeiroDiaMes(Data:TDateTime) : TDateTime;
begin
   While Dia(Data) <> 1 do Data := Data - 1;
   Result := Data;
end;

{*****************************************************************************}
{ Retorna o Ultimo dia do Mes }
function UltimoDiaMes(Data:TDateTime) : TDateTime;
begin
   Data := Data + 1;
   While Dia(Data) <> 1 do Data := Data + 1;
   Data := Data - 1;
   Result := Data;
end;

{*****************************************************************************}
{ Monta e Retorna a data }
function MontaData(Dia, Mes, Ano : Word ) : TDateTime;
begin
try
  Result := EncodeDate(Ano,Mes,Dia);
except
   Beep;
   erro(CT_ErroMontaData);
   Result := StrToDate('01/01/00');
end;
end;

{ ************* recebe um texto e retorna uma data ************************ }
// exemplo de paramentros 050599 retorna 05/05/1999
function MontaDataTexto( texto : string; Ano4Digito : boolean ) : TDateTime;
var
   aux : string;
   ano,mes,dia : word;
begin
if length(texto) < 6 then
   Result := StrToDate('01/01/00')
else
begin
try
  aux := copy(texto,5,length(texto));
  if (Ano4digito) and (length(aux)= 2) then
  begin
    if StrToInt(aux) < 54 then
       aux := '20' + aux
    else
       aux := '19' + aux;
   end
   else
     if (length(aux)= 4) and ( not Ano4digito) then
      aux := copy(aux,3,4);

  ano := StrtoInt(aux);
  mes := StrtoInt(copy(texto,3,2));
  dia := StrtoInt(copy(texto,1,2));

  if dia = 0 then
     result := strtodate('01/01/1900')
  else
     Result := EncodeDate(ano,Mes,Dia);
except
   Beep;
   erro(CT_ErroMontaData);
   Result := StrToDate('01/01/00');
end;
end;
end;

{*****************************************************************************}
{ Valida da data }
function ValidaData(Dia, Mes, Ano: Word): Boolean;
begin
  Result := (Ano >= 1) and (Ano <= 9999) and (Mes >= 1) and (Mes <= 12) and
    (Dia >= 1) and (Dia <= DiasPorMes(Ano, Mes));
end;

{*****************************************************************************}
{ Dias em um periodo }
function DiasPorPeriodo(Data1, Data2: TDateTime): Longint;
begin
    Result := Abs(Trunc(Data2) - Trunc(Data1));
end;

{*****************************************************************************}
{ Dias em um periodo desconta se o vencimento for na sabado ou domingo }
function DiasPorPeriodoPagamento(DataVen, DataPag: TDateTime): Longint;
begin
result := 0;
if Trunc(DataVen) < Trunc(DataPag) then
   if not ((DiaSemanaNumerico(DataVen) in [7]) and (Trunc(IncDia(DataVen,2)) = Trunc(DataPag))) then
     if not((DiaSemanaNumerico(DataVen) in [1]) and (Trunc(IncDia(DataVen,1)) = Trunc(DataPag))) then
         Result := DiasPorPeriodo(DataVen,DataPag);
end;

{*****************************************************************************}
{ Meses em um periodo desconta se o vencimento for na sabado ou domingo }
function MesPorPeriodoPagamento(DataVen, DataPag: TDateTime): Longint;
var
  meses : Double;
begin
result := 0;
if Trunc(DataVen) < Trunc(DataPag) then
   if not ((DiaSemanaNumerico(DataVen) in [7]) and (Trunc(IncDia(DataVen,2)) = Trunc(DataPag))) then
     if not((DiaSemanaNumerico(DataVen) in [1]) and (Trunc(IncDia(DataVen,1)) = Trunc(DataPag))) then
     begin
         meses := MesesPorPeriodo(DataVen,DataPag);
         result := Trunc(meses) + 1;
         if (meses - Trunc(meses)) <> 0 then
           result := result + 1;
     end;
end;

{*****************************************************************************}
{ Diferenca de data em um periodo }
procedure DiferencaData(Data1, Data2: TDateTime; var Dias, Meses, Anos: Word);
var
  DataAux: TDateTime;
  Dia1, Dia2, Mes1, Mes2, Ano1, Ano2: Word;
begin
  if Data1 > Data2 then begin
    DataAux := Data1;
    Data1 := Data2;
    Data2 := DataAux;
  end;
  DecodeDate(Data1, Ano1, Mes1, Dia1);
  DecodeDate(Data2, Ano2, Mes2, Dia2);
  Anos := Ano2 - Ano1;
  Meses := 0;
  Dias := 0;
  if Mes2 < Mes1 then begin
    Inc(Meses, 12);
    Dec(Anos);
  end;
  Inc(Meses, Mes2 - Mes1);
  if Dia2 < Dia1 then begin
    Inc(Dias, DiasPorMes(Ano1, Mes1));
    if Meses = 0 then begin
      Dec(Anos);
      Meses := 11;
    end
    else Dec(Meses);
  end;
  Inc(Dias, Dia2 - Dia1);
end;


{*****************************************************************************}
{ Quantidade de meses em um periodo }
function MesesPorPeriodo(Data1, Data2: TDateTime): Double;
var
  D, M, Y: Word;
begin
  DiferencaData(Data1, Data2, D, M, Y);
  Result := 12 * Y + M;
end;

{*****************************************************************************}
{ Retorna a quantidade de dias uteis entre duas datas }
function QdadeDiasUteis(dataini,datafin: TdateTime):integer;
var a,b,c:tdatetime;
    ct,s:integer;
begin
if DataFin < DataIni then
   begin
   Result := 0;
   exit;
   end;
ct := 0;
s := 1;
a := dataFin;
b := dataIni;
if a > b then
   begin
   c := a;
   a := b;
   b := c;
   s := 1;
   end;
a := a + 1;
while (dayofweek(a)<>2) and (a <= b) do
      begin
      if dayofweek(a) in [2..6] then
         begin
         inc(ct);
         end;
      a := a + 1;
      end;
ct := ct + round((5*int((b-a)/7)));
a := a + (7*int((b-a)/7));
while a <= b do
      begin
      if dayofweek(a) in [2..6] then
         begin
         inc(ct);
         end;
      a := a + 1;
      end;
if ct < 0 then
   begin
   ct := 0;
   end;
result := s*ct;
end;

{*****************************************************************************}
{ Retorna o dia da semana em valor numerico, segunda, terça, etc }
function DiaSemanaNumerico( Data : TDateTime ) : Word;
begin
Result := DayOfWeek(Data);
end;

{*****************************************************************************}
{ Retora o texto do dia da Semana }
function TextoDiaSemana( Data : TDateTime ) : String;
begin
case IntToStr(DayOfWeek(Data))[1] of
 '1' : Result := 'domingo';
 '2' : Result := 'segunda';
 '3' : Result := 'terça';
 '4' : Result := 'quarta';
 '5' : Result := 'quinta';
 '6' : Result := 'sexta';
end;
end;

{****************************************************************************}
{ Retorna o dia em texto }
function TextoDia( Data : TDateTime) : String;
begin
if Dia(data) = 1 then
  result := 'primeiro'
else
 result := NumeroExtenso(Dia(data));
end;

{****************************************************************************}
{ Retorna o mes em texto }
function TextoMes( Data : TDateTime; Abreviado : Boolean ) : String;
Const
   Meses : array[1..12] of String = ('Janeiro','Fevereiro','Março','Abril','Maio',
                                   'Junho','Julho','Agosto','Setembro','Outubro','Novembro','Dezembro');
begin
if Abreviado then
  result := Copy(Meses[Mes(Data)],0,3)
else
  result:= Meses[Mes(Data)];
end;



{****************************************************************************}
function NumeroMes( Mes: Integer; Abreviado : Boolean ) : String;
Const
   Meses : array[1..12] of String = ('Janeiro','Fevereiro','Março','Abril','Maio',
                                   'Junho','Julho','Agosto','Setembro','Outubro','Novembro','Dezembro');
begin
if Abreviado then
  result := Copy(Meses[Mes],0,3)
else
  result:= Meses[Mes];
end;

{*****************************************************************************}
{ Retorna o ano em texto }
function TextoAno( Data : TDateTime) : String;
begin
result := NumeroExtenso(Ano(data));
end;

{*****************************************************************************}
{ Retorna a data em Texto }
function TextoData( Data : TDateTime) : String;
begin
result := TextoDia(data) + ' de ' + LowerCase(TextoMes(data,false)) + ' de ' + TextoAno(data);
end;

{*****************************************************************************}
{ Retorna a data em texto para documentos, true em extenso }
function TextoDataDoc( Data : TDateTime; Cidade : string; extenso : Boolean) : String;
begin
if extenso then
  result := cidade + ', ' + TextoDia(data) +
            ' de ' + LowerCase(TextoMes(data,false)) + ' de ' + TextoAno(data) + '.'
else
  result := cidade + ', ' + IntToStr(Dia(data)) +
            ' de ' + LowerCase(TextoMes(data,false)) + ' de ' + IntToStr(Ano(data)) + '.';
end;

{*****************************************************************************}

{#############################################################################
                                 Funções Horas
 #############################################################################}

{ Retorna a Hora }
function Hora(Time:TDateTime) : Word;
Var Hora,minuto,Segundo,Milisegundo : Word;
begin
   DecodeTime(Time,Hora,Minuto,Segundo,Milisegundo);
   Result := Hora;
end;

{*****************************************************************************}
{ Retorna o Minuto }
function Minuto(Time:TDateTime) : Word;
Var Hora,minuto,Segundo,Milisegundo : Word;
begin
   DecodeTime(Time,Hora,Minuto,Segundo,Milisegundo);
   Result := Minuto;
end;

{*****************************************************************************}
{ Retorna a Segundo }
function Segundo(Time:TDateTime) : Word;
Var Hora,minuto,Segundo,Milisegundo : Word;
begin
   DecodeTime(Time,Hora,Minuto,Segundo,Milisegundo);
   Result := Segundo;
end;

{*****************************************************************************}
{ Retorna a Milisegundo }
function Milisegundo(Time:TDateTime) : Word;
Var Hora,minuto,Segundo,Milisegundo : Word;
begin
   DecodeTime(Time,Hora,Minuto,Segundo,Milisegundo);
   Result := Milisegundo;
end;

{*****************************************************************************}
{ incrementa Horas }
function IncHoras(Hora: TDateTime; Horas, Minutos, Segundos,
  MilSegundos: Integer): TDateTime;
begin
  Result := Hora + (Horas div 24) + (((Horas mod 24) * 3600000 +
    Minutos * 60000 + Segundos * 1000 + MilSegundos) / MSecsPerDay); //MSecsPerDay constanta da unidade SysUtils, milisegundos por dia
end;

{*****************************************************************************}
{ incrementa Hora }
function IncHora(Hora: TDateTime; Horas: Integer): TDateTime;
begin
  Result := IncHoras(Hora, Horas, 0, 0, 0);
end;

{*****************************************************************************}
{ incrementa Minuto }
function IncMinuto(Hora: TDateTime; Minutos: Integer): TDateTime;
begin
  Result := IncHoras(Hora, 0, Minutos, 0, 0);
end;

{*****************************************************************************}
{ incrementa Segundo }
function IncSegundo(Hora: TDateTime; Segundos: Integer): TDateTime;
begin
  Result := IncHoras(Hora, 0, 0, Segundos, 0);
end;

{*****************************************************************************}
{ incrementa MilSegundo }
function IncMilSegundo(Hora: TDateTime; MilSegundos: Integer): TDateTime;
begin
  Result := IncHoras(Hora, 0, 0, 0, MilSegundos);
end;

{ ********* Retorna a diferença entre duas horas *************************** }
function DiferencaHora(Inicio,Fim : TDateTime):String;
begin
If (Inicio > Fim) then
    begin
    Result := TimeToStr((StrTotime('23:59:59')-Inicio)+Fim);
    end
else
   begin
   Result := TimeToStr(Fim-inicio);
   end;
end;


{ ************* recebe um texto e retorna uma hora ************************ }
// exemplo de paramentros 064555 retorna 06:45:55
function MontaHoraTexto( texto : string ) : string;
begin
result := '';
if length(texto) >= 2 then
  Result := copy(texto,1,2);

if length(texto) >= 4 then
  Result :=  Result + ':' + copy(texto,3,2);

if length(texto) >= 6 then
   Result := Result + ':' + copy(texto,5,2);
end;

{****************** reotorna a diferenca entre as datas ***********************}
function DiferencaMinutos(VpaInicio,VpaFim : TDateTime) : Integer;
begin
  If (VpaInicio > VpaFim) then
    result :=(Minuto((StrTotime('23:59:59')-VpaInicio) + VpaFim)+ Hora((StrTotime('23:59:59')-VpaInicio)+VpaFim)*60)+1
  else
    Result := Minuto(VpaFim-Vpainicio)+ (Hora(VpaFim-Vpainicio)*60) ;
end;


function DataToStrFormato(Formato : FormatoData; data : TDateTime; charSeparador : char) : string;
var
  d,m,aa, a : string;
begin
    d := InttoStr(dia(data));
    m := InttoStr(mes(data));
    aa :=InttoStr(ano(data));
    a := copy(aa,length(aa)-1,2);

    if StrtoInt(d) < 10 then
      d := '0' + d;

    if StrtoInt(m) < 10 then
      m := '0' + m;
if CharSeparador <> #0 then
  case formato of
      MMDDAA : begin result := m + charSeparador + d + charSeparador + a  end;
      AAMMDD : begin result := a + charSeparador + m + charSeparador + d end;
      AADDMM : begin result := a + charSeparador + d + charSeparador + m end;
      DDMMAA : begin result := d + charSeparador + m + charSeparador + a end;
      MMDDAAAA : begin result := m + charSeparador + d + charSeparador + aa  end;
      AAAAMMDD : begin result := aa + charSeparador + m + charSeparador + d end;
      AAAADDMM : begin result := aa + charSeparador + d + charSeparador + m end;
      DDMMAAAA : begin result := d + charSeparador + m + charSeparador + aa end;
  end
else
   case formato of
      MMDDAA : begin result := m + d +  a  end;
      AAMMDD : begin result := a +  m +  d end;
      AADDMM : begin result := a +  d +  m end;
      DDMMAA : begin result := d +  m +  a end;
      MMDDAAAA : begin result := m +  d +  aa  end;
      AAAAMMDD : begin result := aa +  m +  d end;
      AAAADDMM : begin result := aa +  d +  m end;
      DDMMAAAA : begin result := d +  m +  aa end;
   end

end;




end.
