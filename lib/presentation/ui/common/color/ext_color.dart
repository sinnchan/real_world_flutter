import 'package:flutter/material.dart';

extension ExColor on Color {
  Color withDark([double? value]) {
    return Color.lerp(this, Colors.black, value ?? 0.3)!;
  }

  Color withLight([double? value]) {
    return Color.lerp(this, Colors.white, value ?? 0.3)!;
  }
}
