import 'package:flutter/material.dart';
import 'dart:async';

class KnapsackScreen extends StatefulWidget {
  const KnapsackScreen({super.key});

  @override
  State<KnapsackScreen> createState() => _KnapsackScreenState();
}

class _KnapsackScreenState extends State<KnapsackScreen> {
  final List<int> weights = [1, 3, 4, 5];
  final List<int> values = [1, 4, 5, 7];
  int capacity = 7;

  List<List<int>> dp = [];
  int currentRow = 0, currentCol = 0;
  bool isRunning = false;
  String explanation =
      "🎒 0/1 Knapsack Problem:\n\nWe choose items with given weights & values to maximize total value within capacity.";

  @override
  void initState() {
    super.initState();
    _initializeDP();
  }

  void _initializeDP() {
    dp = List.generate(weights.length + 1,
            (_) => List.generate(capacity + 1, (_) => 0));
  }

  Future<void> _startAnimation() async {
    if (isRunning) return;
    setState(() {
      isRunning = true;
      currentRow = 0;
      currentCol = 0;
    });

    for (int i = 1; i <= weights.length; i++) {
      for (int w = 1; w <= capacity; w++) {
        await Future.delayed(const Duration(milliseconds: 700));
        setState(() {
          currentRow = i;
          currentCol = w;

          if (weights[i - 1] <= w) {
            dp[i][w] = dp[i - 1][w].clamp(
                0, 999999).compareTo(dp[i - 1][w - weights[i - 1]] + values[i - 1]) <
                0
                ? dp[i - 1][w - weights[i - 1]] + values[i - 1]
                : dp[i - 1][w];

            explanation =
            "Checking item $i (W=${weights[i - 1]}, V=${values[i - 1]}) at capacity $w.\n"
                "👉 Max of: exclude (${dp[i - 1][w]}) or include (${dp[i - 1][w - weights[i - 1]] + values[i - 1]}).";
          } else {
            dp[i][w] = dp[i - 1][w];
            explanation =
            "Item $i (W=${weights[i - 1]}) too heavy for capacity $w.\n👉 Carry forward value = ${dp[i][w]}.";
          }
        });
      }
    }

    setState(() {
      isRunning = false;
      explanation =
      "✅ Completed!\nMaximum value for capacity $capacity = ${dp[weights.length][capacity]} 🎉";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🎒 0/1 Knapsack Visualizer"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Card(
              color: Colors.deepPurpleAccent.withOpacity(0.6),
              margin: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  explanation,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: GridView.builder(
                  itemCount: (weights.length + 1) * (capacity + 1),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: capacity + 1),
                  itemBuilder: (context, index) {
                    int row = index ~/ (capacity + 1);
                    int col = index % (capacity + 1);
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: (row == currentRow && col == currentCol)
                            ? Colors.orange
                            : Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          dp[row][col].toString(),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _startAnimation,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, padding: const EdgeInsets.all(16)),
              child: const Text(
                "▶ Start Knapsack Animation",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
