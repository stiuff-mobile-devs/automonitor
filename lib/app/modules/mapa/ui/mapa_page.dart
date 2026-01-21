import 'package:automonitor/app/modules/mapa/controller/mapa_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MapaPage extends GetView<MapaController> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
    appBar: AppBar(title: Text('MapaPage')),

    body: SafeArea(
      child: Text('MapaPageController'))
    );
  }
}