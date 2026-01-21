import 'package:automonitor/app/routes/app_pages.dart';
import 'package:automonitor/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
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
