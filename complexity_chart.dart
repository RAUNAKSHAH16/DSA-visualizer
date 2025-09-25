import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ComplexityChart extends StatelessWidget {
  final String type;

  ComplexityChart({required this.type});

  List<FlSpot> generateData(String type) {
    List<FlSpot> data = [];
    for (int i = 1; i <= 10; i++) {
      double y;
      switch (type) {
        case 'O(n)':
          y = i.toDouble();
          break;
        case 'O(n^2)':
          y = (i * i).toDouble();
          break;
        case 'O(log n)':
          y = (math.log(i) / math.ln2);
          break;
        case 'O(n log n)':
          y = i * (math.log(i) / math.ln2);
          break;
        default:
          y = i.toDouble();
      }
      data.add(FlSpot(i.toDouble(), y));
    }
    return data;
  }

  Color getColorByType() {
    switch (type) {
      case 'O(n)':
        return Colors.green;
      case 'O(n^2)':
        return Colors.red;
      case 'O(log n)':
        return Colors.purple;
      case 'O(n log n)':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final points = generateData(type);
    final color = getColorByType();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.15), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(2, 4),
            )
          ],
        ),
        child: Column(
          children: [
            SizedBox(height: 16),
            Text(
              'Time Complexity Chart: $type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: points,
                      isCurved: true,
                      color: color,
                      dotData: FlDotData(show: true),
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        color: color.withOpacity(0.25),
                      ),
                    )
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 10,
                        reservedSize: 35,
                        getTitlesWidget: (value, meta) => Text(
                          value.toStringAsFixed(0),
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) => Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'n=${value.toInt()}',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  minX: 1,
                  maxX: 10,
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
