import 'package:flutter/material.dart';
import 'dart:async';

class ExponentialSearchScreen extends StatefulWidget {
  @override
  _ExponentialSearchScreenState createState() =>
      _ExponentialSearchScreenState();
}

class _ExponentialSearchScreenState extends State<ExponentialSearchScreen> {
  List<int> arr = [2, 3, 4, 10, 40, 50, 80, 100];
  int target = 10;
  int highlightedIndex = -1;
  String result = "";

  Future<int> binarySearch(int left, int right) async {
    while (left <= right) {
      int mid = left + ((right - left) ~/ 2);
      setState(() => highlightedIndex = mid);
      await Future.delayed(Duration(seconds: 1));

      if (arr[mid] == target) return mid;
      if (arr[mid] < target)
        left = mid + 1;
      else
        right = mid - 1;
    }
    return -1;
  }

  Future<void> exponentialSearch() async {
    if (arr[0] == target) {
      setState(() => result = "Found at index 0");
      return;
    }

    int i = 1;
    while (i < arr.length && arr[i] <= target) {
      setState(() => highlightedIndex = i);
      await Future.delayed(Duration(seconds: 1));
      i *= 2;
    }

    int idx = await binarySearch(i ~/ 2, (i < arr.length) ? i : arr.length - 1);

    setState(() {
      result = idx != -1 ? "Found at index $idx" : "Not Found";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Exponential Search Visualizer")),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade200, Colors.blue.shade200],
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
                      ? Colors.redAccent
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: exponentialSearch,
              child: Text("Start Exponential Search"),
            ),
            SizedBox(height: 20),
            Text(result, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
