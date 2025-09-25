import 'package:flutter/material.dart';

class SpeedSlider extends StatelessWidget {
  final double speed;
  final ValueChanged<double> onSpeedChanged;

  const SpeedSlider({
    Key? key,
    required this.speed,
    required this.onSpeedChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: speed,
      min: 50.0,
      max: 1000.0,
      divisions: 20,
      label: "${speed.toInt()} ms",
      onChanged: onSpeedChanged,
    );
  }
}
