import 'dart:async';
import 'package:flutter/material.dart';

class DFSScreen extends StatefulWidget {
  @override
  _DFSScreenState createState() => _DFSScreenState();
}

class _DFSScreenState extends State<DFSScreen> {
  final Map<int, List<int>> graph = {
    0: [1, 2],
    1: [3, 4],
    2: [5],
    3: [],
    4: [],
    5: [],
  };

  final Map<int, Offset> positions = {
    0: Offset(200, 80),
    1: Offset(100, 180),
    2: Offset(300, 180),
    3: Offset(50, 280),
    4: Offset(150, 280),
    5: Offset(300, 280),
  };

  Set<int> visited = {};
  List<int> traversalOrder = [];
  bool isRunning = false;

  Future<void> dfs(int node) async {
    if (visited.contains(node)) return;

    visited.add(node);
    traversalOrder.add(node);
    setState(() {});
    await Future.delayed(Duration(milliseconds: 600));

    for (int neighbor in graph[node]!) {
      await dfs(neighbor);
    }

    setState(() => isRunning = false);
  }

  void startDFS() {
    if (isRunning) return;
    visited.clear();
    traversalOrder.clear();
    setState(() => isRunning = true);
    dfs(0);
  }

  void reset() {
    visited.clear();
    traversalOrder.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DFS Visualizer"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade900, Colors.green.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size(double.infinity, double.infinity),
                      painter: GraphPainter(graph, positions, visited),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.white, thickness: 1),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      "Traversal Order:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      children: traversalOrder
                          .map((node) => Chip(
                        label: Text("Node $node"),
                        backgroundColor: Colors.white70,
                      ))
                          .toList(),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: isRunning ? null : startDFS,
                          child: Text("Start DFS"),
                        ),
                        ElevatedButton(
                          onPressed: isRunning ? null : reset,
                          child: Text("Reset"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GraphPainter extends CustomPainter {
  final Map<int, List<int>> graph;
  final Map<int, Offset> positions;
  final Set<int> visited;

  GraphPainter(this.graph, this.positions, this.visited);

  @override
  void paint(Canvas canvas, Size size) {
    final nodePaint = Paint()..color = Colors.orange;
    final visitedPaint = Paint()..color = Colors.redAccent;
    final edgePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;

    graph.forEach((node, edges) {
      for (int neighbor in edges) {
        canvas.drawLine(
          positions[node]!,
          positions[neighbor]!,
          edgePaint,
        );
      }
    });

    graph.keys.forEach((node) {
      final pos = positions[node]!;
      canvas.drawCircle(
        pos,
        22,
        visited.contains(node) ? visitedPaint : nodePaint,
      );
      final textPainter = TextPainter(
        text: TextSpan(
          text: '$node',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        pos - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
