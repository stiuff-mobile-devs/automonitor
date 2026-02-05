import 'package:automonitor/app/routes/app_routes.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final int splashDuration = 2; // Duração do splash em segundos
  final RxDouble opacity = 0.0.obs;

  @override
  void onReady() {
    super.onReady();
    Future.microtask(() => opacity.value = 1.0);
  }

  void onEnd() {
    // Navegar para a página inicial após o splash
    Get.offAllNamed(Routes.LOGIN);
  }
}