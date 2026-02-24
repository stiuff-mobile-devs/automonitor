import 'package:automonitor/app/config/secrets.dart';
import 'package:automonitor/app/modules/user/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart'; // Para kIsWeb
// Alias para evitar conflito de nomes
import 'package:google_sign_in/google_sign_in.dart' as google;

class GoogleService {
  final auth = fb.FirebaseAuth.instance;
  final google.GoogleSignIn googleSignIn = google.GoogleSignIn.instance;
  final List<String> _scopes = ['email', 'profile'];

  // Inicialização v7: No Mobile, o serverClientId é essencial
  late final Future<void> _init = kIsWeb 
    ? Future.value() 
    : googleSignIn.initialize(serverClientId: Secrets.googleApiKey);

  GoogleService();

  Future<UserModel?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // --- ROTINA WEB (Sua versão que funciona) ---
        fb.GoogleAuthProvider authProvider = fb.GoogleAuthProvider();
        _scopes.forEach((scope) => authProvider.addScope(scope));
        authProvider.setCustomParameters({'client_id': Secrets.googleApiKey});

        fb.UserCredential result = await auth.signInWithPopup(authProvider);
        return _getUserModelFromFirebaseUser(result.user);
      } else {
        // --- ROTINA MOBILE (Sua versão v7 funcional) ---
        await _init;
        final googleUser = await googleSignIn.authenticate();
        return await _signInMobile(googleUser);
      }
    } catch (e) {
      print("Erro no login: $e");
      return null;
    }
  }

  Future<UserModel?> _signInMobile(google.GoogleSignInAccount googleUser) async {
    try {
      final google.GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Simplificação para Mobile: Firebase exige prioritariamente o idToken
      final credential = fb.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await auth.signInWithCredential(credential);
      return _getUserModelFromFirebaseUser(userCredential.user);
    } catch (e) {
      print("Erro na troca de tokens mobile: $e");
      return null;
    }
  }

  Future<UserModel?> signInSilently() async {
    try {
      if (auth.currentUser != null) {
        return _getUserModelFromFirebaseUser(auth.currentUser);
      }

      if (!kIsWeb) {
        await _init;
        final attempt = googleSignIn.attemptLightweightAuthentication();
        if (attempt == null) return null;
        final account = await attempt;
        return account != null ? await _signInMobile(account) : null;
      }
      return null;
    } catch (e) {
      print("ERRO NO LOGIN MOBILE: $e"); // Isso vai te dizer o código real do erro no terminal
      return null;
    }
  }

  UserModel? _getUserModelFromFirebaseUser(fb.User? user) {
    if (user == null) return null;
    return UserModel(
      id: user.uid,
      name: user.displayName ?? "",
      email: user.email ?? "",
    );
  }

  Future<void> signOut() async {
    if (!kIsWeb) await googleSignIn.signOut();
    await auth.signOut();
  }
}