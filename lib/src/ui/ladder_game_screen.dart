import 'package:flutter/material.dart';
import 'package:ladder_game/ladder_game.dart';

class LadderGameScreen extends StatefulWidget {
  final LadderGameController controller;

  const LadderGameScreen({super.key, required this.controller});

  @override
  State<LadderGameScreen> createState() => _LadderGameScreenState();
}

class _LadderGameScreenState extends State<LadderGameScreen> {
  bool isAnimating = false;
  int currentStep = 0;

  int get participantCount => widget.controller.participantCount;
  int get ladderRows => widget.controller.ladderRows;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("사다리 게임")),
      body: Column(
        children: [
          // 사다리 게임 영역을 더 작게 조정
          Expanded(
            flex: 3, // 전체의 3/5 비율
            child: _buildLadderGame(),
          ),
          // 컨트롤 패널 영역 확대
          Expanded(
            flex: 2, // 전체의 2/5 비율
            child: _buildControlPanel(),
          ),
        ],
      ),
    );
  }

  void _addParticipant() {
    setState(() {
      widget.controller.addParticipant(
        Participant(
          name: '참가자 ${participantCount + 1}',
          result: '결과 ${participantCount + 1}',
          image: '🏆',
        ),
      );
    });
  }

  void _removeParticipant() {
    if (participantCount > 2) {
      setState(() {
        widget.controller.removeParticipant(participantCount - 1);
      });
    }
  }

  void _addLadderRow() {
    setState(() {
      widget.controller.setLadderRows(ladderRows + 1);
    });
  }

  void _removeLadderRow() {
    if (ladderRows > 1) {
      setState(() {
        widget.controller.setLadderRows(ladderRows - 1);
      });
    }
  }

  void _generateLadderConnections() {
    setState(() {
      widget.controller.shuffleConnections();
    });
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => EditDialog(
        participants: widget.controller.participants,
        onSave: (updatedParticipants) {
          setState(() {
            widget.controller.participants = updatedParticipants;
            widget.controller.shuffleConnections();
          });
        },
      ),
    );
  }

  void _startAnimation() async {
    setState(() {
      isAnimating = true;
      currentStep = 0;
      widget.controller.startGame();
    });

    final maxSteps = widget.controller.paths.isNotEmpty
        ? widget.controller.paths[0].length - 1
        : 0;

    // 단계별로 애니메이션 실행 (세로 이동만)
    for (int step = 0; step <= maxSteps; step++) {
      await Future.delayed(const Duration(milliseconds: 800));
      setState(() {
        currentStep = step;
      });
    }

    // 결과 표시
    await Future.delayed(const Duration(milliseconds: 500));
    _showResultDialog();

    setState(() {
      isAnimating = false;
      currentStep = 0;
    });
  }

  void _showResultDialog() {
    final results = widget.controller.getResults();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("🎉 게임 결과"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: results.entries.map((entry) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue[100],
                child: Text(entry.key.name.substring(0, 1)),
              ),
              title: Text(entry.key.name),
              subtitle: Text("결과: ${entry.value}"),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("닫기"),
          ),
        ],
      ),
    );
  }

  Widget _buildLadderGame() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columnWidth =
              constraints.maxWidth / widget.controller.participantCount;
          final totalHeight = constraints.maxHeight - 80; // 상하 여백 고려
          final rowHeight = totalHeight / (widget.controller.ladderRows + 1);

          return Stack(
            children: [
              // 사다리 배경
              Positioned.fill(
                child: CustomPaint(
                  painter: LadderPainter(
                    participantCount: widget.controller.participantCount,
                    ladderRows: widget.controller.ladderRows,
                    connections: widget.controller.connection.rows,
                  ),
                ),
              ),

              // 시작 라벨들
              ...List.generate(widget.controller.participantCount, (index) {
                final dx = columnWidth * index + columnWidth / 2 - 30;
                return Positioned(
                  left: dx,
                  top: 10,
                  child: Container(
                    width: 60,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blue[300]!),
                    ),
                    child: Center(
                      child: Text(
                        widget.controller.participants[index].name,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }),

              // 결과 라벨들
              ...List.generate(widget.controller.participantCount, (index) {
                final dx = columnWidth * index + columnWidth / 2 - 30;
                final dy = totalHeight + 40;
                return Positioned(
                  left: dx,
                  top: dy,
                  child: Container(
                    width: 60,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.orange[300]!),
                    ),
                    child: Center(
                      child: Text(
                        widget.controller.participants[index].result,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }),

              // 애니메이션 아이콘들
              if (isAnimating)
                ...List.generate(widget.controller.participantCount, (index) {
                  final path = widget.controller.paths[index];
                  final stepIndex = currentStep.clamp(0, path.length - 1);

                  // 현재 스텝에서의 위치 계산
                  final currentCol = path.columnAt(stepIndex);
                  final dx = columnWidth * currentCol + columnWidth / 2 - 20;
                  final dy = 40 + rowHeight * stepIndex;

                  return AnimatedPositioned(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                    left: dx,
                    top: dy,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.green[400]!, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          widget.controller.participants[index].name.substring(
                            0,
                            1,
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 참가자 수 조절
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '참가자 수: $participantCount',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: participantCount > 2
                              ? _removeParticipant
                              : null,
                          icon: const Icon(Icons.remove),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.red[100],
                            foregroundColor: Colors.red[700],
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: _addParticipant,
                          icon: const Icon(Icons.add),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.blue[100],
                            foregroundColor: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // 사다리 줄 수 조절
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '사다리 줄 수: $ladderRows',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: ladderRows > 1 ? _removeLadderRow : null,
                          icon: const Icon(Icons.remove),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.red[100],
                            foregroundColor: Colors.red[700],
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: _addLadderRow,
                          icon: const Icon(Icons.add),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.blue[100],
                            foregroundColor: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 기능 버튼들
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isAnimating ? null : _generateLadderConnections,
                    icon: const Icon(Icons.shuffle),
                    label: const Text('사다리 섞기'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[100],
                      foregroundColor: Colors.purple[700],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isAnimating ? null : _showEditDialog,
                    icon: const Icon(Icons.edit),
                    label: const Text('이름/결과 편집'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[100],
                      foregroundColor: Colors.orange[700],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 게임 시작 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isAnimating ? null : _startAnimation,
                icon: Icon(
                  isAnimating ? Icons.hourglass_empty : Icons.play_arrow,
                ),
                label: Text(
                  isAnimating ? '게임 진행 중...' : '🎮 사다리게임 시작!',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAnimating ? Colors.grey : Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
