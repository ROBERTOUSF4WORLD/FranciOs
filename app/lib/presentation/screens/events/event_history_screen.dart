import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/services/auth_service.dart';
import '../../../data/services/event_service.dart';

/// Tela de Historico do Event Engine.
///
/// Lista, em tempo real, os eventos de vida que o usuario registrou
/// (users/{uid}/events), do mais recente para o mais antigo. Cada
/// evento e o que alimenta o Life Engine no backend
/// (backend/functions/src/engines/lifeEngine.ts).
class EventHistoryScreen extends StatelessWidget {
  const EventHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = AuthService().currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Historico de eventos')),
      body: usuario == null
          ? const Center(child: Text('Usuario nao autenticado.'))
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(usuario.uid)
                  .collection('events')
                  .orderBy('criadoEm', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return const Center(
                    child: Text('Nenhum evento registrado ainda.'),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final dados = docs[index].data();
                    final tipo = _tipoFromString(dados['tipo'] as String?);
                    final valor = dados['valor'] as num?;
                    final observacao = dados['observacao'] as String?;
                    final criadoEm = (dados['criadoEm'] as Timestamp?)?.toDate();

                    return ListTile(
                      leading: CircleAvatar(child: Icon(_iconeDoTipo(tipo))),
                      title: Text(tipo?.label ?? (dados['tipo'] as String? ?? 'Evento')),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (observacao != null && observacao.isNotEmpty)
                            Text(observacao),
                          if (criadoEm != null)
                            Text(
                              DateFormat('dd/MM/yyyy HH:mm').format(criadoEm),
                              style: const TextStyle(fontSize: 12),
                            ),
                        ],
                      ),
                      trailing: valor != null ? Text('${valor.toInt()}') : null,
                    );
                  },
                );
              },
            ),
    );
  }

  LifeEventTipo? _tipoFromString(String? valor) {
    if (valor == null) return null;
    for (final tipo in LifeEventTipo.values) {
      if (tipo.name == valor) return tipo;
    }
    return null;
  }

  IconData _iconeDoTipo(LifeEventTipo? tipo) {
    switch (tipo) {
      case LifeEventTipo.sono:
        return Icons.bedtime;
      case LifeEventTipo.exercicio:
        return Icons.fitness_center;
      case LifeEventTipo.alimentacao:
        return Icons.restaurant;
      case LifeEventTipo.trabalho:
        return Icons.work;
      case LifeEventTipo.estudo:
        return Icons.school;
      case LifeEventTipo.financas:
        return Icons.attach_money;
      case LifeEventTipo.humor:
        return Icons.mood;
      case LifeEventTipo.estresse:
        return Icons.bolt;
      case LifeEventTipo.relacionamento:
        return Icons.favorite;
      case LifeEventTipo.habito:
        return Icons.check_circle;
      case LifeEventTipo.espiritualidade:
        return Icons.self_improvement;
      case null:
        return Icons.event;
    }
  }
}
