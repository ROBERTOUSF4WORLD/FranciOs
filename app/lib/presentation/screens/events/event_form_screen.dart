import 'package:flutter/material.dart';

import '../../../data/services/event_service.dart';

/// Tela do Event Engine: permite ao usuario registrar um evento de
/// vida (sono, exercicio, humor, etc.) que alimenta o Life Engine
/// (backend/functions/src/engines/lifeEngine.ts) via a Cloud
/// Function 'registerLifeEvent'.
class EventFormScreen extends StatefulWidget {
  const EventFormScreen({super.key});

  @override
  State<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _eventService = EventService();
  final _observacaoController = TextEditingController();

  LifeEventTipo _tipo = LifeEventTipo.humor;
  double _valor = 5;
  bool _enviando = false;

  @override
  void dispose() {
    _observacaoController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _enviando = true);

    try {
      await _eventService.registrarEvento(
        tipo: _tipo,
        valor: _valor,
        observacao: _observacaoController.text,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento registrado com sucesso!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao registrar evento: $e')),
      );
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar evento')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<LifeEventTipo>(
              value: _tipo,
              decoration: const InputDecoration(labelText: 'Categoria'),
              items: LifeEventTipo.values
                  .map(
                    (tipo) => DropdownMenuItem(
                      value: tipo,
                      child: Text(tipo.label),
                    ),
                  )
                  .toList(),
              onChanged: (tipo) {
                if (tipo != null) setState(() => _tipo = tipo);
              },
            ),
            const SizedBox(height: 24),
            Text('Intensidade: ${_valor.round()}'),
            Slider(
              value: _valor,
              min: 0,
              max: 10,
              divisions: 10,
              label: _valor.round().toString(),
              onChanged: (valor) => setState(() => _valor = valor),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _observacaoController,
              decoration: const InputDecoration(
                labelText: 'Observacao (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _enviando ? null : _salvar,
              child: _enviando
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Salvar evento'),
            ),
          ],
        ),
      ),
    );
  }
}
