// lib/src/ui/result_dialog.dart

import 'package:flutter/material.dart';

import '../models/participant.dart';

/// 결과 다이얼로그 위젯
class ResultDialog extends StatelessWidget {
  final List<Participant> participants;
  final List<int> finalPositions; // 참가자별 도착 위치 인덱스

  const ResultDialog({
    super.key,
    required this.participants,
    required this.finalPositions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: const [
          Text('🎉 게임 결과'),
          Spacer(),
          Icon(Icons.celebration, color: Colors.orange),
        ],
      ),
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(participants.length, (i) {
            final pos = finalPositions[i];
            final participant = participants[i];
            final resultParticipant = participants[pos];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[100]!, Colors.purple[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        participant.name.substring(
                          0,
                          participant.name.length > 2
                              ? 2
                              : participant.name.length,
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.arrow_forward, color: Colors.grey),
                  const SizedBox(width: 16),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Center(
                      child: Text(
                        resultParticipant.image,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      resultParticipant.result,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('확인'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
