import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/router/app_router.dart';
import 'data/services/auth_service.dart';

/// Ponto de entrada do FranciOS.
///
/// Versao 0.1 do roadmap: inicializa o Firebase e carrega o fluxo
/// de autenticacao (Login/Cadastro) seguido do Dashboard Inteligente.
/// Os modulos completos (Life Engine, Memory Engine, especialistas
/// etc.) devem ser adicionados conforme a arquitetura definida em
/// docs/Arquitetura.md.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: gerar firebase_options.dart com o FlutterFire CLI
  // (flutterfire configure) e passar via 'options:' abaixo:
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Firebase.initializeApp();

  runApp(FranciOSApp(authService: AuthService()));
}

class FranciOSApp extends StatelessWidget {
  const FranciOSApp({super.key, required this.authService});

  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    final router = buildAppRouter(authService);

    return MaterialApp.router(
      title: 'FranciOS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      routerConfig: router,
    );
  }
}
