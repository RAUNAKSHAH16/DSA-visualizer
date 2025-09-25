import 'package:flutter/material.dart';
import '../widgets/bar_widget.dart';


class BinarySearchScreen extends StatefulWidget {
  @override
  _BinarySearchScreenState createState() => _BinarySearchScreenState();
}

class _BinarySearchScreenState extends State<BinarySearchScreen> {
  List<double> bars = [];
  int low = 0;
  int high = 0;
  int mid = -1;
  int targetIndex = -1;
  int? targetValue;
  bool isSearching = false;
  bool found = false;
  final TextEditingController targetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generateBars();
  }

  void _generateBars() {
    bars = List.generate(18, (index) => (60 + index * 10).toDouble());
    bars.sort();
    low = 0;
    high = bars.length - 1;
    mid = -1;
    targetIndex = -1;
    found = false;
    isSearching = false;
    targetController.clear();
    setState(() {});
  }

  void _startSearch() {
    if (targetController.text.isEmpty) return;

    final value = int.tryParse(targetController.text);
    if (value == null) return;

    setState(() {
      targetValue = value;
      low = 0;
      high = bars.length - 1;
      mid = -1;
      found = false;
      targetIndex = -1;
      isSearching = true;
    });
  }

  void _nextStep() {
    if (!isSearching || low > high || found || targetValue == null) return;

    setState(() {
      mid = (low + high) ~/ 2;

      if (bars[mid].toInt() == targetValue) {
        found = true;
        targetIndex = mid;
        isSearching = false;
      } else if (bars[mid].toInt() < targetValue!) {
        low = mid + 1;
      } else {
        high = mid - 1;
      }

      // Stop searching if range is invalid
      if (low > high && !found) {
        isSearching = false;
      }
    });
  }

  Color _getBarColor(int index) {
    if (index == targetIndex) return Colors.greenAccent;
    if (index == mid) return Colors.redAccent;
    if (index >= low && index <= high && isSearching) return Colors.tealAccent;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Binary Search (Visualizer)"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF004D40), Color(0xFF26A69A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: targetController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter target value",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: isSearching ? null : _startSearch,
                      child: Text("Start"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: bars.asMap().entries.map((entry) {
                        return BarWidget(
                          value: entry.value,
                          color: _getBarColor(entry.key),
                          isHighlighted: entry.key == mid,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              if (found)
                Text(
                  "🎯 Target Found at index $targetIndex!",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )
              else if (!found && !isSearching)
                Text(
                  "❌ Target not found!",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _generateBars,
                    icon: Icon(Icons.refresh),
                    label: Text("Shuffle"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.teal,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: (isSearching && !found && low <= high)
                        ? _nextStep
                        : null,
                    icon: Icon(Icons.skip_next),
                    label: Text("Next"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.indigo,
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
