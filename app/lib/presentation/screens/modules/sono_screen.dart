import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../data/services/auth_service.dart';

/// Tela do modulo Sono.
///
/// Segundo modulo dedicado do FranciOS, construido sobre o mesmo
/// padrao do modulo Saude (ver saude_screen.dart). O evento 'sono'
/// impacta principalmente a energia Mental (recuperacao cognitiva) e,
/// de forma secundaria, a Fisica, conforme os pesos definidos no
/// Life Engine (backend/functions/src/engines/lifeEngine.ts).
///
/// Le tudo em tempo real do Firestore (users/{uid}) e reaproveita o
/// fluxo de registro do Event Engine (/events/new) para criar novos
/// registros de sono, sem duplicar logica.
class SonoScreen extends StatelessWidget {
  const SonoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = AuthService().currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Sono')),
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
                final mental = (energias['mental'] as num?)?.toInt() ?? 0;
                final fisica = (energias['fisica'] as num?)?.toInt() ?? 0;
                final carregando = userSnapshot.connectionState ==
                    ConnectionState.waiting;

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _EnergiaCard(
                      titulo: 'Energia Mental',
                      icone: Icons.psychology,
                      cor: Colors.indigo,
                      valor: mental,
                      carregando: carregando,
                    ),
                    const SizedBox(height: 12),
                    _EnergiaCard(
                      titulo: 'Energia Fisica',
                      icone: Icons.favorite,
                      cor: Colors.redAccent,
                      valor: fisica,
                      carregando: carregando,
                    ),
                    const SizedBox(height: 12),
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Registrar seu sono ajuda a recuperar as energias '
                          'Mental e Fisica. Anote as horas dormidas no campo '
                          '"valor" ao criar um evento de sono.',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Registros de sono',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    _HistoricoSono(uid: usuario.uid),
                  ],
                );
              },
            ),
    );
  }
}

/// Cartao de destaque de uma energia (0-100), reutilizavel dentro do
/// modulo Sono para exibir Mental e Fisica lado a lado.
class _EnergiaCard extends StatelessWidget {
  const _EnergiaCard({
    required this.titulo,
    required this.icone,
    required this.cor,
    required this.valor,
    required this.carregando,
  });

  final String titulo;
  final IconData icone;
  final Color cor;
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
              children: [
                Icon(icone, color: cor),
                const SizedBox(width: 8),
                Text(
                  titulo,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
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
          ],
        ),
      ),
    );
  }
}

/// Lista, em tempo real, apenas os eventos do tipo 'sono' do usuario.
class _HistoricoSono extends StatelessWidget {
  const _HistoricoSono({required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('events')
          .where('tipo', isEqualTo: 'sono')
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
              child: Text('Nenhum registro de sono ainda.'),
            ),
          );
        }

        return Column(
          children: docs.map((doc) {
            final dados = doc.data();
            final valor = dados['valor'] as num?;
            final observacao = dados['observacao'] as String?;
            final criadoEm = (dados['criadoEm'] as Timestamp?)?.toDate();
            final dataFmt = criadoEm != null
                ? DateFormat('dd/MM/yyyy HH:mm').format(criadoEm)
                : null;

            return Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.bedtime)),
                title: Text(
                  valor != null ? '$valor horas' : 'Sono',
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
}
