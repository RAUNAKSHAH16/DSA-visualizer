import 'package:flutter/material.dart';

class SudokuSolver extends StatefulWidget {
  const SudokuSolver({super.key});

  @override
  State<SudokuSolver> createState() => _SudokuSolverState();
}

class _SudokuSolverState extends State<SudokuSolver> {
  List<List<int>> board = List.generate(9, (_) => List.generate(9, (_) => 0));
  List<List<TextEditingController>> controllers = List.generate(
    9,
        (_) => List.generate(9, (_) => TextEditingController()),
  );

  bool isSafe(List<List<int>> board, int row, int col, int num) {
    for (int x = 0; x < 9; x++) {
      if (board[row][x] == num || board[x][col] == num) return false;
    }
    int startRow = row - row % 3, startCol = col - col % 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i + startRow][j + startCol] == num) return false;
      }
    }
    return true;
  }

  bool solveSudoku(List<List<int>> board) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (board[row][col] == 0) {
          for (int num = 1; num <= 9; num++) {
            if (isSafe(board, row, col, num)) {
              board[row][col] = num;
              if (solveSudoku(board)) return true;
              board[row][col] = 0;
            }
          }
          return false;
        }
      }
    }
    return true;
  }

  void onSolvePressed() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          board[i][j] = int.tryParse(controllers[i][j].text) ?? 0;
        }
      }
      if (solveSudoku(board)) {
        for (int i = 0; i < 9; i++) {
          for (int j = 0; j < 9; j++) {
            controllers[i][j].text = board[i][j].toString();
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No solution exists!")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Sudoku Solver"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF283E51), Color(0xFF485563)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(9, (i) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(9, (j) {
                        return Container(
                          width: 32,
                          height: 32,
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            border: Border.all(color: Colors.grey.shade700),
                          ),
                          child: TextField(
                            controller: controllers[i][j],
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                            ),
                          ),
                        );
                      }),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onSolvePressed,
                style: ElevatedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  backgroundColor: Colors.tealAccent.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 10,
                ),
                child: const Text(
                  "Solve",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}