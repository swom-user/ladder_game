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

  @override
  String toString() =>
      'Participant(name: $name, result: $result, image: $image)';
}
