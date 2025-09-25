import 'package:flutter/material.dart';
import '../widgets/bar_widget.dart';
import 'dart:async';
import '../widgets/speed_slider.dart';

class SelectionSortScreen extends StatefulWidget {
  @override
  _SelectionSortScreenState createState() => _SelectionSortScreenState();
}

class _SelectionSortScreenState extends State<SelectionSortScreen> {
  List<double> bars = [];
  int selectedBar = -1;
  int comparingBar = -1;
  bool isSorting = false;
  double _speed = 300; //

  @override
  void initState() {
    super.initState();
    _generateBars();
  }

  void _generateBars() {
    bars = List.generate(30, (index) => (100 + index * 4).toDouble());
    bars.shuffle();
    selectedBar = -1;
    comparingBar = -1;
    setState(() {});
  }

  Future<void> _selectionSort() async {
    setState(() {

      isSorting = true;
    });

    int n = bars.length;
    for (int i = 0; i < n - 1; i++) {
      int minIndex = i;
      setState(() {
        selectedBar = minIndex;
      });

      for (int j = i + 1; j < n; j++) {
        setState(() {
          comparingBar = j;
        });

        await Future.delayed(Duration(milliseconds: _speed.toInt()));

        if (bars[j] < bars[minIndex]) {
          minIndex = j;
          setState(() {
            selectedBar = minIndex;
          });
        }
      }

      if (minIndex != i) {
        double temp = bars[i];
        bars[i] = bars[minIndex];
        bars[minIndex] = temp;
      }
    }

    setState(() {
      isSorting = false;
      selectedBar = -1;
      comparingBar = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Selection Sort Visualizer"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF6F00), Color(0xFFFFB74D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 12),
              Text(
                "Visualize how Selection Sort works!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              SpeedSlider(
                speed: _speed,
                onSpeedChanged: (val) => setState(() => _speed = val),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: bars
                          .asMap()
                          .entries
                          .map((entry) => BarWidget(
                        value: entry.value,
                        isHighlighted: entry.key == selectedBar ||
                            entry.key == comparingBar,
                        color: entry.key == selectedBar
                            ? Colors.deepOrangeAccent
                            : entry.key == comparingBar
                            ? Colors.amber
                            : Colors.white,
                      ))
                          .toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: isSorting ? null : _generateBars,
                    icon: Icon(Icons.shuffle),
                    label: Text("Shuffle"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 6,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: isSorting ? null : _selectionSort,
                    icon: Icon(Icons.sort),
                    label: Text("Sort"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 6,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
