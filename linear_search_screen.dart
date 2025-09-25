import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/speed_slider.dart';

class LinearSearchScreen extends StatefulWidget {
  @override
  _LinearSearchScreenState createState() => _LinearSearchScreenState();
}

class _LinearSearchScreenState extends State<LinearSearchScreen> {
  List<int> _array = [10, 20, 30, 40, 50, 60, 70];
  int _currentIndex = -1;
  int _foundIndex = -1;
  bool _isSearching = false;
  int _target = 30;
  double _speed = 300; // milliseconds

  Future<void> _startSearch() async {
    setState(() {
      _isSearching = true;
      _currentIndex = -1;
      _foundIndex = -1;
    });

    for (int i = 0; i < _array.length; i++) {
      if (!_isSearching) break;

      setState(() {
        _currentIndex = i;
      });

      await Future.delayed(Duration(milliseconds: _speed.toInt()));

      if (_array[i] == _target) {
        setState(() {
          _foundIndex = i;
          _isSearching = false;
        });
        return;
      }
    }

    setState(() {
      _isSearching = false;
      _currentIndex = -1;
    });
  }

  void _reset() {
    setState(() {
      _isSearching = false;
      _currentIndex = -1;
      _foundIndex = -1;
    });
  }

  Widget _buildArrayDisplay() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _array.asMap().entries.map((entry) {
          int index = entry.key;
          int value = entry.value;
          Color color;

          if (_foundIndex == index) {
            color = Colors.green;
          } else if (_currentIndex == index) {
            color = Colors.orange;
          } else {
            color = Colors.white;
          }

          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.all(6),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$value',
              style: TextStyle(fontSize: 20),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Linear Search"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade800, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20),
              _buildArrayDisplay(),
              SizedBox(height: 30),

              // Target Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Enter target value",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    setState(() {
                      _target = int.tryParse(val) ?? _target;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),

              // Speed Slider
              SpeedSlider(
                speed: _speed,
                onSpeedChanged: (val) => setState(() => _speed = val),
              ),
              SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isSearching ? null : _startSearch,
                    icon: Icon(Icons.play_arrow),
                    label: Text("Start"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _reset,
                    icon: Icon(Icons.restart_alt),
                    label: Text("Reset"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Result
              Text(
                _foundIndex != -1
                    ? "Element found at index $_foundIndex"
                    : !_isSearching && _foundIndex == -1
                    ? "Element not found"
                    : "",
                style: TextStyle(
                  fontSize: 20,
                  color: _foundIndex != -1 ? Colors.greenAccent : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
