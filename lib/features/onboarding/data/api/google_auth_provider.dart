import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthProvider {
  final GoogleSignIn _googleSignIn;

  GoogleAuthProvider({
    required String clientId,
    required String serverClientId,
  }) : _googleSignIn = GoogleSignIn(
          clientId: clientId,
          serverClientId: serverClientId,
        );

  Future<GoogleSignInAccount?> signIn() async {
    try {
      return await _googleSignIn.signIn();
    } catch (error) {
      print('Error signing in: $error');
      return null;
    }
  }

  void signOut() {
    _googleSignIn.disconnect();
  }
}
