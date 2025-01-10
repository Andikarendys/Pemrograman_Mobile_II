import 'package:flutter/material.dart';
import 'package:frontend/userinterface/navigation.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const navigasi()), // Replace with your main screen
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 239, 227, 194),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 1.0,
          heightFactor: 0.8,
          child: Image.asset(
            'lib/images/Logo Fresh Pick.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
