import 'package:flutter/material.dart';

import '../atoms/atoms.dart';

/// Mirrors web `src/design/molecules/GoogleBtn.tsx`.
class GoogleBtn extends StatelessWidget {
  const GoogleBtn({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navy900,
          backgroundColor: Colors.white,
          side: const BorderSide(color: AppColors.gray300, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const _GoogleLogo(size: 20),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                isLoading ? 'Signing in...' : label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The Google "G" mark, painted from the same path colors as the web SVG.
class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final stroke = size.width * 0.18;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    final arcRect = rect.deflate(stroke / 2 + size.width * 0.06);

    // Blue (right)
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(arcRect, -0.35, 0.75, false, paint);
    // Green (bottom)
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(arcRect, 0.9, 1.35, false, paint);
    // Yellow (left)
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(arcRect, 2.45, 1.0, false, paint);
    // Red (top)
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(arcRect, 3.6, 1.5, false, paint);

    // Blue crossbar of the G
    final barPaint = Paint()..color = const Color(0xFF4285F4);
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.5,
        size.height * 0.44,
        size.width * 0.44,
        stroke,
      ),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
