import 'dart:math';

import 'package:flutter/material.dart';

class LadderPainter extends CustomPainter {
  final int participantCount;
  final int ladderRows;
  final List<List<bool>> connections;
  final List<List<int>> allPaths;
  final int currentStep;
  final double animationProgress;

  LadderPainter({
    required this.participantCount,
    required this.ladderRows,
    required this.connections,
    required this.allPaths,
    required this.currentStep,
    this.animationProgress = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final double verticalMargin = size.height * 0.05;
    final double columnWidth = size.width / participantCount;
    // 수정: 결과 위치까지 포함하여 높이 계산 (ladderRows + 2로 변경)
    final double rowHeight =
        (size.height - 2 * verticalMargin) / (ladderRows + 2);

    // 세로선 그리기 - 결과 위치까지 연장
    for (int i = 0; i < participantCount; i++) {
      final double x = columnWidth * i + columnWidth / 2;
      canvas.drawLine(
        Offset(x, verticalMargin),
        Offset(x, size.height - verticalMargin),
        paint,
      );
    }

    // 가로선 그리기
    for (int row = 0; row < ladderRows; row++) {
      final double y = verticalMargin + rowHeight * (row + 1);

      for (int col = 0; col < participantCount - 1; col++) {
        if (row < connections.length &&
            col < connections[row].length &&
            connections[row][col]) {
          final double x1 = columnWidth * col + columnWidth / 2;
          final double x2 = columnWidth * (col + 1) + columnWidth / 2;

          final horizontalPaint = Paint()
            ..color = Colors.black87
            ..strokeWidth = 3.0
            ..strokeCap = StrokeCap.round;

          canvas.drawLine(Offset(x1, y), Offset(x2, y), horizontalPaint);
        }
      }
    }

    // 경로 그리기 (수정된 부분)
    if (allPaths.isNotEmpty && currentStep > 0) {
      List<Color> pathColors = [
        Colors.red,
        Colors.blue,
        Colors.green,
        Colors.orange,
        Colors.purple,
        Colors.teal,
        Colors.pink,
        Colors.brown,
      ];

      for (int pathIndex = 0; pathIndex < allPaths.length; pathIndex++) {
        final path = allPaths[pathIndex];
        final color = pathColors[pathIndex % pathColors.length];

        _drawPath(
          canvas,
          path,
          color,
          size,
          verticalMargin,
          columnWidth,
          rowHeight,
        );
      }
    }

    // 현재 위치 표시 (수정된 부분)
    if (allPaths.isNotEmpty && currentStep < allPaths[0].length) {
      List<Color> circleColors = [
        Colors.red,
        Colors.blue,
        Colors.green,
        Colors.orange,
        Colors.purple,
        Colors.teal,
        Colors.pink,
        Colors.brown,
      ];

      for (int pathIndex = 0; pathIndex < allPaths.length; pathIndex++) {
        final path = allPaths[pathIndex];
        if (currentStep < path.length) {
          _drawAnimatedParticipant(
            canvas,
            path,
            pathIndex,
            circleColors[pathIndex % circleColors.length],
            size,
            verticalMargin,
            columnWidth,
            rowHeight,
          );
        }
      }
    }
  }

  void _drawPath(
    Canvas canvas,
    List<int> path,
    Color color,
    Size size,
    double verticalMargin,
    double columnWidth,
    double rowHeight,
  ) {
    final pathPaint = Paint()
      ..color = color.withAlpha((255.0 * 0.8).round())
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final shadowPaint = Paint()
      ..color = color.withAlpha((255.0 * 0.3).round())
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    // 현재까지의 경로만 그리기 (수정: 최종 위치까지)
    for (int i = 0; i < min(currentStep, path.length - 1); i++) {
      final int fromCol = path[i];
      final int toCol = path[i + 1];
      final double fromY = verticalMargin + rowHeight * i;
      final double toY = verticalMargin + rowHeight * (i + 1);

      final double fromX = columnWidth * fromCol + columnWidth / 2;
      final double toX = columnWidth * toCol + columnWidth / 2;

      if (fromCol == toCol) {
        // 세로선 (직진)
        canvas.drawLine(Offset(fromX, fromY), Offset(toX, toY), shadowPaint);
        canvas.drawLine(Offset(fromX, fromY), Offset(toX, toY), pathPaint);
      } else {
        // 가로이동이 있는 경우: L자 모양으로 그리기
        // 1. 세로선 부분
        canvas.drawLine(Offset(fromX, fromY), Offset(fromX, toY), shadowPaint);
        canvas.drawLine(Offset(fromX, fromY), Offset(fromX, toY), pathPaint);

        // 2. 가로선 부분
        final horizontalPaint = Paint()
          ..color = color.withAlpha((255.0 * 0.9).round())
          ..strokeWidth = 7.0
          ..strokeCap = StrokeCap.round;

        canvas.drawLine(Offset(fromX, toY), Offset(toX, toY), shadowPaint);
        canvas.drawLine(Offset(fromX, toY), Offset(toX, toY), horizontalPaint);
      }
    }
  }

  void _drawAnimatedParticipant(
    Canvas canvas,
    List<int> path,
    int pathIndex,
    Color color,
    Size size,
    double verticalMargin,
    double columnWidth,
    double rowHeight,
  ) {
    if (currentStep >= path.length) return;

    double currentX, currentY;

    if (currentStep == 0) {
      // 시작 위치
      final int col = path[currentStep];
      currentX = columnWidth * col + columnWidth / 2;
      currentY = verticalMargin + rowHeight * currentStep;
    } else {
      // 이동 중인 위치 계산
      final int fromCol = path[currentStep - 1];
      final int toCol = path[currentStep];
      final double fromY = verticalMargin + rowHeight * (currentStep - 1);
      final double toY = verticalMargin + rowHeight * currentStep;

      final double fromX = columnWidth * fromCol + columnWidth / 2;
      final double toX = columnWidth * toCol + columnWidth / 2;

      if (fromCol == toCol) {
        // 세로 이동: 부드럽게 보간
        currentX = fromX;
        currentY = fromY + (toY - fromY) * animationProgress;
      } else {
        // 가로 이동: 먼저 아래로, 그 다음 옆으로
        if (animationProgress < 0.5) {
          // 첫 번째 절반: 세로 이동
          currentX = fromX;
          currentY = fromY + (toY - fromY) * (animationProgress * 2);
        } else {
          // 두 번째 절반: 가로 이동
          currentX = fromX + (toX - fromX) * ((animationProgress - 0.5) * 2);
          currentY = toY;
        }
      }
    }

    // 외부 글로우 효과
    final glowPaint = Paint()
      ..color = color.withAlpha((255.0 * 0.3).round())
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(currentX, currentY), 18, glowPaint);

    // 중간 원 (배경)
    final backgroundPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(currentX, currentY), 15, backgroundPaint);

    // 메인 원 (참가자 색상)
    final circlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(currentX, currentY), 12, circlePaint);

    // 참가자 번호 표시
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${pathIndex + 1}',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              offset: Offset(1, 1),
              blurRadius: 2,
              color: Colors.black.withAlpha((255.0 * 0.5).round()),
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        currentX - textPainter.width / 2,
        currentY - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant LadderPainter oldDelegate) {
    return oldDelegate.participantCount != participantCount ||
        oldDelegate.ladderRows != ladderRows ||
        oldDelegate.connections != connections ||
        oldDelegate.currentStep != currentStep ||
        oldDelegate.allPaths != allPaths ||
        oldDelegate.animationProgress != animationProgress;
  }
}
