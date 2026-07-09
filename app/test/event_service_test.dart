import 'package:flutter_test/flutter_test.dart';
import 'package:francios/data/services/event_service.dart';

/// Testes unitarios do contrato 'LifeEventTipo' <-> Event Engine.
///
/// Estes testes nao dependem do Firebase (ao contrario das telas do
/// app, que instanciam servicos como AuthService/EventService com
/// FirebaseAuth.instance/FirebaseFunctions.instance). Por isso,
/// cobrem apenas a logica pura de mapeamento de categorias, que e
/// o contrato compartilhado com backend/functions/src/engines/types.ts.
void main() {
  group('LifeEventTipo', () {
    test('valor (enviado ao backend) corresponde ao nome do enum', () {
      expect(LifeEventTipo.sono.valor, 'sono');
      expect(LifeEventTipo.exercicio.valor, 'exercicio');
      expect(LifeEventTipo.espiritualidade.valor, 'espiritualidade');
    });

    test('todas as categorias possuem um rotulo (label) legivel e nao vazio', () {
      for (final tipo in LifeEventTipo.values) {
        expect(tipo.label, isNotEmpty);
      }
    });

    test('possui exatamente as 11 categorias definidas no Event Engine', () {
      // Deve permanecer sincronizado com LifeEventTipo em
      // backend/functions/src/engines/types.ts.
      expect(LifeEventTipo.values.length, 11);
    });

    test('nao ha rotulos duplicados entre categorias diferentes', () {
      final labels = LifeEventTipo.values.map((tipo) => tipo.label).toSet();
      expect(labels.length, LifeEventTipo.values.length);
    });
  });
}
