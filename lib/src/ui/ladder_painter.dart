// lib/src/ui/ladder_painter.dart

import 'package:flutter/material.dart';

class LadderPainter extends CustomPainter {
  final int participantCount;
  final int ladderRows;
  final List<List<bool>> connections;

  LadderPainter({
    required this.participantCount,
    required this.ladderRows,
    required this.connections,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final double columnWidth = size.width / participantCount;
    final double rowHeight = size.height / (ladderRows + 1);

    // 세로선 그리기
    for (int i = 0; i < participantCount; i++) {
      final double x = columnWidth * i + columnWidth / 2;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // 가로선 그리기
    for (int row = 0; row < ladderRows; row++) {
      final double y = rowHeight * (row + 1);

      for (int col = 0; col < participantCount - 1; col++) {
        if (connections[row][col]) {
          final double x1 = columnWidth * col + columnWidth / 2;
          final double x2 = columnWidth * (col + 1) + columnWidth / 2;
          canvas.drawLine(Offset(x1, y), Offset(x2, y), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant LadderPainter oldDelegate) {
    return oldDelegate.participantCount != participantCount ||
        oldDelegate.ladderRows != ladderRows ||
        oldDelegate.connections != connections;
  }
}
