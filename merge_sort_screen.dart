import 'package:flutter/material.dart';
import '../widgets/bar_widget.dart';
import 'dart:async';
import '../widgets/speed_slider.dart';

class MergeSortScreen extends StatefulWidget {
  @override
  _MergeSortScreenState createState() => _MergeSortScreenState();
}

class _MergeSortScreenState extends State<MergeSortScreen> {
  List<double> bars = [];
  int highlightLeft = -1;
  int highlightRight = -1;
  bool isSorting = false;
  double _speed = 300; // Initial speed in milliseconds


  @override
  void initState() {
    super.initState();
    _generateBars();
  }

  void _generateBars() {
    bars = List.generate(30, (index) => (100 + index * 4).toDouble());
    bars.shuffle();
    highlightLeft = -1;
    highlightRight = -1;
    setState(() {});
  }

  Future<void> _mergeSort(int left, int right) async {
    if (left < right) {
      int mid = (left + right) ~/ 2;
      await _mergeSort(left, mid);
      await _mergeSort(mid + 1, right);
      await _merge(left, mid, right);
    }
  }

  Future<void> _merge(int left, int mid, int right) async {
    List<double> temp = bars.sublist(left, right + 1);
    int i = 0, j = mid - left + 1, k = left;

    while (i <= mid - left && j <= right - left) {
      setState(() {
        highlightLeft = k;
        highlightRight = j + left;
      });

      await Future.delayed(Duration(milliseconds: _speed.toInt()));


      if (temp[i] <= temp[j]) {
        bars[k++] = temp[i++];
      } else {
        bars[k++] = temp[j++];
      }
      setState(() {});
    }

    while (i <= mid - left) {
      await Future.delayed(Duration(milliseconds: 40));
      bars[k++] = temp[i++];
      setState(() {
        highlightLeft = k;
        highlightRight = -1;
      });
    }

    while (j <= right - left) {
      await Future.delayed(Duration(milliseconds: 40));
      bars[k++] = temp[j++];
      setState(() {
        highlightLeft = k;
        highlightRight = -1;
      });
    }
  }

  Future<void> _startMergeSort() async {
    setState(() {
      isSorting = true;
    });
    await _mergeSort(0, bars.length - 1);
    setState(() {
      isSorting = false;
      highlightLeft = -1;
      highlightRight = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Merge Sort Visualizer"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 12),
              Text(
                "Merge Sort Step-by-Step Animation",
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
                      children: bars.asMap().entries.map((entry) {
                        int index = entry.key;
                        return BarWidget(
                          value: entry.value,
                          isHighlighted:
                          index == highlightLeft || index == highlightRight,
                          color: index == highlightLeft
                              ? Colors.purpleAccent
                              : index == highlightRight
                              ? Colors.deepPurple
                              : Colors.white,
                        );
                      }).toList(),
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
                      foregroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 6,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: isSorting ? null : _startMergeSort,
                    icon: Icon(Icons.sort),
                    label: Text("Sort"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurpleAccent,
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
