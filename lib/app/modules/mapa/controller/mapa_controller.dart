import 'package:automonitor/app/models/veiculo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';

class MapaController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<Veiculo> veiculos = <Veiculo>[].obs;
  late final MapController mapController;

  @override
  void onInit() {
    super.onInit();
    mapController = MapController();
    
    veiculos.bindStream(
      _firestore.collection('locations').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return Veiculo(
            id: doc.id,
            lat: (data['lat'] as num).toDouble(),
            long: (data['long'] ?? data['lng'] as num).toDouble(),
            timestamp: (data['timestamp'] as Timestamp).toDate(),
          );
        }).toList();
      }),
    );
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
            Text('Long: ${veiculo.long}'),
          ],
        ),
      );
    }

  @override
  void onClose() {
    mapController.dispose();
    super.onClose();
  }
}