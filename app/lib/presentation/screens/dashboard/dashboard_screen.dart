import 'package:flutter/material.dart';

import '../../../data/services/auth_service.dart';

/// Dashboard Inteligente (versao inicial/placeholder).
///
/// Nesta primeira versao exibe apenas um layout basico com o
/// Life Score e atalhos para os modulos. A integracao real com o
/// Life Engine, Memory Engine e Prediction Engine (ver docs/) sera
/// adicionada conforme o backend evoluir.
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
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () => authService.logout(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Ola, ${usuario?.displayName ?? 'explorador'}!',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Life Score', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('0 pontos (aguardando primeiros eventos)'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
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
      ),
    );
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
