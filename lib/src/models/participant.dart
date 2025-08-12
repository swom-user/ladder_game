// lib/src/models/participant.dart

/// 사다리 게임 참가자 정보 모델
class Participant {
  /// 참가자 이름
  String name;

  /// 결과 텍스트
  String result;

  /// 결과 이미지 (이모지 또는 asset 경로)
  String image;

  Participant({required this.name, required this.result, required this.image});

  /// 복제 메서드
  Participant copyWith({String? name, String? result, String? image}) {
    return Participant(
      name: name ?? this.name,
      result: result ?? this.result,
      image: image ?? this.image,
    );
  }

  /// JSON 변환 (저장용)
  Map<String, dynamic> toJson() {
    return {'name': name, 'result': result, 'image': image};
  }

  /// JSON에서 객체 생성
  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      name: json['name'] ?? '',
      result: json['result'] ?? '',
      image: json['image'] ?? '',
    );
  }

  /// 문자열로 반환하는 메서드들 (paste-2.txt에서 사용하는 형태로)
  static List<String> getNamesFromParticipants(List<Participant> participants) {
    return participants.map((p) => p.name).toList();
  }

  static List<String> getResultsFromParticipants(
    List<Participant> participants,
  ) {
    return participants.map((p) => p.result).toList();
  }

  static List<String> getImagesFromParticipants(
    List<Participant> participants,
  ) {
    return participants.map((p) => p.image).toList();
  }

  /// 문자열 리스트들로부터 Participant 리스트 생성
  static List<Participant> fromStringLists({
    required List<String> names,
    required List<String> results,
    required List<String> images,
  }) {
    final length = names.length;
    return List.generate(length, (i) {
      return Participant(
        name: i < names.length ? names[i] : '참가자 ${i + 1}',
        result: i < results.length ? results[i] : '결과 ${i + 1}',
        image: i < images.length ? images[i] : '🏆',
      );
    });
  }

  @override
  String toString() =>
      'Participant(name: $name, result: $result, image: $image)';
}
