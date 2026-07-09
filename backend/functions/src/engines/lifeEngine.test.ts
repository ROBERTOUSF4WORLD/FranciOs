import { aplicarEvento, calcularIndices, calcularLifeScore, clamp, ENERGIAS_BASE } from "./lifeEngine";
import { EnergyBreakdown, LifeEvent } from "./types";

describe("clamp", () => {
  it("mantem valores dentro do intervalo padrao (0-100)", () => {
    expect(clamp(150)).toBe(100);
    expect(clamp(-10)).toBe(0);
    expect(clamp(42)).toBe(42);
  });

  it("respeita limites customizados", () => {
    expect(clamp(10, 0, 5)).toBe(5);
    expect(clamp(-3, 0, 5)).toBe(0);
  });
});

describe("calcularLifeScore", () => {
  it("retorna a media das seis energias, arredondada", () => {
    expect(calcularLifeScore(ENERGIAS_BASE)).toBe(50);
  });

  it("reflete corretamente energias desbalanceadas", () => {
    const energias: EnergyBreakdown = {
      ...ENERGIAS_BASE,
      fisica: 100,
      mental: 0,
    };
    // media = (100 + 0 + 50 + 50 + 50 + 50) / 6 = 50
    expect(calcularLifeScore(energias)).toBe(50);
  });
});

describe("aplicarEvento", () => {
  it("aumenta a energia fisica e mental ao registrar sono", () => {
    const evento: LifeEvent = { tipo: "sono", valor: 1 };
    const resultado = aplicarEvento(ENERGIAS_BASE, evento);

    expect(resultado.fisica).toBeGreaterThan(ENERGIAS_BASE.fisica);
    expect(resultado.mental).toBeGreaterThan(ENERGIAS_BASE.mental);
    // Energias nao relacionadas ao sono permanecem inalteradas.
    expect(resultado.financeira).toBe(ENERGIAS_BASE.financeira);
  });

  it("reduz a energia emocional e mental ao registrar estresse", () => {
    const evento: LifeEvent = { tipo: "estresse", valor: 1 };
    const resultado = aplicarEvento(ENERGIAS_BASE, evento);

    expect(resultado.emocional).toBeLessThan(ENERGIAS_BASE.emocional);
    expect(resultado.mental).toBeLessThan(ENERGIAS_BASE.mental);
  });

  it("escala o impacto pela intensidade do evento (campo valor)", () => {
    const eventoFraco: LifeEvent = { tipo: "exercicio", valor: 1 };
    const eventoForte: LifeEvent = { tipo: "exercicio", valor: 5 };

    const resultadoFraco = aplicarEvento(ENERGIAS_BASE, eventoFraco);
    const resultadoForte = aplicarEvento(ENERGIAS_BASE, eventoForte);

    expect(resultadoForte.fisica).toBeGreaterThan(resultadoFraco.fisica);
  });

  it("nunca ultrapassa o limite maximo de 100", () => {
    const energiasNoTopo: EnergyBreakdown = { ...ENERGIAS_BASE, espiritual: 99 };
    const evento: LifeEvent = { tipo: "espiritualidade", valor: 5 };
    const resultado = aplicarEvento(energiasNoTopo, evento);

    expect(resultado.espiritual).toBeLessThanOrEqual(100);
  });

  it("ignora tipos de evento desconhecidos sem alterar as energias", () => {
    const evento: LifeEvent = { tipo: "tipo-inexistente", valor: 3 };
    const resultado = aplicarEvento(ENERGIAS_BASE, evento);

    expect(resultado).toEqual(ENERGIAS_BASE);
  });
});

describe("calcularIndices", () => {
  it("retorna valores neutros (50) quando ha menos de 2 pontos no historico", () => {
    const indices = calcularIndices([ENERGIAS_BASE], 1);
    expect(indices).toEqual({ evolucao: 50, recuperacao: 50, consistencia: 50 });
  });

  it("aumenta a evolucao quando o Life Score melhora entre os dois ultimos pontos", () => {
    const energiasMelhores: EnergyBreakdown = { ...ENERGIAS_BASE, fisica: 80 };
    const indices = calcularIndices([ENERGIAS_BASE, energiasMelhores], 5);

    expect(indices.evolucao).toBeGreaterThan(50);
  });

  it("reduz a evolucao quando o Life Score piora entre os dois ultimos pontos", () => {
    const energiasPiores: EnergyBreakdown = { ...ENERGIAS_BASE, fisica: 20 };
    const indices = calcularIndices([ENERGIAS_BASE, energiasPiores], 5);

    expect(indices.evolucao).toBeLessThan(50);
  });

  it("aumenta a recuperacao quando o score sobe apos uma queda", () => {
    // Historico: base (50) -> queda (menor) -> recuperacao acima da queda.
    const queda: EnergyBreakdown = { ...ENERGIAS_BASE, fisica: 20, mental: 20 };
    const recuperado: EnergyBreakdown = { ...ENERGIAS_BASE, fisica: 70 };
    const indices = calcularIndices([ENERGIAS_BASE, queda, recuperado], 5);

    expect(indices.recuperacao).toBeGreaterThan(50);
  });

  it("mantem a recuperacao neutra (50) quando o score atual e o menor do historico", () => {
    // O ponto atual e o mais baixo -> nao houve recuperacao.
    const queda: EnergyBreakdown = { ...ENERGIAS_BASE, fisica: 20, mental: 20 };
    const indices = calcularIndices([ENERGIAS_BASE, queda], 5);

    expect(indices.recuperacao).toBe(50);
  });

  it("calcula a consistencia proporcional quando ha poucos eventos recentes", () => {
    // 3 eventos * 10 = 30 (abaixo do teto de 100).
    const indices = calcularIndices([ENERGIAS_BASE, ENERGIAS_BASE], 3);
    expect(indices.consistencia).toBe(30);
  });

  it("aumenta a consistencia com mais eventos recentes, ate o teto de 100", () => {
    const indices = calcularIndices([ENERGIAS_BASE, ENERGIAS_BASE], 20);
    expect(indices.consistencia).toBe(100);
  });
});
