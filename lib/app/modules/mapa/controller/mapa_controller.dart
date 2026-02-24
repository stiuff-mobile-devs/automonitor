import 'package:automonitor/app/models/veiculo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Adicione intl no pubspec.yaml para formatar a data

class MapaController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Esse mapa vai guardar: { "ID_DO_VEICULO": { "dono": "...", "carro": "...", "placa": "..." } }
  final Map<String, Map<String, String>> _relatorioVeiculos = {};
  
  RxList<Veiculo> veiculos = <Veiculo>[].obs;
  late final MapController mapController;

  @override
  void onInit() {
    super.onInit();
    mapController = MapController();
    _inicializarJoin();
  }

  Future<void> _inicializarJoin() async {
    try {
      // 1. Busca todos os usuários para criar um mapa de Email -> Nome
      final usersSnapshot = await _firestore.collection('users').get();
      final Map<String, String> emailParaNome = {
        for (var doc in usersSnapshot.docs) 
          doc.data()['email']: doc.data()['name'] ?? 'Sem Nome'
      };

      // 2. Busca os veículos e faz o "join" com o nome do dono via email
      final vehiclesSnapshot = await _firestore.collection('vehicles').get();
      for (var doc in vehiclesSnapshot.docs) {
        final vData = doc.data();
        final emailDono = vData['email'] ?? '';
        
        _relatorioVeiculos[doc.id] = {
          'dono': emailParaNome[emailDono] ?? 'Dono não encontrado',
          'veiculo': vData['name'] ?? 'Novo Carro',
          'placa': vData['placa'] ?? 'Sem Placa',
        };
      }

      // 3. Agora que temos o JOIN pronto, ouvimos as localizações
      _ouvirLocalizacoes();
    } catch (e) {
      print("Erro no Join: $e");
    }
  }

  void _ouvirLocalizacoes() {
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
    // Busca os dados que já foram "juntados" no onInit
    final dadosCompletos = _relatorioVeiculos[veiculo.id];
    
    // Formata o horário de forma amigável
    final dataFormatada = DateFormat('dd/MM/yyyy HH:mm:ss').format(veiculo.timestamp);

    return AlertDialog(
      title: Text(dadosCompletos?['veiculo'] ?? "Veículo"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow("Proprietário:", dadosCompletos?['dono']),
          _infoRow("Placa:", dadosCompletos?['placa']),
          const Divider(),
          _infoRow("Última Atualização:", dataFormatada),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Fechar"))
      ],
    );
  }

  Widget _infoRow(String label, String? valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
          Text(valor ?? "N/A", style: const TextStyle(fontSize: 16)),
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