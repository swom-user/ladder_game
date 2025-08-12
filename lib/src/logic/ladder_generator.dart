// lib/src/logic/ladder_generator.dart

import 'dart:math';

import '../models/ladder_connection.dart';

/// 사다리 가로줄 연결 생성기
class LadderGenerator {
  /// 참가자 수에 따른 자동 사다리 줄 수 계산
  static int calculateLadderRows(int participantCount) {
    final random = Random();

    // 참가자 수에 따른 기본 줄 수 범위
    int minRows, maxRows;

    if (participantCount <= 2) {
      minRows = 3;
      maxRows = 5;
    } else if (participantCount <= 4) {
      minRows = 4;
      maxRows = 7;
    } else if (participantCount <= 6) {
      minRows = 6;
      maxRows = 9;
    } else {
      minRows = 7;
      maxRows = 12;
    }

    // 랜덤하게 줄 수 결정
    return minRows + random.nextInt(maxRows - minRows + 1);
  }

  /// 골고루 분포된 가로줄 생성
  static LadderConnection generate({
    required int participantCount,
    int? ladderRows, // null이면 자동 계산
  }) {
    final random = Random();
    final actualLadderRows =
        ladderRows ?? calculateLadderRows(participantCount);
    final List<List<bool>> connections = [];

    // 각 세로줄(컬럼)별 연결 횟수 추적
    List<int> columnConnectionCount = List.filled(participantCount - 1, 0);

    // 목표: 모든 컬럼에 최소 1개 이상의 연결 보장
    int minConnectionsPerColumn = max(
      1,
      (actualLadderRows / (participantCount - 1)).floor(),
    );

    // 1단계: 각 행에 기본 연결 패턴 생성
    for (int row = 0; row < actualLadderRows; row++) {
      List<bool> rowConnections = List.filled(participantCount - 1, false);

      // 각 행마다 적절한 수의 연결 생성 (참가자 수에 비례)
      int connectionsInRow = _calculateConnectionsForRow(
        participantCount,
        random,
      );

      // 연결이 적은 컬럼들을 우선적으로 선택
      List<int> availablePositions = List.generate(
        participantCount - 1,
        (i) => i,
      );

      // 연결 횟수가 적은 순으로 정렬 (가중치 적용)
      availablePositions.sort((a, b) {
        int diff = columnConnectionCount[a].compareTo(columnConnectionCount[b]);
        if (diff != 0) return diff;
        return random.nextBool() ? -1 : 1; // 동일하면 랜덤
      });

      int placed = 0;
      for (int pos in availablePositions) {
        if (placed >= connectionsInRow) break;

        // 연속 연결 방지 체크
        if (_canPlaceConnection(rowConnections, pos, participantCount)) {
          rowConnections[pos] = true;
          columnConnectionCount[pos]++;
          placed++;
        }
      }

      connections.add(rowConnections);
    }

    // 2단계: 연결이 부족한 컬럼에 강제 연결 추가
    _ensureMinimumConnections(
      connections,
      columnConnectionCount,
      participantCount,
      actualLadderRows,
      minConnectionsPerColumn,
    );

    // 3단계: 빈 행 방지
    _eliminateEmptyRows(connections, participantCount, actualLadderRows);

    return LadderConnection(connections);
  }

  /// 각 행에서 생성할 연결 수 계산
  static int _calculateConnectionsForRow(int participantCount, Random random) {
    // 참가자 수에 따른 적절한 연결 수
    if (participantCount <= 3) {
      return 1; // 작은 그룹은 1개
    } else if (participantCount <= 5) {
      return 1 + random.nextInt(2); // 1-2개
    } else if (participantCount <= 8) {
      return 2 + random.nextInt(2); // 2-3개
    } else {
      return 3 + random.nextInt(2); // 3-4개
    }
  }

  /// 연결 배치 가능 여부 체크
  static bool _canPlaceConnection(
    List<bool> rowConnections,
    int pos,
    int participantCount,
  ) {
    // 연속 연결 방지
    if (pos > 0 && rowConnections[pos - 1]) return false;
    if (pos < participantCount - 2 && rowConnections[pos + 1]) return false;
    return true;
  }

  /// 최소 연결 보장 - 연결이 부족한 컬럼에 추가
  static void _ensureMinimumConnections(
    List<List<bool>> connections,
    List<int> columnConnectionCount,
    int participantCount,
    int ladderRows,
    int minConnectionsPerColumn,
  ) {
    final random = Random();

    for (int col = 0; col < participantCount - 1; col++) {
      while (columnConnectionCount[col] < minConnectionsPerColumn) {
        // 해당 컬럼에 연결 가능한 행들 찾기
        List<int> availableRows = [];

        for (int row = 0; row < ladderRows; row++) {
          if (!connections[row][col] &&
              _canPlaceConnection(connections[row], col, participantCount)) {
            availableRows.add(row);
          }
        }

        if (availableRows.isEmpty) break; // 더 이상 배치할 곳이 없음

        // 랜덤하게 하나 선택해서 연결 추가
        int selectedRow = availableRows[random.nextInt(availableRows.length)];
        connections[selectedRow][col] = true;
        columnConnectionCount[col]++;
      }
    }
  }

  /// 빈 행 제거 - 연결이 하나도 없는 행에 최소 1개 연결 추가
  static void _eliminateEmptyRows(
    List<List<bool>> connections,
    int participantCount,
    int ladderRows,
  ) {
    final random = Random();

    for (int row = 0; row < ladderRows; row++) {
      bool hasAnyConnection = connections[row].any((conn) => conn);

      if (!hasAnyConnection) {
        // 배치 가능한 위치들 찾기
        List<int> safePositions = [];
        for (int col = 0; col < participantCount - 1; col++) {
          if (_canPlaceConnection(connections[row], col, participantCount)) {
            safePositions.add(col);
          }
        }

        if (safePositions.isNotEmpty) {
          // 가운데 부근을 선호하되 랜덤 요소 추가
          safePositions.sort((a, b) {
            int center = (participantCount - 1) ~/ 2;
            int distA = (a - center).abs();
            int distB = (b - center).abs();
            if (distA != distB) return distA.compareTo(distB);
            return random.nextBool() ? -1 : 1;
          });

          int selectedPos = safePositions[0];
          connections[row][selectedPos] = true;
        }
      }
    }
  }

  /// 참가자 수에 따른 권장 사다리 줄 수 계산 (기존 호환성용)
  static int calculateRecommendedRows(int participantCount) {
    return calculateLadderRows(participantCount);
  }
}
