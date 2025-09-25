import 'package:flutter/material.dart';

class TrieNode {
  Map<String, TrieNode> children = {};
  bool isEndOfWord = false;
}

class Trie {
  TrieNode root = TrieNode();

  void insert(String word) {
    TrieNode node = root;
    for (int i = 0; i < word.length; i++) {
      String char = word[i];
      node.children.putIfAbsent(char, () => TrieNode());
      node = node.children[char]!;
    }
    node.isEndOfWord = true;
  }

  bool search(String word) {
    TrieNode? node = root;
    for (int i = 0; i < word.length; i++) {
      String char = word[i];
      if (!node!.children.containsKey(char)) return false;
      node = node.children[char];
    }
    return node!.isEndOfWord;
  }
}

class TrieScreen extends StatefulWidget {
  const TrieScreen({Key? key}) : super(key: key);

  @override
  _TrieScreenState createState() => _TrieScreenState();
}

class _TrieScreenState extends State<TrieScreen> {
  final Trie trie = Trie();
  final TextEditingController _wordController = TextEditingController();
  String resultMessage = "";
  List<String> insertedWords = [];

  void _insertWord() {
    String word = _wordController.text.trim().toLowerCase();
    if (word.isNotEmpty) {
      trie.insert(word);
      insertedWords.add(word);
      setState(() {
        resultMessage = "✅ '$word' inserted into Trie!";
      });
      _wordController.clear();
    }
  }

  void _searchWord() {
    String word = _wordController.text.trim().toLowerCase();
    if (word.isNotEmpty) {
      bool found = trie.search(word);
      setState(() {
        resultMessage =
        found ? "🔍 '$word' found in Trie ✅" : "❌ '$word' not found!";
      });
    }
  }

  Widget _buildTrieVisualization(TrieNode node, String prefix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: node.children.entries.map((entry) {
        String char = entry.key;
        TrieNode childNode = entry.value;
        return Padding(
          padding: const EdgeInsets.only(left: 16, top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: childNode.isEndOfWord
                    ? Colors.greenAccent.shade100
                    : Colors.blue.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    char,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              _buildTrieVisualization(childNode, prefix + char),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        title: const Text("📖 Trie Visualization"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Info Card
            Card(
              color: Colors.lightBlue.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: const Text(
                  "🔹 A Trie (Prefix Tree) is a tree-like data structure used to store strings efficiently.\n\n"
                      "✅ Operations:\n"
                      "• Insert: O(length of word)\n"
                      "• Search: O(length of word)\n\n"
                      "📌 Applications:\n"
                      "• Autocomplete\n"
                      "• Spell check\n"
                      "• IP routing\n"
                      "• Word games",
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Input field
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _wordController,
                    decoration: InputDecoration(
                      hintText: "Enter a word",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _insertWord,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Insert"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _searchWord,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Search"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Result Message
            Text(
              resultMessage,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),

            const SizedBox(height: 20),

            // Trie Visualization
            const Text(
              "📂 Trie Structure:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildTrieVisualization(trie.root, ""),
          ],
        ),
      ),
    );
  }
}
