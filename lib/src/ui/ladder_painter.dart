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
    final double verticalMargin = size.height * 0.05;
    final double horizontalMargin = size.width;
    final double availableWidth = size.width - 2 * horizontalMargin;
    final double columnWidth = availableWidth / participantCount;
    final double rowHeight =
        (size.height - 2 * verticalMargin) / (ladderRows + 1);

    // 세로줄 그리기
    _drawVerticalLines(
      canvas,
      size,
      verticalMargin,
      horizontalMargin,
      columnWidth,
    );

    // 가로줄 그리기
    _drawHorizontalLines(
      canvas,
      size,
      verticalMargin,
      horizontalMargin,
      columnWidth,
      rowHeight,
    );

    // 경로 그리기 (애니메이션 중일 때만)
    if (allPaths.isNotEmpty && currentStep > 0) {
      _drawAllPaths(
        canvas,
        size,
        verticalMargin,
        horizontalMargin,
        columnWidth,
        rowHeight,
      );
    }

    // 현재 위치 표시 (애니메이션 중일 때만)
    if (allPaths.isNotEmpty && currentStep < allPaths[0].length) {
      _drawCurrentPositions(
        canvas,
        size,
        verticalMargin,
        horizontalMargin,
        columnWidth,
        rowHeight,
      );
    }
  }

  void _drawVerticalLines(
    Canvas canvas,
    Size size,
    double verticalMargin,
    double horizontalMargin,
    double columnWidth,
  ) {
    final verticalPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < participantCount; i++) {
      final double x = horizontalMargin + columnWidth * i + columnWidth / 2;
      canvas.drawLine(
        Offset(x, verticalMargin),
        Offset(x, size.height - verticalMargin),
        verticalPaint,
      );
    }
  }

  void _drawHorizontalLines(
    Canvas canvas,
    Size size,
    double verticalMargin,
    double horizontalMargin,
    double columnWidth,
    double rowHeight,
  ) {
    final horizontalPaint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    for (int row = 0; row < ladderRows; row++) {
      final double y = verticalMargin + rowHeight * (row + 1);

      for (int col = 0; col < participantCount - 1; col++) {
        if (row < connections.length &&
            col < connections[row].length &&
            connections[row][col]) {
          final double x1 =
              horizontalMargin + columnWidth * col + columnWidth / 2;
          final double x2 =
              horizontalMargin + columnWidth * (col + 1) + columnWidth / 2;
          canvas.drawLine(Offset(x1, y), Offset(x2, y), horizontalPaint);
        }
      }
    }
  }

  void _drawAllPaths(
    Canvas canvas,
    Size size,
    double verticalMargin,
    double horizontalMargin,
    double columnWidth,
    double rowHeight,
  ) {
    const List<Color> pathColors = [
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
        horizontalMargin,
        columnWidth,
        rowHeight,
      );
    }
  }

  void _drawCurrentPositions(
    Canvas canvas,
    Size size,
    double verticalMargin,
    double horizontalMargin,
    double columnWidth,
    double rowHeight,
  ) {
    const List<Color> circleColors = [
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
          horizontalMargin,
          columnWidth,
          rowHeight,
        );
      }
    }
  }

  void _drawPath(
    Canvas canvas,
    List<int> path,
    Color color,
    Size size,
    double verticalMargin,
    double horizontalMargin,
    double columnWidth,
    double rowHeight,
  ) {
    final pathPaint = Paint()
      ..color = color.withAlpha((255.0 * 0.9).round())
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;

    // 현재까지의 경로만 그리기 (최종 위치까지 포함)
    int stepsToShow = min(currentStep + 1, path.length);

    for (int i = 0; i < stepsToShow - 1; i++) {
      final int fromCol = path[i];
      final int toCol = path[i + 1];

      final double fromY = verticalMargin + rowHeight * i;
      final double toY = verticalMargin + rowHeight * (i + 1);

      final double fromX =
          horizontalMargin + columnWidth * fromCol + columnWidth / 2;
      final double toX =
          horizontalMargin + columnWidth * toCol + columnWidth / 2;

      if (fromCol == toCol) {
        canvas.drawLine(Offset(fromX, fromY), Offset(toX, toY), pathPaint);
      } else {
        canvas.drawLine(Offset(fromX, fromY), Offset(fromX, toY), pathPaint);

        // 2. 가로선 부분
        final horizontalPaint = Paint()
          ..color = color.withAlpha((255.0 * 0.9).round())
          ..strokeWidth = 5.0
          ..strokeCap = StrokeCap.round;

        canvas.drawLine(Offset(fromX, toY), Offset(toX, toY), horizontalPaint);
      }
    }

    // 마지막 세로줄 처리 - 최종 도착지까지의 선분 그리기
    if (stepsToShow == path.length && path.length > 1) {
      final int lastCol = path[path.length - 1];
      final double lastX =
          horizontalMargin + columnWidth * lastCol + columnWidth / 2;
      final double lastFromY = verticalMargin + rowHeight * (path.length - 1);
      final double lastToY = size.height - verticalMargin; // 바닥까지

      canvas.drawLine(
        Offset(lastX, lastFromY),
        Offset(lastX, lastToY),
        pathPaint,
      );
    }
  }

  void _drawAnimatedParticipant(
    Canvas canvas,
    List<int> path,
    int pathIndex,
    Color color,
    Size size,
    double verticalMargin,
    double horizontalMargin,
    double columnWidth,
    double rowHeight,
  ) {
    double currentX, currentY;

    if (currentStep == 0) {
      // 시작 위치
      final int col = path[currentStep];
      currentX = horizontalMargin + columnWidth * col + columnWidth / 2;
      currentY = verticalMargin;
    } else if (currentStep >= path.length) {
      // 최종 위치에 도달한 경우 - 바닥까지 이동
      final int finalCol = path[path.length - 1];
      currentX = horizontalMargin + columnWidth * finalCol + columnWidth / 2;
      currentY = size.height - verticalMargin; // 바닥 위치
      return; // 더 이상 그릴 필요 없음 (이미 최종 결과 표시됨)
    } else if (currentStep == path.length - 1) {
      // 마지막 단계 - 최종 위치까지 이동
      final int fromCol = path[currentStep - 1];
      final int toCol = path[currentStep];

      final double fromY = verticalMargin + rowHeight * (currentStep - 1);
      final double finalY = size.height - verticalMargin; // 바닥까지

      final double fromX =
          horizontalMargin + columnWidth * fromCol + columnWidth / 2;
      final double toX =
          horizontalMargin + columnWidth * toCol + columnWidth / 2;

      if (fromCol == toCol) {
        // 세로 이동: 최종 목적지(바닥)까지
        currentX = fromX;
        currentY = fromY + (finalY - fromY) * animationProgress;
      } else {
        // 가로 이동: 먼저 아래로, 그 다음 옆으로, 마지막에 바닥까지
        if (animationProgress < 0.3) {
          // 첫 번째: 세로 이동 (현재 행까지)
          currentX = fromX;
          final double midY = verticalMargin + rowHeight * currentStep;
          currentY = fromY + (midY - fromY) * (animationProgress / 0.3);
        } else if (animationProgress < 0.6) {
          // 두 번째: 가로 이동
          final double midY = verticalMargin + rowHeight * currentStep;
          currentX = fromX + (toX - fromX) * ((animationProgress - 0.3) / 0.3);
          currentY = midY;
        } else {
          // 세 번째: 최종 바닥까지 세로 이동
          currentX = toX;
          final double midY = verticalMargin + rowHeight * currentStep;
          currentY = midY + (finalY - midY) * ((animationProgress - 0.6) / 0.4);
        }
      }
    } else {
      // 일반적인 이동 중인 위치 계산
      final int fromCol = path[currentStep - 1];
      final int toCol = path[currentStep];

      final double fromY = verticalMargin + rowHeight * (currentStep - 1);
      final double toY = verticalMargin + rowHeight * currentStep;

      final double fromX =
          horizontalMargin + columnWidth * fromCol + columnWidth / 2;
      final double toX =
          horizontalMargin + columnWidth * toCol + columnWidth / 2;

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
    // 성능 최적화: 실제로 변경된 부분만 다시 그리기
    return oldDelegate.participantCount != participantCount ||
        oldDelegate.ladderRows != ladderRows ||
        oldDelegate.connections != connections ||
        oldDelegate.currentStep != currentStep ||
        oldDelegate.allPaths != allPaths ||
        (oldDelegate.animationProgress != animationProgress &&
            allPaths.isNotEmpty);
  }
}
