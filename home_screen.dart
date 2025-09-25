import 'package:flutter/material.dart';
import 'dijkstra_screen.dart';
import 'bubble_sort_screen.dart';
import 'selection_sort_screen.dart';
import 'merge_sort_screen.dart';
import 'binary_search_screen.dart';
import 'quick_sort_screen.dart';
import 'dfs_screen.dart';
import 'bfs_screen.dart';
import 'heap_sort_screen.dart';
import 'linear_search_screen.dart';
import 'topological_sort_screen.dart';
import 'algorithm_assistant_screen.dart';
import 'sliding_window_screen.dart';
import 'chat_screen.dart';
import 'n_queens_visualizer.dart';
import 'sudoku_solver.dart';
import 'rat_maze.dart';
import 'tree_traversal_screen.dart';
import 'word_search_screen.dart';
import 'knights_tour_screen.dart';
import 'counting_sort_screen.dart';
import 'radix_sort_screen.dart';
import 'exponential_search_screen.dart';
import 'two_sum_screen.dart';
import 'knapsack_screen.dart';
import 'subsets_screen.dart';
import 'trie_screen.dart';
import 'recursion_screen.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> algorithms = [
    {'name': 'Dijkstra', 'screen': DijkstraScreen(), 'icon': Icons.map},
    {'name': 'Bubble Sort', 'screen': BubbleSortScreen(), 'icon': Icons.bubble_chart},
    {'name': 'Selection Sort', 'screen': SelectionSortScreen(), 'icon': Icons.select_all},
    {'name': 'Merge Sort', 'screen': MergeSortScreen(), 'icon': Icons.merge_type},
    {'name': 'Binary Search', 'screen': BinarySearchScreen(), 'icon': Icons.search},
    {'name': 'Quick Sort', 'screen': QuickSortScreen(), 'icon': Icons.speed},
    {'name': 'DFS', 'screen': DFSScreen(), 'icon': Icons.linear_scale},
    {'name': 'BFS', 'screen': BFSScreen(), 'icon': Icons.sync_alt},
    {'name': 'Heap Sort', 'screen': HeapSortScreen(), 'icon': Icons.sort},
    {'name': 'Linear Search', 'screen': LinearSearchScreen(), 'icon': Icons.find_in_page},
    {'name': 'Topological Sort', 'screen': TopologicalSortScreen(), 'icon': Icons.timeline},
    {'name': 'AI Assistant', 'screen': AlgorithmAssistantScreen(), 'icon': Icons.smart_toy},
    {'name': 'Sliding Window', 'screen': SlidingWindowScreen(), 'icon': Icons.view_week},
    {'name': 'OpenAI Chat', 'screen': ChatScreen(), 'icon': Icons.chat},
    {'name': 'N-Queens', 'screen': NQueensVisualizer(), 'icon': Icons.grid_on},
    {'name': 'Sudoku Solver', 'screen': SudokuSolver(), 'icon': Icons.grid_4x4},
    {'name': 'Rat in a Maze', 'screen': RatInMazeScreen(), 'icon': Icons.route},
    {'name': 'Tree Traversals', 'screen': TreeTraversalScreen(), 'icon': Icons.account_tree},
    {'name': 'Word Search', 'screen': WordSearchScreen(), 'icon': Icons.grid_view},
    {'name': 'Knight\'s Tour', 'screen': KnightsTourScreen(), 'icon': Icons.directions_walk},
    {'name': 'Counting Sort', 'screen': CountingSortScreen(), 'icon': Icons.filter_9_plus},
    {'name': 'Radix Sort', 'screen': RadixSortScreen(), 'icon': Icons.format_list_numbered},
    {'name': 'Exponential Search', 'screen': ExponentialSearchScreen(), 'icon': Icons.trending_up},
    {'name': 'Two Sum (HashMap)', 'screen': TwoSumScreen(), 'icon': Icons.exposure_plus_2},
    {'name': '0/1 Knapsack', 'screen': KnapsackScreen(), 'icon': Icons.backpack},
    {'name': 'Subsets (Power Set)', 'screen': SubsetsScreen(), 'icon': Icons.grid_view},
    {'name': 'Trie Visualization', 'screen': TrieScreen(), 'icon': Icons.account_tree},
    {'name': 'Recursion Visualizer', 'screen': RecursionScreen(), 'icon': Icons.device_hub},

  ];

  @override
  Widget build(BuildContext context) {
    final filteredAlgorithms = algorithms
        .where((algo) => algo['name'].toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("DSA Visualizer"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search algorithm...',
                    hintStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white24,
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              Text(
                "Welcome to DSA Visualizer",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 20),

              // Use Expanded to fill remaining space and avoid overflow or white gap
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    itemCount: filteredAlgorithms.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemBuilder: (context, index) {
                      final algo = filteredAlgorithms[index];
                      return ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => algo['screen']),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(algo['icon'], size: 40),
                            SizedBox(height: 10),
                            Text(
                              algo['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
