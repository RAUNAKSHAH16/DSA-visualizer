import 'package:flutter/material.dart';
import '../models/node.dart';

class GridCell extends StatelessWidget {
  final Node node;
  final VoidCallback onTap;

  GridCell({required this.node, required this.onTap});

  Color _getColor(NodeType type) {
    switch (type) {
      case NodeType.start:
        return Colors.green;
      case NodeType.end:
        return Colors.red;
      case NodeType.wall:
        return Colors.black;
      case NodeType.visited:
        return Colors.blue.shade200;
      case NodeType.path:
        return Colors.yellow;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: _getColor(node.type),
          border: Border.all(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
