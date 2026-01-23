import 'package:automonitor/app/components/appbar.dart';
import 'package:automonitor/app/models/veiculo.dart';
import 'package:automonitor/app/modules/mapa/controller/mapa_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapaPage extends GetView<MapaController> {
  const MapaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(title: "AutoMonitor"),
      body: mapa(),
    );
  }

  Widget mapa() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(-22.8966, -43.1238),
        initialZoom: 15.0,
      ),
      children: [openstreetmap, markers()],
    );
  }

  TileLayer get openstreetmap => TileLayer( // Renderiza o mapa
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: 'com.example.automonitor',
  );

  Widget markers() { // Coloca os marcadores no mapa
    return Obx(() { // Atualiza quando algum marcador se move
      return MarkerLayer(
        markers: controller.veiculos.map((veiculo) {
          return Marker(
            point: LatLng(veiculo.lat, veiculo.long),
            child: GestureDetector(
              onTap: () {Get.dialog(popUp(veiculo));},
              child: Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 50,
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget popUp(Veiculo veiculo) {
    return AlertDialog(
      title: Text("Veiculo"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('ID:  ${veiculo.id}'),
          Text('Lat: ${veiculo.lat}'),
          Text('Lng: ${veiculo.long}'),
        ],
      ),
    );
  }
}
