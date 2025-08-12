// lib/src/logic/ladder_tracer.dart

import '../models/ladder_connection.dart';
import '../models/ladder_path.dart';

/// 사다리 경로 계산기
class LadderTracer {
  /// 주어진 시작 열(startColumn)에서 내려가면서 경로를 계산
  static LadderPath tracePath({
    required LadderConnection connection,
    required int startColumn,
    required int participantCount,
  }) {
    List<int> steps = [startColumn];
    int currentColumn = startColumn;
    int maxSteps = connection.rows.length + 1;

    for (
      int row = 0;
      row < connection.rows.length && steps.length <= maxSteps;
      row++
    ) {
      if (currentColumn > 0 &&
          connection.hasConnection(row, currentColumn - 1)) {
        // 왼쪽으로 이동
        currentColumn--;
      } else if (currentColumn < participantCount - 1 &&
          connection.hasConnection(row, currentColumn)) {
        // 오른쪽으로 이동
        currentColumn++;
      }
      steps.add(currentColumn);
    }

    return LadderPath(startIndex: startColumn, steps: steps);
  }

  /// 모든 참가자의 경로 계산
  static List<LadderPath> traceAllPaths({
    required LadderConnection connection,
    required int participantCount,
  }) {
    return List.generate(
      participantCount,
      (i) => tracePath(
        connection: connection,
        startColumn: i,
        participantCount: participantCount,
      ),
    );
  }
}
