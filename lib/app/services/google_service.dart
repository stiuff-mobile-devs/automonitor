import 'package:automonitor/app/config/secrets.dart';
import 'package:automonitor/app/modules/user/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart'; // Para kIsWeb
// Alias para evitar conflito de nomes
import 'package:google_sign_in/google_sign_in.dart' as google;

class GoogleService {
  final auth = fb.FirebaseAuth.instance;

  // CORREÇÃO DEFINITIVA DO CONSTRUTOR:
  // Na v7, usamos o Singleton '.instance'.
  // Não passamos 'clientId' nem 'scopes' aqui, pois o construtor antigo sumiu.
  final google.GoogleSignIn googleSignIn = google.GoogleSignIn.instance;

  // Lista de escopos centralizada
  final List<String> _scopes = ['email', 'profile'];

  GoogleService();

  Future<void> _ensureInitialized() async {
    // Inicialização apenas para Mobile (Web usa fluxo puro do Firebase)
    if (!kIsWeb) {
      await googleSignIn.initialize();
    }
  }

  Future<UserModel?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // --- WEB: FLUXO COM SECRETS ---
        // Aqui está o pulo do gato: Configuramos o Provider do Firebase
        // com o seu CLIENT ID do Secrets. Assim não precisa por no HTML.
        
        fb.GoogleAuthProvider authProvider = fb.GoogleAuthProvider();
        
        // Adiciona os escopos
        _scopes.forEach((scope) => authProvider.addScope(scope));
        
        // Injeta o ClientID via parâmetros customizados
        authProvider.setCustomParameters({
          'client_id': Secrets.googleApiKey, 
        });

        // Abre o popup usando essa configuração segura
        fb.UserCredential result = await auth.signInWithPopup(authProvider);
        return _getUserModelFromFirebaseUser(result.user);
        
      } else {
        // --- MOBILE: FLUXO NATIVO v7 ---
        await _ensureInitialized(); 

        try {
          // Na v7, passamos os scopes aqui se necessário, 
          // mas o arquivo google-services.json gerencia a maioria.
          // Usamos 'authenticate' em vez de 'signIn'.
          final google.GoogleSignInAccount account = await googleSignIn.authenticate();
          
          return await _signInMobile(account);
        } catch (e) {
          print("Erro login mobile: $e");
          return null;
        }
      }
    } catch (e) {
      print("Erro geral: $e");
      return null;
    }
  }

  Future<UserModel?> _signInMobile(google.GoogleSignInAccount googleUser) async {
    try {
      final google.GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // v7: Recupera Access Token via authorizationClient
      final authClient = googleSignIn.authorizationClient;
      final authorization = await authClient.authorizationForScopes(_scopes);

      final credential = fb.GoogleAuthProvider.credential(
        accessToken: authorization?.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await auth.signInWithCredential(credential);
      return _getUserModelFromFirebaseUser(userCredential.user);
    } catch (e) {
      print("Erro troca de tokens: $e");
      return null;
    }
  }

  Future<UserModel?> signInSilently() async {
    try {
      // 1. Prioridade: Cache do Firebase (Web e Mobile)
      if (auth.currentUser != null) {
        return _getUserModelFromFirebaseUser(auth.currentUser);
      }

      // 2. Mobile: Tenta login silencioso nativo da v7
      if (!kIsWeb) {
         await _ensureInitialized();
         
         // 'attemptLightweightAuthentication' substitui 'signInSilently'
         final account = await googleSignIn.attemptLightweightAuthentication();
         
         if (account != null) {
           return await _signInMobile(account);
         }
      }
      return null;
    } catch (_) {
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
    if (!kIsWeb) {
      try {
        await googleSignIn.signOut();
      } catch (_) {}
    }
    await auth.signOut();
  }
}