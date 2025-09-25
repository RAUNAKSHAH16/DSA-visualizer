import 'package:flutter/material.dart';
import 'dart:async';

class TwoSumScreen extends StatefulWidget {
  @override
  _TwoSumScreenState createState() => _TwoSumScreenState();
}

class _TwoSumScreenState extends State<TwoSumScreen> {
  List<int> arr = [2, 7, 11, 15];
  int? target;
  Map<int, int> hashMap = {};
  List<int>? result;
  String explanation = "Enter a target value and start!";
  int currentIndex = -1;

  bool isRunning = false;

  final TextEditingController targetController = TextEditingController();

  Future<void> runTwoSum() async {
    if (target == null) return;

    setState(() {
      hashMap.clear();
      result = null;
      explanation = "Starting Two Sum algorithm...";
      currentIndex = -1;
      isRunning = true;
    });

    for (int i = 0; i < arr.length; i++) {
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        currentIndex = i;
        explanation =
        "Checking element ${arr[i]} at index $i. Need ${target! - arr[i]} to reach $target.";
      });

      int complement = target! - arr[i];
      if (hashMap.containsKey(complement)) {
        await Future.delayed(Duration(seconds: 2));
        setState(() {
          result = [hashMap[complement]!, i];
          explanation =
          "Found! ${arr[i]} + $complement = $target at indices ${result![0]} and ${result![1]} 🎉";
          isRunning = false;
        });
        return;
      }

      hashMap[arr[i]] = i;
      setState(() {
        explanation += "\nNot found. Adding ${arr[i]} to HashMap.";
      });
    }

    setState(() {
      explanation = "No two numbers sum to $target ❌";
      isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade700, Colors.blue.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                "🔎 Two Sum (HashMap) Visualizer",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 8, color: Colors.black45)],
                ),
              ),
              SizedBox(height: 20),

              // Input for target
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: targetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Enter Target Value",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onChanged: (val) {
                    if (val.isNotEmpty) {
                      target = int.tryParse(val);
                    }
                  },
                ),
              ),
              SizedBox(height: 20),

              // Array Display
              Wrap(
                spacing: 12,
                children: arr.asMap().entries.map((entry) {
                  int idx = entry.key;
                  int value = entry.value;
                  bool isHighlighted = idx == currentIndex;
                  bool isResult =
                      result != null && (result![0] == idx || result![1] == idx);

                  return AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isResult
                          ? Colors.greenAccent
                          : (isHighlighted ? Colors.orangeAccent : Colors.white),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(2, 2),
                        )
                      ],
                    ),
                    child: Text(
                      "$value",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                        isHighlighted || isResult ? Colors.black : Colors.blue,
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 30),

              // Explanation box
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  explanation,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(height: 20),

              // Start Button
              ElevatedButton(
                onPressed: isRunning ? null : runTwoSum,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: Text(
                  "▶ Start",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
