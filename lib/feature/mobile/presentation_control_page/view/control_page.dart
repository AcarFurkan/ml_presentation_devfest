import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:ml_presentation_devfest/feature/mobile/presentation_control_page/viewmodel/cubit/presentation_cubit.dart';
import 'package:ml_presentation_devfest/main.dart';

class ControlPage extends StatefulWidget {
  const ControlPage(
      {super.key,
      required this.title,
      required this.customPaint,
      this.text,
      required this.onImage,
      this.bodyText,
      this.initialDirection = CameraLensDirection.back});

  final String title;
  final CustomPaint? customPaint;
  final String? text;
  final String? bodyText;

  final Function(InputImage inputImage) onImage;
  final CameraLensDirection initialDirection;

  @override
  // ignore: library_private_types_in_public_api
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage>
    with TickerProviderStateMixin {
  CameraController? _controller;
  num _cameraIndex = 0;

  @override
  void initState() {
    super.initState();

    _cameraIndex = 1;
    _startLiveFeed();
  }

  @override
  void dispose() {
    _stopLiveFeed();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      //  floatingActionButton: fab(),
    );
  }

  Widget _body() => _liveFeedBody();

  Widget _liveFeedBody() {
    if (_controller == null) {
      return Container();
    }
    if (_controller?.value.isInitialized == false) {
      return Container();
    }

    final size = MediaQuery.of(context).size;

    var scale = size.aspectRatio * _controller!.value.aspectRatio;

    if (scale < 1) scale = 1 / scale;
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        buildCameraView(scale),
        if (widget.customPaint != null)
          Container(
            child: widget.customPaint,
          ),
        Positioned(
          left: context.read<PresentationCubit>().leftHip,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: 2,
            child: const DecoratedBox(
              decoration: BoxDecoration(color: Colors.green),
            ),
          ),
        ),
        Positioned(
          left: context.read<PresentationCubit>().rightHip,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: 2,
            child: const DecoratedBox(
              decoration: BoxDecoration(color: Colors.red),
            ),
          ),
        )
      ],
    );
  }

  Transform buildCameraView(double scale) {
    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(_controller!),
      ),
    );
  }

  Future _startLiveFeed() async {
    var cameras = await availableCameras();
    final camera = cameras[_cameraIndex.toInt()];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      if (cameras.isNotEmpty) {
        _controller?.startImageStream(_processCameraImage);
      }
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  Future _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final camera = cameras[_cameraIndex.toInt()];
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    if (imageRotation == null) return;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw);
    if (inputImageFormat == null) return;

    final inputImageData = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation,
      format: inputImageFormat,
      bytesPerRow: image.planes.firstOrNull?.bytesPerRow ?? 0,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, metadata: inputImageData);

    widget.onImage(inputImage);
  }
}
