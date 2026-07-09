import 'package:cloud_functions/cloud_functions.dart';

/// Categorias de evento aceitas pelo Event Engine / Life Engine.
/// Precisam espelhar 'LifeEventTipo' em
/// backend/functions/src/engines/types.ts.
enum LifeEventTipo {
  sono,
  exercicio,
  alimentacao,
  trabalho,
  estudo,
  financas,
  humor,
  estresse,
  relacionamento,
  habito,
  espiritualidade,
}

extension LifeEventTipoLabel on LifeEventTipo {
  String get valor => name;

  String get label {
    switch (this) {
      case LifeEventTipo.sono:
        return 'Sono';
      case LifeEventTipo.exercicio:
        return 'Exercicio';
      case LifeEventTipo.alimentacao:
        return 'Alimentacao';
      case LifeEventTipo.trabalho:
        return 'Trabalho';
      case LifeEventTipo.estudo:
        return 'Estudo';
      case LifeEventTipo.financas:
        return 'Financas';
      case LifeEventTipo.humor:
        return 'Humor';
      case LifeEventTipo.estresse:
        return 'Estresse';
      case LifeEventTipo.relacionamento:
        return 'Relacionamento';
      case LifeEventTipo.habito:
        return 'Habito';
      case LifeEventTipo.espiritualidade:
        return 'Espiritualidade';
    }
  }
}

/// Servico responsavel por falar com o Event Engine no backend.
///
/// Encapsula a chamada da Cloud Function 'registerLifeEvent', que
/// recebe o evento relatado pelo usuario, grava no Firestore e
/// aciona o Life Engine para recalcular o Life Score.
class EventService {
  EventService({FirebaseFunctions? functions})
      : _functions = functions ?? FirebaseFunctions.instance;

  final FirebaseFunctions _functions;

  Future<void> registrarEvento({
    required LifeEventTipo tipo,
    double? valor,
    String? observacao,
  }) async {
    final callable = _functions.httpsCallable('registerLifeEvent');

    try {
      await callable.call(<String, dynamic>{
        'tipo': tipo.valor,
        if (valor != null) 'valor': valor,
        if (observacao != null && observacao.trim().isNotEmpty)
          'observacao': observacao.trim(),
      });
    } on FirebaseFunctionsException catch (e) {
      throw Exception(e.message ?? 'Nao foi possivel registrar o evento.');
    }
  }
}
