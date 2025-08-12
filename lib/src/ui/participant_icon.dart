// lib/src/ui/participant_icon.dart

import 'package:flutter/material.dart';

/// 참가자 아이콘 위젯
/// [name]: 참가자 이름 (첫 글자 표시)
/// [image]: 이모지 또는 asset 이미지 경로 (이미지 우선)
/// [size]: 아이콘 크기
class ParticipantIcon extends StatelessWidget {
  final String name;
  final String? image;
  final double size;

  const ParticipantIcon({
    super.key,
    required this.name,
    this.image,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = (name.isNotEmpty) ? name.substring(0, 1) : '?';

    Widget icon;

    if (image != null && image!.isNotEmpty) {
      if (image!.startsWith('http') || image!.startsWith('https')) {
        // 네트워크 이미지
        icon = ClipOval(
          child: Image.network(
            image!,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _defaultAvatar(displayText),
          ),
        );
      } else if (image!.startsWith('assets/')) {
        // 에셋 이미지
        icon = ClipOval(
          child: Image.asset(
            image!,
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        );
      } else {
        // 이모지 텍스트로 표시
        icon = Center(
          child: Text(image!, style: TextStyle(fontSize: size * 0.6)),
        );
      }
    } else {
      icon = _defaultAvatar(displayText);
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue[100],
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: icon,
    );
  }

  Widget _defaultAvatar(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: size * 0.5,
          color: Colors.white,
        ),
      ),
    );
  }
}
