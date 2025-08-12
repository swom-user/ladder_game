// lib/src/ui/edit_dialog.dart

import 'package:flutter/material.dart';

import '../models/participant.dart';

/// 이름, 결과, 이미지 편집 다이얼로그 위젯
class EditDialog extends StatefulWidget {
  final List<Participant> participants;

  /// 변경 완료 후 호출되는 콜백
  final void Function(List<Participant> updatedParticipants) onSave;

  const EditDialog({
    super.key,
    required this.participants,
    required this.onSave,
  });

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late List<TextEditingController> _nameControllers;
  late List<TextEditingController> _resultControllers;
  late List<String> _images;

  final List<String> _availableImages = [
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

  @override
  void initState() {
    super.initState();
    _nameControllers = widget.participants
        .map((p) => TextEditingController(text: p.name))
        .toList();
    _resultControllers = widget.participants
        .map((p) => TextEditingController(text: p.result))
        .toList();
    _images = widget.participants.map((p) => p.image).toList();
  }

  @override
  void dispose() {
    for (var c in _nameControllers) {
      c.dispose();
    }
    for (var c in _resultControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _pickImage(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('이미지 선택'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _availableImages.length,
              itemBuilder: (context, i) {
                final img = _availableImages[i];
                final isSelected = _images[index] == img;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _images[index] = img;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(img, style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  void _onSave() {
    final updatedParticipants = List<Participant>.generate(
      widget.participants.length,
      (index) => Participant(
        name: _nameControllers[index].text.isNotEmpty
            ? _nameControllers[index].text
            : '참가자 ${index + 1}',
        result: _resultControllers[index].text.isNotEmpty
            ? _resultControllers[index].text
            : '결과 ${index + 1}',
        image: _images[index],
      ),
    );

    widget.onSave(updatedParticipants);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('이름, 결과 및 이미지 편집'),
      content: SizedBox(
        width: double.maxFinite,
        height: 500,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '참가자 이름',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...List.generate(widget.participants.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: TextField(
                    controller: _nameControllers[index],
                    decoration: InputDecoration(
                      labelText: '참가자 ${index + 1}',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
              const Text(
                '결과 및 이미지',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...List.generate(widget.participants.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _pickImage(index),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              _images[index],
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _resultControllers[index],
                          decoration: InputDecoration(
                            labelText: '결과 ${index + 1}',
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        TextButton(onPressed: _onSave, child: const Text('확인')),
      ],
    );
  }
}
