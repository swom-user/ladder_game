// lib/src/logic/ladder_game_controller.dart

import 'dart:math';

import '../models/ladder_connection.dart';
import '../models/ladder_path.dart';
import '../models/participant.dart';
import 'ladder_generator.dart';
import 'ladder_tracer.dart';

class LadderGameController {
  /// 참가자 리스트
  List<Participant> participants = [];

  /// 사다리 연결 상태
  late LadderConnection connection;

  /// 현재 경로 목록
  List<LadderPath> paths = [];

  /// 참가자 수
  int get participantCount => participants.length;

  /// 사다리 줄 수
  int ladderRows;

  /// 생성자
  LadderGameController({
    required List<Participant> initialParticipants,
    this.ladderRows = 5,
  }) {
    participants = List.from(initialParticipants);
    _generateConnections();
    _traceAllPaths();
  }

  /// 사다리 연결 새로 생성
  void _generateConnections() {
    connection = LadderGenerator.generate(
      participantCount: participantCount,
      ladderRows: ladderRows,
    );
  }

  /// 경로 계산
  void _traceAllPaths() {
    paths = LadderTracer.traceAllPaths(
      connection: connection,
      participantCount: participantCount,
    );
  }

  /// 참가자 추가
  void addParticipant(Participant participant) {
    participants.add(participant);
    _generateConnections();
    _traceAllPaths();
  }

  /// 참가자 제거
  void removeParticipant(int index) {
    if (participants.length > 2 && index >= 0 && index < participants.length) {
      participants.removeAt(index);
      _generateConnections();
      _traceAllPaths();
    }
  }

  /// 사다리 줄 수 변경
  void setLadderRows(int rows) {
    ladderRows = max(1, rows);
    _generateConnections();
    _traceAllPaths();
  }

  /// 사다리 다시 섞기
  void shuffleConnections() {
    _generateConnections();
    _traceAllPaths();
  }

  /// 게임 시작 시 경로 계산
  List<LadderPath> startGame() {
    _traceAllPaths();
    return paths;
  }

  /// 최종 결과 매핑 (참가자 → 결과)
  Map<Participant, String> getResults() {
    final results = <Participant, String>{};
    for (int i = 0; i < participantCount; i++) {
      final endIndex = paths[i].endIndex;
      results[participants[i]] = participants[endIndex].result;
    }
    return results;
  }
}
