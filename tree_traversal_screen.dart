import 'package:flutter/material.dart';
import 'dart:async';

class TreeNode {
  final String value;
  final TreeNode? left;
  final TreeNode? right;

  TreeNode(this.value, {this.left, this.right});
}

class TreeTraversalScreen extends StatefulWidget {
  @override
  _TreeTraversalScreenState createState() => _TreeTraversalScreenState();
}

class _TreeTraversalScreenState extends State<TreeTraversalScreen> {
  late TreeNode root;
  List<String> traversalResult = [];
  bool isTraversing = false;

  @override
  void initState() {
    super.initState();
    root = TreeNode('A',
      left: TreeNode('B', left: TreeNode('D'), right: TreeNode('E')),
      right: TreeNode('C', left: TreeNode('F'), right: TreeNode('G')),
    );
  }

  Future<void> traverse(TreeNode? node, String type) async {
    if (node == null || !isTraversing) return;

    if (type == 'Preorder') {
      await visit(node);
      await traverse(node.left, type);
      await traverse(node.right, type);
    } else if (type == 'Inorder') {
      await traverse(node.left, type);
      await visit(node);
      await traverse(node.right, type);
    } else if (type == 'Postorder') {
      await traverse(node.left, type);
      await traverse(node.right, type);
      await visit(node);
    }
  }

  Future<void> visit(TreeNode node) async {
    setState(() {
      traversalResult.add(node.value);
    });
    await Future.delayed(Duration(milliseconds: 700));
  }

  Future<void> startTraversal(String type) async {
    if (isTraversing) return;
    setState(() {
      traversalResult.clear();
      isTraversing = true;
    });
    await traverse(root, type);
    setState(() {
      isTraversing = false;
    });
  }

  Widget buildNode(String value, bool isHighlighted) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.orange : Colors.blue.shade100,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))
        ],
      ),
      alignment: Alignment.center,
      child: Text(value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget buildTree() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildNode('A', traversalResult.contains('A')),
          ],
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildNode('B', traversalResult.contains('B')),
            buildNode('C', traversalResult.contains('C')),
          ],
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildNode('D', traversalResult.contains('D')),
            buildNode('E', traversalResult.contains('E')),
            buildNode('F', traversalResult.contains('F')),
            buildNode('G', traversalResult.contains('G')),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: Text('Tree Traversals'),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          buildTree(),
          SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => startTraversal('Inorder'),
                child: Text('Inorder'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              ),
              ElevatedButton(
                onPressed: () => startTraversal('Preorder'),
                child: Text('Preorder'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              ),
              ElevatedButton(
                onPressed: () => startTraversal('Postorder'),
                child: Text('Postorder'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            "Traversal Output:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              children: traversalResult
                  .map((e) => Container(
                margin: EdgeInsets.all(4),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(e,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
