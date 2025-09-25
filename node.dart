class Node {
  final int row;
  final int col;
  NodeType type;
  double distance;
  Node? previous;
  bool isVisited;

  Node({
    required this.row,
    required this.col,
    this.type = NodeType.normal,
    this.distance = double.infinity,
    this.previous,
    this.isVisited = false,
  });
}

enum NodeType {
  start,
  end,
  wall,
  visited,
  normal,
  path
}
