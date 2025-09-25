import 'dart:async';
import 'package:flutter/material.dart';

class RatInMazeScreen extends StatefulWidget {
  const RatInMazeScreen({super.key});

  @override
  State<RatInMazeScreen> createState() => _RatInMazeScreenState();
}

class _RatInMazeScreenState extends State<RatInMazeScreen> {
  static const int n = 5;
  List<List<int>> maze = [
    [1, 0, 0, 0, 0],
    [1, 1, 0, 1, 1],
    [0, 1, 0, 0, 1],
    [1, 1, 1, 1, 1],
    [0, 0, 0, 0, 1],
  ];

  List<List<bool>> visited =
  List.generate(n, (_) => List.generate(n, (_) => false));
  List<List<bool>> path =
  List.generate(n, (_) => List.generate(n, (_) => false));
  bool isSolving = false;

  Future<bool> solve(int x, int y) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (x == n - 1 && y == n - 1) {
      setState(() => path[x][y] = true);
      return true;
    }

    if (x < 0 || y < 0 || x >= n || y >= n || maze[x][y] == 0 || visited[x][y]) {
      return false;
    }

    setState(() {
      visited[x][y] = true;
      path[x][y] = true;
    });

    if (await solve(x + 1, y) ||
        await solve(x, y + 1) ||
        await solve(x - 1, y) ||
        await solve(x, y - 1)) {
      return true;
    }

    setState(() => path[x][y] = false);
    return false;
  }

  void startSolving() async {
    setState(() {
      visited =
          List.generate(n, (_) => List.generate(n, (_) => false));
      path =
          List.generate(n, (_) => List.generate(n, (_) => false));
      isSolving = true;
    });
    await solve(0, 0);
    setState(() => isSolving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rat in a Maze Solver"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: n * n,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: n,
                  ),
                  itemBuilder: (context, index) {
                    int x = index ~/ n;
                    int y = index % n;
                    Color color;
                    if (path[x][y]) {
                      color = Colors.green;
                    } else if (visited[x][y]) {
                      color = Colors.yellow;
                    } else if (maze[x][y] == 1) {
                      color = Colors.white;
                    } else {
                      color = Colors.red;
                    }

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton.icon(
                onPressed: isSolving ? null : startSolving,
                icon: const Icon(Icons.play_arrow),
                label: const Text("Start"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
