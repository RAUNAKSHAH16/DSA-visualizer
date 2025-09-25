import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import '../widgets/speed_slider.dart';

class HeapSortScreen extends StatefulWidget {
  @override
  _HeapSortScreenState createState() => _HeapSortScreenState();
}

class _HeapSortScreenState extends State<HeapSortScreen> {
  List<int> _array = [];
  List<Color> _barColors = [];
  double _speed = 300;
  bool _isSorting = false;

  @override
  void initState() {
    super.initState();
    _generateArray();
  }

  void _generateArray() {
    final rand = Random();
    _array = List.generate(15, (_) => rand.nextInt(200) + 50);
    _barColors = List.generate(_array.length, (_) => Colors.blueAccent);
    setState(() {});
  }

  void _swap(int i, int j) {
    int temp = _array[i];
    _array[i] = _array[j];
    _array[j] = temp;

    Color tempColor = _barColors[i];
    _barColors[i] = _barColors[j];
    _barColors[j] = tempColor;
  }

  Future<void> _heapify(int n, int i) async {
    int largest = i;
    int left = 2 * i + 1;
    int right = 2 * i + 2;

    if (left < n && _array[left] > _array[largest]) {
      largest = left;
    }

    if (right < n && _array[right] > _array[largest]) {
      largest = right;
    }

    if (largest != i) {
      _barColors[i] = Colors.red;
      _barColors[largest] = Colors.green;
      setState(() {});
      await Future.delayed(Duration(milliseconds: _speed.toInt()));

      _swap(i, largest);
      setState(() {});

      await _heapify(n, largest);

      _barColors[i] = Colors.blueAccent;
      _barColors[largest] = Colors.blueAccent;
    }
  }

  Future<void> _heapSort() async {
    int n = _array.length;

    for (int i = n ~/ 2 - 1; i >= 0; i--) {
      await _heapify(n, i);
    }

    for (int i = n - 1; i >= 0; i--) {
      _swap(0, i);
      _barColors[i] = Colors.purple; // Mark as sorted
      setState(() {});
      await Future.delayed(Duration(milliseconds: _speed.toInt()));
      await _heapify(i, 0);
    }
  }

  Future<void> _startSort() async {
    setState(() => _isSorting = true);
    await _heapSort();
    setState(() => _isSorting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Heap Sort Visualizer"),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade900, Colors.indigoAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _array.asMap().entries.map((entry) {
                  int index = entry.key;
                  int value = entry.value;
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                    width: 15,
                    height: value.toDouble(),
                    decoration: BoxDecoration(
                      color: _barColors[index],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),

            // Speed Slider
            SpeedSlider(
              speed: _speed,
              onSpeedChanged: (val) => setState(() => _speed = val),
            ),

            SizedBox(height: 10),
            if (!_isSorting)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _generateArray,
                    icon: Icon(Icons.refresh),
                    label: Text('Shuffle'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.indigo,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _startSort,
                    icon: Icon(Icons.play_arrow),
                    label: Text('Start'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green,
                    ),
                  ),
                ],
              ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
