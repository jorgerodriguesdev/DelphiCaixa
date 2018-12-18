unit AFechaCaixa;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Formularios, UnCaixa, StdCtrls, LabelCorMove, ExtCtrls, Componentes1,
  PainelGradiente, Localizacao, Buttons, Mask, Db, DBTables, numericos,
  UnComandosAUT, DBKeyViolation;

type
  TFFechaCaixa = class(TFormularioPermissao)
    PTitulo: TPainelGradiente;
    PanelColor2: TPanelColor;
    Label3D1: TLabel3D;
    Localiza: TConsultaPadrao;
    BFechar: TBitBtn;
    Tempo: TPainelTempo;
    PFechamento: TPanelColor;
    Label19: TLabel;
    Label18: TLabel;
    Label17: TLabel;
    Label14: TLabel;
    Label9: TLabel;
    Label7: TLabel;
    LFechamento: TLabel;
    LCorretoTotal: TLabel;
    EValorFechamento: Tnumerico;
    EValorOutrosFechamento: Tnumerico;
    EValorChequeFechamento: Tnumerico;
    EValorDinheiroFechamento: Tnumerico;
    ESenhaFechamento: TEditColor;
    EUsuarioFechamento: TEditLocaliza;
    ECorretoTotal: Tnumerico;
    BFechaCaixa: TBitBtn;
    LFecha: TLabel3D;
    BProblema: TBitBtn;
    BFecha: TSpeedButton;
    ValidaGravacao1: TValidaGravacao;
    BBAjuda: TBitBtn;
    EVerificaValores: TBitBtn;
    Tra1: TBitBtn;
    Tra2: TBitBtn;
    Tra3: TBitBtn;
    Tra4: TBitBtn;
    AUX: TQuery;
    Aux1: TQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure UsuarioSelect(Sender: TObject);
    procedure EUsuarioRetorno(Retorno1, Retorno2: String);
    procedure ECaixaFechamentoChange(Sender: TObject);
    procedure ESenhaFechamentoExit(Sender: TObject);
    procedure BProblemaClick(Sender: TObject);
    procedure EUsuarioFechamentoChange(Sender: TObject);
    procedure BFechaCaixaClick(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
    procedure EVerificaValoresClick(Sender: TObject);
    procedure Tra3Click(Sender: TObject);
  private
    { Private declarations }
    VprParcial, VprDiario : Integer;
    VprSenhaUsuarioAtual : string;
    VprTipoAbertura : integer; // 0  - caixa,  1 parcial
    Caixa: TFuncoesCaixa;
    procedure ConfiguraFechamento;
    procedure FechaCaixa_Parcial( Problema : Boolean );
  public
     procedure FechaCaixa;
     procedure FechaParcial;
     procedure CarregaMovimento(diario, texto : string);
     procedure CarregaExtrato(seqdiario, seqparcial : integer);
     procedure Imprimefechamento;
  end;

var
  FFechaCaixa: TFFechaCaixa;
  AUT : TFuncoesAut;
implementation

{$R *.DFM}

uses FunSql, APrincipal, ConstMsg, Constantes, FunData, FunValida, funObjeto, unECf,
  ASangriaSuprimento, funnumeros, funstring;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                  funcoes do formulario
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{ ****************** Na criação do Formulário ******************************** }
procedure TFFechaCaixa.FormCreate(Sender: TObject);
begin
  AUT := TFuncoesAut.Create;
  Caixa := TFuncoesCaixa.Criar(Self, FPrincipal.BaseDados);
  Self.HelpFile := Varia.PathHelp + 'MCAIXA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFFechaCaixa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FPrincipal.BaseDados.InTransaction then
    FPrincipal.BaseDados.Rollback;
  Caixa.Destroy;
  Action := CaFree;
end;

{ *************** Registra a classe para evitar duplicidade ****************** }
procedure TFFechaCaixa.BFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFFechaCaixa.CarregaMovimento(diario, texto : string);
begin
  LimpaSQLTabela(AUX1);
  Aux1.SQL.Add(' select sum(val_movimento) as valor, '+
               ' ope.des_operacao from ite_caixa cad, cad_tipo_opera ope'+
               ' where cad.cod_operacao = ope.cod_operacao'+
               ' and seq_diario = ' + diario +
               texto +
               ' group by cad.cod_operacao. ope.des_operacao');
  Aux1.open;
end;

procedure TFFechaCaixa.CarregaExtrato(seqdiario, seqparcial : integer);
begin
  LimpaSQLTabela(Aux1);
  Aux1.SQL.Add(' SELECT * FROM ITE_CAIXA ITE, CAD_TIPO_OPERA CAD, CADFORMASPAGAMENTO FRM, CADCLIENTES CLI ' +
               ' WHERE ITE.EMP_FIL = ' + IntToStr(Varia.CodigoEmpFil));
  //if CParciaisEstornados.Checked then
  //      ITECAIXA.SQL.Add(' AND ITE.FLA_ESTORNADO = ''S''');
  Aux1.SQL.Add(' AND ITE.SEQ_DIARIO = ' + inttostr(seqdiario) +
               ' AND ITE.SEQ_PARCIAL = ' + inttostr(seqparcial) +
               ' AND ITE.COD_OPERACAO = CAD.COD_OPERACAO ' +
               ' AND ITE.COD_FRM = FRM.I_COD_FRM ');
  Aux1.SQL.Add(' AND ITE.COD_CLI *= CLI.I_COD_CLI ');
  Aux1.SQL.Add(' order by Ite.Hor_movimento');
  AbreTabela(Aux1);
end;

{********************* fechamento de caixa ********************************* }
procedure TFFechaCaixa.FechaCaixa;
begin
  if caixa.VerificaFechaCaixa(Varia.CaixaPadrao) then
  begin
    VprTipoAbertura := 0;
    ConfiguraFechamento;
    self.ShowModal;
  end
  else
    self.close;
end;

{********************** fechamento de parcial ******************************* }
procedure TFFechaCaixa.FechaParcial;
begin
 if caixa.VerificaFechaParcial(Varia.CaixaPadrao) then
 begin
   VprTipoAbertura := 1;
   ConfiguraFechamento;
   self.ShowModal;
 end
 else
   self.close;
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                  funcoes dos Localizas
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{*********************** select usuarios ************************************* }
procedure TFFechaCaixa.UsuarioSelect(Sender: TObject);
begin
  (Sender as TEditLocaliza).ASelectLocaliza.Clear;
  (Sender as TEditLocaliza).ASelectLocaliza.Add(' SELECT * FROM CADUSUARIOS ' +
                                                ' WHERE I_EMP_FIL = ' + IntToStr(Varia.CodigoEmpFil) +
                                                ' AND C_NOM_USU LIKE ''@%''');
  (Sender as TEditLocaliza).ASelectValida.Clear;
  (Sender as TEditLocaliza).ASelectValida.Add(' SELECT * FROM CADUSUARIOS ' +
                                              ' WHERE I_EMP_FIL = ' + IntToStr(Varia.CodigoEmpFil) +
                                              ' AND I_COD_USU = @');
end;

{************************ retorno do usuario ******************************* }
procedure TFFechaCaixa.EUsuarioRetorno(Retorno1,
  Retorno2: String);
begin
  if (Retorno1 <> '') then
    VprSenhaUsuarioAtual := Descriptografa(Retorno1)
  else
    VprSenhaUsuarioAtual := '';
end;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                  funcoes do Caixa
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{**************** valida o fechamento *************************************** }
procedure TFFechaCaixa.EUsuarioFechamentoChange(Sender: TObject);
begin
  ValidaGravacao1.execute;
  if BFechaCaixa.Enabled then
    if EUsuarioFechamento.Text = '' then
      BFechaCaixa.Enabled := false;
end;

{****************** calcula o valor total ********************************** }
procedure TFFechaCaixa.ECaixaFechamentoChange(Sender: TObject);
begin
  EValorFechamento.AValor:= EValorOutrosFechamento.AValor +
                            EValorChequeFechamento.AValor +
                            EValorDinheiroFechamento.AValor;
  tra1.Enabled := EValorDinheiroFechamento.AValor <> 0;
  tra2.Enabled := EValorChequeFechamento.AValor <> 0;
  tra3.Enabled := EValorOutrosFechamento.AValor <> 0;
  tra4.Enabled := EValorFechamento.AValor <> 0;
end;

{***************** verifica a senha de fechamento do caixa ****************** }
procedure TFFechaCaixa.ESenhaFechamentoExit(Sender: TObject);
var
  ECF : TECF;
begin
  if not BFechar.Focused then
    if (UpperCase((Trim(VprSenhaUsuarioAtual))) <> (UpperCase(Trim(ESenhaFechamento.Text)))) then
    begin
      Aviso(CT_SenhaInvalida);
      ESenhaFechamento.Text:='';
      ESenhaFechamento.SetFocus;
    end
    else
    begin
      // verifica aciona gaveta
      if (varia.UsarGaveta = 'S') then
      begin
        ECF := TECF.criar(nil, FPrincipal.BaseDados);
        if ECF.AbrePorta then
        begin
          ECF.AcionaGaveta;
          ECF.FecharPorta;
        end
        else
          aviso(CT_ImpressoraFiscalFechada);
       Ecf.Free;
     end;
  end;
end;

{************* configura o fechamento do caixa ******************************* }
procedure TFFechaCaixa.ConfiguraFechamento;
var
  VpfDinheiro, VpfCheque, VpfOutros: Double;
begin
  VprDiario := Caixa.SequencialGeralAberto(varia.CaixaPadrao);
  VprParcial := Caixa.SequencialParcialAberto(varia.CaixaPadrao);
  if VprTipoAbertura = 0  then // caso caixa geral
  begin
    BFecha.Enabled := True;
    EUsuarioFechamento.Enabled := True;
    LFecha.Caption:='Fechamento caixa geral Nro '  + IntToStr(varia.CaixaPadrao) + '.';
    Caixa.BuscaUltimoFechamentoDiario(VprDiario, VpfDinheiro, VpfCheque, VpfOutros);
    EValorDinheiroFechamento.AValor:=VpfDinheiro;
    EValorChequeFechamento.AValor:=VpfCheque;
    EValorOutrosFechamento.AValor:=VpfOutros;
    AlterarEnabledDet([ EValorDinheiroFechamento, EValorChequeFechamento, EValorOutrosFechamento,
                        EValorFechamento ], false );
  end
  else
  begin
    EUsuarioFechamento.Text:= IntToStr(Caixa.UsuarioParcial(VprParcial, VprDiario));
    EUsuarioFechamento.Atualiza;
    LFecha.Caption:='Fechamento caixa Parcial Nro ' + IntToStr(varia.CaixaPadrao) + '.';
  end;
  EUsuarioFechamentoChange(nil);
end;

{*************** fecha o caixa *********************************************** }
procedure TFFechaCaixa.FechaCaixa_Parcial( Problema : Boolean );
begin
  if not FPrincipal.BaseDados.InTransaction then
    FPrincipal.BaseDados.StartTransaction;

  try
    if VprTipoAbertura = 0 then // geral
    begin
      Tempo.Execute('Fechando Caixa ...');
      Caixa.FechaCaixa( Varia.CaixaPadrao, VprDiario,
                        StrToInt(EUsuarioFechamento.Text),
                        EValorDinheiroFechamento.AValor,
                        EValorChequeFechamento.AValor,
                        EValorOutrosFechamento.AValor);
      imprimefechamento;
      self.Close;
    end
    else
    begin         // parcial
      Tempo.Execute('Fechando Parcial ...');
      if Caixa.FechaCaixaParcial( Varia.CaixaPadrao, VprDiario, VprParcial,
                                  EValorDinheiroFechamento.AValor,
                                  EValorChequeFechamento.AValor,
                                  EValorOutrosFechamento.AValor, PROBLEMA) then
         begin
          ImprimeFechamento;
          Close // FECHA A TELA SE A PARCIAL FOI FECHADO CORRETAMENTE.
         end
      else
      begin
         EVerificaValoresClick(EVerificaValores);
         BProblema.Visible := True;
      end;
    end;

    if FPrincipal.BaseDados.InTransaction then
      FPrincipal.BaseDados.Commit;

  except
    if FPrincipal.BaseDados.InTransaction then
      FPrincipal.BaseDados.Rollback;
    Aviso('Erro ao fechar o caixa!');
  end;
  Tempo.Fecha;
end;

{******************* fecha o caixa com problemas **************************** }
procedure TFFechaCaixa.BProblemaClick(Sender: TObject);
begin
  if Confirmacao(CT_FechaCaixaProblema) then
    FechaCaixa_Parcial( true );
end;

{******************* fecha o caixa sem problemas **************************** }
procedure TFFechaCaixa.BFechaCaixaClick(Sender: TObject);
begin
   if ESenhaFechamento.Text <> '' then
     begin
       FechaCaixa_Parcial( false );
     end
   else
     ESenhaFechamentoExit(nil);
end;

{********************* Imprime fechamento na autenticadora ********************}
procedure TFFechaCaixa.Imprimefechamento;
var
 texto, sigla : string;
begin
  texto := '';
  Case varia.TipoImpressoraAUT of
    0 : begin end;
    1 : begin
          AUT.AbrePorta;
          if Aut.VerificaImpressora then
          begin
            AUT.Imprime('___________________________________');
            Aut.ImprimeFormato(' ENCERRAMENTO DO MOVIMENTO DE CAIXA ');
            AUT.Imprime('___________________________________');
            AUT.ImprimeFormato(eusuariofechamento.text
                               + ' - ' + lfechamento.caption
                               + '  ' + datetostr(date)
                               + '  ' + timetostr(time));
            AUT.Imprime('___________________________________');

            AUT.ImprimeFormato('Dinheiro : ' + AdicionaCharE('.',' ' + formatfloat(varia.MascaraValor,Evalordinheirofechamento.AValor), 16));
            AUT.ImprimeFormato('Cheques  : ' + AdicionaCharE('.',' ' + formatfloat(varia.MascaraValor,Evalorchequefechamento.AValor), 16));
            AUT.ImprimeFormato('Outros   : ' + AdicionaCharE('.',' ' + formatfloat(varia.MascaraValor,Evaloroutrosfechamento.AValor), 16));

            if VprTipoAbertura = 0 then
              CarregaMovimento(inttostr(vprdiario), '')
            else
              begin
                texto := (' and cad.seq_parcial = ' + inttostr(vprparcial));
                CarregaMovimento(inttostr(vprdiario), texto );
              end;
            while not aux1.eof do
            begin
              AUT.ImprimeFormato(AdicionaBrancoD(cortaString(Aux1.fieldbyname('des_operacao').asString,20),20)
                                 + ' = ' +
                                 AdicionaCharE('.',' ' + formatfloat(varia.MascaraValor,Aux1.fieldbyname('valor').asfloat),16));
              aux1.next;
            end;
            AUT.ImprimeFormato(AdicionaBrancoD(cortaString('SALDO DE CAIXA ', 20),20)
            + ' = ' + adicionaCharE('.',' ' + formatfloat(varia.MascaraValor,Evalorfechamento.AValor), 16));

            if Confirmacao('Deseja imprimir Extrato de Movimento do Caixa ') then
            begin
              CarregaExtrato(vprdiario, vprparcial);
              AUT.Imprime('___________________________________');
              AUT.ImprimeFormato(' EXTRATO DO MOVIMENTO DE CAIXA ');
              AUT.Imprime('___________________________________');
              while not Aux1.eof do
              begin
                if aux1.fieldbyname('credito_debito').asString = 'C' then
                begin
                  texto := inttostr(aux1.fieldbyname('nro_receber').asinteger);
                  sigla := 'CR';
                end
                else
                  begin
                    texto := inttostr(aux1.fieldbyname('nro_pagar').asinteger);
                    sigla := 'DB';
                  end;
                AUT.ImprimeFormato(AdicionaBrancoD(cortaString(Aux1.fieldbyname('seq_caixa').asString
                                   + ' ' + texto
                                   + ' ' + Aux1.fieldbyname('c_nro_not').asString
                                   + ' ' + Aux1.fieldbyname('c_nom_cli').asString,40),40));
                AUT.ImprimeFormato(retiraacentuacao(AdicionaBrancoD(cortaString(Aux1.fieldbyname('des_operacao').asString,20),20)
                                   + ' = '
                                   + AdicionaCharE('.',' ' + formatfloat(varia.MascaraValor,Aux1.fieldbyname('val_movimento').asfloat),16)
                                   + ' ' + sigla ));
                Aux1.next;
              end;
              AUT.Imprime('___________________________________');
              AUT.ImprimeFormato(AdicionaBrancoD(cortaString('Saldo Creditos/Debitos nos Lancamentos',38),38)
                                 + ' = '
                                 + formatfloat(varia.MascaraValor,ecorretototal.AValor));


            end;
          end;
        end;
  end;
end;

procedure TFFechaCaixa.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FFechaCaixa.HelpContext);
end;

procedure TFFechaCaixa.EVerificaValoresClick(Sender: TObject);
begin
   LCorretoTotal.Visible := True;
   ECorretoTotal.Visible := True;
   ECorretoTotal.AValor := Caixa.SomaFechamentoParcial(VprDiario, VprParcial);
   if sender <> nil then
   begin
     caixa.GuardaValoresFechamento( Varia.CaixaPadrao, VprDiario, VprParcial,
                                    EValorDinheiroFechamento.AValor,
                                    EValorChequeFechamento.AValor,
                                        EValorOutrosFechamento.AValor );
      if Abs((ArredondaDecimais(ECorretoTotal.AValor,2) -
               ArredondaDecimais((EValorDinheiroFechamento.AValor + EValorChequeFechamento.avalor + EValorOutrosFechamento.AValor),2))) >
               Varia.ValorTolerancia  then
        erro('O valor do fechamento está incorreto.')
      else
        aviso('Valores Corretos');
    end;
end;

procedure TFFechaCaixa.Tra3Click(Sender: TObject);
var
  Baixa : double;
begin
  FSangriaSuprimento := TFSangriaSuprimento.CriarSDI(Application,'' , true);
  case (sender as TComponent).Tag of
    1 : Baixa := FSangriaSuprimento.SangriaFechamento(EValorDinheiroFechamento.AValor);
    2 : Baixa := FSangriaSuprimento.SangriaFechamento(EValorChequeFechamento.AValor);
    3 : Baixa := FSangriaSuprimento.SangriaFechamento(EValorOutrosFechamento.AValor);
    4 : Baixa := FSangriaSuprimento.SangriaFechamento(EValorFechamento.AValor);
  end;

  case (sender as TComponent).Tag of
    1 : EValorDinheiroFechamento.AValor := EValorDinheiroFechamento.AValor - Baixa;
    2 : EValorChequeFechamento.AValor := EValorChequeFechamento.AValor - Baixa;
    3 : EValorOutrosFechamento.AValor := EValorOutrosFechamento.AValor - Baixa;
    4 : begin
          EValorDinheiroFechamento.AValor := 0;
          EValorChequeFechamento.AValor := 0;
          EValorOutrosFechamento.AValor := 0;
        end;
  end;
  ECaixaFechamentoChange(nil);
  EVerificaValoresClick(nil);
end;

Initialization
  RegisterClasses([TFFechaCaixa]);
end.
