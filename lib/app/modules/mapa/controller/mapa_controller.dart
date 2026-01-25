import 'dart:async';
import 'package:automonitor/app/models/veiculo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class MapaController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Veiculo> veiculos = [];  
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
        veiculos = veiculosAtualizados;
        update();
      });
  }

  @override
  void onClose(){
    _inscricoesVeiculos?.cancel();
    super.onClose();
  }
}