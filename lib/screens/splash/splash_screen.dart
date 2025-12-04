
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shortestSide = size.shortestSide;
    final maxLogoWidth = shortestSide < 600 ? size.width * 0.75 : size.width * 0.6;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxLogoWidth),
          child: AspectRatio(
            aspectRatio: 2000 / 383,
            child: Image.asset('assets/images/nepalink.png', fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
