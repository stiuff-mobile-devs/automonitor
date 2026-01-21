import 'package:automonitor/app/modules/splash/controller/splash_controller.dart';
import 'package:automonitor/app/utils/color_pallete.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.darkBlueToBlackGradient(),
              ),
              child: Center(
                child: Obx(
                  () => AnimatedOpacity(
                    onEnd: controller.onEnd,
                    opacity: controller.opacity.value,
                    duration: Duration(seconds: controller.splashDuration),
                    child: Text(
                      'Bem-vindo ao AutoMonitor!',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}