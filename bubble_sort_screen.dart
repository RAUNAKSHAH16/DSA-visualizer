import 'package:flutter/material.dart';
import '../widgets/bar_widget.dart';
import 'dart:async';
import '../widgets/speed_slider.dart';
import 'package:fl_chart/fl_chart.dart';

class BubbleSortScreen extends StatefulWidget {
  @override
  _BubbleSortScreenState createState() => _BubbleSortScreenState();
}

class _BubbleSortScreenState extends State<BubbleSortScreen> {
  List<double> bars = [];
  int highlightedIndex = -1;
  bool isSorting = false;
  double _speed = 300.0;

  int comparisons = 0;
  List<FlSpot> timeComplexityPoints = [];

  @override
  void initState() {
    super.initState();
    _generateBars();
  }

  void _generateBars() {
    bars = List.generate(30, (index) => (100 + index * 4).toDouble());
    bars.shuffle();
    highlightedIndex = -1;
    comparisons = 0;
    timeComplexityPoints.clear();
    setState(() {});
  }

  Future<void> _bubbleSort() async {
    setState(() {
      isSorting = true;
    });

    for (int i = 0; i < bars.length - 1; i++) {
      for (int j = 0; j < bars.length - i - 1; j++) {
        setState(() {
          highlightedIndex = j;
        });

        await Future.delayed(Duration(milliseconds: _speed.toInt()));

        comparisons++;
        timeComplexityPoints.add(FlSpot(comparisons.toDouble(), bars.length.toDouble()));
        setState(() {});

        if (bars[j] > bars[j + 1]) {
          double temp = bars[j];
          bars[j] = bars[j + 1];
          bars[j + 1] = temp;
        }
      }
    }

    setState(() {
      highlightedIndex = -1;
      isSorting = false;
    });
  }

  Widget buildLineChart() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            backgroundColor: Colors.white,
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 20),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 28),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: true),
            gridData: FlGridData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: timeComplexityPoints,
                isCurved: true,
                dotData: FlDotData(show: false),
                color: Colors.redAccent,
                barWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Bubble Sort Visualizer"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF004D40), Color(0xFF1DE9B6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 12),
              Text(
                "Watch Bubble Sort in Action!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SpeedSlider(
                speed: _speed,
                onSpeedChanged: (val) => setState(() => _speed = val),
              ),
              buildLineChart(), // 👈 Add graph view here
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
                        isHighlighted: entry.key == highlightedIndex,
                        color: entry.key == highlightedIndex
                            ? Colors.limeAccent
                            : Color(0xFF00C853),
                      ))
                          .toList(),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: isSorting ? null : _generateBars,
                    icon: Icon(Icons.shuffle),
                    label: Text("Shuffle"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 6,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: isSorting ? null : _bubbleSort,
                    icon: Icon(Icons.sort),
                    label: Text("Sort"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 6,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "Time Complexity: O(n²)\nSpace Complexity: O(1)",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
