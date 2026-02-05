import 'package:automonitor/app/modules/login/bindings/login_bindings.dart';
import 'package:automonitor/app/modules/login/ui/login_page.dart';
import 'package:automonitor/app/modules/mapa/bindings/mapa_bindings.dart';
import 'package:automonitor/app/modules/mapa/ui/mapa_page.dart';
import 'package:automonitor/app/modules/splash/bindings/splash_bindings.dart';
import 'package:automonitor/app/modules/splash/ui/splash_page.dart';
import 'package:automonitor/app/routes/app_routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

abstract class AppPages {
  static final pages = [
    GetPage( // SplashPage
      name: Routes.SPLASH, 
      page: () => SplashPage(),
      binding: SplashBindings(),
    ),
    GetPage(
      name: Routes.MAPA, 
      page: () => MapaPage(),
      binding: MapaBindings()
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
      binding: LoginBindings(),
    ),
  ];
}