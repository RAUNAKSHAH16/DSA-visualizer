import 'package:flutter/material.dart';

class BarWidget extends StatelessWidget {
  final double value;
  final bool isHighlighted;
  final Color color;

  BarWidget({
    required this.value,
    this.isHighlighted = false,
    this.color = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: value,
      width: 8,
      margin: EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            offset: Offset(0, 2),
          )
        ],
      ),
    );
  }
}

