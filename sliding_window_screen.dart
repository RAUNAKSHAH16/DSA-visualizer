import 'package:flutter/material.dart';
import 'dart:async';

class SlidingWindowScreen extends StatefulWidget {
  const SlidingWindowScreen({super.key});

  @override
  State<SlidingWindowScreen> createState() => _SlidingWindowScreenState();
}

class _SlidingWindowScreenState extends State<SlidingWindowScreen> {
  List<int> numbers = [1, 3, 2, 6, 2, 8, 1];
  int windowSize = 3;
  int currentIndex = 0;
  bool isRunning = false;
  List<double> windowAverages = [];
  List<List<int>> windowElements = [];

  void startSlidingWindow() async {
    setState(() {
      windowAverages.clear();
      windowElements.clear();
      isRunning = true;
      currentIndex = 0;
    });

    for (int i = 0; i <= numbers.length - windowSize; i++) {
      if (!isRunning) break;

      List<int> window = numbers.sublist(i, i + windowSize);
      double avg = window.reduce((a, b) => a + b) / windowSize;

      setState(() {
        windowElements.add(window);
        windowAverages.add(avg);
        currentIndex = i;
      });

      await Future.delayed(const Duration(seconds: 1));
    }

    setState(() => isRunning = false);
  }

  void reset() {
    setState(() {
      isRunning = false;
      currentIndex = 0;
      windowAverages.clear();
      windowElements.clear();
    });
  }

  Widget _buildBox(int num, {bool highlighted = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: highlighted ? Colors.deepPurple : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
        boxShadow: highlighted
            ? [BoxShadow(color: Colors.deepPurple.shade200, blurRadius: 10)]
            : [],
      ),
      child: Text(
        '$num',
        style: TextStyle(
          color: highlighted ? Colors.white : Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sliding Window Visualization"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: const Color(0xFFF9F9FF),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Array Elements:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: numbers.asMap().entries.map((entry) {
                int index = entry.key;
                int value = entry.value;
                bool highlight = index >= currentIndex &&
                    index < currentIndex + windowSize &&
                    isRunning;
                return _buildBox(value, highlighted: highlight);
              }).toList(),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: isRunning ? null : startSlidingWindow,
              icon: const Icon(Icons.play_arrow),
              label: const Text("Start Sliding"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: reset,
              child: const Text("Reset"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 30),
            if (windowAverages.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: windowAverages.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      elevation: 3,
                      child: ListTile(
                        leading: Text(
                          'Window ${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        title: Text(
                          'Elements: ${windowElements[index].join(', ')}',
                        ),
                        trailing: Text(
                          'Avg: ${windowAverages[index].toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.deepPurple),
                        ),
                      ),
                    );
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}
