import * as admin from "firebase-admin";
import { auth } from "firebase-functions/v1";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { recalcularLifeScore } from "./engines/lifeEngine";

admin.initializeApp();
const db = admin.firestore();

/**
 * FranciOS - Cloud Functions (esqueleto inicial)
 *
 * Estas funcoes representam o ponto de partida do backend descrito
 * em docs/Arquitetura.md e docs/EventEngine.md. A medida que o
 * projeto evoluir, cada "motor" (Event, Life, Memory, Prediction)
 * deve ganhar seu proprio modulo dentro de src/engines/.
 */

// ------------------------------------------------------------------
// 1. Trigger de cadastro: cria o documento inicial do usuario quando
//    uma nova conta e criada no Firebase Authentication.
// ------------------------------------------------------------------
export const onUserCreated = auth.user().onCreate(async (user) => {
  const profile = {
    uid: user.uid,
    email: user.email ?? null,
    nome: user.displayName ?? null,
    criadoEm: admin.firestore.FieldValue.serverTimestamp(),
    lifeScore: 50,
    nivel: "Explorador",
    franciPoints: 0,
  };

  await db.collection("users").doc(user.uid).set(profile, { merge: true });
});

// ------------------------------------------------------------------
// 2. Event Engine + Life Engine: registra um evento de vida enviado
//    pelo app (ex: dormiu, treinou, estudou) e aciona o Life Engine
//    para recalcular o Life Score, as energias e os indices.
// ------------------------------------------------------------------
export const registerLifeEvent = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Usuario nao autenticado.");
  }

  const uid = request.auth.uid;
  const { tipo, valor, observacao } = request.data as {
    tipo: string;
    valor?: number;
    observacao?: string;
  };

  if (!tipo) {
    throw new HttpsError("invalid-argument", "O campo 'tipo' e obrigatorio.");
  }

  const eventRef = db
    .collection("users")
    .doc(uid)
    .collection("events")
    .doc();

  await eventRef.set({
    tipo,
    valor: valor ?? null,
    observacao: observacao ?? null,
    criadoEm: admin.firestore.FieldValue.serverTimestamp(),
  });

  // Aciona o Life Engine para recalcular Life Score, energias e
  // indices com base no historico atualizado de eventos.
  const lifeScoreResult = await recalcularLifeScore(db, uid);

  return {
    success: true,
    eventId: eventRef.id,
    lifeScore: lifeScoreResult.lifeScore,
    energias: lifeScoreResult.energias,
    indices: lifeScoreResult.indices,
  };
});
