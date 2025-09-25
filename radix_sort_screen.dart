import 'package:flutter/material.dart';
import 'dart:async';

class RadixSortScreen extends StatefulWidget {
  @override
  _RadixSortScreenState createState() => _RadixSortScreenState();
}

class _RadixSortScreenState extends State<RadixSortScreen> {
  List<int> arr = [170, 45, 75, 90, 802, 24, 2, 66];
  int highlightedIndex = -1;

  Future<void> countingSortByExp(int exp) async {
    int n = arr.length;
    List<int> output = List.filled(n, 0);
    List<int> count = List.filled(10, 0);

    for (int i = 0; i < n; i++) {
      count[(arr[i] ~/ exp) % 10]++;
      setState(() => highlightedIndex = i);
      await Future.delayed(Duration(milliseconds: 300));
    }

    for (int i = 1; i < 10; i++) count[i] += count[i - 1];

    for (int i = n - 1; i >= 0; i--) {
      output[count[(arr[i] ~/ exp) % 10] - 1] = arr[i];
      count[(arr[i] ~/ exp) % 10]--;
      setState(() => arr = List.from(output));
      await Future.delayed(Duration(milliseconds: 300));
    }
  }

  Future<void> radixSort() async {
    int maxVal = arr.reduce((a, b) => a > b ? a : b);
    for (int exp = 1; maxVal ~/ exp > 0; exp *= 10) {
      await countingSortByExp(exp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Radix Sort Visualizer")),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade200, Colors.teal.shade200],
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
                      ? Colors.greenAccent
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10),
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
              onPressed: radixSort,
              child: Text("Start Radix Sort"),
            )
          ],
        ),
      ),
    );
  }
}
