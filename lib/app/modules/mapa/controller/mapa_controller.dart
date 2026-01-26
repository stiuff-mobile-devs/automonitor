import 'dart:async';
import 'package:automonitor/app/models/veiculo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapaController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Veiculo> veiculos = [];
  List<Marker> listaDeMarkers = [];  
  StreamSubscription? _inscricoesVeiculos;

  @override
  void onInit(){
    super.onInit();
    _listenVehicles();
  }

  void _listenVehicles(){
    _inscricoesVeiculos = _firestore
      .collection('locations')
      .snapshots()
      .listen((snapshot){
        final List<Veiculo> veiculosAtualizados = [];
        for (var doc in snapshot.docs) {
          final data = doc.data();
          if (data['lat'] == null || (data['lng'] == null && data['long'] == null)) continue;
          final vehicle = Veiculo(
            id: doc.id, 
            lat: (data['lat'] as num).toDouble(),
            long: (data['long'] == null) ? (data['lng'] as num).toDouble(): (data['long'] as num).toDouble() , 
            timestamp: (data['timestamp'] as Timestamp).toDate()
          );
          veiculosAtualizados.add(vehicle);
        }
          listaDeMarkers = veiculosAtualizados.map((veiculo) => Marker(
          point: LatLng(veiculo.lat, veiculo.long),
          width: 50,
          height: 50,
          child: _buildMarkerWidget(veiculo), // Widget separado
        )).toList();
        veiculos = veiculosAtualizados;
        update();
      });
  }

  Widget _buildMarkerWidget(Veiculo veiculo) {
    return GestureDetector(
      onTap: () => Get.dialog(popUp(veiculo)), // Mova o popUp para o controller ou use uma função estática
      child: const Icon(
        Icons.location_pin,
        color: Colors.red,
        size: 50,
      ),
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
  void onClose(){
    _inscricoesVeiculos?.cancel();
    super.onClose();
  }
}