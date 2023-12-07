import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ml_presentation_devfest/core/draw_dots/draw_cubit.dart';

class DotCirclePainter extends CustomPainter {
  BuildContext context;
  DotCirclePainter(this.context);
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Color paintColor = Colors.grey.withOpacity(0.3);
    const double circleRadius = 2;
    const double lineTreshold = 65;
    const double lineStroke = 4;
    final circlePainter = Paint()
      ..color = paintColor
      ..strokeWidth = 6.0
      ..style = PaintingStyle.fill;

    var dots = context.read<DrawCubit>().drawCircle(size, 5);
    for (var element in dots) {
      canvas.drawCircle(element.position, circleRadius, circlePainter);
    }
    for (var i = 0; i < dots.length; i++) {
      for (var j = i + 1; j < dots.length; j++) {
        var x = dots[i].position.dx - dots[j].position.dx;
        var y = dots[i].position.dy - dots[j].position.dy;

        var distance = sqrt(x * x + y * y);
        var strokeWidth =
            ((lineTreshold - distance) / lineTreshold) * lineStroke;
        if (distance < lineTreshold) {
          canvas.drawLine(
              dots[i].position,
              dots[j].position,
              Paint()
                ..strokeWidth = strokeWidth
                ..color = paintColor);
        }
      }
    }
  }
}
