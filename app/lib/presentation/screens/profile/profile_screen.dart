import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../data/services/auth_service.dart';

/// Tela de Perfil do usuario.
///
/// Exibe os dados basicos da conta (nome, email) e as informacoes
/// de evolucao vindas do Life Engine (Life Score, nivel, Franci
/// Points), lidas do documento users/{uid} no Firestore. Permite
/// editar o nome de exibicao.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  late final TextEditingController _nomeController;
  bool _editando = false;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(
      text: _authService.currentUser?.displayName ?? '',
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  Future<void> _salvarNome() async {
    final usuario = _authService.currentUser;
    if (usuario == null) return;

    final novoNome = _nomeController.text.trim();
    if (novoNome.isEmpty) return;

    setState(() => _salvando = true);

    try {
      await _authService.atualizarNome(novoNome);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(usuario.uid)
          .set({'nome': novoNome}, SetOptions(merge: true));

      if (!mounted) return;
      setState(() => _editando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nome atualizado com sucesso!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar nome: $e')),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuario = _authService.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
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
                final nivel = dados?['nivel'] as String? ?? 'Explorador';
                final franciPoints = (dados?['franciPoints'] as num?)?.toInt() ?? 0;

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    CircleAvatar(
                      radius: 40,
                      child: Text(
                        (usuario.displayName?.isNotEmpty ?? false)
                            ? usuario.displayName![0].toUpperCase()
                            : '?',
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_editando)
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _nomeController,
                              decoration: const InputDecoration(
                                labelText: 'Nome',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: _salvando
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.check),
                            onPressed: _salvando ? null : _salvarNome,
                          ),
                        ],
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            usuario.displayName ?? 'Explorador',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            onPressed: () => setState(() => _editando = true),
                          ),
                        ],
                      ),
                    Center(
                      child: Text(
                        usuario.email ?? '',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Evolucao', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const SizedBox(height: 12),
                            _InfoRow(label: 'Life Score', valor: '$lifeScore pontos'),
                            _InfoRow(label: 'Nivel', valor: nivel),
                            _InfoRow(label: 'Franci Points', valor: '$franciPoints'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton.icon(
                      onPressed: () => _authService.logout(),
                      icon: const Icon(Icons.logout),
                      label: const Text('Sair da conta'),
                    ),
                  ],
                );
              },
            ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.valor});

  final String label;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(valor, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
