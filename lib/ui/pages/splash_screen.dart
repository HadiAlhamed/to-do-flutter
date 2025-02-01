import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:to_do_app/ui/pages/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Simulating a delay to show the splash screen (e.g., loading resources)
    Timer(const Duration(seconds: 8), () {
      // Navigate to the home screen after 3 seconds
      Get.off(() => MyHomePage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}
