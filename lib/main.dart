import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'view/spalsh_screen.dart';

void main() {
  runApp(const ParkingApp());
}

class ParkingApp extends StatelessWidget {
  const ParkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parking Master',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black12
      ),
      home: const SplashScreen(),
    );
  }
}


