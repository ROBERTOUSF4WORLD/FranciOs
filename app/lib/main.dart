import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

/// Ponto de entrada do FranciOS.
///
/// Este arquivo e um esqueleto inicial (Versao 0.1 do roadmap):
/// inicializa o Firebase e carrega a tela inicial (splash/login).
/// Os modulos completos (Life Engine, Memory Engine, especialistas,
/// dashboard etc.) devem ser adicionados em lib/presentation e
/// lib/domain conforme a arquitetura definida em docs/Arquitetura.md.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: gerar firebase_options.dart com o FlutterFire CLI
  // (flutterfire configure) e descomentar a linha abaixo.
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const FranciOSApp());
}

class FranciOSApp extends StatelessWidget {
  const FranciOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FranciOS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const HomePlaceholderScreen(),
    );
  }
}

/// Tela inicial provisoria ate a implementacao do fluxo real de
/// autenticacao (login/cadastro) e do Dashboard Inteligente.
class HomePlaceholderScreen extends StatelessWidget {
  const HomePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FranciOS')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'O Sistema Operacional da Vida\n\nEsqueleto inicial do app.\nProximo passo: implementar Login, Cadastro e Dashboard Inteligente.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
