import 'package:flutter/material.dart';
import 'dart:async';

class CountingSortScreen extends StatefulWidget {
  @override
  _CountingSortScreenState createState() => _CountingSortScreenState();
}

class _CountingSortScreenState extends State<CountingSortScreen> {
  List<int> arr = [9, 4, 1, 7, 9, 1, 2, 0]; // sample array
  int highlightedIndex = -1;

  Future<void> countingSort() async {
    int n = arr.length;
    int maxVal = arr.reduce((a, b) => a > b ? a : b);
    List<int> count = List.filled(maxVal + 1, 0);
    List<int> output = List.filled(n, 0);

    // Count occurrences
    for (int i = 0; i < n; i++) {
      count[arr[i]]++;
      setState(() => highlightedIndex = i);
      await Future.delayed(Duration(milliseconds: 400));
    }

    // Cumulative count
    for (int i = 1; i <= maxVal; i++) {
      count[i] += count[i - 1];
      setState(() {});
      await Future.delayed(Duration(milliseconds: 400));
    }

    // Place elements in output
    for (int i = n - 1; i >= 0; i--) {
      output[count[arr[i]] - 1] = arr[i];
      count[arr[i]]--;
      setState(() => arr = List.from(output));
      await Future.delayed(Duration(milliseconds: 400));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Counting Sort Visualizer")),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade200, Colors.blue.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              spacing: 10,
              children: arr
                  .asMap()
                  .entries
                  .map((entry) => Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: entry.key == highlightedIndex
                      ? Colors.orange
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(2, 2))
                  ],
                ),
                child: Text(
                  entry.value.toString(),
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ))
                  .toList(),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: countingSort,
              child: Text("Start Counting Sort"),
            )
          ],
        ),
      ),
    );
  }
}
