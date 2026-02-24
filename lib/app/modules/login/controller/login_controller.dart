import 'package:automonitor/app/modules/user/model/user_model.dart';
import 'package:automonitor/app/modules/user/repository/user_repository.dart';
import 'package:automonitor/app/services/google_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final UserRepository _repository = UserRepository();
  final GoogleService _signInService = GoogleService();

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Tenta logar sozinho assim que abrir a tela
    trySilentSignIn();
  }

  Future<void> trySilentSignIn() async {
    UserModel? user = await _signInService.signInSilently();
    if (user != null) {
      _goToMapaPage();
    }
  }

  Future<void> trySignInWithGoogle() async {
    isLoading(true);
    try {
      UserModel? user = await _signInService.signInWithGoogle();
      if (user != null) {
        await _saveUser(user);
        _goToMapaPage();
      }
    } catch (e) {
      // Feedback visual para o usuário não ficar perdido
      Get.snackbar(
        "Erro no Login", 
        "Não foi possível conectar. Tente novamente.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      print("Erro LoginController: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> _saveUser(UserModel user) async {
    // Verifica se o usuário já existe na coleção 'users'
    UserModel? isSaved = await _repository.getUser(user.id);
    if (isSaved == null) {
      // Se não existe, salva com o Email e Nome para o JOIN do mapa
      await _repository.addUser(user);
    }
  }

  _goToMapaPage() {
    Get.offAllNamed(Routes.MAPA);
  }
}