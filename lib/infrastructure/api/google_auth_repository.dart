import 'package:teja/infrastructure/api/google_auth_provider.dart';

class GoogleAuthRepository {
  final GoogleAuthProvider _googleAuthProvider;

  GoogleAuthRepository(this._googleAuthProvider);

  Future<void> signIn() async {
    final user = await _googleAuthProvider.signIn();
    if (user != null) {
      print('User signed in: $user');
    }
  }

  void signOut() {
    _googleAuthProvider.signOut();
  }
}
