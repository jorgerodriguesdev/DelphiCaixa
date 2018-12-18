unit AReFechaCaixa;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Formularios, UnCaixa, StdCtrls, LabelCorMove, ExtCtrls, Componentes1,
  PainelGradiente, Localizacao, Buttons, Mask, Db, DBTables, numericos,
  DBKeyViolation, UnComandosAUT;

type
  TFReFechaCaixa = class(TFormularioPermissao)
    PTitulo: TPainelGradiente;
    PanelColor2: TPanelColor;
    Label3D1: TLabel3D;
    Localiza: TConsultaPadrao;
    BFechar: TBitBtn;
    Tempo: TPainelTempo;
    PFechamento: TPanel;
    Label19: TLabel;
    Label18: TLabel;
    Label17: TLabel;
    Label14: TLabel;
    LCorretoTotal: TLabel;
    LCaixaAtivo: TLabel3D;
    EValorFechamento: Tnumerico;
    EValorOutrosFechamento: Tnumerico;
    EValorChequeFechamento: Tnumerico;
    EValorDinheiroFechamento: Tnumerico;
    ECorretoTotal: Tnumerico;
    BFechaCaixa: TBitBtn;
    LFecha: TLabel3D;
    ValidaGravacao1: TValidaGravacao;
    Parcial: TQuery;
    ParcialVAL_FECHAMENTO_PARCIAL: TFloatField;
    ParcialVAL_DINHEIRO_FECHAMENTO: TFloatField;
    ParcialVAL_CHEQUE_FECHAMENTO: TFloatField;
    ParcialVAL_OUTROS_FECHAMENTO: TFloatField;
    ParcialVAL_IDEAL_FECHAMENTO: TFloatField;
    ParcialSEQ_PARCIAL: TIntegerField;
    ParcialSEQ_DIARIO: TIntegerField;
    ParcialCOD_USUARIO: TIntegerField;
    BBAjuda: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFecharClick(Sender: TObject);
    procedure ECaixaFechamentoChange(Sender: TObject);
    procedure BFechaCaixaClick(Sender: TObject);
    procedure BBAjudaClick(Sender: TObject);
  private
    { Private declarations }
    VprParcial, VprDiario : Integer;
    VprSenhaUsuarioAtual : string;
    VprTipoAbertura : integer; // 0  - caixa,  1 parcial
    Caixa: TFuncoesCaixa;
    procedure ConfiguraFechamento;
    procedure FechaCaixa_Parcial( Problema : Boolean );
  public
     procedure ReFechaParcial( seqDiario, SeqParcial : Integer );
  end;

var
  FReFechaCaixa: TFReFechaCaixa;
  AUT : TFuncoesAut;
implementation

{$R *.DFM}

  uses FunSql, APrincipal, ConstMsg, Constantes, FunData, FunValida, funObjeto,
  APermiteAlterar;

{(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
                  funcoes do formulario
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) }

{ ****************** Na criação do Formulário ******************************** }
procedure TFReFechaCaixa.FormCreate(Sender: TObject);
begin
  AUT := TFuncoesAut.Create;
  Caixa := TFuncoesCaixa.Criar(Self, FPrincipal.BaseDados);
  Self.HelpFile := Varia.PathHelp + 'MCAIXA.HLP>janela';  // Indica o Paph e o nome do arquivo de Help
end;

{ ******************* Quando o formulario e fechado ************************** }
procedure TFReFechaCaixa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FPrincipal.BaseDados.InTransaction then
    FPrincipal.BaseDados.Rollback;
  Caixa.Destroy;
  Action := CaFree;
end;

{ *************** Registra a classe para evitar duplicidade ****************** }
procedure TFReFechaCaixa.BFecharClick(Sender: TObject);
begin
  Close;
end;

{********************** fechamento de parcial ******************************* }
procedure TFReFechaCaixa.ReFechaParcial( seqDiario, SeqParcial : Integer );
begin
   self.VprDiario := seqDiario;
   self.VprParcial := SeqParcial;
   ConfiguraFechamento;
   self.ShowModal;
end;

{****************** calcula o valor total ********************************** }
procedure TFReFechaCaixa.ECaixaFechamentoChange(Sender: TObject);
begin
  EValorFechamento.AValor:= EValorOutrosFechamento.AValor +
                            EValorChequeFechamento.AValor +
                            EValorDinheiroFechamento.AValor;
end;


{************* configura o fechamento do caixa ******************************* }
procedure TFReFechaCaixa.ConfiguraFechamento;
var
  VpfDinheiro, VpfCheque, VpfOutros: Double;
begin
  caixa.LocalizaMovParcialSeq( Parcial, VprDiario, VprParcial );
  EValorDinheiroFechamento.AValor := ParcialVAL_DINHEIRO_FECHAMENTO.AsCurrency;
  EValorChequeFechamento.AValor := ParcialVAL_CHEQUE_FECHAMENTO.AsCurrency;
  EValorOutrosFechamento.AValor := ParcialVAL_OUTROS_FECHAMENTO.AsCurrency;
  EValorFechamento.AValor := ParcialVAL_FECHAMENTO_PARCIAL.AsCurrency;
  ECorretoTotal.AValor := ParcialVAL_IDEAL_FECHAMENTO.AsCurrency;
  LCaixaAtivo.Caption := 'Caixa : ' + IntToStr(varia.CaixaPadrao) + '.';
  LFecha.Caption:='REFECHAMENTO DE CAIXA PACIAL.';
end;

{*************** fecha o caixa *********************************************** }
procedure TFReFechaCaixa.FechaCaixa_Parcial( Problema : Boolean );
begin
  if not FPrincipal.BaseDados.InTransaction then
    FPrincipal.BaseDados.StartTransaction;
  try

    if FPrincipal.BaseDados.InTransaction then
      FPrincipal.BaseDados.Commit;

  except
    if FPrincipal.BaseDados.InTransaction then
      FPrincipal.BaseDados.Rollback;
    Aviso('Erro ao fechar o caixa!');
  end;
  Tempo.Fecha;
end;

{************* refecha o caixa ******************************************** }
procedure TFReFechaCaixa.BFechaCaixaClick(Sender: TObject);
var
  VpfAlteracao : string;
begin
  // veririca permicao para alterar
  VpfAlteracao := '';
  FPermiteAlterar := TFPermiteAlterar.CriarSDI(Application, '', FPrincipal.VerificaPermisao('FPermiteAlterar'));
  if FPermiteAlterar.CarregaTipoAlterar('F', ParcialCOD_USUARIO.AsString, VpfAlteracao, config.SenhaAlteracao) then
  begin
    caixa.ReFechaCaixa( ParcialSEQ_DIARIO.AsInteger, ParcialSEQ_PARCIAL.AsInteger,
                        EValorDinheiroFechamento.AValor,
                        EValorChequeFechamento.AValor,
                        EValorOutrosFechamento.AValor );
    caixa.GeraAlteracao( ParcialSEQ_DIARIO.AsInteger, ParcialSEQ_PARCIAL.AsInteger,
                         strtoInt(VpfAlteracao), ParcialCOD_USUARIO.AsInteger, 0,'P');
  end;
  Case varia.TipoImpressoraAUT of
    0 : begin end;
    1 : begin
          AUT.AbrePorta;
          AUT.Imprime('___________________________________');
          Aut.ImprimeFormato(' REFECHAMENTO DE CAIXA ');
          AUT.Imprime('___________________________________');
          AUT.ImprimeFormato(lCaixaAtivo.Caption
                             + ' ' + datetostr(date)
                             + ' ' + timetostr(time));
          AUT.Imprime('___________________________________');
          AUT.ImprimeFormato('DINHEIRO      : ' + formatfloat('#0.00',Evalordinheirofechamento.AValor));
          AUT.ImprimeFormato('CHEQUES       : ' + formatfloat('#0.00',Evalorchequefechamento.AValor));
          AUT.ImprimeFormato('OUTROS        : ' + formatfloat('#0.00',Evaloroutrosfechamento.AValor));
          AUT.ImprimeFormato('TOTAL         : ' + formatfloat('#0.00',Evalorfechamento.AValor));
          AUT.ImprimeFormato('VALOR CORRETO : ' + formatfloat('#0.00',ECorretototal.AValor));
        end;
  end;
end;

procedure TFReFechaCaixa.BBAjudaClick(Sender: TObject);
begin
   Application.HelpCommand(HELP_CONTEXT,FReFechaCaixa.HelpContext);
end;

Initialization
  RegisterClasses([TFReFechaCaixa]);
end.
