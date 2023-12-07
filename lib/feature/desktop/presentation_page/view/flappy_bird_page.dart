import 'package:flutter/material.dart';
import 'package:ml_presentation_devfest/core/components/presentation_background.dart';
import 'package:ml_presentation_devfest/feature/desktop/presentation_page/view/presentation_page.dart';
import 'package:video_player/video_player.dart';

class FlappyBirdPage extends StatefulWidget {
  const FlappyBirdPage({super.key});

  @override
  State<FlappyBirdPage> createState() => _FlappyBirdPageState();
}

class _FlappyBirdPageState extends State<FlappyBirdPage> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.asset("assets/flappy.mp4")
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        _controller
          ..setLooping(true)
          ..play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return PresentationBackground(
      child: Row(
        children: [
          Text(
            "Flappy Bird",
            style: titleTextStyle.copyWith(fontSize: 90),
            textAlign: TextAlign.center,
          ),
          Center(
            child: _controller.value.isInitialized
                ? SizedBox(
                    width: 500,
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
