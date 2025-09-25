import 'package:flutter/material.dart';

class NQueensVisualizer extends StatefulWidget {
  const NQueensVisualizer({super.key});

  @override
  State<NQueensVisualizer> createState() => _NQueensVisualizerState();
}

class _NQueensVisualizerState extends State<NQueensVisualizer> {
  int n = 8;
  List<List<int>> solutions = [];
  int currentSolutionIndex = 0;

  @override
  void initState() {
    super.initState();
    _solveNQueens(n);
  }

  void _solveNQueens(int n) {
    List<int> board = List.filled(n, -1);
    solutions.clear();
    _placeQueens(0, board);
    setState(() {});
  }

  void _placeQueens(int row, List<int> board) {
    if (row == n) {
      solutions.add(List.from(board));
      return;
    }

    for (int col = 0; col < n; col++) {
      if (_isSafe(row, col, board)) {
        board[row] = col;
        _placeQueens(row + 1, board);
        board[row] = -1;
      }
    }
  }

  bool _isSafe(int row, int col, List<int> board) {
    for (int i = 0; i < row; i++) {
      if (board[i] == col ||
          (row - i).abs() == (col - board[i]).abs()) {
        return false;
      }
    }
    return true;
  }

  void _nextSolution() {
    setState(() {
      currentSolutionIndex = (currentSolutionIndex + 1) % solutions.length;
    });
  }

  Widget _buildBoard() {
    if (solutions.isEmpty) return const Text("No solutions found");

    List<int> board = solutions[currentSolutionIndex];

    return Column(
      children: List.generate(n, (row) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(n, (col) {
            bool isDark = (row + col) % 2 == 1;
            bool hasQueen = board[row] == col;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? Colors.brown[700] : Colors.white,
                border: Border.all(color: Colors.black),
              ),
              alignment: Alignment.center,
              child: hasQueen
                  ? const Text(
                '♛',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.purple,
                ),
              )
                  : null,
            );
          }),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("N-Queens Visualizer"),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBoard(),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _nextSolution,
              icon: const Icon(Icons.skip_next),
              label: const Text("Next Solution"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Solution ${currentSolutionIndex + 1} of ${solutions.length}",
              style: const TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
