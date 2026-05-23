import 'package:flutter/foundation.dart';

@immutable
class Position {
  const Position(this.row, this.col);

  final int row;
  final int col;

  @override
  bool operator ==(Object other) =>
      other is Position && other.row == row && other.col == col;

  @override
  int get hashCode => Object.hash(row, col);

  @override
  String toString() => 'Position($row, $col)';
}
