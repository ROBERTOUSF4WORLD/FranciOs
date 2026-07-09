import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../data/services/auth_service.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/cadastro_screen.dart';
import '../../presentation/screens/dashboard/dashboard_screen.dart';
import '../../presentation/screens/events/event_form_screen.dart';
import '../../presentation/screens/events/event_history_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';

/// Configuracao central de rotas do FranciOS (go_router).
///
/// Redireciona automaticamente para /login quando o usuario nao
/// esta autenticado, e para /dashboard quando ja esta logado e
/// tenta acessar /login ou /cadastro.
GoRouter buildAppRouter(AuthService authService) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(authService.authStateChanges),
    redirect: (context, state) {
      final logado = authService.currentUser != null;
      final indoParaAuth = state.matchedLocation == '/login' ||
          state.matchedLocation == '/cadastro';

      if (!logado && !indoParaAuth) return '/login';
      if (logado && indoParaAuth) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/cadastro',
        builder: (context, state) => const CadastroScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/events/new',
        builder: (context, state) => const EventFormScreen(),
      ),
      GoRoute(
        path: '/events',
        builder: (context, state) => const EventHistoryScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}

/// Adapta uma Stream para o ChangeNotifier exigido pelo
/// 'refreshListenable' do go_router, permitindo que o router
/// reaja automaticamente a mudancas no estado de autenticacao.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
