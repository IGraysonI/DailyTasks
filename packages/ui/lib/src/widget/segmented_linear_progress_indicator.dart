import 'package:flutter/material.dart';

/// {@template segmented_linear_progress_indicator}
/// A linear progress indicator that is segmented into multiple parts for easier visualization.
/// {@endtemplate}
class SegmentedLinearProgressIndicator extends StatelessWidget {
  /// {@macro segmented_linear_progress_indicator}
  const SegmentedLinearProgressIndicator({
    required this.maxValue,
    required this.currentValue,
    this.filledColor = Colors.blue,
    this.emptyColor = Colors.grey,
    this.rewardSegments,
    super.key,
  }) : assert(maxValue <= 15, 'maxValue cannot be greater than 15');

  /// The maximum value of the progress indicator.
  final int maxValue;

  /// The current value of the progress indicator.
  final int currentValue;

  /// The color of the filled segments.
  final Color filledColor;

  /// The color of the empty segments.
  final Color emptyColor;

  /// List of reward segments that would be marked on the progress indicator.
  final List<int>? rewardSegments;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final segmentWidth = constraints.maxWidth / maxValue;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          maxValue,
          (index) => SizedBox(
            width: segmentWidth,
            height: 20,
            child: CustomPaint(
              painter: _SegmentPainter(
                isFilled: index < currentValue,
                primaryColor: filledColor,
                secondaryColor: emptyColor,
                isRewardSegment: rewardSegments?.contains(index + 1) ?? false,
                numberOfRewardInSegment: rewardSegments?.where((segment) => segment == index + 1).length ?? 0,
                context: context,
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _SegmentPainter extends CustomPainter {
  _SegmentPainter({
    required this.isFilled,
    required this.primaryColor,
    required this.secondaryColor,
    required this.isRewardSegment,
    required this.numberOfRewardInSegment,
    required this.context,
  });

  final bool isFilled;
  final Color primaryColor;
  final Color secondaryColor;
  final bool isRewardSegment;
  final int numberOfRewardInSegment;
  final BuildContext context;

  @override
  void paint(Canvas canvas, Size size) {
    Path? path;

    final slant = size.width * 0.2;
    final rightEdgeGap = size.height * 0.5;
    final bottomEdgeGap = size.width * 0.2;

    if (numberOfRewardInSegment > 1) {
      final fillPaint = Paint()
        ..color = isFilled ? primaryColor : secondaryColor
        ..style = PaintingStyle.fill;

      final paint = Paint()
        ..color = isFilled ? primaryColor : secondaryColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round;

      final startPoint = Offset(0, size.height);
      final topLeft = Offset(slant, 0);
      final topRight = Offset(size.width, 0);
      final bottomRight = Offset(size.width - slant, size.height);

      final rightEdgeEnd = Offset(
        size.width - (slant * 0.35),
        size.height - rightEdgeGap,
      );

      final bottomEdgeEnd = Offset(
        size.width - bottomEdgeGap,
        size.height,
      );

      final fillPath = Path()
        ..moveTo(startPoint.dx, startPoint.dy)
        ..lineTo(topLeft.dx, topLeft.dy)
        ..lineTo(topRight.dx, topRight.dy)
        ..lineTo(bottomRight.dx, bottomRight.dy)
        ..close();
      canvas.drawPath(fillPath, fillPaint);

      path = Path()
        ..moveTo(startPoint.dx, startPoint.dy)
        ..lineTo(topLeft.dx, topLeft.dy)
        ..lineTo(topRight.dx, topRight.dy)
        ..lineTo(rightEdgeEnd.dx, rightEdgeEnd.dy)
        ..moveTo(bottomEdgeEnd.dx, bottomEdgeEnd.dy)
        ..lineTo(startPoint.dx, startPoint.dy);
      canvas.drawPath(path, paint);

      final textStyle = TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      );

      final textSpan = TextSpan(
        text: numberOfRewardInSegment.toString(),
        style: textStyle,
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      final textPosition = Offset(
        size.width - (slant * 0.5) - (textPainter.width),
        size.height - (rightEdgeGap / 2) - (textPainter.height / 3),
      );

      textPainter.paint(canvas, textPosition);
    } else {
      final paint = Paint()
        ..color = isFilled ? primaryColor : secondaryColor
        ..style = PaintingStyle.fill;

      path = Path()
        ..moveTo(0, size.height)
        ..lineTo(slant, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width - slant, size.height)
        ..close();
      canvas.drawPath(path, paint);
    }

    if (isRewardSegment) {
      final borderPaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.5;
      canvas.drawPath(path, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
