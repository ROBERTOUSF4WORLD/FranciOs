import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../data/services/auth_service.dart';

/// Tela do modulo Saude.
///
/// Primeiro modulo dedicado do FranciOS. Consolida, em um so lugar,
/// a energia Fisica do usuario (calculada pelo Life Engine em
/// backend/functions/src/engines/lifeEngine.ts) e o historico dos
/// eventos que impactam a saude fisica: sono, exercicio, alimentacao
/// e habito. Le tudo em tempo real do Firestore (users/{uid}).
///
/// A criacao de novos eventos reaproveita o fluxo ja existente do
/// Event Engine (/events/new), evitando duplicar a logica de
/// registro. Modulos futuros (Sono, Financas, etc.) devem seguir
/// este mesmo padrao.
class SaudeScreen extends StatelessWidget {
  const SaudeScreen({super.key});

  /// Tipos de evento (LifeEventTipo no backend) associados a saude fisica.
  static const Set<String> _tiposSaude = {
    'sono',
    'exercicio',
    'alimentacao',
    'habito',
  };

  @override
  Widget build(BuildContext context) {
    final usuario = AuthService().currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Saude')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/events/new'),
        icon: const Icon(Icons.add),
        label: const Text('Registrar evento'),
      ),
      body: usuario == null
          ? const Center(child: Text('Usuario nao autenticado.'))
          : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(usuario.uid)
                  .snapshots(),
              builder: (context, userSnapshot) {
                final dados = userSnapshot.data?.data();
                final energias =
                    (dados?['energias'] as Map<String, dynamic>?) ?? const {};
                final fisica =
                    (energias['fisica'] as num?)?.toInt() ?? 0;

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _EnergiaFisicaCard(
                      valor: fisica,
                      carregando: userSnapshot.connectionState ==
                          ConnectionState.waiting,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Eventos de saude',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    _HistoricoSaude(uid: usuario.uid),
                  ],
                );
              },
            ),
    );
  }
}

/// Cartao de destaque com a energia Fisica atual (0-100).
class _EnergiaFisicaCard extends StatelessWidget {
  const _EnergiaFisicaCard({required this.valor, required this.carregando});

  final int valor;
  final bool carregando;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.favorite, color: Colors.redAccent),
                SizedBox(width: 8),
                Text(
                  'Energia Fisica',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              carregando ? 'Carregando...' : '$valor / 100',
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (valor.clamp(0, 100)) / 100,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Registre sono, exercicio, alimentacao e habitos para '
              'melhorar sua energia fisica.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

/// Lista, em tempo real, apenas os eventos de saude do usuario.
class _HistoricoSaude extends StatelessWidget {
  const _HistoricoSaude({required this.uid});

  final String uid;

  static const Map<String, IconData> _icones = {
    'sono': Icons.bedtime,
    'exercicio': Icons.fitness_center,
    'alimentacao': Icons.restaurant,
    'habito': Icons.repeat,
  };

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('events')
          .where('tipo', whereIn: SaudeScreen._tiposSaude.toList())
          .orderBy('criadoEm', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text('Nenhum evento de saude registrado ainda.'),
            ),
          );
        }

        return Column(
          children: docs.map((doc) {
            final dados = doc.data();
            final tipo = dados['tipo'] as String? ?? 'evento';
            final valor = dados['valor'] as num?;
            final observacao = dados['observacao'] as String?;
            final criadoEm = (dados['criadoEm'] as Timestamp?)?.toDate();
            final dataFmt = criadoEm != null
                ? DateFormat('dd/MM/yyyy HH:mm').format(criadoEm)
                : null;

            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(_icones[tipo] ?? Icons.circle),
                ),
                title: Text(_capitalizar(tipo)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (valor != null) Text('Valor: $valor'),
                    if (observacao != null && observacao.isNotEmpty)
                      Text(observacao),
                    if (dataFmt != null)
                      Text(
                        dataFmt,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  String _capitalizar(String texto) {
    if (texto.isEmpty) return texto;
    return texto[0].toUpperCase() + texto.substring(1);
  }
}
