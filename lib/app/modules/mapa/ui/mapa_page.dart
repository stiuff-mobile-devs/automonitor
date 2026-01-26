import 'package:automonitor/app/components/appbar.dart';
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

  Widget markers() {
    return GetBuilder<MapaController>(
      builder: (controller) {
        return MarkerLayer(
          markers: controller.listaDeMarkers,
        );
      },
    );
  }
}
