import 'package:flutter/cupertino.dart';

class LineAnimatedPosition extends StatefulWidget {
  final double startX;
  final double startY;
  final double targetX;
  final double targetY;
  final Widget child;
  final Duration duration;

  const LineAnimatedPosition({
    super.key,
    required this.startX,
    required this.startY,
    required this.targetX,
    required this.targetY,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<LineAnimatedPosition> createState() => _LineAnimatedPositionState();
}

class _LineAnimatedPositionState extends State<LineAnimatedPosition>
    with TickerProviderStateMixin {
  late AnimationController _xController;
  late AnimationController _yController;
  late Animation<double> _xAnimation;
  late Animation<double> _yAnimation;

  late double _currentX;
  late double _currentY;

  @override
  void initState() {
    super.initState();
    _currentX = widget.startX;
    _currentY = widget.startY;

    _xController = AnimationController(vsync: this, duration: widget.duration);
    _yController = AnimationController(vsync: this, duration: widget.duration);

    _xAnimation = Tween<double>(
      begin: widget.startX,
      end: widget.targetX,
    ).animate(CurvedAnimation(parent: _xController, curve: Curves.easeInOut));

    _yAnimation = Tween<double>(
      begin: widget.startY,
      end: widget.targetY,
    ).animate(CurvedAnimation(parent: _yController, curve: Curves.easeInOut));

    // 가로 이동 후 세로 이동 시작
    _xController.forward().whenComplete(() {
      _yController.forward();
    });

    // 애니메이션 진행 중 위치 업데이트
    _xAnimation.addListener(() {
      setState(() {
        _currentX = _xAnimation.value;
      });
    });

    _yAnimation.addListener(() {
      setState(() {
        _currentY = _yAnimation.value;
      });
    });
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LineAnimatedPosition oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.targetX != oldWidget.targetX ||
        widget.targetY != oldWidget.targetY) {
      // 위치가 바뀌면 새 애니메이션 실행
      _xController.reset();
      _yController.reset();

      _xAnimation = Tween<double>(
        begin: _currentX,
        end: widget.targetX,
      ).animate(CurvedAnimation(parent: _xController, curve: Curves.easeInOut));
      _yAnimation = Tween<double>(
        begin: _currentY,
        end: widget.targetY,
      ).animate(CurvedAnimation(parent: _yController, curve: Curves.easeInOut));

      _xController.forward().whenComplete(() => _yController.forward());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(left: _currentX, top: _currentY, child: widget.child);
  }
}
