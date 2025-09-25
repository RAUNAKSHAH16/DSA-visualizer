import 'dart:async';
import 'package:flutter/material.dart';

class TopologicalSortScreen extends StatefulWidget {
  @override
  _TopologicalSortScreenState createState() => _TopologicalSortScreenState();
}

class _TopologicalSortScreenState extends State<TopologicalSortScreen> {
  Map<int, List<int>> graph = {
    0: [1, 2],
    1: [3],
    2: [3],
    3: [4],
    4: [],
  };

  List<int> visited = [];
  List<int> result = [];
  bool isSorting = false;
  int speed = 500; // milliseconds

  Future<void> _topologicalSort() async {
    visited.clear();
    result.clear();
    setState(() => isSorting = true);

    for (int node in graph.keys) {
      if (!visited.contains(node)) {
        await _dfs(node);
      }
    }

    result = result.reversed.toList();
    setState(() => isSorting = false);
  }

  Future<void> _dfs(int node) async {
    visited.add(node);
    setState(() {});
    await Future.delayed(Duration(milliseconds: speed));

    for (int neighbor in graph[node]!) {
      if (!visited.contains(neighbor)) {
        await _dfs(neighbor);
      }
    }

    result.add(node);
    setState(() {});
    await Future.delayed(Duration(milliseconds: speed));
  }

  void _reset() {
    visited.clear();
    result.clear();
    setState(() {});
  }

  Widget _buildNode(int node) {
    Color color = visited.contains(node) ? Colors.green : Colors.blue;
    return Column(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Text(
            '$node',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        SizedBox(height: 10),
        Text('Node $node', style: TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildGraphLayout() {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      alignment: WrapAlignment.center,
      children: graph.keys.map((node) => _buildNode(node)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Topological Sort Visualizer"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade900, Colors.deepPurpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            _buildGraphLayout(),
            SizedBox(height: 20),
            Text(
              'Traversal Order:',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: result
                  .map((node) => Chip(
                label: Text('$node'),
                backgroundColor: Colors.amber,
                labelStyle: TextStyle(color: Colors.black),
              ))
                  .toList(),
            ),
            SizedBox(height: 20),
            Text("Speed: ${speed}ms", style: TextStyle(color: Colors.white)),
            Slider(
              value: speed.toDouble(),
              min: 100,
              max: 1000,
              divisions: 9,
              label: '$speed ms',
              onChanged: isSorting
                  ? null
                  : (val) {
                setState(() => speed = val.toInt());
              },
            ),
            SizedBox(height: 10),
            if (!isSorting)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _reset,
                    icon: Icon(Icons.refresh),
                    label: Text("Reset"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _topologicalSort,
                    icon: Icon(Icons.play_arrow),
                    label: Text("Start"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              )
            else
              CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
