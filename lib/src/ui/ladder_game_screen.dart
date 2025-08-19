// lib/src/ui/ladder_game_screen.dart

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ladder_game/ladder_game.dart';

class LadderGameScreen extends StatefulWidget {
  const LadderGameScreen({super.key});

  @override
  State<LadderGameScreen> createState() => _LadderGameScreenState();
}

class _LadderGameScreenState extends State<LadderGameScreen>
    with TickerProviderStateMixin {
  late AnimationController _resultAnimationController;
  late AnimationController _stepAnimationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _stepAnimation;

  int participantCount = 2;
  List<List<bool>> ladderConnections = [];
  List<String> participantNames = [];
  List<String> results = [];
  List<List<int>> allPaths = [];
  List<String> resultImages = [];
  bool isAnimating = false;
  int currentAnimationStep = 0;
  bool showFinalResults = false;
  List<int> finalResults = [];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeLadder();
  }

  @override
  void dispose() {
    _resultAnimationController.dispose();
    _stepAnimationController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _resultAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _stepAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _resultAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _resultAnimationController,
        curve: Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _resultAnimationController,
        curve: Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    _stepAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _stepAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _initializeLadder() {
    _updateParticipantNames();
    _updateResults();
    _updateResultImages();
    _generateLadderConnections();
  }

  void _updateParticipantNames() {
    List<String> newParticipantNames = [];
    for (int i = 0; i < participantCount; i++) {
      if (i < participantNames.length) {
        newParticipantNames.add(participantNames[i]);
      } else {
        newParticipantNames.add('참가자 ${i + 1}');
      }
    }
    participantNames = newParticipantNames;
  }

  void _updateResults() {
    List<String> newResults = [];
    for (int i = 0; i < participantCount; i++) {
      if (i < results.length) {
        newResults.add(results[i]);
      } else {
        newResults.add('결과 ${i + 1}');
      }
    }
    results = newResults;
  }

  void _updateResultImages() {
    List<String> defaultImages = [
      '🏆',
      '🎁',
      '🍕',
      '☕',
      '🎵',
      '📚',
      '🎮',
      '🌟',
    ];

    List<String> newResultImages = [];
    for (int i = 0; i < participantCount; i++) {
      if (i < resultImages.length) {
        newResultImages.add(resultImages[i]);
      } else {
        newResultImages.add(defaultImages[i % defaultImages.length]);
      }
    }
    resultImages = newResultImages;
  }

  void _generateLadderConnections() {
    final connection = LadderGenerator.generate(
      participantCount: participantCount,
    );

    ladderConnections = connection.rows;
  }

  void _addParticipant() {
    setState(() {
      participantCount++;
      _initializeLadder();
    });
  }

  void _removeParticipant() {
    if (participantCount > 2) {
      setState(() {
        participantCount--;
        _initializeLadder();
      });
    }
  }

  // List<int> _traceLadderPathWithJump(int startColumn) {
  //   List<int> path = [startColumn];
  //   int currentColumn = startColumn;
  //
  //   debugPrint('=== 참가자 $startColumn 경로 추적 시작 (점프 규칙) ===');
  //
  //   for (int row = 0; row < ladderConnections.length; row++) {
  //     debugPrint('Row $row: 현재 위치 = $currentColumn');
  //     debugPrint('Row $row 연결 상태: ${ladderConnections[row]}');
  //
  //     int newColumn = _findJumpTarget(
  //       ladderConnections[row],
  //       currentColumn,
  //       participantCount,
  //     );
  //
  //     if (newColumn != currentColumn) {
  //       debugPrint('  -> 점프 이동: $currentColumn → $newColumn');
  //       currentColumn = newColumn;
  //     } else {
  //       debugPrint('  -> 직진: $currentColumn');
  //     }
  //
  //     path.add(currentColumn);
  //   }
  //
  //   debugPrint('최종 경로: $path (도착지: ${path.last})');
  //   debugPrint('');
  //   return path;
  // }
  //
  // int _findJumpTarget(List<bool> row, int currentColumn, int participantCount) {
  //   debugPrint('  현재 컬럼: $currentColumn, 행 연결: $row');
  //
  //   int leftMostConnection = -1;
  //   for (int i = currentColumn - 1; i >= 0; i--) {
  //     if (i < row.length && row[i]) {
  //       leftMostConnection = i;
  //     } else {
  //       break;
  //     }
  //   }
  //
  //   int rightMostConnection = -1;
  //   for (
  //     int i = currentColumn;
  //     i < row.length && i < participantCount - 1;
  //     i++
  //   ) {
  //     if (row[i]) {
  //       rightMostConnection = i + 1;
  //     } else {
  //       break;
  //     }
  //   }
  //
  //   if (leftMostConnection >= 0) {
  //     debugPrint('  왼쪽으로 점프: $currentColumn -> $leftMostConnection');
  //     return leftMostConnection;
  //   } else if (rightMostConnection >= 0) {
  //     debugPrint('  오른쪽으로 점프: $currentColumn -> $rightMostConnection');
  //     return rightMostConnection;
  //   }
  //
  //   debugPrint('  점프 없음, 직진');
  //   return currentColumn;
  // }

  List<int> _traceLadderPath(int startColumn) {
    return _traceLadderPathStandard(startColumn);
  }

  List<int> _traceLadderPathStandard(int startColumn) {
    List<int> path = [startColumn];
    int currentColumn = startColumn;

    for (int row = 0; row < ladderConnections.length; row++) {
      if (currentColumn > 0 &&
          (currentColumn - 1) < ladderConnections[row].length &&
          ladderConnections[row][currentColumn - 1]) {
        currentColumn--;
      } else if (currentColumn < participantCount - 1 &&
          currentColumn < ladderConnections[row].length &&
          ladderConnections[row][currentColumn]) {
        currentColumn++;
      }

      path.add(currentColumn);
    }

    return path;
  }

  // 매우 빠른 애니메이션으로 수정
  void _startAllAnimation() async {
    if (isAnimating) return;

    List<List<int>> paths = [];
    for (int i = 0; i < participantCount; i++) {
      List<int> path = _traceLadderPath(i);
      paths.add(path);
      debugPrint('참가자 $i 최종 경로: $path, 도착지: ${path.last}');
    }

    setState(() {
      isAnimating = true;
      allPaths = paths;
      currentAnimationStep = 0;
      showFinalResults = false;
      finalResults = paths.map((path) => path.last).toList();
    });

    int maxSteps = ladderConnections.length + 2;

    debugPrint('전체 애니메이션 스텝: 0 to ${maxSteps - 1} (총 $maxSteps개)');

    // 각 스텝 사이의 대기 시간을 매우 짧게 조정 (100ms → 50ms)
    for (int i = 0; i < maxSteps; i++) {
      setState(() {
        currentAnimationStep = i;
      });

      debugPrint('애니메이션 스텝: $i/${maxSteps - 1}');

      _stepAnimationController.reset();
      await _stepAnimationController.forward();

      // 스텝 간 대기 시간을 매우 짧게 조정
      if (i == maxSteps - 1) {
        // 마지막 스텝에서는 짧은 대기 (100ms → 50ms)
        await Future.delayed(Duration(milliseconds: 50));
      }
    }

    setState(() {
      showFinalResults = true;
    });

    _resultAnimationController.forward().then((_) {
      Future.delayed(Duration(milliseconds: 200), () {
        _showAllResultsDialog(paths);
      });
    });

    await Future.delayed(Duration(milliseconds: 1500));

    setState(() {
      isAnimating = false;
      allPaths = [];
      currentAnimationStep = 0;
      showFinalResults = false;
    });

    _resultAnimationController.reset();
  }

  void _startSingleAnimation(int participantIndex) async {
    if (isAnimating) return;

    List<int> singlePath = _traceLadderPath(participantIndex);
    debugPrint('개별 애니메이션 - 참가자 $participantIndex 경로: $singlePath');

    setState(() {
      isAnimating = true;
      allPaths = [singlePath];
      currentAnimationStep = 0;
      showFinalResults = false;
      finalResults = [singlePath.last];
    });

    // 개별 애니메이션도 빠르게 조정
    for (int i = 0; i < singlePath.length; i++) {
      setState(() {
        currentAnimationStep = i;
      });

      debugPrint('개별 애니메이션 스텝: $i');

      _stepAnimationController.reset();
      await _stepAnimationController.forward();

      if (i == singlePath.length - 1) {
        // 마지막 스텝 대기 시간 단축 (100ms → 50ms)
        await Future.delayed(Duration(milliseconds: 50));
      }
    }

    setState(() {
      showFinalResults = true;
    });

    _resultAnimationController.forward();

    // 개별 결과 대기 시간 단축 (800ms → 400ms)
    await Future.delayed(Duration(milliseconds: 400));

    _showSingleResultDialog(
      participantNames[participantIndex],
      singlePath.last,
    );

    setState(() {
      isAnimating = false;
      allPaths = [];
      currentAnimationStep = 0;
      showFinalResults = false;
    });

    _resultAnimationController.reset();
  }

  void _showAllResultsDialog(List<List<int>> paths) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Text('🎉 게임 결과'),
              Spacer(),
              Icon(Icons.celebration, color: Colors.orange),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(participantCount, (i) {
                int finalPosition = paths[i].last;
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[100]!, Colors.purple[100]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha((255.0 * 0.3).round()),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 2),
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
                            participantNames[i].substring(
                              0,
                              min(2, participantNames[i].length),
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.arrow_forward, color: Colors.grey[600]),
                      SizedBox(width: 16),
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
                            resultImages[finalPosition],
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          results[finalPosition],
                          style: TextStyle(
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh),
                  SizedBox(width: 4),
                  Text('다시 하기'),
                ],
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _generateLadderConnections();
                });
              },
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSingleResultDialog(String participant, int resultIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('🎯 결과'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple[100]!, Colors.blue[100]!],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(
                      participant,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withAlpha((255.0 * 0.3).round()),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          resultImages[resultIndex],
                          style: TextStyle(fontSize: 36),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      results[resultIndex],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => EditDialog(
        participantNames: participantNames,
        results: results,
        resultImages: resultImages,
        onSave: (names, resultTexts, images) {
          setState(() {
            participantNames = names;
            results = resultTexts;
            resultImages = images;
          });
        },
      ),
    );
  }

  Widget _buildLadderGame() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          _buildParticipantNames(),
          Expanded(child: _buildLadderCanvas()),
          _buildResultsSection(),
        ],
      ),
    );
  }

  Widget _buildParticipantNames() {
    return SizedBox(
      height: 60,
      child: Row(
        children: List.generate(participantCount, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _startSingleAnimation(index),
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Center(
                        child: Text(
                          participantNames[index],
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child:
                        allPaths.isNotEmpty &&
                            currentAnimationStep == 0 &&
                            allPaths.any(
                              (path) => path.isNotEmpty && path[0] == index,
                            )
                        ? Icon(Icons.circle, color: Colors.red, size: 12)
                        : SizedBox(),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLadderCanvas() {
    return AnimatedBuilder(
      animation: _stepAnimationController,
      builder: (context, child) {
        return CustomPaint(
          size: Size(double.infinity, double.infinity),
          painter: LadderPainter(
            participantCount: participantCount,
            ladderRows: ladderConnections.length,
            connections: ladderConnections,
            allPaths: allPaths,
            currentStep: currentAnimationStep,
            animationProgress: _stepAnimation.value,
          ),
        );
      },
    );
  }

  Widget _buildResultsSection() {
    return SizedBox(
      height: 120,
      child: Column(
        children: [
          _buildEndPositionIndicators(),
          _buildResultImageAnimations(),
          _buildResultTexts(),
        ],
      ),
    );
  }

  Widget _buildEndPositionIndicators() {
    return SizedBox(
      height: 20,
      child: Row(
        children: List.generate(participantCount, (index) {
          return Expanded(
            child: Center(
              child:
                  allPaths.isNotEmpty &&
                      currentAnimationStep >= ladderConnections.length &&
                      finalResults.contains(index)
                  ? Icon(Icons.circle, color: Colors.red, size: 12)
                  : SizedBox(),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildResultImageAnimations() {
    if (!showFinalResults) return SizedBox(height: 40);

    return SizedBox(
      height: 40,
      child: Row(
        children: List.generate(participantCount, (index) {
          bool shouldShow = finalResults.contains(index);
          return Expanded(
            child: Center(
              child: shouldShow
                  ? AnimatedBuilder(
                      animation: _resultAnimationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Transform.rotate(
                            angle: _rotationAnimation.value,
                            child: Opacity(
                              opacity: _fadeAnimation.value,
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withAlpha(
                                        (255.0 * 0.5).round(),
                                      ),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    resultImages[index],
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : SizedBox(),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildResultTexts() {
    return Expanded(
      child: Row(
        children: List.generate(participantCount, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 2),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.green),
                ),
                child: Center(
                  child: Text(
                    results[index],
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildParticipantCountControls(),
          SizedBox(height: 16),
          _buildActionButtons(),
          SizedBox(height: 8),
          _buildStartGameButton(),
        ],
      ),
    );
  }

  Widget _buildParticipantCountControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('참가자 수: $participantCount'),
        Row(
          children: [
            IconButton(
              onPressed: _removeParticipant,
              icon: Icon(Icons.remove),
              style: IconButton.styleFrom(backgroundColor: Colors.red[100]),
            ),
            SizedBox(width: 8),
            IconButton(
              onPressed: _addParticipant,
              icon: Icon(Icons.add),
              style: IconButton.styleFrom(backgroundColor: Colors.blue[100]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _generateLadderConnections();
              });
            },
            child: Text('사다리 다시 그리기'),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: _showEditDialog,
            child: Text('이름/결과 편집'),
          ),
        ),
      ],
    );
  }

  Widget _buildStartGameButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isAnimating ? null : _startAllAnimation,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          isAnimating ? '게임 진행 중...' : '🎮 사다리게임 시작!',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('사다리게임'), backgroundColor: Colors.blue),
      body: Column(
        children: [
          Expanded(child: _buildLadderGame()),
          _buildControlPanel(),
        ],
      ),
    );
  }
}
