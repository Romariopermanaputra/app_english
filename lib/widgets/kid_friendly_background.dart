import 'package:flutter/material.dart';
import 'dart:math' as math;

class KidFriendlyBackground extends StatelessWidget {
  final Widget child;
  final Color baseColor;

  const KidFriendlyBackground({
    super.key,
    required this.child,
    required this.baseColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            baseColor.withOpacity(0.1),
            baseColor.withOpacity(0.3),
            baseColor.withOpacity(0.1),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Pola elemen mengambang di latar belakang
          Positioned(
            top: -50,
            left: -50,
            child: _buildShape(Icons.star_rounded, 150, baseColor.withOpacity(0.15), 0.2),
          ),
          Positioned(
            bottom: 100,
            right: -60,
            child: _buildShape(Icons.circle, 200, baseColor.withOpacity(0.1), 0),
          ),
          Positioned(
            top: 200,
            right: 20,
            child: _buildShape(Icons.favorite_rounded, 80, baseColor.withOpacity(0.12), -0.3),
          ),
          Positioned(
            bottom: -30,
            left: 20,
            child: _buildShape(Icons.change_history_rounded, 120, baseColor.withOpacity(0.15), 0.5),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: -30,
            child: _buildShape(Icons.cloud_rounded, 140, baseColor.withOpacity(0.12), -0.1),
          ),
          // Konten utama
          SafeArea(child: child),
        ],
      ),
    );
  }

  Widget _buildShape(IconData icon, double size, Color color, double rotation) {
    return Transform.rotate(
      angle: rotation * math.pi,
      child: Icon(
        icon,
        size: size,
        color: color,
      ),
    );
  }
}
