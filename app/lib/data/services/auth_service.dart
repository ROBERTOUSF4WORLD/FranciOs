import 'package:firebase_auth/firebase_auth.dart';

/// Servico responsavel por encapsular toda a comunicacao com o
/// Firebase Authentication (login, cadastro, logout, estado do
/// usuario atual). Mantem a UI desacoplada do SDK do Firebase.
class AuthService {
  AuthService({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  /// Stream com o usuario atual (null quando deslogado).
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential> login({
    required String email,
    required String senha,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );
  }

  Future<UserCredential> cadastrar({
    required String email,
    required String senha,
    required String nome,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );

    await credential.user?.updateDisplayName(nome.trim());

    // O documento em /users/{uid} e criado automaticamente pela
    // Cloud Function 'onUserCreated' (ver backend/functions/src/index.ts).

    return credential;
  }

  Future<void> logout() {
    return _firebaseAuth.signOut();
  }

  Future<void> recuperarSenha(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

  /// Traduz os codigos de erro do FirebaseAuth para mensagens
  /// legiveis em portugues.
  String traduzirErro(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'Nenhuma conta encontrada com este e-mail.';
        case 'wrong-password':
          return 'Senha incorreta.';
        case 'email-already-in-use':
          return 'Ja existe uma conta com este e-mail.';
        case 'invalid-email':
          return 'E-mail invalido.';
        case 'weak-password':
          return 'A senha precisa ter pelo menos 6 caracteres.';
        default:
          return 'Erro de autenticacao: ${error.message}';
      }
    }
    return 'Ocorreu um erro inesperado. Tente novamente.';
  }
}
