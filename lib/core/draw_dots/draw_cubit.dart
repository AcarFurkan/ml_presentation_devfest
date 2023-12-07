import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

@immutable
abstract class DrawState {}

class DrawInitial extends DrawState {}

class DrawCubit extends Cubit<DrawState> {
  DrawCubit() : super(DrawInitial()) {
    timer = Timer.periodic(animDuration, (timer) {
      emit(DrawInitial());
    });
  }
  Duration animDuration = const Duration(milliseconds: 5);
  List<Dot> drawCircle(Size size, double density) {
    if (circles != null) {
      for (var i = 0; i < circles!.length; i++) {
        circles![i] = Dot.nextDot(
            circles![i], animDuration.inMilliseconds.toDouble() / 50, size);
      }
      return circles!;
    }

    return circles ??= _createDots(size, density);
  }

  late Timer timer;
  late BuildContext context;
  List<Dot>? circles;
  List<Dot> _createDots(Size size, double density) {
    var area = size.width * size.height;
    var dotCount = ((area / (100 * 100)) * density).toInt();
    List<Dot> list = [];
    for (var i = 0; i < dotCount; i++) {
      Offset position = Offset(Random().nextDouble() * size.width,
          Random().nextDouble() * size.height);
      Offset speed =
          Offset(Random().nextDouble() * 4, Random().nextDouble() * 4);
      if (Random().nextBool()) {
        speed = Offset(-speed.dx, speed.dy);
      }
      if (Random().nextBool()) {
        speed = Offset(speed.dx, -speed.dy);
      }
      list.add(Dot(position, speed));
    }
    return list;
  }
}

class Dot {
  Offset position;
  Offset speed;
  Dot(this.position, this.speed);

  factory Dot.nextDot(Dot dot, double time, Size size) {
    const double radius = 10;

    if (dot.position.dx < radius) {
      dot.speed = Offset(-dot.speed.dx, dot.speed.dy);
    }
    if (dot.position.dx > size.width - radius) {
      dot.speed = Offset(-dot.speed.dx, dot.speed.dy);
    }
    if (dot.position.dy < radius) {
      dot.speed = Offset(dot.speed.dx, -dot.speed.dy);
    }
    if (dot.position.dy > size.height - radius) {
      dot.speed = Offset(dot.speed.dx, -dot.speed.dy);
    }
    return Dot(dot.position + (dot.speed * time), dot.speed);
  }
}
