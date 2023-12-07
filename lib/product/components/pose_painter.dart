import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:ml_presentation_devfest/feature/mobile/presentation_control_page/viewmodel/cubit/presentation_cubit.dart';

import 'coordinate_translator.dart';

class PosePainter extends CustomPainter {
  PosePainter(this.poses, this.absoluteImageSize, this.rotation, this.context);

  final List<Pose> poses;
  final Size absoluteImageSize;
  final InputImageRotation rotation;
  final BuildContext context;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.green;

    final leftPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..color = Colors.yellow;

    final rightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..color = Colors.blueAccent;

    for (final pose in poses) {
      pose.landmarks.forEach((_, landmark) {
        canvas.drawCircle(
            Offset(
              translateX(landmark.x, rotation, size, absoluteImageSize),
              translateY(landmark.y, rotation, size, absoluteImageSize),
            ),
            1,
            paint);
      });
      // print(pose.landmarks[PoseLandmarkType.leftWrist]?.x);
      context.read<PresentationCubit>().x = translateX(
          pose.landmarks[PoseLandmarkType.leftIndex]?.x ?? 0,
          rotation,
          size,
          absoluteImageSize);
      context.read<PresentationCubit>().y = translateY(
          pose.landmarks[PoseLandmarkType.leftIndex]?.y ?? 0,
          rotation,
          size,
          absoluteImageSize);

      context.read<PresentationCubit>().leftHip = translateX(
          pose.landmarks[PoseLandmarkType.leftHip]?.x ?? 0,
          rotation,
          size,
          absoluteImageSize);
      context.read<PresentationCubit>().rightHip = translateX(
          pose.landmarks[PoseLandmarkType.rightHip]?.x ?? 0,
          rotation,
          size,
          absoluteImageSize);

      context.read<PresentationCubit>().rightWristsY = translateY(
          pose.landmarks[PoseLandmarkType.rightIndex]?.y ?? 0,
          rotation,
          size,
          absoluteImageSize);
      context.read<PresentationCubit>().eyeLocationY = translateY(
        pose.landmarks[PoseLandmarkType.leftEar]?.y ?? 0,
        rotation,
        size,
        absoluteImageSize,
      );

      context.read<PresentationCubit>().headx = translateX(
          pose.landmarks[PoseLandmarkType.leftWrist]!.x,
          rotation,
          size,
          absoluteImageSize);

      void paintLine(
          PoseLandmarkType type1, PoseLandmarkType type2, Paint paintType) {
        final PoseLandmark joint1 = pose.landmarks[type1]!;
        final PoseLandmark joint2 = pose.landmarks[type2]!;
        canvas.drawLine(
            Offset(translateX(joint1.x, rotation, size, absoluteImageSize),
                translateY(joint1.y, rotation, size, absoluteImageSize)),
            Offset(translateX(joint2.x, rotation, size, absoluteImageSize),
                translateY(joint2.y, rotation, size, absoluteImageSize)),
            paintType);
      }

      //PoseLandmarkType.
      PoseLandmarkType.leftShoulder;

      // print(translateY(pose.landmarks[PoseLandmarkType.rightWrist]?.y ?? 0,
      //     rotation, size, absoluteImageSize));
      // print(translateY(pose.landmarks[PoseLandmarkType.leftEyeOuter]?.y ?? 0,
      //     rotation, size, absoluteImageSize));
      //Draw arms
      paintLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, leftPaint);
      paintLine(
          PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, leftPaint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow,
          rightPaint);
      paintLine(
          PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, rightPaint);

      //Draw Body
      paintLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, leftPaint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip,
          rightPaint);

      //Draw legs
      paintLine(
          PoseLandmarkType.leftHip, PoseLandmarkType.leftAnkle, leftPaint);
      paintLine(
          PoseLandmarkType.rightHip, PoseLandmarkType.rightAnkle, rightPaint);
    }
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.poses != poses;
  }
}
