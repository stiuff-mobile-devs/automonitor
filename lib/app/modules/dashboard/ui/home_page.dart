import 'package:automonitor/app/components/appbar.dart';
import 'package:automonitor/app/modules/dashboard/controller/home_controller.dart';
import 'package:automonitor/app/utils/color_pallete.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: Appbar(title: 'Dashboard'),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.darkBlueToBlackGradient(),
        ),
        child: Placeholder()
      )
    );
  }
}