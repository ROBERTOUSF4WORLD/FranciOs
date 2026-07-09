import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/services/auth_service.dart';
import 'widgets/life_chart_widget.dart';

/// Dashboard Inteligente.
///
/// Exibe o Life Score, as energias e os tres indices calculados pelo
/// Life Engine (backend/functions/src/engines/lifeEngine.ts), lidos
/// em tempo real do documento users/{uid} no Firestore. A integracao
/// com o Memory Engine e o Prediction Engine sera adicionada conforme
/// o backend evoluir (ver docs/Arquitetura.md).
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
            icon: const Icon(Icons.history),
            tooltip: 'Historico de eventos',
            onPressed: () => context.push('/events'),
          ),
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
                final indices =
                    (dados?['indices'] as Map<String, dynamic>?) ?? const {};

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
                    LifeChartWidget(uid: usuario.uid),
                    const SizedBox(height: 16),
                    if (indices.isNotEmpty) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Indices',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const SizedBox(height: 12),
                              _IndiceBar(
                                rotulo: 'Evolucao',
                                valor: (indices['evolucao'] as num?)?.toInt() ?? 0,
                              ),
                              const SizedBox(height: 12),
                              _IndiceBar(
                                rotulo: 'Recuperacao',
                                valor: (indices['recuperacao'] as num?)?.toInt() ?? 0,
                              ),
                              const SizedBox(height: 12),
                              _IndiceBar(
                                rotulo: 'Consistencia',
                                valor: (indices['consistencia'] as num?)?.toInt() ?? 0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
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
                        _ModuloChip(label: 'Saude', rota: '/modules/saude'),
                        _ModuloChip(label: 'Sono', rota: '/modules/sono'),
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

/// Exibe um indice do Life Engine (0-100) como um rotulo, o valor
/// numerico e uma barra de progresso proporcional.
class _IndiceBar extends StatelessWidget {
  const _IndiceBar({required this.rotulo, required this.valor});

  final String rotulo;
  final int valor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(rotulo),
            Text('$valor'),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (valor.clamp(0, 100)) / 100,
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

/// Chip de um modulo do FranciOS. Quando [rota] e informada, o chip
/// se torna clicavel e navega para a tela do modulo correspondente
/// (via go_router). Modulos ainda sem tela dedicada ficam sem rota.
class _ModuloChip extends StatelessWidget {
  const _ModuloChip({required this.label, this.rota});

  final String label;
  final String? rota;

  @override
  Widget build(BuildContext context) {
    final chip = Chip(label: Text(label));
    if (rota == null) return chip;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => context.push(rota!),
      child: chip,
    );
  }
}
