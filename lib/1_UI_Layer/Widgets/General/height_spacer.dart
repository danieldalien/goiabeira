import 'package:flutter/material.dart';

class HeightSpacer extends StatelessWidget {
  final int multiplier;
  const HeightSpacer({this.multiplier = 2, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 5 * multiplier.toDouble());
  }
}
