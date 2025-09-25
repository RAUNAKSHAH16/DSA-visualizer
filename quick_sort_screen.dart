import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/speed_slider.dart';

class QuickSortScreen extends StatefulWidget {
  @override
  _QuickSortScreenState createState() => _QuickSortScreenState();
}

class _QuickSortScreenState extends State<QuickSortScreen> {
  List<int> _array = [];
  List<Color> _barColors = [];
  bool _isSorting = false;
  double _speed = 300; // 👈 Speed in milliseconds, adjustable via slider

  @override
  void initState() {
    super.initState();
    _generateRandomArray();
  }

  void _generateRandomArray() {
    final random = Random();
    _array = List.generate(15, (_) => random.nextInt(200) + 50);
    _barColors = List.generate(_array.length, (_) => Colors.blueAccent);
    setState(() {});
  }

  Future<void> _quickSort(int low, int high) async {
    if (low < high) {
      int pivotIndex = await _partition(low, high);
      await _quickSort(low, pivotIndex - 1);
      await _quickSort(pivotIndex + 1, high);
    }
  }

  Future<int> _partition(int low, int high) async {
    int pivot = _array[high];
    _barColors[high] = Colors.red;
    int i = low - 1;

    for (int j = low; j < high; j++) {
      _barColors[j] = Colors.orange;
      await Future.delayed(Duration(milliseconds: _speed.toInt()));
// 👈 Uses slider speed
      setState(() {});

      if (_array[j] < pivot) {
        i++;
        _swap(i, j);
        _barColors[i] = Colors.green;
      }

      _barColors[j] = Colors.blueAccent;
    }

    _swap(i + 1, high);
    _barColors[high] = Colors.blueAccent;
    setState(() {});
    return i + 1;
  }

  void _swap(int i, int j) {
    int temp = _array[i];
    _array[i] = _array[j];
    _array[j] = temp;

    Color tempColor = _barColors[i];
    _barColors[i] = _barColors[j];
    _barColors[j] = tempColor;
  }

  Future<void> _startSort() async {
    setState(() => _isSorting = true);
    await _quickSort(0, _array.length - 1);
    setState(() => _isSorting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quick Sort Visualizer'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade900, Colors.deepPurpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _array.asMap().entries.map((entry) {
                  int idx = entry.key;
                  int val = entry.value;
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                    width: 15,
                    height: val.toDouble(),
                    decoration: BoxDecoration(
                      color: _barColors[idx],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 30),

            // 👇 Speed Slider Added Here
            SpeedSlider(
              speed: _speed,
              onSpeedChanged: (val) => setState(() => _speed = val),
            ),

            // 👇 Control Buttons
            if (!_isSorting)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _generateRandomArray,
                    icon: Icon(Icons.refresh),
                    label: Text('Shuffle'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
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
