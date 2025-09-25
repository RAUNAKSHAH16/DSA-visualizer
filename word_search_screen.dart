import 'package:flutter/material.dart';

class WordSearchScreen extends StatefulWidget {
  @override
  _WordSearchScreenState createState() => _WordSearchScreenState();
}

class _WordSearchScreenState extends State<WordSearchScreen> {
  final List<List<String>> board = [
    ['D', 'S', 'A', 'X'],
    ['O', 'S', 'E', 'R'],
    ['G', 'R', 'I', 'D'],
    ['E', 'A', 'M', 'H'],
  ];

  final TextEditingController _controller = TextEditingController();
  String resultMessage = '';
  List<List<bool>> highlight = [];

  @override
  void initState() {
    super.initState();
    highlight = List.generate(board.length, (i) => List.generate(board[0].length, (j) => false));
  }

  bool searchWord(String word) {
    int rows = board.length;
    int cols = board[0].length;
    List<List<int>> directions = [
      [0, 1], [1, 0], [0, -1], [-1, 0],
      [1, 1], [-1, -1], [1, -1], [-1, 1],
    ];

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        for (var dir in directions) {
          int x = i, y = j;
          int k = 0;

          while (k < word.length &&
              x >= 0 &&
              y >= 0 &&
              x < rows &&
              y < cols &&
              board[x][y] == word[k]) {
            k++;
            x += dir[0];
            y += dir[1];
          }

          if (k == word.length) {
            x = i;
            y = j;
            for (int l = 0; l < word.length; l++) {
              highlight[x][y] = true;
              x += dir[0];
              y += dir[1];
            }

            resultMessage = '✅ Found at starting position: ($i, $j)';
            return true;
          }
        }
      }
    }
    resultMessage = '❌ Not Found';
    return false;
  }

  void handleSearch() {
    setState(() {
      highlight = List.generate(board.length, (i) => List.generate(board[0].length, (j) => false));
      searchWord(_controller.text.toUpperCase().trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: const Text("Word Search in Grid"),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter Word',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: handleSearch,
            child: const Text("Search Word"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey[700],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            resultMessage,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: board.length * board[0].length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: board[0].length,
                ),
                itemBuilder: (context, index) {
                  int row = index ~/ board[0].length;
                  int col = index % board[0].length;
                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: highlight[row][col] ? Colors.greenAccent : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade600,
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        )
                      ],
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Text(
                        board[row][col],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
