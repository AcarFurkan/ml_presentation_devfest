import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ml_presentation_devfest/core/draw_dots/draw_cubit.dart';
import 'package:ml_presentation_devfest/core/draw_dots/draw_painter.dart';

class PresentationBackground extends StatelessWidget {
  const PresentationBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.black,
            child: BlocBuilder<DrawCubit, DrawState>(
              builder: (context, state) {
                return CustomPaint(
                  painter: DotCirclePainter(context),
                );
              },
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: child,
            ),
          ),
        )
      ],
    );
  }
}
