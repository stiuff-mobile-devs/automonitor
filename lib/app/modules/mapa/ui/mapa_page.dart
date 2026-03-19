import 'package:automonitor/app/components/appbar.dart';
import 'package:automonitor/app/modules/mapa/controller/mapa_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapaPage extends GetView<MapaController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(title: "AutoMonitor"),
      body: FlutterMap(
        mapController: controller.mapController,
        options: MapOptions(
          initialCenter: LatLng(-22.8966, -43.1238),
          initialZoom: 15.0,
        ),
        children: [mapa(), markers()],
      ),
    );
  }

  Widget mapa() {
    return TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'br.uff.sti.automonitor',
      keepBuffer: 1,
      tileProvider: CancellableNetworkTileProvider(),
    );
  }

  Widget markers() {
    return Obx(
      () => MarkerLayer(
        markers: controller.veiculos
            .map(
              (veiculo) => Marker(
                point: LatLng(veiculo.lat, veiculo.long),
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () => Get.dialog(controller.popUp(veiculo)),
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 50,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
