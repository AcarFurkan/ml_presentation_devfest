import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import '../../../../../product/components/pose_painter.dart';

part 'presentation_state.dart';

class PresentationCubit extends Cubit<PresentationState> {
  PresentationCubit() : super(PresentationInitial());
  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CustomPaint? customPaint;
  final bool _canProcess = true;
  bool _isBusy = false;
  BuildContext? context;
  double x = 0;
  double y = 0;
  double headx = 0;
  bool passedRightTHForNext = false;
  bool passedLeftTHForNext = false;

  bool passedRightTHPrevious = false;
  bool passedLeftThForPrevious = false;

  double eyeLocationY = 0;
  double rightWristsY = 0;

  double leftHip = 0;
  double rightHip = 0;

  setBuildContext(BuildContext context) {
    this.context = context;
  }

  void processImageCompute(InputImage inputImage) async {
    compute(processImage, inputImage);
    emit(PresentationInitial());
  }

  int pos = 90;

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;

    if (_isBusy) return;

    _isBusy = true;

    final poses = await _poseDetector.processImage(inputImage);
    bool isEyeLocationY = rightWristsY < eyeLocationY;

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = PosePainter(poses, inputImage.metadata!.size,
          inputImage.metadata!.rotation, context!);
      customPaint = CustomPaint(painter: painter);

      if (!isEyeLocationY) {
        _isBusy = false;
        passedRightTHForNext = false;
        passedLeftTHForNext = false;
        passedLeftThForPrevious = false;
        passedRightTHPrevious = false;
        emit(PresentationInitial());

        return;
      }
      print(headx);

      double rightTreshold = leftHip != 0 ? leftHip : 100;
      double leftTreshold =
          rightHip != 0 ? rightHip : MediaQuery.of(context!).size.width - 100;
      if (x > rightTreshold) {
        passedRightTHForNext = true;
      }
      if (x < leftTreshold && passedRightTHForNext) {
        passedLeftTHForNext = true;
      }

      if (x < leftTreshold) {
        passedRightTHPrevious = true;
      }

      if (x > rightTreshold && passedRightTHPrevious) {
        passedLeftThForPrevious = true;
      }
      print("--------0");
      print(x);
      print("left hip: $leftHip ");
      print("right hip: $rightHip ");

      //print(eyeLocationY);
      //print(rightWristsY);
      print("--------1");

      if (passedLeftThForPrevious && passedRightTHPrevious && isEyeLocationY) {
        passedLeftTHForNext = false;
        passedRightTHForNext = false;
        passedLeftThForPrevious = false;
        passedRightTHPrevious = false;
        log("NEXT " * 500);

        users.doc('test').set({'value': "next", 'position': x});
        emit(PresentationChangePage());
      }

      if (passedRightTHForNext && passedLeftTHForNext && isEyeLocationY) {
        passedRightTHForNext = false;
        passedLeftTHForNext = false;
        passedLeftThForPrevious = false;
        passedRightTHPrevious = false;
        log("BACK " * 500);
        users.doc('test').set({'value': "back", 'position': x});
        emit(PresentationChangePage());
      }
    } else {
      //text = 'Poses found: ${poses.length}\n\n';
      // TODO: set _customPaint to draw landmarks on top of image
      customPaint = null;
    }
    _isBusy = false;
    emit(PresentationInitial());
  }
}
