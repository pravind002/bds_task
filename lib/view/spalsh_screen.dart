import 'dart:async';

import 'package:flutter/material.dart';

import '../helpers/colors.dart';
import '../helpers/custom_widgets.dart';
import 'parking_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const ParkingScreen()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Center(child: customText('Parking \n\n Master',color: whiteColor,fontsize: 50,fontWeight: FontWeight.bold)),
    );
  }
}
