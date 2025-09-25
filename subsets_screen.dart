import 'package:flutter/material.dart';
import 'dart:math';

class SubsetsScreen extends StatefulWidget {
  const SubsetsScreen({Key? key}) : super(key: key);

  @override
  _SubsetsScreenState createState() => _SubsetsScreenState();
}

class _SubsetsScreenState extends State<SubsetsScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  List<int> numbers = [];
  List<List<int>> subsets = [];
  bool generated = false;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
    AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _animation =
        Tween<double>(begin: 0, end: 8).animate(_animationController);
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void generateSubsets() {
    subsets.clear();
    int n = numbers.length;
    int total = pow(2, n).toInt();

    for (int mask = 0; mask < total; mask++) {
      List<int> subset = [];
      for (int i = 0; i < n; i++) {
        if ((mask & (1 << i)) != 0) {
          subset.add(numbers[i]);
        }
      }
      subsets.add(subset);
    }

    setState(() {
      generated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Subsets (Power Set)"),
        backgroundColor: Colors.deepPurple,
        elevation: 6,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.indigo, Colors.black87],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Info card
            Card(
              margin: const EdgeInsets.all(12),
              color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "🔢 The Subset Problem:\n\n"
                      "For an array of size n, there are 2^n possible subsets.\n"
                      "This algorithm generates all subsets using bit masking.\n\n"
                      "Example: [1,2] → [ ], [1], [2], [1,2]",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),

            // Input field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Enter numbers separated by commas (e.g. 1,2,3)",
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.input),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Generate button
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  numbers = _controller.text
                      .split(',')
                      .where((e) => e.trim().isNotEmpty)
                      .map((e) => int.tryParse(e.trim()) ?? 0)
                      .toList();
                });
                generateSubsets();
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text("Generate Subsets"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
            ),

            const SizedBox(height: 20),

            // Result area
            Expanded(
              child: generated
                  ? ListView.builder(
                itemCount: subsets.length,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, sin(_animation.value) * 4),
                        child: Card(
                          color: Colors.white.withOpacity(0.9),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.deepPurple,
                              child: Text(
                                "${index + 1}",
                                style:
                                const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(subsets[index].toString()),
                          ),
                        ),
                      );
                    },
                  );
                },
              )
                  : const Center(
                child: Text(
                  "👉 Enter an array and click 'Generate Subsets' to see all subsets here.",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
