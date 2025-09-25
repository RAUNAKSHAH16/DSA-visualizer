import 'package:flutter/material.dart';
import 'bubble_sort_screen.dart';
import 'quick_sort_screen.dart';
import 'merge_sort_screen.dart';
import 'binary_search_screen.dart';
import 'linear_search_screen.dart';
import 'dijkstra_screen.dart';
import 'dfs_screen.dart';
import 'bfs_screen.dart';


class AlgorithmAssistantScreen extends StatefulWidget {
  @override
  _AlgorithmAssistantScreenState createState() => _AlgorithmAssistantScreenState();
}

class _AlgorithmAssistantScreenState extends State<AlgorithmAssistantScreen> {
  String selectedTask = 'Search';
  double dataSize = 50;
  bool isSorted = false;
  String? recommendedAlgo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Algorithm Recommender'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade900, Colors.indigo.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("What do you want to do?",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              dropdownColor: Colors.indigo.shade100,
              value: selectedTask,
              items: ['Search', 'Sort', 'Find Shortest Path']
                  .map((task) => DropdownMenuItem(
                child: Text(task),
                value: task,
              )).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTask = value!;
                });
              },
            ),
            SizedBox(height: 20),
            Text("Data Size: ${dataSize.toInt()}",
              style: TextStyle(color: Colors.white),
            ),
            Slider(
              min: 10,
              max: 1000,
              divisions: 99,
              value: dataSize,
              onChanged: (val) {
                setState(() => dataSize = val);
              },
              label: dataSize.toInt().toString(),
            ),
            SizedBox(height: 20),
            if (selectedTask != 'Find Shortest Path')
              Row(
                children: [
                  Checkbox(
                    value: isSorted,
                    onChanged: (val) {
                      setState(() => isSorted = val!);
                    },
                  ),
                  Text("Is the data sorted?",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                child: Text("Get Recommendation"),
                onPressed: () {
                  final algo = recommendAlgorithm(
                    task: selectedTask,
                    size: dataSize.toInt(),
                    isSorted: isSorted,
                  );

                  setState(() {
                    recommendedAlgo = algo;
                  });

                  Future.delayed(Duration(seconds: 1), () {
                    Widget? screen = getScreenForAlgorithm(algo);
                    if (screen != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => screen),
                      );
                    }
                  });
                },
              ),
            ),
            SizedBox(height: 30),
            if (recommendedAlgo != null)
              Center(
                child: Text(
                  "Recommended Algorithm:\n$recommendedAlgo",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
          ],
        ),
      ),
    );
  }

  // ✅ Helper function to map algorithm name to visualizer screen
  Widget? getScreenForAlgorithm(String algo) {
    switch (algo) {
      case 'Bubble Sort':
        return BubbleSortScreen();
      case 'Quick Sort':
        return QuickSortScreen();
      case 'Merge Sort':
        return MergeSortScreen();
      case 'Binary Search':
        return BinarySearchScreen();
      case 'Linear Search':
        return LinearSearchScreen();
      case 'Dijkstra':
        return DijkstraScreen();
      case 'DFS':
        return DFSScreen();
      case 'BFS':
        return BFSScreen();
      default:
        return null;
    }
  }

  // 🔍 Basic AI-based recommendation logic
  String recommendAlgorithm({required String task, required int size, required bool isSorted}) {
    if (task == 'Search') {
      if (isSorted && size <= 1000) {
        return 'Binary Search';
      } else {
        return 'Linear Search';
      }
    } else if (task == 'Sort') {
      if (size <= 100) return 'Bubble Sort';
      if (size <= 500) return 'Quick Sort';
      return 'Merge Sort';
    } else if (task == 'Find Shortest Path') {
      if (size <= 300) return 'BFS';
      return 'Dijkstra';
    } else {
      return 'Quick Sort'; // Default fallback
    }
  }
}
