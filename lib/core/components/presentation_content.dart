import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ml_presentation_devfest/core/draw_dots/draw_cubit.dart';
import 'package:ml_presentation_devfest/core/draw_dots/draw_painter.dart';
import 'package:ml_presentation_devfest/feature/desktop/presentation_page/view/presentation_page.dart';

class PresentationContent extends StatelessWidget {
  const PresentationContent({
    super.key,
    required this.title,
    required this.contents,
    this.verticalPadding = 10,
  });
  final String title;
  final List<String> contents;
  final double verticalPadding;

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      title,
                      style: titleTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  //  ...content
                  ...contents.map((e) => Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: verticalPadding),
                        child: Text(
                          e,
                          style: contentTextStyle,
                        ),
                      )),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
