import 'package:flutter/material.dart';

class Circularloader extends StatelessWidget {
  const Circularloader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: SizedBox(child: CircularProgressIndicator.adaptive()));
  }
}
