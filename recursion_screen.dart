import 'package:flutter/material.dart';
import 'dart:async';

class RecursionScreen extends StatefulWidget {
  @override
  _RecursionScreenState createState() => _RecursionScreenState();
}

class _RecursionScreenState extends State<RecursionScreen> {
  List<String> steps = [];
  int currentStep = 0;
  bool isRunning = false;
  final TextEditingController _controller = TextEditingController();

  int fib(int n, String prefix) {
    steps.add("$prefix ➝ fib($n) called");
    if (n <= 1) {
      steps.add("$prefix ← Returning $n");
      return n;
    }
    int left = fib(n - 1, prefix + "  ");
    int right = fib(n - 2, prefix + "  ");
    int result = left + right;
    steps.add("$prefix ← Returning $result");
    return result;
  }

  void startRecursion(int n) {
    steps.clear();
    fib(n, "");
    currentStep = 0;
    setState(() {
      isRunning = true;
    });

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (currentStep < steps.length - 1) {
        setState(() {
          currentStep++;
        });
      } else {
        timer.cancel();
        setState(() {
          isRunning = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text("Recursion Visualizer"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Fibonacci Recursion Tree",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.amberAccent),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter n",
                      hintStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white24,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: isRunning
                      ? null
                      : () {
                    if (_controller.text.isNotEmpty) {
                      int n = int.tryParse(_controller.text) ?? 0;
                      if (n < 0) return;
                      startRecursion(n);
                    }
                  },
                  child: Text("Start"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: Colors.deepPurpleAccent, width: 2),
                ),
                padding: EdgeInsets.all(12),
                child: steps.isEmpty
                    ? Center(
                  child: Text(
                    "Enter a number and press Start",
                    style: TextStyle(color: Colors.white70),
                  ),
                )
                    : ListView.builder(
                  itemCount: currentStep < steps.length
                      ? currentStep + 1
                      : steps.length,
                  itemBuilder: (context, index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 400),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: steps[index].contains("Returning")
                            ? Colors.green.withOpacity(0.3)
                            : Colors.deepPurple.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        steps[index],
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: "monospace"),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
