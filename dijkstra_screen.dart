import 'package:flutter/material.dart';
import '../models/node.dart';
import '../widgets/grid_cell.dart';
import 'dart:async';


class DijkstraScreen extends StatefulWidget {
  @override
  _DijkstraScreenState createState() => _DijkstraScreenState();
}

class _DijkstraScreenState extends State<DijkstraScreen> {
  static const int rows = 8;
  static const int cols = 10;
  late List<List<Node>> grid;

  late Node startNode;
  late Node endNode;
  bool isRunning = false;

  int _visitedCount = 0;
  int _pathLength = 0;

  @override
  void initState() {
    super.initState();
    _initializeGrid();
  }

  void _initializeGrid() {
    grid = List.generate(rows, (i) {
      return List.generate(
        cols,
            (j) => Node(row: i, col: j),
      );
    });

    startNode = grid[0][0];
    startNode.type = NodeType.start;

    endNode = grid[rows - 1][cols - 1];
    endNode.type = NodeType.end;

    setState(() {});
  }

  Future<void> _runDijkstra() async {
    isRunning = true;
    List<Node> visited = [];

    List<Node> queue = [startNode];
    startNode.distance = 0;

    while (queue.isNotEmpty) {
      queue.sort((a, b) => a.distance.compareTo(b.distance));
      Node current = queue.removeAt(0);

      if (current == endNode) break;

      for (Node neighbor in _getNeighbors(current)) {
        if (neighbor.type != NodeType.wall &&
            current.distance + 1 < neighbor.distance) {
          neighbor.distance = current.distance + 1;
          neighbor.previous = current;

          if (neighbor.type != NodeType.end &&
              neighbor.type != NodeType.start) {
            neighbor.type = NodeType.visited;
            visited.add(neighbor);
          }

          if (!queue.contains(neighbor)) queue.add(neighbor);

          setState(() {});
          await Future.delayed(Duration(milliseconds: 30));
        }
      }
    }

    _visitedCount = visited.length;
    await _reconstructPath();
    isRunning = false;
  }

  Future<void> _reconstructPath() async {
    _pathLength = 0;
    Node? current = endNode.previous;
    while (current != null && current != startNode) {
      current.type = NodeType.path;
      _pathLength++;
      setState(() {});
      await Future.delayed(Duration(milliseconds: 30));
      current = current.previous;
    }
  }

  List<Node> _getNeighbors(Node node) {
    List<Node> neighbors = [];

    final directions = [
      [0, 1],
      [1, 0],
      [-1, 0],
      [0, -1],
    ];

    for (var dir in directions) {
      int newRow = node.row + dir[0];
      int newCol = node.col + dir[1];

      if (newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols) {
        neighbors.add(grid[newRow][newCol]);
      }
    }

    return neighbors;
  }

  void _resetGrid() {
    setState(() {
      _visitedCount = 0;
      _pathLength = 0;
      _initializeGrid();
    });
  }


  void _toggleWall(Node node) {
    if (isRunning || node.type == NodeType.start || node.type == NodeType.end) return;

    setState(() {
      node.type = node.type == NodeType.wall ? NodeType.normal : NodeType.wall;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double availableHeight = screenHeight - 280;

    double cellWidth = screenWidth / cols;
    double cellHeight = availableHeight / rows;
    double cellSize = cellWidth < cellHeight ? cellWidth : cellHeight;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Dijkstra Visualizer"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 16),
              Text(
                "Tap to toggle walls. Press 'Start' to visualize.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    Text(
                      "Visited Nodes: $_visitedCount",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      "Shortest Path Length: $_pathLength",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Container(
                height: cellSize * rows,
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: rows * cols,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    int i = index ~/ cols;
                    int j = index % cols;
                    return SizedBox(
                      width: cellSize,
                      height: cellSize,
                      child: GridCell(
                        node: grid[i][j],
                        onTap: () => _toggleWall(grid[i][j]),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: isRunning ? null : _runDijkstra,
                    icon: Icon(Icons.play_arrow),
                    label: Text("Start"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: isRunning ? null : _resetGrid,
                    icon: Icon(Icons.refresh),
                    label: Text("Reset"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
