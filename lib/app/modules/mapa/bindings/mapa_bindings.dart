import 'package:automonitor/app/modules/mapa/controller/mapa_controller.dart';
import 'package:get/get.dart';

class MapaBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapaController>(() => MapaController());
    }
}