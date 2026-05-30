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
  });

  final bool isFilled;
  final Color primaryColor;
  final Color secondaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isFilled ? primaryColor : secondaryColor
      ..style = PaintingStyle.fill;
    const tiltOffset = 20.0;
    final path = Path()
      ..moveTo(tiltOffset, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width - tiltOffset, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
