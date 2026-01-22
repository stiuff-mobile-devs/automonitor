import 'package:automonitor/app/routes/app_pages.dart';
import 'package:automonitor/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
      GetMaterialApp(
        debugShowCheckedModeBanner: true,
        title: 'Auto Monitor',
        initialRoute: Routes.SPLASH,
        defaultTransition: Transition.fade,
        getPages: AppPages.pages,
      )
  );
}
