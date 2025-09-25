import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(KnightsTourApp());

class KnightsTourApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Knight\'s Tour',
      theme: ThemeData.dark(),
      home: KnightsTourScreen(),
    );
  }
}

class KnightsTourScreen extends StatefulWidget {
  @override
  _KnightsTourScreenState createState() => _KnightsTourScreenState();
}

class _KnightsTourScreenState extends State<KnightsTourScreen> {
  static const int boardSize = 8;
  List<List<int>> board = List.generate(
      boardSize, (_) => List.filled(boardSize, -1));
  List<List<int>> knightPath = [];
  int knightX = 0;
  int knightY = 0;
  int moveCount = 0;
  bool solving = false;
  double speed = 300;

  final List<List<int>> directions = [
    [2, 1], [1, 2], [-1, 2], [-2, 1],
    [-2, -1], [-1, -2], [1, -2], [2, -1]
  ];

  bool isSafe(int x, int y) {
    return x >= 0 && x < boardSize && y >= 0 && y < boardSize &&
        board[x][y] == -1;
  }

  Future<bool> solveKnightTour(int x, int y, int movei) async {
    board[x][y] = movei;
    knightPath.add([x, y]);
    setState(() {
      knightX = x;
      knightY = y;
      moveCount = movei;
    });
    await Future.delayed(Duration(milliseconds: speed.toInt()));

    if (movei == boardSize * boardSize - 1) return true;

    for (List<int> dir in directions) {
      int nextX = x + dir[0];
      int nextY = y + dir[1];
      if (isSafe(nextX, nextY)) {
        if (await solveKnightTour(nextX, nextY, movei + 1)) return true;
      }
    }

    board[x][y] = -1;
    knightPath.removeLast();
    return false;
  }

  void startTour() async {
    setState(() {
      board = List.generate(boardSize, (_) => List.filled(boardSize, -1));
      knightPath.clear();
      solving = true;
    });
    await solveKnightTour(0, 0, 0);
    setState(() {
      solving = false;
    });
  }

  void resetBoard() {
    setState(() {
      board = List.generate(boardSize, (_) => List.filled(boardSize, -1));
      knightPath.clear();
      knightX = 0;
      knightY = 0;
      moveCount = 0;
      solving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double cellSize = MediaQuery
        .of(context)
        .size
        .width / boardSize;
    return Scaffold(
      appBar: AppBar(
        title: Text("Knight's Tour"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: solving ? null : resetBoard,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: boardSize,
                  ),
                  itemCount: boardSize * boardSize,
                  itemBuilder: (context, index) {
                    int x = index ~/ boardSize;
                    int y = index % boardSize;
                    bool isDark = (x + y) % 2 == 1;
                    return Container(
                      decoration: BoxDecoration(
                        color: isDark ? Colors.brown : Colors.white,
                        border: Border.all(color: Colors.black, width: 0.5),
                      ),
                      child: Center(
                        child: board[x][y] != -1
                            ? Text('${board[x][y]}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ))
                            : null,
                      ),
                    );
                  },
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 200),
                  left: knightY * cellSize,
                  top: knightX * cellSize,
                  child: Container(
                    width: cellSize,
                    height: cellSize,
                    child: Center(
                      child: Image.asset(
                        'assets/knight.png',
                        width: cellSize * 0.6,
                        height: cellSize * 0.6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: solving ? null : startTour,
                  icon: Icon(Icons.play_arrow),
                  label: Text("Start Tour"),
                ),
                Text("Speed"),
                Slider(
                  value: speed,
                  min: 50,
                  max: 1000,
                  divisions: 19,
                  label: "${speed.toInt()}ms",
                  onChanged: (val) {
                    setState(() {
                      speed = val;
                    });
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}