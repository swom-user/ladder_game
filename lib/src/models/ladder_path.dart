// lib/src/models/ladder_path.dart

/// 사다리 타기 경로 정보 모델
class LadderPath {
  /// 시작 열 인덱스 (0부터 시작)
  final int startIndex;

  /// 각 단계별(행) 열 인덱스 리스트
  /// 예: [0, 1, 1, 2, 2] → 0열에서 시작해 1열로 이동 후 최종 2열에 도착
  final List<int> steps;

  LadderPath({required this.startIndex, required this.steps});

  /// 최종 도착 열 인덱스
  int get endIndex => steps.isNotEmpty ? steps.last : startIndex;

  /// 경로 길이 (행 개수 + 1)
  int get length => steps.length;

  /// 현재 단계의 열 인덱스 반환
  int columnAt(int step) {
    if (step < 0 || step >= steps.length) return endIndex;
    return steps[step];
  }

  /// 디버그용 문자열
  @override
  String toString() {
    return 'LadderPath(start: $startIndex, steps: $steps, end: $endIndex)';
  }
}
