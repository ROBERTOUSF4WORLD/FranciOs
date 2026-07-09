/**
 * Tipos compartilhados pelos "motores" do FranciOS (Event Engine,
 * Life Engine, Memory Engine, Prediction Engine). Mantidos em um
 * unico arquivo para facilitar a evolucao do dominio conforme
 * descrito em docs/Arquitetura.md.
 */

/** Categorias de evento aceitas pelo Event Engine / Life Engine. */
export type LifeEventTipo =
  | "sono"
  | "exercicio"
  | "alimentacao"
  | "trabalho"
  | "estudo"
  | "financas"
  | "humor"
  | "estresse"
  | "relacionamento"
  | "habito"
  | "espiritualidade";

export interface LifeEvent {
  tipo: LifeEventTipo | string;
  valor?: number | null;
  observacao?: string | null;
  criadoEm?: FirebaseFirestore.Timestamp;
}

/** As seis "energias" que compoem o Life Score (ver README/docs). */
export interface EnergyBreakdown {
  fisica: number;
  mental: number;
  emocional: number;
  financeira: number;
  social: number;
  espiritual: number;
}

export interface LifeIndices {
  evolucao: number;
  recuperacao: number;
  consistencia: number;
}

export interface LifeScoreResult {
  lifeScore: number;
  energias: EnergyBreakdown;
  indices: LifeIndices;
  atualizadoEm: FirebaseFirestore.FieldValue;
}
