// lib/src/utils/constants.dart

import 'package:flutter/material.dart';

/// 기본 결과 이미지 목록 (이모지 또는 문자열)
const List<String> defaultResultImages = [
  '🏆',
  '🎁',
  '🍕',
  '☕',
  '🎵',
  '📚',
  '🎮',
  '🌟',
  '⭐',
  '💎',
  '🎪',
  '🎯',
  '🚀',
  '🎨',
  '🏅',
  '💰',
  '🍰',
  '🎂',
  '🍦',
  '🧸',
  '🎈',
  '🎊',
  '🎉',
  '🔥',
];

/// 참가자별 색상 팔레트 (사다리 경로, 아이콘 등에서 활용)
const List<Color> participantColors = [
  Colors.red, // 빨강
  Colors.blue, // 파랑
  Colors.green, // 초록
  Colors.orange, // 주황
  Colors.purple, // 보라
  Colors.teal, // 청록
  Colors.pink, // 분홍
  Colors.brown, // 갈색
];

/// 경로 색상 (사다리 애니메이션용)
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

/// 원형 참가자 색상 (애니메이션 표시용)
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

/// 애니메이션 관련 상수
const Duration animationStepDuration = Duration(milliseconds: 600);
const Duration animationResultDuration = Duration(milliseconds: 1500);
const Duration singleAnimationStepDuration = Duration(milliseconds: 500);
const Duration resultShowDelay = Duration(milliseconds: 500);
const Duration finalAnimationDelay = Duration(milliseconds: 3000);

/// UI 관련 상수
const double participantIconSize = 40.0;
const double ladderRowMinCount = 1;
const int participantMinCount = 2;

/// 사다리 연결 확률
const double ladderConnectionProbability = 0.4;

/// 기본 참가자 설정
const int defaultParticipantCount = 2;
const int defaultLadderRows = 5;

/// 기본 참가자 이름 생성 함수
String getDefaultParticipantName(int index) => '참가자 ${index + 1}';

/// 기본 결과 이름 생성 함수
String getDefaultResultName(int index) => '결과 ${index + 1}';

/// 기본 이미지 선택 함수
String getDefaultImage(int index) =>
    defaultResultImages[index % defaultResultImages.length];
