import 'package:flutter/cupertino.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Center(
        child: Text("About"),
      ),
    );
  }
}