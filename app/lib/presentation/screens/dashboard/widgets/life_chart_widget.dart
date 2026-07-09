import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Grafico de evolucao do Life Score.
///
/// Le a serie historica gravada pelo Life Engine em
/// users/{uid}/lifeScoreHistory (ver
/// backend/functions/src/engines/lifeEngine.ts) e desenha uma linha
/// com a evolucao do Life Score ao longo do tempo, usando fl_chart.
///
/// Cada registro em lifeScoreHistory corresponde a um recalculo
/// disparado por um novo evento de vida (Event Engine).
class LifeChartWidget extends StatelessWidget {
  const LifeChartWidget({super.key, required this.uid});

  /// UID do usuario autenticado cujo historico sera exibido.
  final String uid;

  /// Numero maximo de pontos exibidos no grafico (janela recente).
  static const int _limite = 30;

  @override
  Widget build(BuildContext context) {
    final stream = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('lifeScoreHistory')
        .orderBy('criadoEm', descending: true)
        .limit(_limite)
        .snapshots();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Evolucao do Life Score',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data?.docs ?? const [];
                  if (docs.length < 2) {
                    return const Center(
                      child: Text(
                        'Registre mais eventos para ver sua evolucao.',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  // A query vem em ordem decrescente (mais recente
                  // primeiro); invertemos para desenhar da esquerda
                  // (mais antigo) para a direita (mais recente).
                  final pontos = docs.reversed.toList();
                  final spots = <FlSpot>[
                    for (var i = 0; i < pontos.length; i++)
                      FlSpot(
                        i.toDouble(),
                        ((pontos[i].data()['lifeScore'] as num?) ?? 0)
                            .toDouble(),
                      ),
                  ];

                  return LineChart(
                    LineChartData(
                      minY: 0,
                      maxY: 100,
                      gridData: const FlGridData(show: true),
                      titlesData: const FlTitlesData(
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 32,
                            interval: 25,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          barWidth: 3,
                          color: Theme.of(context).colorScheme.primary,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.15),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
