import 'package:flutter/material.dart';

/// 自定义金币图标 - 圆形黄色硬币，中间带白色¥符号
/// 参考设计：圆形金币，带有3D效果和白色¥符号
class CoinIcon extends StatelessWidget {
  final double size;
  final Color coinColor;
  final Color symbolColor;
  final bool show3D;

  const CoinIcon({
    super.key,
    this.size = 24,
    this.coinColor = const Color(0xFFFFC107), // 金黄色
    this.symbolColor = Colors.white,
    this.show3D = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CoinIconPainter(
          coinColor: coinColor,
          symbolColor: symbolColor,
          show3D: show3D,
        ),
      ),
    );
  }
}

class _CoinIconPainter extends CustomPainter {
  final Color coinColor;
  final Color symbolColor;
  final bool show3D;

  _CoinIconPainter({
    required this.coinColor,
    required this.symbolColor,
    required this.show3D,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final centerX = w / 2;
    final centerY = h / 2;
    final radius = w / 2 * 0.9;

    // 绘制3D效果 - 底部阴影
    if (show3D) {
      final shadowPaint = Paint()
        ..color = const Color(0xFFD4A500).withValues(alpha: 0.6)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(centerX, centerY + radius * 0.15),
        radius * 0.85,
        shadowPaint,
      );
    }

    // 绘制主硬币圆形
    final coinPaint = Paint()
      ..color = coinColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(centerX, centerY),
      radius,
      coinPaint,
    );

    // 绘制硬币边缘高光（3D效果）
    if (show3D) {
      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.08;

      canvas.drawCircle(
        Offset(centerX, centerY),
        radius * 0.95,
        highlightPaint,
      );

      // 左上高光
      final highlightPath = Path();
      highlightPath.addArc(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius * 0.9),
        -2.8,
        1.2,
      );

      final highlightStrokePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.06
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(highlightPath, highlightStrokePaint);
    }

    // 绘制¥符号（白色）
    final symbolPaint = Paint()
      ..color = symbolColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.15
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final symbolSize = radius * 0.35;

    // ¥ 的两条上斜线
    canvas.drawLine(
      Offset(centerX - symbolSize * 0.7, centerY - symbolSize * 0.6),
      Offset(centerX, centerY + symbolSize * 0.1),
      symbolPaint,
    );

    canvas.drawLine(
      Offset(centerX + symbolSize * 0.7, centerY - symbolSize * 0.6),
      Offset(centerX, centerY + symbolSize * 0.1),
      symbolPaint,
    );

    // ¥ 的中间横线 1
    canvas.drawLine(
      Offset(centerX - symbolSize * 0.6, centerY - symbolSize * 0.1),
      Offset(centerX + symbolSize * 0.6, centerY - symbolSize * 0.1),
      symbolPaint,
    );

    // ¥ 的中间横线 2
    canvas.drawLine(
      Offset(centerX - symbolSize * 0.6, centerY + symbolSize * 0.1),
      Offset(centerX + symbolSize * 0.6, centerY + symbolSize * 0.1),
      symbolPaint,
    );

    // ¥ 的下竖线
    canvas.drawLine(
      Offset(centerX, centerY + symbolSize * 0.1),
      Offset(centerX, centerY + symbolSize * 0.75),
      symbolPaint,
    );
  }

  @override
  bool shouldRepaint(_CoinIconPainter oldDelegate) {
    return oldDelegate.coinColor != coinColor ||
        oldDelegate.symbolColor != symbolColor ||
        oldDelegate.show3D != show3D;
  }
}
