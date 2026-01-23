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
      appBar: Appbar(title: "Mapa"),

      body: Mapa(),
    );
  }

  Widget Mapa() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(-22.8966, -43.1238),
        initialZoom: 15.0,
      ),
      children: [openstreetmap, Markers()],
    );
  }

  TileLayer get openstreetmap => TileLayer(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: 'com.example.automonitor',
  );

  Widget Markers() {
    return Obx(() {
      return MarkerLayer(
        markers: controller.veiculos.map((veiculo) {
          return Marker(
            point: LatLng(veiculo.lat, veiculo.long),
            child: GestureDetector(
              onTap: () {
                // popup depois
              },
              child: Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 40,
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}
