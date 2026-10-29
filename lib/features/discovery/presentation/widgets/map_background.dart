import 'package:flutter/material.dart';

/// Static mock map — grey background with painted roads/parks.
/// Placeholder until `google_maps_flutter` integration lands.
class MapBackground extends StatelessWidget {
  const MapBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MapPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _MapPainter extends CustomPainter {
  static const _bg = Color(0xFFEEF2F6);
  static const _road = Color(0xFFFFFFFF);
  static const _park = Color(0xFFDDEBD6);
  static const _water = Color(0xFFCFE0F3);

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = _bg;
    canvas.drawRect(Offset.zero & size, bg);

    final road = Paint()..color = _road;
    final park = Paint()..color = _park;
    final water = Paint()..color = _water;

    final w = size.width;
    final h = size.height;

    void vRoad(double xRatio, double widthPx) {
      final x = w * xRatio;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, 0, widthPx, h),
          const Radius.circular(2),
        ),
        road,
      );
    }

    void hRoad(double yRatio, double heightPx) {
      final y = h * yRatio;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, y, w, heightPx),
          const Radius.circular(2),
        ),
        road,
      );
    }

    vRoad(0.10, 10);
    vRoad(0.38, 8);
    vRoad(0.67, 10);
    vRoad(0.87, 7);
    hRoad(0.15, 10);
    hRoad(0.35, 8);
    hRoad(0.55, 12);
    hRoad(0.78, 8);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.15, h * 0.18, 80, 100),
        const Radius.circular(10),
      ),
      park,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.72, h * 0.40, 90, 110),
        const Radius.circular(10),
      ),
      park,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.44, h * 0.62, 80, 100),
        const Radius.circular(10),
      ),
      park,
    );

    canvas.drawOval(
      Rect.fromLTWH(w * 0.74, h * 0.14, 70, 50),
      water,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
