import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/services/auth_service.dart';

/// Dashboard Inteligente.
///
/// Exibe o Life Score e as energias calculadas pelo Life Engine
/// (backend/functions/src/engines/lifeEngine.ts), lidos em tempo
/// real do documento users/{uid} no Firestore. A integracao com o
/// Memory Engine e o Prediction Engine sera adicionada conforme o
/// backend evoluir (ver docs/Arquitetura.md).
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final usuario = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Perfil',
            onPressed: () => context.push('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () => authService.logout(),
          ),
        ],
      ),
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
              builder: (context, snapshot) {
                final dados = snapshot.data?.data();
                final lifeScore = (dados?['lifeScore'] as num?)?.toInt() ?? 0;
                final energias =
                    (dados?['energias'] as Map<String, dynamic>?) ?? const {};

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      'Ola, ${usuario.displayName ?? 'explorador'}!',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Life Score', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(
                              snapshot.connectionState == ConnectionState.waiting
                                  ? 'Carregando...'
                                  : '$lifeScore pontos',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (energias.isNotEmpty) ...[
                      const Text('Energias', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 8),
                      ...energias.entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_capitalizar(entry.key)),
                              Text('${(entry.value as num).toInt()}'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    const Text('Modulos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: const [
                        _ModuloChip(label: 'Saude'),
                        _ModuloChip(label: 'Sono'),
                        _ModuloChip(label: 'Financas'),
                        _ModuloChip(label: 'Estudos'),
                        _ModuloChip(label: 'Habitos'),
                        _ModuloChip(label: 'Humor'),
                      ],
                    ),
                  ],
                );
              },
            ),
    );
  }

  String _capitalizar(String texto) {
    if (texto.isEmpty) return texto;
    return texto[0].toUpperCase() + texto.substring(1);
  }
}

class _ModuloChip extends StatelessWidget {
  const _ModuloChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label));
  }
}
