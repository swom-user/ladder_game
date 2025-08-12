// lib/src/utils/constants.dart

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
const List<int> participantColors = [
  0xFFE53935, // red
  0xFF1E88E5, // blue
  0xFF43A047, // green
  0xFFF4511E, // orange
  0xFF8E24AA, // purple
  0xFF00897B, // teal
  0xFFD81B60, // pink
  0xFF6D4C41, // brown
];

/// 애니메이션 관련 상수
const Duration animationStepDuration = Duration(milliseconds: 500);
const Duration animationResultDuration = Duration(milliseconds: 1500);

/// UI 관련 상수
const double participantIconSize = 40.0;
const double ladderRowMinCount = 1;
const int participantMinCount = 2;
