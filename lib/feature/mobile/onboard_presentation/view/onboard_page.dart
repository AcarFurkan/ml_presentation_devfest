import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ml_presentation_devfest/feature/mobile/presentation_control_page/viewmodel/cubit/presentation_cubit.dart';

import '../../presentation_control_page/view/control_page.dart';

class OnBoardPage extends StatelessWidget {
  const OnBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<PresentationCubit>().setBuildContext(context);
    return BlocBuilder<PresentationCubit, PresentationState>(
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: ControlPage(
              customPaint: context.read<PresentationCubit>().customPaint,
              onImage: (inputImage) async {
                context.read<PresentationCubit>().processImage(inputImage);
              },
              title: 'tt',
            ),
          ),
        );
      },
    );
  }
}
