import * as admin from "firebase-admin";
import { EnergyBreakdown, LifeEvent, LifeIndices, LifeScoreResult } from "./types";

/**
 * Life Engine (versao inicial)
 * ------------------------------------------------------------------
 * Motor matematico responsavel por transformar eventos brutos
 * (registrados pelo Event Engine) em metricas de vida: Life Score,
 * as seis energias e os tres indices descritos em docs/LifeEngine.md
 * e no README do projeto.
 *
 * Esta e uma primeira versao deterministica e auditavel (sem IA/ML),
 * pensada para ser facil de explicar ao usuario (principio de
 * "explicabilidade" do Manifesto da IA). Uma versao futura podera
 * substituir os pesos fixos abaixo por um modelo aprendido pelo
 * Memory Engine, mantendo a mesma interface de entrada/saida.
 */

// Cada tipo de evento afeta um subconjunto das seis energias.
// Os pesos vao de -1 (impacto negativo) a +1 (impacto positivo).
const IMPACTO_POR_TIPO: Record<string, Partial<EnergyBreakdown>> = {
  sono: { fisica: 0.8, mental: 0.5 },
  exercicio: { fisica: 1, mental: 0.4, emocional: 0.3 },
  alimentacao: { fisica: 0.6 },
  trabalho: { financeira: 0.5, mental: -0.2 },
  estudo: { mental: 0.7 },
  financas: { financeira: 0.8 },
  humor: { emocional: 0.8 },
  estresse: { emocional: -0.8, mental: -0.5 },
  relacionamento: { social: 0.8, emocional: 0.3 },
  habito: { mental: 0.3, fisica: 0.2 },
  espiritualidade: { espiritual: 1 },
};

export const ENERGIAS_BASE: EnergyBreakdown = {
  fisica: 50,
  mental: 50,
  emocional: 50,
  financeira: 50,
  social: 50,
  espiritual: 50,
};

/** Mantem um valor dentro de um intervalo (0-100 por padrao). */
export function clamp(valor: number, min = 0, max = 100): number {
  return Math.min(max, Math.max(min, valor));
}

/**
 * Aplica o impacto de um unico evento sobre as energias atuais.
 * O parametro 'valor' do evento (ex: horas de sono, intensidade do
 * treino) atua como multiplicador do impacto padrao do tipo.
 *
 * Exportada para permitir testes unitarios diretos (ver
 * lifeEngine.test.ts), sem depender do Firestore.
 */
export function aplicarEvento(energias: EnergyBreakdown, evento: LifeEvent): EnergyBreakdown {
  const impacto = IMPACTO_POR_TIPO[evento.tipo] ?? {};
  const intensidade = clamp(evento.valor ?? 1, 0, 5); // 0..5, padrao 1
  const atualizado = { ...energias };

  for (const chave of Object.keys(impacto) as (keyof EnergyBreakdown)[]) {
    const delta = (impacto[chave] ?? 0) * intensidade * 4; // escala de ajuste
    atualizado[chave] = clamp(atualizado[chave] + delta);
  }

  return atualizado;
}

/** Calcula o Life Score (media das seis energias, arredondada). */
export function calcularLifeScore(energias: EnergyBreakdown): number {
  const valores = Object.values(energias);
  const media = valores.reduce((soma, v) => soma + v, 0) / valores.length;
  return Math.round(media);
}

/** Calcula os tres indices (evolucao, recuperacao, consistencia). */
export function calcularIndices(
  historico: EnergyBreakdown[],
  eventosRecentes: number,
): LifeIndices {
  if (historico.length < 2) {
    return { evolucao: 50, recuperacao: 50, consistencia: 50 };
  }

  const scoreAnterior = calcularLifeScore(historico[historico.length - 2]);
  const scoreAtual = calcularLifeScore(historico[historico.length - 1]);

  // Evolucao: tendencia de melhora do Life Score ao longo do tempo.
  const evolucao = clamp(50 + (scoreAtual - scoreAnterior) * 5);

  // Recuperacao: capacidade de subir o score apos uma queda.
  const menorScore = Math.min(...historico.map(calcularLifeScore));
  const recuperacao = clamp(50 + (scoreAtual - menorScore) * 2);

  // Consistencia: baseada na frequencia de eventos registrados
  // (aproximacao simples; versoes futuras devem considerar janelas
  // de tempo reais via Memory Engine).
  const consistencia = clamp(Math.min(100, eventosRecentes * 10));

  return { evolucao, recuperacao, consistencia };
}

/**
 * Recalcula o Life Score completo de um usuario a partir do
 * historico de eventos armazenados em users/{uid}/events.
 */
export async function recalcularLifeScore(
  db: FirebaseFirestore.Firestore,
  uid: string,
): Promise<LifeScoreResult> {
  const eventosSnapshot = await db
    .collection("users")
    .doc(uid)
    .collection("events")
    .orderBy("criadoEm", "asc")
    .limitToLast(50) // janela recente; Memory Engine cuidara do longo prazo
    .get();

  const eventos = eventosSnapshot.docs.map((doc) => doc.data() as LifeEvent);

  const historicoEnergias: EnergyBreakdown[] = [ENERGIAS_BASE];
  for (const evento of eventos) {
    const anterior = historicoEnergias[historicoEnergias.length - 1];
    historicoEnergias.push(aplicarEvento(anterior, evento));
  }

  const energiasFinal = historicoEnergias[historicoEnergias.length - 1];
  const lifeScore = calcularLifeScore(energiasFinal);
  const indices = calcularIndices(historicoEnergias, eventos.length);

  const resultado: LifeScoreResult = {
    lifeScore,
    energias: energiasFinal,
    indices,
    atualizadoEm: admin.firestore.FieldValue.serverTimestamp(),
  };

  await db.collection("users").doc(uid).set(
    {
      lifeScore: resultado.lifeScore,
      energias: resultado.energias,
      indices: resultado.indices,
      lifeScoreAtualizadoEm: resultado.atualizadoEm,
    },
    { merge: true },
  );

  // Registra um snapshot na serie historica users/{uid}/lifeScoreHistory
  // para permitir a visualizacao da evolucao do Life Score ao longo do
  // tempo (grafico no Dashboard). Cada evento gera um novo ponto.
  await db
    .collection("users")
    .doc(uid)
    .collection("lifeScoreHistory")
    .add({
      lifeScore: resultado.lifeScore,
      energias: resultado.energias,
      criadoEm: admin.firestore.FieldValue.serverTimestamp(),
    });

  return resultado;
}
