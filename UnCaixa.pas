unit UnCaixa;

interface

uses
    Db, DBTables, Classes, SysUtils, PainelGradiente, FunSql, Registry;

type
  TCalculoCaixa = class
  private
    Aux,
    Aux1,
    Tabela : TQuery;
    BaseDados : TDatabase;
  public
    constructor Criar( AOwner : TComponent; ADataBase : TDataBase ); virtual;
    destructor Destroy; override;
    function SomaFechamentoParcial(Geral, Parcial: Integer): Double;
    function SomaFechamentoDiario(Geral: Integer): Double;
    function SomaFechamentoporOperacao( NroCaixa, operacao: string): Double;
    function SaldoUltimoCaixa(NroCaixa: string; Var  ValorCheque, ValorDinheiro, ValorOutros : Double): Double; //
    procedure BuscaUltimoFechamentoDiario(Geral: Integer; var VpaDinheiro, VpaCheque, VpaOutros: Double);
    procedure SomaCreditoParcial(Geral, Parcial: Integer;  var VpaDinheiro, VpaCheque, VpaOutros, VpaTroco : Double);
    procedure SomaDebitoParcial(Geral, Parcial: Integer;  var VpaDinheiro, VpaCheque, VpaOutros, VpaTroco : Double);
    procedure CarregaParcialAnterior( SeqDiario : Integer;  var VpaDinheiro, VpaCheque, VpaOutros: Double);
    procedure ValoresAberturaAtual( SeqDiario : Integer; var VpaDinheiro, VpaCheque, VpaOutros: Double);
end;

type
  TLocalizaCaixa = class(TCalculoCaixa)
    procedure LocalizaMovDiario( tabela : TQuery );
    procedure LocalizaMovParcial( Tabela : TQuery );
    procedure LocalizaMovDiarioSeq( tabela : TQuery; SeqDiario : Integer );
    procedure LocalizaMovParcialSeq( Tabela : TQuery; SeqDiario, SeqParcial : Integer );
    procedure LocalizaCadCaixa( tabela : TQuery; NroCaixa : Integer );

    procedure LocalizaItens(Tabela : TQuery);
    procedure LocalizaItemCaixaCR(Tabela : TQuery; SeqParcial, seqDiario, LancamentoCR : Integer );
    procedure LocalizaFormaPagamento(Tabela : TQuery; CodFormaPagto : integer );
end;

type
  TFuncoesCaixa = class(TLocalizaCaixa)
  private
  public
    { ***** abertura e fechamento ***** }
    function ExisteCaixaGeralAberto(NroCaixa: Integer): Boolean;
    function ExisteParcialAberto(NroCaixa : Integer): Boolean;
    function DataUltimaAbertura( NroCaixa : Integer ) : TDateTime;
    function VerificaAbreCaixa( nroCaixa : Integer ) : Boolean;
    function VerificaAbreParcial( nroCaixa : Integer ) : Boolean;
    function VerificaFechaCaixa( nroCaixa : Integer ) : Boolean;
    function VerificaFechaParcial( nroCaixa : Integer ) : Boolean;
    function UsuarioParcial( SeqParcial, SeqDiario : Integer): Integer;
    function ProximoSequencialCaixaGeral: Integer;
    function ProximoSequencialCaixaParcial( SeqDiario : Integer): Integer;
    function ProximoSequencialItemFechamento(GeralAberto, ParcialAberto: Integer): Integer;
    procedure AbreCaixaGeral(NroCaixa, VpaUsuarioAbertura: Integer;
                            VpaValorDinheiroAbertura, VpaValorChequeAbertura,
                            VpaValorOutrosAbertura, VpaSaldoAnterior: Double);  //
    function AbreCaixaParcial(NroCaixa, SeqDiario, VpaUsuarioAbertura: Integer;
                              VpaValorDinheiroAbertura, VpaValorChequeAbertura,
                              VpaValorOutrosAbertura, VpaSaldoAnterior : Double ): integer;

    procedure FechaCaixa(NroCaixa, SeqDiario, VpaUsuarioFechamento: Integer;
                        VpaValorDinheiro, VpaValorCheque, VpaValorOutros: Double);
    procedure GuardaValoresFechamento( NroCaixa, SeqDiario, SeqParcial : Integer;
                                       VpaValorDinheiro, VpaValorCheque, VpaValorOutros: Double);
    function FechaCaixaParcial( NroCaixa, SeqDiario, SeqParcial : Integer;
                                VpaValorDinheiro, VpaValorCheque, VpaValorOutros: Double;
                                VpaProblema: Boolean) : Boolean;
    { ***** reabertura de caixa ***** }
    procedure ReabreUltimoCaixaGeral(VpaCaixaAbertura, VpaCodigoAlteracao, VpaUsuarioAlteracao: Integer);
    procedure ReabreUltimoCaixaParcial( VpaNroCaixa, VpaCodigoAlteracao, VpaUsuarioAlteracao: Integer);
    function VerificaAbreUltimoCaixa( NroCaixa : Integer ) :  string;

    { retorno sequencial }
    function SequencialGeralAberto(NroCaixa: Integer): Integer;
    function SequencialParcialAberto(NroCaixa: Integer): Integer;
    function CaixaAtivo( NroCAixa : Integer ) : Boolean;
    function InverteCreDeb( tipo : string ) : string;
    function CaixaUsaEcf( NroCAixa : Integer ) : Boolean;
    function ProximoSequencialAlteracao: Integer;
    function ProximoSequencialItemCaixa(GeralAberto, ParcialAberto: Integer): Integer;

    { ***** alteração de caixa ***** }
    function GeraAlteracao(Geral,  Parcial, VpaCodAlteracao,
                           VpaCodUsuarioAlterou, VpaNumeroItem: Integer; VpaDiarioParcial: string): Boolean;
    { ***** Busca informacoes ****** }
    function BuscaUsuarioCaixa(Geral, Parcial: Integer): string;
    function BuscaNumeroCaixa(Geral: string): Integer;
    function BuscaClientePagar(NroOrdem: Integer): Integer;
    function BuscaClienteReceber(NroOrdem: Integer): Integer;
    { ***** lanca item caixa ***** }
    function LancaItemCaixa( VpaCreditoDebito, VpaNroNota: string; Vpadataemissao: tdatetime;  VpaOperacao, VpaFormaPagamento,
                             NroOrdem,  NroParcela,VpaSeqGeral,
                             VpaSeqParcial: Integer; VpaValor, VpaTroco, VpaPagoRecebido: Double; VpaBancario: Integer; VpaFlaPodeEstornar : string ): Boolean;
    { ***** estorna caixa ***** }
    function EstornaCaixaCP(VpaFormaPagamento, CodCli : Integer; VpaValor : Double): Boolean;
    function EstornaCaixaCR(VpaFormaPagamento, CodCli : Integer; VpaValor : Double): Boolean;

    //item
    procedure DisvinculaUmItemCR(LancamentoCR, NroParcela : Integer );
    procedure DisvinculaUmItemCP(LancamentoCP, NroParcela : Integer );
    // todos
    procedure DisvinculaTodosItemCR(LancamentoCR, CodFilial : Integer );
    procedure DisvinculaTodosItemCP(LancamentoCP, CodFilial : Integer );

    procedure EstornaItemBanco(lancamentoCR : Integer );
    function VerificaPodeEstornarBanco( lancamento, CodFilial : Integer ) : Boolean;

    procedure RecalculaFechamento(SeqDiario, Seqparcial : Integer; ValorFechamento, valorIdeal : Double );
    procedure MudaEstadoParcial( estado : string;  SeqDiario, Seqparcial : Integer );
    procedure ReFechaCaixa( SeqDiario, Seqparcial : Integer; VpaValorDinheiro, VpaValorCheque, VpaValorOutros : Double );
    function VerificaSaldodeCaixa( valor : double; CodCaixaDiario, CodCaixaPArcial : Integer ) : boolean;
    procedure GuardaSaldoAtual(SeqCaixaDiario : Integer);

end;

implementation

uses ConstMsg, Constantes, Funstring, Fundata, funnumeros, unfluxo;


{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                           calcula Caixa
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{ ****************** Na criação da classe ******************************** }
constructor TCalculoCaixa.Criar( AOwner : TComponent; ADataBase : TDataBase );
begin
  inherited;
  baseDados := ADataBase;
  Aux := TQuery.Create(AOwner);
  Aux.DatabaseName := ADataBase.DatabaseName;
  Aux1 := TQuery.Create(AOwner);
  Aux1.DatabaseName := ADataBase.DatabaseName;
  Tabela := TQuery.Create(AOwner);
  Tabela.DatabaseName := ADataBase.DatabaseName;
end;

{ ******************* Quando destroy a classe ****************************** }
destructor TCalculoCaixa.Destroy;
begin
  FechaTabela(Aux);
  Aux.Destroy;
  FechaTabela(Aux1);
  Aux1.Destroy;
  FechaTabela(Tabela);
  Tabela.Destroy;
  inherited;
end;

{******************** retorna o saldo do último caixa geral fechado ***********}
function TCalculoCaixa.SaldoUltimoCaixa( NroCaixa: string; Var  ValorCheque, ValorDinheiro, ValorOutros : Double ): Double;
begin
  AdicionaSQLAbreTabela(AUX , ' Select VAL_DINHEIRO_FECHAMENTO, VAL_CHEQUE_FECHAMENTO, VAL_OUTROS_FECHAMENTO,VAL_TOTAL_FECHAMENTO from MOV_DIARIO ' +
                              ' where NUM_CAIXA = ' + NroCaixa +
                              ' ORDER BY SEQ_DIARIO'); // Fechado.
  AUX.Last;

  Result := AUX.FieldByName('VAL_TOTAL_FECHAMENTO').AsFloat;
  ValorCheque := AUX.FieldByName('VAL_CHEQUE_FECHAMENTO').AsFloat;
  ValorDinheiro := AUX.FieldByName('VAL_DINHEIRO_FECHAMENTO').AsFloat;
  ValorOutros := AUX.FieldByName('VAL_OUTROS_FECHAMENTO').AsFloat;

  aux.close;
end;

{******************** retorna o saldo fechamento de caixa ********* ***********}
function TCalculoCaixa.SomaFechamentoporOperacao( NroCaixa, operacao: string ): Double;
begin
  AdicionaSQLAbreTabela(AUX , ' select sum(val_movimento) as valor, ope.des_operacao '+
                              ' from ite_caixa  cad, cad_tipo_opera ope '+
                              ' where num_caixa = ' + nrocaixa +
                              ' and cod_operacao = ' + operacao +
                              ' and cad.cod_operacao = ope.cod_operacao '+
                              ' group by cad.cod_operacao. ope.des_operacao ');

  Result := AUX.FieldByName('valor').AsFloat;
  aux.close;
end;

{ ***** retorna a soma (soma do lucro: fechamento - abertura) de todos os fechamentos parciais de um geral aberto ***** }
procedure TCalculoCaixa.BuscaUltimoFechamentoDiario(Geral: Integer;
  var VpaDinheiro, VpaCheque, VpaOutros: Double);
begin
  // OBS: o valor de abertura do caixa geral ja está embutido no primeiro caixa parcial que é aberto automaticamente.
  AdicionaSQLAbreTabela(Aux , ' SELECT VAL_DINHEIRO_FECHAMENTO, VAL_CHEQUE_FECHAMENTO, VAL_OUTROS_FECHAMENTO FROM CRP_PARCIAL ' +
                              ' WHERE SEQ_DIARIO = ' + IntToStr(Geral) +
                              ' ORDER BY SEQ_PARCIAL ');
  Aux.Last;
  VpaDinheiro := Aux.FieldByName('VAL_DINHEIRO_FECHAMENTO').AsFloat;
  VpaCheque   := Aux.FieldByName('VAL_CHEQUE_FECHAMENTO').AsFloat;
  VpaOutros   := Aux.FieldByName('VAL_OUTROS_FECHAMENTO').AsFloat;
  Aux.close;
end;

{ ***** retorna a soma (soma do lucro) doS fechamentos abertos parciais de um geral ***** }
function TCalculoCaixa.SomaFechamentoParcial(Geral, Parcial: Integer): Double;
begin
  // Retorna o valor de abertura;
  AdicionaSQLAbreTabela(Aux1 , ' Select VAL_ABERTURA_PARCIAL from CRP_PARCIAL ' +
                               ' where  ' +
                               ' SEQ_DIARIO = ' + IntToStr(Geral) +
                               ' and SEQ_PARCIAL = ' + IntToStr(Parcial));
  Result := Aux1.FieldByName('VAL_ABERTURA_PARCIAL').AsFloat;
  // Acumula os CREDITOS;
  AdicionaSQLAbreTabela(Aux1 , ' Select SUM(VAL_MOVIMENTO) AS CREDITOS from ITE_CAIXA' +
                               ' where SEQ_DIARIO = ' + IntToStr(Geral) +
                               ' and SEQ_PARCIAL = ' + IntToStr(Parcial) +
                               ' and CREDITO_DEBITO = ''C''' +
                               ' and isnull(FLA_ESTORNADO, ''N'') = ''N'''); // MOVIMENTO NÃO ESTÁ ESTORNADO.
  Result:=Result + Aux1.FieldByName('CREDITOS').AsFloat;
  // Acumula os DEBITOS;
  AdicionaSQLAbreTabela(Aux1 , ' Select SUM(VAL_MOVIMENTO) AS DEBITOS from ITE_CAIXA' +
                               ' where SEQ_DIARIO = ' + IntToStr(Geral) +
                               ' and SEQ_PARCIAL = ' + IntToStr(Parcial) +
                               ' and CREDITO_DEBITO = ''D''' +
                               ' and isnull(FLA_ESTORNADO, ''N'') = ''N''');  // MOVIMENTO NÃO ESTÁ ESTORNADO.
  // CREDITOS - DÉBITOS;
  Result:=(Result - Aux1.FieldByName('DEBITOS').AsFloat);
  aux1.close;
end;

{ ***** retorna a soma (soma do lucro) dos fechamentos um geral ***** }
function TCalculoCaixa.SomaFechamentoDiario(Geral: Integer): Double;
begin
  // Retorna o valor de abertura;
  AdicionaSQLAbreTabela(Aux1 , ' Select VAL_TOTAL_ABERTURA from MOV_DIARIO ' +
                               ' where SEQ_DIARIO = ' + IntToStr(Geral));
  Result:=Aux1.FieldByName('VAL_TOTAL_ABERTURA').AsFloat;
  // Acumula os CREDITOS;
  AdicionaSQLAbreTabela(Aux1 , ' Select ISNULL((SUM(VAL_MOVIMENTO)),0) AS CREDITOS from ITE_CAIXA' +
                               ' where SEQ_DIARIO = ' + IntToStr(Geral) +
                               ' and CREDITO_DEBITO = ''C''' +
                               ' and isnull(FLA_ESTORNADO, ''N'') = ''N''' ); // MOVIMENTO NÃO ESTÁ ESTORNADO.
  Result:=Result + Aux1.FieldByName('CREDITOS').AsFloat;
  // Acumula os DEBITOS;
  AdicionaSQLAbreTabela(Aux1 , ' Select ISNULL(SUM(VAL_MOVIMENTO),0) AS DEBITOS from ITE_CAIXA' +
                               ' where SEQ_DIARIO = ' + IntToStr(Geral) +
                               ' and CREDITO_DEBITO = ''D''' +
                               ' and isnull(FLA_ESTORNADO, ''N'') = ''N''');  // MOVIMENTO NÃO ESTÁ ESTORNADO.
  // CREDITOS - DÉBITOS;
  Result:=(Result - Aux1.FieldByName('DEBITOS').AsFloat);
  Aux1.close;
end;

{ ***** retorna a soma Creditos ********************************************* }
procedure TCalculoCaixa.SomaCreditoParcial(Geral, Parcial: Integer;  var VpaDinheiro, VpaCheque, VpaOutros, VpaTroco : Double);
begin
  // Acumula os CREDITOS;
  AdicionaSQLAbreTabela(Aux1 , ' Select SUM(VAL_PAGO_RECEBIDO) AS CREDITOS, C_FLA_TIP, SUM(VAL_TROCO) troco ' +
                               ' from ITE_CAIXA ITE, CadFormasPagamento frm ' +
                               ' where SEQ_DIARIO = ' + IntToStr(Geral) +
                               ' and SEQ_PARCIAL = ' + IntToStr(Parcial) +
                               ' and CREDITO_DEBITO = ''C''' +
                               ' and isnull(FLA_ESTORNADO, ''N'') = ''N''' +
                               ' and ITE.COD_FRM = FRM.i_COD_FRM ' +
                               ' group by C_FLA_TIP '); // MOVIMENTO NÃO ESTÁ ESTORNADO.
  VpaDinheiro := 0;
  VpaCheque := 0;
  VpaOutros := 0;
  Vpatroco :=0;
  while not aux1.eof do
  begin
    if Aux1.FieldByName('C_FLA_TIP').AsString = 'C' then
      VpaCheque := VpaCheque + Aux1.FieldByName( 'CREDITOS').AsFloat
    else
      if Aux1.FieldByName('C_FLA_TIP').AsString = 'D' then
        VpaDinheiro := VpaDinheiro + VpaDinheiro + Aux1.FieldByName('CREDITOS').AsFloat
      else
         VpaOutros := VpaOutros + Aux1.FieldByName('CREDITOS').AsFloat;
    Vpatroco := Vpatroco + Aux1.FieldByName('Troco').AsFloat;  // soma troco de todos os tipos de formas
    aux1.next;
  end;
  aux1.close;
end;

{ ***** retorna a soma Creditos ********************************************* }
procedure TCalculoCaixa.SomaDebitoParcial(Geral, Parcial: Integer;  var VpaDinheiro, VpaCheque, VpaOutros, VpaTroco : Double);
begin
  // Acumula os CREDITOS;
  AdicionaSQLAbreTabela(Aux1 , ' Select SUM(VAL_PAGO_RECEBIDO) AS DEBITO, C_FLA_TIP, SUM(VAL_TROCO) troco ' +
                               ' from ITE_CAIXA ITE, CadFormasPagamento frm ' +
                               ' where SEQ_DIARIO = ' + IntToStr(Geral) +
                               ' and SEQ_PARCIAL = ' + IntToStr(Parcial) +
                               ' and CREDITO_DEBITO = ''D''' +
                               ' and isnull(FLA_ESTORNADO, ''N'') = ''N''' +
                               ' and ITE.COD_FRM = FRM.i_COD_FRM ' +
                               ' group by C_FLA_TIP '); // MOVIMENTO NÃO ESTÁ ESTORNADO.

  VpaDinheiro := 0;
  VpaCheque := 0;
  VpaOutros := 0;
  Vpatroco :=0;
  while not aux1.eof do
  begin
    if Aux1.FieldByName('C_FLA_TIP').AsString = 'C' then
      VpaCheque := VpaCheque + Aux1.FieldByName('DEBITO').AsFloat
    else
      if Aux1.FieldByName('C_FLA_TIP').AsString = 'D' then
        VpaDinheiro := VpaDinheiro + Aux1.FieldByName('DEBITO').AsFloat
      else
         VpaOutros := VpaOutros + Aux1.FieldByName('DEBITO').AsFloat;
    Vpatroco := Vpatroco + Aux1.FieldByName('Troco').AsFloat;  // soma troco de todos os tipos de formas
    aux1.next;
  end;
  aux1.close;
end;

{***************** carrega dados da parcial anterior ************************ }
procedure TCalculoCaixa.CarregaParcialAnterior( SeqDiario : Integer;
                                                var VpaDinheiro, VpaCheque, VpaOutros: Double);
begin
  AdicionaSQLAbreTabela(Aux , ' Select CRP.VAL_DINHEIRO_FECHAMENTO, CRP.VAL_CHEQUE_FECHAMENTO, CRP.VAL_OUTROS_FECHAMENTO ' +
                              ' from MOV_DIARIO MOV, CRP_PARCIAL CRP ' +
                              ' where MOV.SEQ_DIARIO = ' + IntToStr(SeqDiario) +
                              ' and MOV.EMP_FIL = CRP.EMP_FIL ' +
                              ' and MOV.SEQ_DIARIO = CRP.SEQ_DIARIO ' +
                              ' ORDER BY CRP.SEQ_PARCIAL');
  if (not Aux.EOF) then
  begin
    Aux.Last;
    VpaDinheiro:=Aux.FieldByName('VAL_DINHEIRO_FECHAMENTO').AsFloat;
    VpaCheque:=Aux.FieldByName('VAL_CHEQUE_FECHAMENTO').AsFloat;
    VpaOutros:=Aux.FieldByName('VAL_OUTROS_FECHAMENTO').AsFloat;
  end;
  Aux.close;
end;

{***************** carrega dados da parcial anterior ************************ }
procedure TCalculoCaixa.ValoresAberturaAtual( SeqDiario : Integer;
                                                var VpaDinheiro, VpaCheque, VpaOutros: Double);
begin
  AdicionaSQLAbreTabela(Aux , ' Select CRP.VAL_DINHEIRO_ABERTURA, CRP.VAL_CHEQUE_ABERTURA, CRP.VAL_OUTROS_ABERTURA ' +
                              ' from MOV_DIARIO MOV, CRP_PARCIAL CRP ' +
                              ' where MOV.SEQ_DIARIO = ' + IntToStr(SeqDiario) +
                              ' and MOV.EMP_FIL = CRP.EMP_FIL ' +
                              ' and MOV.SEQ_DIARIO = CRP.SEQ_DIARIO ' +
                              ' ORDER BY CRP.SEQ_PARCIAL');
  if (not Aux.EOF) then
  begin
    Aux.Last;
    VpaDinheiro:=Aux.FieldByName('VAL_DINHEIRO_ABERTURA').AsFloat;
    VpaCheque:=Aux.FieldByName('VAL_CHEQUE_ABERTURA').AsFloat;
    VpaOutros:=Aux.FieldByName('VAL_OUTROS_ABERTURA').AsFloat;
  end;
  Aux.close;
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                           Localiza Caixa
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}



{************** localiza o mov diario *************************************** }
procedure TLocalizaCaixa.LocalizaMovDiario( tabela : TQuery );
begin
  AdicionaSQLAbreTabela(Tabela, ' SELECT * FROM MOV_DIARIO');
end;

{************** localiza o mov parcial *************************************** }
procedure TLocalizaCaixa.LocalizaMovParcial( tabela : TQuery );
begin
  AdicionaSQLAbreTabela(Tabela, ' SELECT * FROM CRP_PARCIAL');
end;

{************ localiza um determinadao movimento diario ********************** }
procedure TLocalizaCaixa.LocalizaMovDiarioSeq( tabela : TQuery; SeqDiario : Integer );
begin
  AdicionaSQLAbreTabela(Tabela, ' SELECT * FROM MOV_DIARIO '  +
                                ' where SEQ_DIARIO = ' + IntToStr(SeqDiario) );
end;

{************ localiza um determinadao movimento parcial ********************** }
procedure TLocalizaCaixa.LocalizaMovParcialSeq( Tabela : TQuery; SeqDiario, SeqParcial : Integer );
begin
  AdicionaSQLAbreTabela(Tabela, ' SELECT * FROM CRP_PARCIAL ' +
                                ' where  SEQ_DIARIO = ' + IntToStr(SeqDiario) +
                                ' and SEQ_PARCIAL = ' + IntToStr(SeqParcial) );
end;

{****************** localiza um caixa *************************************** }
procedure TLocalizaCaixa.LocalizaCadCaixa( tabela : TQuery; NroCaixa : Integer );
begin
  AdicionaSQLAbreTabela(tabela , ' Select * from cad_caixa ' +
                                 ' where NUM_CAIXA = ' + IntToStr(NroCaixa));
end;




procedure TLocalizaCaixa.LocalizaItens(Tabela : TQuery);
begin
  AdicionaSQLAbreTabela(Tabela, ' select * from ITE_CAIXA ');
end;

procedure TLocalizaCaixa.LocalizaItemCaixaCR(Tabela : TQuery; SeqParcial, seqDiario, LancamentoCR : Integer );
begin
  AdicionaSQLAbreTabela(Tabela, ' select * from ITE_CAIXA ' +
                                ' where seq_diario = ' + IntTostr(seqDiario) +
                                ' and seq_parcial = ' + IntToStr(SeqParcial) +
                                ' and lan_receber = ' + inttostr(LancamentoCR) );
end;


procedure TLocalizaCaixa.LocalizaFormaPagamento(Tabela : TQuery; CodFormaPagto : integer );
begin
  AdicionaSQLAbreTabela( Tabela, ' select *  from CadFormasPagamento ' +
                                 ' where i_cod_frm =  ' + InttoStr(CodFormaPagto) );
end;



{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                           Funcoes Caixa
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{########################## verificação ###################################### }

{************** verifica se existe caixa geral aberto ********************** }
function TFuncoesCaixa.ExisteCaixaGeralAberto(NroCaixa: Integer): Boolean;
begin
  AdicionaSQLAbreTabela(Aux , ' Select FLA_CAIXA_ABERTO from cad_caixa ' +
                              ' where NUM_CAIXA = ' + IntToStr(NroCaixa) +
                              ' and isnull(FLA_CAIXA_ABERTO,''N'') = ''N'''); // Aberto.
  Result:= Aux.EOF;
  aux.close;
end;

{***** Verifica se existe caixa parcial aberto *****}
function TFuncoesCaixa.ExisteParcialAberto(NroCaixa : Integer): Boolean;
begin
  AdicionaSQLAbreTabela(Aux , ' Select NUM_CAIXA from CAD_CAIXA ' +
                              ' where NUM_CAIXA = ' + IntToStr(NroCaixa) +
                              ' and isnull(FLA_PARCIAL_ABERTO,''N'') = ''N'''); // Aberto.
  Result:= Aux.EOF;
  aux.close;
end;

{******************** existe caixa aberto neste dia ************************** }
function TFuncoesCaixa.DataUltimaAbertura(NroCaixa : Integer ) : TDateTime;
begin
  AdicionaSQLAbreTabela(Aux , ' Select DAT_ABERTURA from cad_caixa ' +
                              ' where NUM_CAIXA = ' + IntToStr(NroCaixa) );

  Result := Aux.FieldByName('DAT_ABERTURA').AsDateTime;
  aux.close;
end;


{##################### abertura de caixas #################################### }

{************** verifica se pode abrir o caixa ******************************* }
function TFuncoesCaixa.VerificaAbreCaixa( nroCaixa : Integer ) : boolean;
var
  ultimaData : TDateTime;
begin
  result := true;
  // verifica caixa aberto
  if ExisteCaixaGeralAberto(nroCaixa) then
  begin
    result := false;
    aviso(CT_CaixaJaAberto);
  end;

  ultimaData := DataUltimaAbertura(nroCaixa);

  if ultimaData > date then
  begin
    result := false;
    aviso(CT_CaixaDataInvalida);
  end;

  // verifica se o caixa ja foi aberto
  if (result) and (not Config.VariosCaixasDia) then
    if ultimaData = date then
    begin
      result := false;
      aviso(CT_CaixaGeralJaCriado);
    end;
end;

{*************** verifica se pode abrir parcial ***************************** }
function TFuncoesCaixa.VerificaAbreParcial( nroCaixa : Integer ) : Boolean;
var
  ultimaData : TDateTime;
begin
  result := true;
  // verifica caixa aberto
  if not ExisteCaixaGeralAberto(nroCaixa) then
  begin
    result := false;
    aviso(CT_SemCaixaGeral);
  end;

  // erifica se o parcial ja foi aberto
    if ExisteParcialAberto(nroCaixa) then
    begin
      result := false;
      aviso(CT_PArcialJaAberto);
    end;

  if not Config.ParcialCaixaDataAnterior then
  begin
    ultimaData := DataUltimaAbertura(nroCaixa);
    if ultimaData < date then
    begin
      result := false;
      aviso(CT_CaixaParcialDataInvalida);
    end;
 end;
end;

{******************* verifica a possibilidade de fechar o caixa geral ******** }
function TFuncoesCaixa.VerificaFechaCaixa( nroCaixa : Integer ) : Boolean;
begin
  result := true;
  if SequencialParcialAberto(nroCaixa) <> 0 then
  begin
    aviso(CT_ParcialAberto);
    result := false;
 end;

  if result then
    if SequencialGeralAberto(nroCaixa) = 0 then
    begin
      aviso(CT_CaixaJaFechado);
      result := false;
    end
end;

{******************* verifica a possibilidade de fechar o caixa parcial ******** }
function TFuncoesCaixa.VerificaFechaParcial( nroCaixa : Integer ) : Boolean;
begin
  result := true;
  if SequencialParcialAberto(nroCaixa) = 0 then
  begin
    aviso(CT_CaixaJaFechado);
    result := false;
 end;
end;


function TFuncoesCaixa.UsuarioParcial( SeqParcial, SeqDiario : Integer): Integer;
begin
  AdicionaSQLAbreTabela(Aux , ' Select COD_USUARIO from CRP_PARCIAL ' +
                              ' where  SEQ_PARCIAL =  ' + IntToStr(SeqParcial) +
                              ' and SEQ_DIARIO = ' + IntToStr(SeqDiario) );
  Result:=Aux.FieldByName('COD_USUARIO').AsInteger; // retorna o usuario que abriu o parcial.
  aux.close;
end;



{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                     abertura e fechamento
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{***** retorna o próximo codigo sequencial do movimento de caixa geral ***** }
function TFuncoesCaixa.ProximoSequencialCaixaGeral : Integer;
begin
  result := ProximoCodigoFilial( 'MOV_DIARIO','SEQ_DIARIO','I_EMP_FIL',varia.CodigoFilCadastro, BaseDados);
 // AdicionaSQLAbreTabela(Aux1, ' SELECT MAX(SEQ_DIARIO) SEQ_DIARIO FROM MOV_DIARIO');
//  Result := Aux1.FieldByName('SEQ_DIARIO').AsInteger + 1;
//  aux1.close;
end;

{***** retorna o próximo codigo sequencial do movimento parcial de caixa  **** }
function TFuncoesCaixa.ProximoSequencialCaixaParcial( SeqDiario : Integer): Integer;
begin
  AdicionaSQLAbreTabela(Aux1, ' SELECT MAX(SEQ_PARCIAL) SEQ_PARCIAL FROM CRP_PARCIAL' +
                              ' where SEQ_DIARIO = ' + IntToStr(seqdiario) );
  Result:=Aux1.FieldByName('SEQ_PARCIAL').AsInteger + 1;
  aux1.close;
end;

{************ proximo do codigo do item de fechamento *********************** }
function TFuncoesCaixa.ProximoSequencialItemFechamento(GeralAberto, ParcialAberto: Integer): Integer;
begin
  AdicionaSQLAbreTabela(Aux1, ' SELECT MAX(SEQ_FECHAMENTO)SEQ_FECHAMENTO FROM ITE_FECHAMENTO' +
                              ' where SEQ_DIARIO = ' + IntToStr(GeralAberto) +
                              ' and SEQ_PARCIAL = ' + IntToStr(ParcialAberto) );
  Result:=Aux1.FieldByName('SEQ_FECHAMENTO').AsInteger + 1;
  aux1.close;
end;

{ ***** Inicializa o caixa geral e Gera uma Abertura de Caixa Parcial. ***** }
procedure TFuncoesCaixa.AbreCaixaGeral(NroCaixa, VpaUsuarioAbertura: Integer;
                                      VpaValorDinheiroAbertura, VpaValorChequeAbertura,
                                      VpaValorOutrosAbertura, VpaSaldoAnterior: Double );
var
  VpfSequencialDiario : Integer;
  VpfGerarSaldoBanco : Boolean;
begin
   // ABRE GERAL;
  Tabela.RequestLive := True;
  LocalizaMovDiario(tabela);
  VpfSequencialDiario := ProximoSequencialCaixaGeral; //RETORNAR O PRÓXIMO GERAL;
  // Gera Registro de Caixa Geral Aberto.
  Tabela.Insert;
  Tabela.FieldByName('EMP_FIL').AsInteger := Varia.CodigoFilCadastro;
  Tabela.FieldByName('SEQ_DIARIO').AsInteger := VpfSequencialDiario;
  Tabela.FieldByName('NUM_CAIXA').AsInteger := NroCaixa; // CAIXA GERAL DESTE NÚMERO DE CAIXA;
  Tabela.FieldByName('COD_USUARIO_ABERTURA').AsInteger := VpaUsuarioAbertura;
  Tabela.FieldByName('DAT_ABERTURA').AsDateTime := Date;
  Tabela.FieldByName('HOR_ABERTURA').AsDateTime := Time;
  Tabela.FieldByName('VAL_TOTAL_ABERTURA').AsFloat := VpaValorDinheiroAbertura + VpaValorChequeAbertura + VpaValorOutrosAbertura;
  Tabela.FieldByName('VAL_SALDO_ANTERIOR').AsFloat := VpaSaldoAnterior;
  Tabela.FieldByName('VAL_DINHEIRO_ABERTURA').AsFloat := VpaValorDinheiroAbertura;
  Tabela.FieldByName('VAL_CHEQUE_ABERTURA').AsFloat := VpaValorChequeAbertura;
  Tabela.FieldByName('VAL_OUTROS_ABERTURA').AsFloat := VpaValorOutrosAbertura;
  //atualiza a data de alteracao para poder exportar
  Tabela.FieldByName('D_ULT_ALT').AsDateTime := Date;
  Tabela.Post;

  // flag o caixa aberto
  LocalizaCadCaixa( tabela,  NroCaixa );
  VpfGerarSaldoBanco := trim(tabela.FieldByName('c_cai_ger').AsString) = 'S';
  Tabela.Edit;
  Tabela.FieldByName('FLA_CAIXA_ABERTO').AsString := 'S';
  Tabela.FieldByName('SEQ_DIARIO').AsInteger := VpfSequencialDiario;
  Tabela.FieldByName('DAT_ABERTURA').AsDateTime := date;
  //atualiza a data de alteracao para poder exportar
  Tabela.FieldByName('D_ULT_ALT').AsDateTime := Date;
  Tabela.post;

  AbreCaixaParcial( NroCaixa, VpfSequencialDiario, VpaUsuarioAbertura, VpaValorDinheiroAbertura,
                    VpaValorChequeAbertura, VpaValorOutrosAbertura, VpaSaldoAnterior );

  Tabela.RequestLive:=False;
  tabela.Close;

  // guarda saldo banco
  if VpfGerarSaldoBanco then
    GuardaSaldoAtual(VpfSequencialDiario);
end;

{ ************** Abertura de Caixa Parcial. ******************************** }
function TFuncoesCaixa.AbreCaixaParcial(NroCaixa, SeqDiario, VpaUsuarioAbertura: Integer;
                                        VpaValorDinheiroAbertura, VpaValorChequeAbertura,
                                        VpaValorOutrosAbertura, VpaSaldoAnterior : Double ): integer;
begin
    result := ProximoSequencialCaixaParcial(SeqDiario); //RETORNAR O PRÓXIMO PARCIAL;
    // ABRE PARCIAL;
    Tabela.RequestLive:=True;
    AdicionaSQLAbreTabela(Tabela, ' SELECT * FROM CRP_PARCIAL');
    Tabela.Insert;
    Tabela.FieldByName('EMP_FIL').AsInteger := Varia.CodigoFilCadastro;
    Tabela.FieldByName('SEQ_DIARIO').AsInteger := SeqDiario; //RETORNAR O PRÓXIMO PARCIAL;
    Tabela.FieldByName('SEQ_PARCIAL').AsInteger := result;
    Tabela.FieldByName('COD_USUARIO').AsInteger := VpaUsuarioAbertura;
    Tabela.FieldByName('DAT_ABERTURA').AsDateTime := Date;
    Tabela.FieldByName('HOR_ABERTURA').AsDateTime := Time;
    Tabela.FieldByName('VAL_ABERTURA_PARCIAL').AsFloat := VpaValorDinheiroAbertura + VpaValorChequeAbertura + VpaValorOutrosAbertura;
    Tabela.FieldByName('VAL_DINHEIRO_ABERTURA').AsFloat := VpaValorDinheiroAbertura;
    Tabela.FieldByName('VAL_CHEQUE_ABERTURA').AsFloat := VpaValorChequeAbertura;
    Tabela.FieldByName('VAL_OUTROS_ABERTURA').AsFloat := VpaValorOutrosAbertura;
    Tabela.FieldByName('FLA_ESTADO').AsString := 'N'; // NÃO TEM PROBLEMA
    //atualiza a data de alteracao para poder exportar
    Tabela.FieldByName('D_ULT_ALT').AsDateTime := Date;

    Tabela.Post;

     // flag o parcial aberto
    LocalizaCadCaixa( tabela,  NroCaixa );
    Tabela.Edit;
    Tabela.FieldByName('FLA_PARCIAL_ABERTO').AsString := 'S';
    Tabela.FieldByName('SEQ_PARCIAL').AsInteger := result;
    //atualiza a data de alteracao para poder exportar
    Tabela.FieldByName('D_ULT_ALT').AsDateTime := Date;

    Tabela.post;
    Tabela.RequestLive:=False;
    Tabela.close;
end;

{****************** fecha um caixa geral ************************************ }
procedure TFuncoesCaixa.FechaCaixa(NroCaixa, SeqDiario, VpaUsuarioFechamento: Integer;
                                  VpaValorDinheiro, VpaValorCheque, VpaValorOutros: Double);
begin
  Tabela.RequestLive := True;
  LocalizaMovDiarioSeq(tabela, SeqDiario);
  Tabela.Edit;
  Tabela.FieldByName('COD_USUARIO_FECHAMENTO').AsInteger:=VpaUsuarioFechamento;
  Tabela.FieldByName('DAT_FECHAMENTO').AsDateTime:=Date;
  Tabela.FieldByName('HOR_FECHAMENTO').AsDateTime:=Time;
  Tabela.FieldByName('VAL_TOTAL_FECHAMENTO').AsFloat:=VpaValorDinheiro + VpaValorCheque + VpaValorOutros;
  Tabela.FieldByName('VAL_IDEAL_FECHAMENTO').AsFloat:=SomaFechamentoDiario(Tabela.FieldByName('SEQ_DIARIO').AsInteger);
  Tabela.FieldByName('VAL_DINHEIRO_FECHAMENTO').AsFloat:=VpaValorDinheiro;
  Tabela.FieldByName('VAL_CHEQUE_FECHAMENTO').AsFloat:=VpaValorCheque;
  Tabela.FieldByName('VAL_OUTROS_FECHAMENTO').AsFloat:=VpaValorOutros;
  //atualiza a data de alteracao para poder exportar
  Tabela.FieldByName('D_ULT_ALT').AsDateTime := Date;

  Tabela.Post;

   // flag o caixa aberto
  LocalizaCadCaixa( tabela,  NroCaixa );
  Tabela.Edit;
  Tabela.FieldByName('FLA_CAIXA_ABERTO').AsString := 'N';
  Tabela.FieldByName('SEQ_DIARIO').AsInteger := 0;
  //atualiza a data de alteracao para poder exportar
  Tabela.FieldByName('D_ULT_ALT').AsDateTime := Date;

  Tabela.post;

  Tabela.RequestLive := False;
  Tabela.close;
end;


{****************** fecha um caixa parcial *********************************** }
procedure TFuncoesCaixa.GuardaValoresFechamento( NroCaixa, SeqDiario, SeqParcial : Integer;
                                                VpaValorDinheiro, VpaValorCheque, VpaValorOutros: Double);
begin
  Tabela.RequestLive := True;
  LocalizaMovParcialSeq( tabela, SeqDiario, SeqParcial );
  Aux.RequestLive := True;
  // gurda os valores de fechamento
  AdicionaSQLAbreTabela(Aux, ' SELECT * FROM ITE_FECHAMENTO ');
  Aux.Insert;
  Aux.FieldByName('EMP_FIL').AsInteger := Varia.CodigoFilCadastro;
  Aux.FieldByName('SEQ_DIARIO').AsInteger := Tabela.FieldByName('SEQ_DIARIO').AsInteger;
  Aux.FieldByName('SEQ_PARCIAL').AsInteger := Tabela.FieldByName('SEQ_PARCIAL').AsInteger;
  Aux.FieldByName('SEQ_FECHAMENTO').AsInteger := ProximoSequencialItemFechamento(
                                                 Tabela.FieldByName('SEQ_DIARIO').AsInteger,
                                                  Tabela.FieldByName('SEQ_PARCIAL').AsInteger);
  Aux.FieldByName('DAT_FECHAMENTO').AsDateTime := Date;
  Aux.FieldByName('HOR_FECHAMENTO').AsDateTime := Time;
  Aux.FieldByName('VAL_DINHEIRO').AsFloat := VpaValorDinheiro;
  Aux.FieldByName('VAL_CHEQUE').AsFloat := VpaValorCheque;
  Aux.FieldByName('VAL_OUTROS').AsFloat := VpaValorOutros;
  Aux.FieldByName('VAL_FECHAMENTO_PARCIAL').AsFloat := (VpaValorDinheiro + VpaValorCheque + VpaValorOutros);
  //atualiza a data de alteracao para poder exportar
  Aux.FieldByname('D_ULT_ALT').AsDateTime := Date;
  Aux.Post;
  aux.close;
  Tabela.close;
  Tabela.RequestLive := false;
  Aux.RequestLive := false;
end;

{****************** fecha um caixa parcial *********************************** }
function TFuncoesCaixa.FechaCaixaParcial( NroCaixa, SeqDiario, SeqParcial : Integer;
                        VpaValorDinheiro, VpaValorCheque, VpaValorOutros: Double;
                        VpaProblema: Boolean) : Boolean;
var
  VpfValorFechamento : Double;
begin
  result := true;

  // guarda os valore do fechamento
  GuardaValoresFechamento( NroCaixa, SeqDiario, SeqParcial,
                           VpaValorDinheiro, VpaValorCheque, VpaValorOutros );

  Tabela.RequestLive := True;
  LocalizaMovParcialSeq( tabela, SeqDiario, SeqParcial );

  // CALCULAR A SOMA DOS ITENS DE CAIXA DESTE MOVIMENTO PARCIAL ABERTO.
  VpfValorFechamento := SomaFechamentoParcial(Tabela.FieldByName('SEQ_DIARIO').AsInteger,
                        Tabela.FieldByName('SEQ_PARCIAL').AsInteger);

  // Valores dentro do limite de tolerância fecha senão não fecha.
  if Abs((ArredondaDecimais(VpfValorFechamento,2) -
           ArredondaDecimais((VpaValorDinheiro + VpaValorCheque + VpaValorOutros),2))) >
           Varia.ValorTolerancia  then
  begin
    if VpaProblema then    // caso fechar com problemas
    begin
      Tabela.Edit;
      Tabela.FieldByName('FLA_ESTADO').AsString := 'S'; // FECHAMENTO COM PROBLEMAS;
    end
    else
    begin
      Aviso('Os valores de fechamento não conferem.');
      result := false;
    end;
  end;

  // Valores corretos - FECHAR O CAIXA PARCIAL;
  if result then
  begin
    if (Tabela.State <> dsEdit) then
      Tabela.Edit;
    Tabela.FieldByName('VAL_TOLERANCIA').AsFloat := Varia.ValorTolerancia;
    Tabela.FieldByName('VAL_DINHEIRO_FECHAMENTO').AsFloat := (VpaValorDinheiro);
    Tabela.FieldByName('VAL_CHEQUE_FECHAMENTO').AsFloat := (VpaValorCheque);
    Tabela.FieldByName('VAL_OUTROS_FECHAMENTO').AsFloat := (VpaValorOutros);
    Tabela.FieldByName('VAL_FECHAMENTO_PARCIAL').AsFloat := (VpaValorDinheiro + VpaValorCheque + VpaValorOutros);
    Tabela.FieldByName('VAL_IDEAL_FECHAMENTO').AsFloat := VpfValorFechamento;
    //atualiza a data de alteracao para poder exportar
    Tabela.FieldByName('D_ULT_ALT').AsDateTime := Date;

    Tabela.Post;

    // flag o parcial aberto
    LocalizaCadCaixa( tabela,  NroCaixa );
    Tabela.Edit;
    Tabela.FieldByName('FLA_PARCIAL_ABERTO').AsString := 'N';
    Tabela.FieldByName('SEQ_PARCIAL').AsInteger := 0;
    //atualiza a data de alteracao para poder exportar
    Tabela.FieldByName('D_ULT_ALT').AsDateTime := Date;

    Tabela.post;
  end;
  Tabela.RequestLive:=False;
  Aux.RequestLive:=False;
  aux.close;
  tabela.close;
end;



{ ***** efetua reabertura de caixa parcial e lanca a alteração efetuada ***** }
procedure TFuncoesCaixa.ReabreUltimoCaixaParcial( VpaNroCaixa, VpaCodigoAlteracao, VpaUsuarioAlteracao: Integer);
var
  VpfSequencialDiario, VpaUltimoFechado : Integer;
begin
  // seq_diario
  VpfSequencialDiario := SequencialGeralAberto(VpaNroCaixa);

  LimpaSQLTabela(Aux);
  AdicionaSQLAbreTabela(AUX , ' Select MAX(SEQ_PARCIAL) SEQ_PARCIAL from CRP_PARCIAL ' +
                              ' WHERE SEQ_DIARIO = ' + IntToStr(VpfSequencialDiario) );
  if (not AUX.EOF) then
  begin
    VpaUltimoFechado := AUX.FieldByName('SEQ_PARCIAL').AsInteger;
    LimpaSQLTabela(AUX);
    AUX.sql.Add(' UPDATE CRP_PARCIAL SET VAL_FECHAMENTO_PARCIAL = NULL, ' +
                ' VAL_DINHEIRO_FECHAMENTO = NULL, VAL_CHEQUE_FECHAMENTO = NULL, ' +
                ' VAL_OUTROS_FECHAMENTO = NULL, VAL_IDEAL_FECHAMENTO = NULL, FLA_ESTADO = ''N'' ' +
                ' , D_ULT_ALT = '+ SQLTextoDataAAAAMMMDD(DATE)+
                ' WHERE SEQ_DIARIO = ' + IntToStr(VpfSequencialDiario) +
                ' AND SEQ_PARCIAL = ' + IntToStr(VpaUltimoFechado));
    AUX.ExecSQL;

    // reabre o ultimo caixa
    LimpaSQLTabela(Aux);
    AUX.sql.Add(' UPDATE CAD_CAIXA ' +
                ' SET FLA_PARCIAL_ABERTO = ''S'', ' +
                ' SEQ_PARCIAL = ' + IntToStr(VpaUltimoFechado) +
                ' , D_ULT_ALT = '+ SQLTextoDataAAAAMMMDD(DATE)+
                ' WHERE NUM_CAIXA = ' + IntToStr(VpaNroCaixa) );
    AUX.ExecSQL;

    // LANÇA ALTERAÇÃO.
    GeraAlteracao( VpfSequencialDiario, VpaUltimoFechado, VpaCodigoAlteracao, VpaUsuarioAlteracao, 0, 'P' );
    Aux.close;
  end;
end;

{ ***** efetua reabertura de caixa geral e lanca a alteração efetuada ***** }
procedure TFuncoesCaixa.ReabreUltimoCaixaGeral(VpaCaixaAbertura, VpaCodigoAlteracao, VpaUsuarioAlteracao: Integer);
var
  VpaUltimoFechado: Integer;
begin
  if (VpaCaixaAbertura <> 0) then
  begin
    LimpaSQLTabela(Aux);
    AdicionaSQLAbreTabela(AUX , ' Select MAX(SEQ_DIARIO) SEQ_DIARIO from MOV_DIARIO ' +
                                ' where NUM_CAIXA = ' + IntToStr(VpaCaixaAbertura) );
    if (not AUX.EOF) then
    begin
      VpaUltimoFechado := AUX.FieldByName('SEQ_DIARIO').AsInteger;
      LimpaSQLTabela(Aux);
      LimpaSQLTabela(AUX);
      AUX.sql.Add(' UPDATE MOV_DIARIO SET VAL_TOTAL_FECHAMENTO = NULL, ' +
                  ' VAL_DINHEIRO_FECHAMENTO = NULL, VAL_CHEQUE_FECHAMENTO = NULL, ' +
                  ' VAL_OUTROS_FECHAMENTO = NULL, VAL_IDEAL_FECHAMENTO = NULL ' +
                  ' , D_ULT_ALT = '+ SQLTextoDataAAAAMMMDD(DATE)+
                  ' WHERE SEQ_DIARIO = ' + IntToStr(VpaUltimoFechado));
      AUX.ExecSQL;

      // reabre o ultimo caixa
      LimpaSQLTabela(Aux);
      AUX.sql.Add(' UPDATE CAD_CAIXA ' +
                  ' SET FLA_CAIXA_ABERTO = ''S'', ' +
                  ' SEQ_DIARIO = ' + IntToStr(VpaUltimoFechado) +
                  ' , D_ULT_ALT = '+ SQLTextoDataAAAAMMMDD(DATE)+
                  ' WHERE NUM_CAIXA = ' + IntToStr(VpaCaixaAbertura) );
      AUX.ExecSQL;

      // REATIVA.
      // LANÇA ALTERAÇÃO.
      GeraAlteracao( VpaUltimoFechado, 0, VpaCodigoAlteracao, VpaUsuarioAlteracao, 0,'C' );
    end;
    Aux.close;
  end;
end;


{************** verifica se pode reabrir o ultimo caixa ********************** }
function TFuncoesCaixa.VerificaAbreUltimoCaixa( NroCaixa : Integer ) :  string;
begin
  // T tudo aberto, P parcial fechado, C parcial e caixa fechado
  result := 'C';
  LocalizaCadCaixa(tabela, Nrocaixa);
  if (Tabela.fieldByName('FLA_CAIXA_ABERTO').AsString = 'S') and
     (Tabela.fieldByName('FLA_PARCIAL_ABERTO').AsString = 'S') then
  begin
    result := 'T';
    Aviso(CT_ParcialGeralAberto);
  end
  else
     if (Tabela.fieldByName('FLA_CAIXA_ABERTO').AsString = 'S') then
       result := 'P';
  FechaTabela(tabela);
end;


{################# retorno dos sequenciais ################################# }

{***** Sequencial do caixa geral ********************************************* }
function TFuncoesCaixa.SequencialGeralAberto( NroCaixa: Integer ): Integer;
begin
  AdicionaSQLAbreTabela(Aux , ' Select SEQ_DIARIO from cad_caixa ' +
                              ' where NUM_CAIXA = ' + IntToStr(NroCaixa) +
                              ' and FLA_CAIXA_ABERTO = ''S''');
  Result := Aux.FieldByName('SEQ_DIARIO').AsInteger;
  Aux.close;
end;

{***** Sequencial do caixa parcial ******************************************* }
function TFuncoesCaixa.SequencialParcialAberto( NroCaixa: Integer ): Integer;
begin
  AdicionaSQLAbreTabela(Aux , ' Select SEQ_PARCIAL from cad_caixa ' +
                              ' where NUM_CAIXA = ' + IntToStr(NroCaixa) +
                              ' and FLA_PARCIAL_ABERTO = ''S''');
  Result := Aux.FieldByName('SEQ_PARCIAL').AsInteger;
  Aux.close;
end;

{****************** verifica o caixa ativo ********************************* }
function TFuncoesCaixa.CaixaAtivo( NroCAixa : Integer ) : Boolean;
begin
  AdicionaSQLAbreTabela(Aux , ' Select FLA_CAIXA_ABERTO, DAT_ABERTURA from cad_caixa ' +
                              ' where NUM_CAIXA = ' + IntToStr(NroCaixa) +
                              ' and isnull(FLA_CAIXA_ABERTO,''N'') = ''S''' +
                              ' and isnull(FLA_PARCIAL_ABERTO,''N'') = ''S'''); // Aberto.
  Result:= not Aux.EOF;
  if not result then
    aviso(CT_CaixaAtivo)
  else
    if not Config.itemCaixaDataAnterior then
      if aux.FieldByName('DAT_ABERTURA').AsDateTime < date then
      begin
        result := false;
        aviso(CT_CaixaParcialDataInvalida);
      end;
  Aux.close;
end;

{******************** inverte o credito e debito *************************** }
function TFuncoesCaixa.InverteCreDeb( tipo : string ) : string;
begin
  if tipo = 'C' then
   result := 'D'
  else
   result := 'C'
end;

{ *************** verifica se o caixa utiliza ECF ************************** }
function  TFuncoesCaixa.CaixaUsaEcf( NroCAixa : Integer ) : Boolean;
begin
  AdicionaSQLAbreTabela(Aux , ' Select FLA_USA_ECF from cad_caixa ' +
                              ' where NUM_CAIXA = ' + IntToStr(NroCaixa) );
  result := aux.FieldByName('FLA_USA_ECF').AsString = 'S';
  Aux.close;
end;

{******************** proximo sequencial da alteracao ********************** }
function TFuncoesCaixa.ProximoSequencialAlteracao: Integer;
begin
  result := ProximoCodigoFilial('MOV_ALTERACAO','SEQ_ALTERACAO','I_EMP_FIL',varia.CodigoFilCadastro, BaseDados);
end;

{************** proximo sequencial dos item de caixa ************************* }
function TFuncoesCaixa.ProximoSequencialItemCaixa(GeralAberto, ParcialAberto: Integer): Integer;
begin
  AdicionaSQLAbreTabela(Aux1, ' SELECT max(SEQ_CAIXA) SEQ_CAIXA FROM ITE_CAIXA' +
                              ' where  SEQ_DIARIO = ' + IntToStr(GeralAberto) +
                              ' and SEQ_PARCIAL = ' + IntToStr(ParcialAberto) );
  Result:=Aux1.FieldByName('SEQ_CAIXA').AsInteger + 1;
  Aux1.close;
end;

{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                           Alterarcoes Caixa
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

{********************** gera alteracao de caixa ***************************** }
function TFuncoesCaixa.GeraAlteracao( Geral, Parcial, VpaCodAlteracao, VpaCodUsuarioAlterou,
                                     VpaNumeroItem: Integer; VpaDiarioParcial: string): Boolean;
begin
  try
    AUX.RequestLive:=True;
    LimpaSQLTabela(Aux);
    AdicionaSQLAbreTabela(AUX, ' SELECT * FROM MOV_ALTERACAO ');
    AUX.Insert;
    AUX.FieldByName('EMP_FIL').AsInteger := Varia.CodigoFilCadastro;
    AUX.FieldByName('SEQ_ALTERACAO').AsInteger := ProximoSequencialAlteracao;
    AUX.FieldByName('SEQ_DIARIO').AsInteger := Geral;
    AUX.FieldByName('NUM_CAIXA').AsInteger := BuscaNumeroCaixa(AUX.FieldByName('SEQ_DIARIO').AsString);
    if (Parcial <> 0) then
      AUX.FieldByName('SEQ_PARCIAL').AsInteger := Parcial;
    if (VpaNumeroItem <> 0) then
      AUX.FieldByName('NUM_ITEM').AsInteger := VpaNumeroItem;
    AUX.FieldByName('COD_ALTERACAO').AsInteger := VpaCodAlteracao;
    AUX.FieldByName('COD_USUARIO_ALTERACAO').AsInteger := VpaCodUsuarioAlterou;
    AUX.FieldByName('DAT_ALTERACAO').AsDateTime := Date;
    AUX.FieldByName('HOR_ALTERACAO').AsDateTime := Time;
    AUX.FieldByName('FLA_DIARIO_PARCIAL').AsString := VpaDiarioParcial;
    //atualiza a data de alteracao para poder exportar
    AUX.FieldByname('D_ULT_ALT').AsDateTime := Date;
    AUX.Post;
    AUX.RequestLive:=False;
  except
    Aviso('Lançamento de alteração incorreto.');
    Result:=False;
  end;
  Aux.close;
end;


{((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                           Busca Informacoes Caixa
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))}

function TFuncoesCaixa.BuscaNumeroCaixa(Geral: string): Integer;
begin
  AdicionaSQLAbreTabela(AUX1, ' SELECT NUM_CAIXA FROM MOV_DIARIO ' +
                             ' WHERE  SEQ_DIARIO = ' + Geral);
  Result:=AUX1.FieldByName('NUM_CAIXA').AsInteger;
  Aux1.close;
end;


function TFuncoesCaixa.BuscaUsuarioCaixa(Geral, Parcial: Integer): string;
begin
  AdicionaSQLAbreTabela(AUX, ' SELECT COD_USUARIO FROM CRP_PARCIAL ' +
                             ' WHERE SEQ_DIARIO = ' + IntToStr(Geral) +
                             ' AND SEQ_PARCIAL = ' + IntToStr(Parcial));
  Result:=AUX.FieldByName('COD_USUARIO').AsString;
  Aux.close;
end;


function TFuncoesCaixa.BuscaClientePagar(NroOrdem: Integer): Integer;
begin
  AdicionaSQLAbreTabela(AUX, ' SELECT I_COD_CLI FROM CADCONTASAPAGAR ' +
                             ' WHERE I_EMP_FIL = ' + IntToStr(Varia.CodigoEmpFil) +
                             ' AND I_LAN_APG = ' + IntToStr(NroOrdem));
  Result:=AUX.FieldByName('I_COD_CLI').AsInteger;
  Aux.close;
end;


function TFuncoesCaixa.BuscaClienteReceber(NroOrdem: Integer): Integer;
begin
  AdicionaSQLAbreTabela(AUX, ' SELECT I_COD_CLI FROM CADCONTASARECEBER ' +
                             ' WHERE I_EMP_FIL = ' + IntToStr(Varia.CodigoEmpFil) +
                             ' AND I_LAN_REC = ' + IntToStr(NroOrdem));
  Result:=AUX.FieldByName('I_COD_CLI').AsInteger;
  Aux.close;
end;


{********************* lanca item de caixa ********************************* }
function TFuncoesCaixa.LancaItemCaixa( VpaCreditoDebito, VpaNronota: string; VpaDataemissao: TDateTime;  VpaOperacao, VpaFormaPagamento,
                                        NroOrdem,  NroParcela, VpaSeqGeral, VpaSeqParcial: Integer;
                                        VpaValor, VpaTroco, VpaPagoRecebido: Double;
                                        VpaBancario: Integer; VpaFlaPodeEstornar : string ): Boolean;
begin
  Tabela.RequestLive:=True;
  LocalizaItens(Tabela);
  Tabela.Insert;
  Tabela.FieldByName('EMP_FIL').AsInteger := Varia.CodigoFilCadastro;
  Tabela.FieldByName('FIL_ORI').AsInteger := Varia.CodigoEmpFil;
  Tabela.FieldByName('I_COD_EMP').AsInteger := Varia.CodigoEmpresa;
  Tabela.FieldByName('SEQ_DIARIO').AsInteger := VpaSeqGeral;
  Tabela.FieldByName('SEQ_PARCIAL').AsInteger := VpaSeqParcial;
  Tabela.fieldbyname('C_NRO_NOT').asString := VpaNroNota;
  Tabela.fieldbyname('D_DAT_NOT').asDateTime := VpaDataEmissao;
  Tabela.FieldByName('SEQ_CAIXA').AsInteger := ProximoSequencialItemCaixa(VpaSeqGeral, VpaSeqParcial);
  Tabela.FieldByName('COD_OPERACAO').AsInteger := VpaOperacao;
  Tabela.FieldByName('COD_FRM').AsInteger := VpaFormaPagamento;
  Tabela.FieldByName('DAT_MOVIMENTO').AsDateTime:=Date;
  Tabela.FieldByName('HOR_MOVIMENTO').AsDateTime:=Time;
  Tabela.FieldByName('CREDITO_DEBITO').AsString:=VpaCreditoDebito;
  Tabela.FieldByName('FLA_ESTORNADO').AsString:='N';
  Tabela.FieldByName('VAL_MOVIMENTO').AsFloat := VpaValor;
  Tabela.FieldByName('VAL_TROCO').AsFloat := VpaTroco;
  Tabela.FieldByName('VAL_PAGO_RECEBIDO').AsFloat := VpaPagoRecebido;
  Tabela.FieldByName('FLA_PODE_ESTORNAR').AsString := VpaFlaPodeEstornar; // S pode N naum

  if (VpaBancario > 0)  then
    Tabela.FieldByName('I_LAN_BAC').AsInteger := VpaBancario;
  if ((NroOrdem > 0) and  (NroParcela > 0)) then // Se foi informada a ordem e parcela a pagar ou receber.
  begin
    if (VpaCreditoDebito = 'D') then // DÉBITO. - CONTA A PAGAR.
    begin
      Tabela.FieldByName('LAN_PAGAR').AsInteger := NroOrdem;
      Tabela.FieldByName('NRO_PAGAR').AsInteger := NroParcela;
      Tabela.FieldByName('COD_CLI').AsInteger := BuscaClientePagar(NroOrdem);
    end
    else
    begin // CRÉDITO. - CONTA A RECEBER.
      Tabela.FieldByName('COD_CLI').AsInteger := BuscaClienteReceber(NroOrdem);
      Tabela.FieldByName('LAN_RECEBER').AsInteger := NroOrdem;
      Tabela.FieldByName('NRO_RECEBER').AsInteger := NroParcela;
    end;
  end;
  //atualiza a data de alteracao para poder exportar
  Tabela.FieldByName('D_ULT_ALT').AsDateTime := Date;

  Tabela.Post;
  Result := True;
  Tabela.RequestLive:=False;
  FechaTabela(Tabela);
end;

{###################### estorno caixa #######################################}


{************** item **************** }






{**************** devincula Um item do conta a receber ************************ }
procedure TFuncoesCaixa.DisvinculaUmItemCR(LancamentoCR, NroParcela : Integer );
begin
  LimpaSQLTabela(tabela);
  Tabela.SQL.Add(' UPDATE ITE_CAIXA SET' +
                 ' LAN_RECEBER = NULL, NRO_RECEBER = NULL ' +
                 ' , D_ULT_ALT = '+ SQLTextoDataAAAAMMMDD(DATE)+
                 ' WHERE FIL_ORI = ' + IntToStr(Varia.CodigoEmpFil) +
                 ' and LAN_RECEBER = ' + IntToStr(LancamentoCR)  +
                 ' and NRO_RECEBER = ' + Inttostr(NroParcela) );
  Tabela.ExecSQL;
  FechaTabela(tabela);
end;

{**************** devincula Um item do conta a pagar ************************ }
procedure TFuncoesCaixa.DisvinculaUmItemCP(LancamentoCP, NroParcela : Integer );
begin
  LimpaSQLTabela(tabela);
  Tabela.SQL.Add(' UPDATE ITE_CAIXA SET' +
                 ' LAN_PAGAR = NULL, NRO_PAGAR = NULL  ' +
                 ' , D_ULT_ALT = '+ SQLTextoDataAAAAMMMDD(DATE)+
                 ' WHERE FIL_ORI = ' + IntToStr(Varia.CodigoEmpFil) +
                 ' and LAN_PAGAR = ' + IntToStr(LancamentoCP) +
                 ' and NRO_PAGAR = ' + Inttostr(NroParcela)  );
  Tabela.ExecSQL;
  FechaTabela(tabela);
end;


{********************* Estorna item de caixa ********************************* }
function TFuncoesCaixa.EstornaCaixaCP(VpaFormaPagamento, CodCli : integer;  VpaValor : Double): Boolean;
var
  VpaSeqGeral,VpaSeqParcial : integer;
begin
  LocalizaFormaPagamento(Aux,VpaFormaPagamento);
  if aux.fieldByname('C_FLA_BCP').AsString = 'C' then
  begin
    VpaSeqGeral := SequencialGeralAberto(varia.CaixaPadrao);
    VpaSeqParcial :=SequencialParcialAberto(varia.CaixaPadrao);
    Tabela.RequestLive:=True;
    LocalizaItens(Tabela);
    Tabela.Insert;
    Tabela.FieldByName('EMP_FIL').AsInteger := Varia.CodigoFilCadastro;
    Tabela.FieldByName('FIL_ORI').AsInteger := Varia.CodigoEmpFil;
    Tabela.FieldByName('I_COD_EMP').AsInteger := Varia.CodigoEmpresa;
    Tabela.FieldByName('SEQ_DIARIO').AsInteger := VpaSeqGeral;
    Tabela.FieldByName('SEQ_PARCIAL').AsInteger := VpaSeqParcial;
    Tabela.FieldByName('SEQ_CAIXA').AsInteger := ProximoSequencialItemCaixa(VpaSeqGeral, VpaSeqParcial);
    Tabela.FieldByName('COD_OPERACAO').AsInteger := varia.CodOpeEstornaCaixaCP;
    Tabela.FieldByName('COD_FRM').AsInteger := VpaFormaPagamento;
    Tabela.FieldByName('DAT_MOVIMENTO').AsDateTime:=Date;
    Tabela.FieldByName('HOR_MOVIMENTO').AsDateTime:=Time;
    Tabela.FieldByName('CREDITO_DEBITO').AsString:='C';
    Tabela.FieldByName('FLA_ESTORNADO').AsString:='N';
    Tabela.FieldByName('VAL_MOVIMENTO').AsFloat := VpaValor;
    Tabela.FieldByName('VAL_TROCO').AsFloat :=0;
    Tabela.FieldByName('VAL_PAGO_RECEBIDO').AsFloat := VpaValor;
    Tabela.FieldByName('FLA_PODE_ESTORNAR').AsString := 'N'; // S pode N naum
    Tabela.FieldByName('COD_CLI').AsInteger := CodCli;
    //atualiza a data de alteracao para poder exportar
    Tabela.FieldByName('D_ULT_ALT').AsDateTime := Date;
    Tabela.Post;
    Result := True;
    Tabela.RequestLive:=False;
    FechaTabela(Tabela);
  end;
  aux.close;
end;

{********************* Estorna item de caixa ********************************* }
function TFuncoesCaixa.EstornaCaixaCR(VpaFormaPagamento, CodCli : integer;  VpaValor : Double): Boolean;
var
  VpaSeqGeral,VpaSeqParcial : integer;
begin
  LocalizaFormaPagamento(Aux,VpaFormaPagamento);
  if aux.fieldByname('C_FLA_BCR').AsString = 'C' then
  begin
    VpaSeqGeral := SequencialGeralAberto(varia.CaixaPadrao);
    VpaSeqParcial :=SequencialParcialAberto(varia.CaixaPadrao);
    Tabela.RequestLive:=True;
    LocalizaItens(Tabela);
    Tabela.Insert;
    Tabela.FieldByName('EMP_FIL').AsInteger := Varia.CodigoFilCadastro;
    Tabela.FieldByName('FIL_ORI').AsInteger := Varia.CodigoEmpFil;
    Tabela.FieldByName('I_COD_EMP').AsInteger := Varia.CodigoEmpresa;
    Tabela.FieldByName('SEQ_DIARIO').AsInteger := VpaSeqGeral;
    Tabela.FieldByName('SEQ_PARCIAL').AsInteger := VpaSeqParcial;
    Tabela.FieldByName('SEQ_CAIXA').AsInteger := ProximoSequencialItemCaixa(VpaSeqGeral, VpaSeqParcial);
    Tabela.FieldByName('COD_OPERACAO').AsInteger := varia.CodOpeEstornaCaixaCR;
    Tabela.FieldByName('COD_FRM').AsInteger := VpaFormaPagamento;
    Tabela.FieldByName('DAT_MOVIMENTO').AsDateTime:=Date;
    Tabela.FieldByName('HOR_MOVIMENTO').AsDateTime:=Time;
    Tabela.FieldByName('CREDITO_DEBITO').AsString:='D';
    Tabela.FieldByName('FLA_ESTORNADO').AsString:='N';
    Tabela.FieldByName('VAL_MOVIMENTO').AsFloat := VpaValor;
    Tabela.FieldByName('VAL_TROCO').AsFloat :=0;
    Tabela.FieldByName('VAL_PAGO_RECEBIDO').AsFloat := VpaValor;
    Tabela.FieldByName('FLA_PODE_ESTORNAR').AsString := 'N'; // S pode N naum
    Tabela.FieldByName('COD_CLI').AsInteger := CodCli;
    //atualiza a data de alteracao para poder exportar
    Tabela.FieldByName('D_ULT_ALT').AsDateTime := Date;
    Tabela.Post;
    Result := True;
    Tabela.RequestLive:=False;
    FechaTabela(Tabela);
  end;
  aux.close;
end;


function TFuncoesCaixa.VerificaPodeEstornarBanco( lancamento, CodFilial : Integer ) : Boolean;
begin
  result := true;
  AdicionaSQLAbreTabela(Tabela, ' select * from ite_caixa ite ' +
                                ' where i_lan_bac = ' + IntTostr(lancamento) );
  if not Tabela.eof then
  begin
    AdicionaSQLAbreTabela(Aux, ' select * from cad_caixa cai ' +
                               ' where cai.seq_diario = ' + Tabela.fieldbyName('Seq_diario').AsString +
                               ' and cai.seq_parcial = ' + Tabela.fieldbyName('Seq_Parcial').AsString +
                               ' and cai.num_caixa = ' + Inttostr(varia.CaixaPadrao));
    if aux.FieldByName('Fla_parcial_aberto').AsString <> 'S' then
      result := false;
  end;
  Tabela.close;
  aux.close;
end;

{************ estorna todos item de caixa do banco *************************** }
procedure TFuncoesCaixa.EstornaItemBanco(lancamentoCR : Integer );
begin
  LimpaSQLTabela(tabela);
  Tabela.SQL.Add(' UPDATE ITE_CAIXA SET FLA_ESTORNADO = ''S'' '  +
                 ' , D_ULT_ALT = '+ SQLTextoDataAAAAMMMDD(DATE)+
                 ' WHERE I_LAN_BAC = ' + IntToStr(lancamentoCR) );
  Tabela.ExecSQL;
  FechaTabela(tabela);
end;



{**************** devincula item do conta a receber ************************ }
procedure TFuncoesCaixa.DisvinculaTodosItemCR(LancamentoCR, CodFilial : Integer );
begin
  LimpaSQLTabela(tabela);
  Tabela.SQL.Add(' UPDATE ITE_CAIXA SET' +
                 ' LAN_RECEBER = NULL, NRO_RECEBER = NULL ' +
                 ' , D_ULT_ALT = '+ SQLTextoDataAAAAMMMDD(DATE)+
                 ' WHERE FIL_ORI = ' + IntToStr(CodFilial) +
                 ' and LAN_RECEBER = ' + IntToStr(LancamentoCR) );
  Tabela.ExecSQL;
  FechaTabela(tabela);
end;

{**************** devincula item do conta a pagar ************************ }
procedure TFuncoesCaixa.DisvinculaTodosItemCP(LancamentoCP, CodFilial : Integer );
begin
  LimpaSQLTabela(tabela);
  Tabela.SQL.Add(' UPDATE ITE_CAIXA SET' +
                 ' LAN_PAGAR = NULL, NRO_PAGAR = NULL  ' +
                 ' , D_ULT_ALT = '+ SQLTextoDataAAAAMMMDD(DATE)+
                 ' WHERE FIL_ORI = ' + IntToStr(CodFilial) +
                 ' and LAN_PAGAR = ' + IntToStr(LancamentoCP) );
  Tabela.ExecSQL;
  FechaTabela(tabela);
end;





procedure TFuncoesCaixa.RecalculaFechamento(SeqDiario, Seqparcial : Integer; ValorFechamento, valorIdeal : Double );
var
  VpfValorFechamentoNovo : Double;
begin
  // recalcula
  VpfValorFechamentoNovo := SomaFechamentoParcial( SeqDiario, Seqparcial );

  if ( ValorIdeal <> VpfValorFechamentoNovo ) then
  begin
    // Valor de fechamento foi alterado, RE-FECHAR;
    LimpaSQLTabela(AUX);
    AUX.sql.Add( ' UPDATE CRP_PARCIAL SET VAL_IDEAL_FECHAMENTO = ' +
                 (substituistr(FloatToStr(VpfValorFechamentoNovo),',','.')) +
                 ', VAL_CORRIGIDO = ISNULL(VAL_CORRIGIDO,0) + ' +
                 (substituistr(FloatToStr(VpfValorFechamentoNovo - ValorIdeal),',','.')) +
                 ' , D_ULT_ALT = '+ SQLTextoDataAAAAMMMDD(DATE)+
                 ' WHERE SEQ_DIARIO = ' + IntToStr(SeqDiario) +
                 ' AND SEQ_PARCIAL = ' + IntToStr(Seqparcial) );
    AUX.ExecSQL;

    if abs(ValorFechamento - VpfValorFechamentoNovo) <= Varia.ValorTolerancia  then
      if Confirmacao('O caixa está correto, deseja refechá-lo corretamente ?') then
        MudaEstadoParcial('N',SeqDiario, Seqparcial);
    Aux.close;
  end;
end;

procedure TFuncoesCaixa.MudaEstadoPArcial( estado : string; SeqDiario, SeqParcial : Integer );
begin
   LimpaSQLTabela(AUX);
   AUX.sql.Add(' UPDATE CRP_PARCIAL SET FLA_ESTADO = '''  +  estado + ''' ' +
               ' , D_ULT_ALT = '+ SQLTextoDataAAAAMMMDD(DATE)+
               ' WHERE SEQ_DIARIO = ' + IntToStr(SeqDiario) +
               ' AND SEQ_PARCIAL = ' + IntToStr(SeqParcial) );
   AUX.ExecSQL;
end;

{******************* refaz o fechamento do caixa ***************************** }
procedure TFuncoesCaixa.ReFechaCaixa( SeqDiario, Seqparcial : Integer;
                                      VpaValorDinheiro, VpaValorCheque, VpaValorOutros : Double);
var
  ValorInicial : Double;
begin
  Tabela.RequestLive := True;
  LocalizaMovParcialSeq(tabela, SeqDiario, Seqparcial);
  ValorInicial := Tabela.FieldByName('VAL_FECHAMENTO_PARCIAL').AsCurrency;
  Tabela.Edit;
  Tabela.FieldByName('VAL_FECHAMENTO_PARCIAL').AsCurrency := VpaValorDinheiro + VpaValorCheque + VpaValorOutros;
  Tabela.FieldByName('VAL_DINHEIRO_FECHAMENTO').AsCurrency := VpaValorDinheiro;
  Tabela.FieldByName('VAL_CHEQUE_FECHAMENTO').AsCurrency := VpaValorCheque;
  Tabela.FieldByName('VAL_OUTROS_FECHAMENTO').AsCurrency := VpaValorOutros;
  Tabela.FieldByName('VAL_CORRIGIDO').AsCurrency := Tabela.FieldByName('VAL_CORRIGIDO').AsCurrency +
                                                    (ValorInicial - Tabela.FieldByName('VAL_FECHAMENTO_PARCIAL').AsCurrency);
  //atualiza a data de alteracao para poder exportar
  Tabela.FieldByName('D_ULT_ALT').AsDateTime := Date;
  Tabela.Post;
end;

function TFuncoesCaixa.VerificaSaldodeCaixa( valor : double; CodCaixaDiario, CodCaixaPArcial : Integer ) : boolean;
begin
  result := true;
  if (ArredondaDecimais(valor,2)) > (ArredondaDecimais(SomaFechamentoParcial(CodCaixaDiario, CodCaixaPArcial),2)) then
  begin
    Aviso(CT_ValorMaiorSaldoCaixa);
    result := false;
  end;
end;


procedure TFuncoesCaixa.GuardaSaldoAtual(SeqCaixaDiario : Integer);
var
  unFlu : TFuncoesFluxo;
begin
  unFlu := TFuncoesFluxo.criar(nil,BaseDados);
  unFlu.LocalizaDadosBancos(Tabela, date);
  aux.RequestLive := true;
  AdicionaSQLAbreTabela(Aux,'select * from movsaldobanco');
  while not tabela.eof do
  begin
    aux.insert;
    aux.FieldByName('i_seq_mov').AsInteger := ProximoCodigoFilial('MovSaldoBanco','i_seq_mov','seq_diario',SeqCaixaDiario,BaseDados);
    aux.FieldByName('seq_diario').AsInteger := SeqCaixaDiario;
    aux.FieldByName('n_sal_atu').AsFloat := tabela.fieldByName('n_sal_atu').AsFloat;
    aux.FieldByName('c_nro_con').AsString := tabela.fieldByName('c_nro_con').AsString;
    aux.FieldByName('d_ult_alt').AsDateTime := date;
    aux.post;
    tabela.next;
  end;
  aux.RequestLive := false;
  unFlu.Free;
end;


end.
