import 'dart:math';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ml_presentation_devfest/core/components/presentation_background.dart';
import 'package:ml_presentation_devfest/core/components/presentation_content.dart';
import 'package:ml_presentation_devfest/core/draw_dots/draw_cubit.dart';
import 'package:ml_presentation_devfest/core/draw_dots/draw_painter.dart';
import 'package:video_player/video_player.dart';

const colorizeColors = [
  Colors.purple,
  Colors.blue,
  Colors.yellow,
  Colors.red,
];

const titleTextStyle = TextStyle(
  fontSize: 70.0,
  fontFamily: 'Horizon',
  fontWeight: FontWeight.bold,
  color: Colors.white,
);
const contentTextStyle = TextStyle(
  fontSize: 40.0,
  fontFamily: 'Horizon',
  fontWeight: FontWeight.bold,
  color: Colors.white,
);
const subContentTextStyle = TextStyle(
  fontSize: 40.0,
  fontFamily: 'Horizon',
  fontWeight: FontWeight.normal,
  color: Colors.white,
);

class PresentationPage extends StatefulWidget {
  const PresentationPage({super.key});

  @override
  State<PresentationPage> createState() => _PresentationPageState();
}

class _PresentationPageState extends State<PresentationPage> {
  final PageController controller = PageController(initialPage: 0);

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

  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc("test")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }
            Map<String, dynamic> data =
                snapshot.data?.data() as Map<String, dynamic>? ?? {};
            print(data);
            data["value"];
            if (isOpen) {
              if (data.isNotEmpty) {
                if (data["value"] == "next") {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  });
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    controller.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  });
                }
              }
            } else {
              isOpen = true;
            }

            var value;
            if (data.values.isNotEmpty) {
              value = data.values.first;
            } else {
              value = 0;
            }
            return RawKeyboardListener(
              focusNode: FocusNode(),
              onKey: (event) {
                if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
                  controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                  controller.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                }
              },
              child: GestureDetector(
                onTap: () {
                  controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                },
                onDoubleTap: () {
                  controller.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                },
                child: PageView.builder(
                  controller: controller,
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const PresentationBackground(
                        child: Text(
                          "Unlocking Flutter's Potential:\n Crafting a Face Detection-Controlled Flappy Bird Game",
                          style: titleTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    if (index == 1) {
                      return const PresentationContent(
                        title: "Agenda",
                        contents: [
                          " - Flutter ile Sınırları Zorla",
                          " - Flutter'ın Gücünü Kullanarak Yapay Zeka Uygulamaları Oluşturun",
                          " - Flutter ve MLKit ile Hızlı ve Etkili Makine Öğrenimi Çözümleri",
                          " - Flutter ile TFLite Modelleri Entegre Ederek Akıllı Uygulamalar Yaratın",
                          " - Flutter ve MLKit ile Kendi Flappy Bird Oyununuzu Yaratın",
                        ],
                      );
                    }
                    if (index == 2) {
                      return const PresentationContent(
                        title: "Platformlar",
                        contents: [
                          " - IOS",
                          " - ANDROID",
                          " - MACOS",
                          " - WINDOWS",
                          " - LINUX",
                          " - WEB",
                          " - BACKEND (FROG)",
                        ],
                      );
                    }
                    if (index == 3) {
                      return const PresentationContent(
                        title: "Yapay Zeka Implementasyonu​",
                        contents: [
                          " * LOCAL",
                          "     - TFLite",
                          "     - MLKit",
                          "     - OTHER",
                          "",
                          " * REMOTE / BACKEND",
                        ],
                      );
                    }
                    if (index == 4) {
                      return const PresentationContent(
                        title: "MLKIT​",
                        verticalPadding: 0,
                        contents: [
                          " * Vision APIs​",
                          "     - Barcode Scanning",
                          "     - Face Detection​",
                          "     - Face Mesh Detection​",
                          "     - Image Labeling​",
                          "     - Object Detection and Tracking​",
                          "     - Text Recognition V2​",
                          "     - Digital Ink Recognition​​",
                          "     - Pose Detection",
                          "     - Selfie Segmentation",
                          "",
                          " * Natural Language APIs ​​",
                          "     - Language Identification​​",
                          "     - Smart Reply​​",
                          "     -  Entity Extraction​​",
                        ],
                      );
                    }
                    if (index == 5) {
                      return PresentationBackground(
                        child: Text(
                          "TFLite Flutter",
                          style: titleTextStyle.copyWith(fontSize: 90),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    if (index == 6) {
                      return PresentationBackground(
                        child: Text(
                          "Sunumu Temas Etmeden Nasıl Değiştirebiliriz?",
                          style: titleTextStyle.copyWith(fontSize: 90),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    if (index == 7) {
                      return PresentationBackground(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Flappy Bird",
                              style: titleTextStyle.copyWith(fontSize: 90),
                              textAlign: TextAlign.center,
                            ),
                            Center(
                              child: _controller.value.isInitialized
                                  ? SizedBox(
                                      // width: 450,
                                      // height: MediaQuery.of(context)
                                      //     .size
                                      //     .height*.9,
                                      child: AspectRatio(
                                        aspectRatio:
                                            _controller.value.aspectRatio,
                                        child: VideoPlayer(_controller),
                                      ),
                                    )
                                  : Container(),
                            ),
                          ],
                        ),
                      );
                    }
                    if (index == 8) {
                      return   PresentationBackground(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Teşekkürler",
                              style: titleTextStyle.copyWith(
                                fontSize: 90,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 100,),
                            const Text(
                              "@furkanacardev",
                              style: titleTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }
                    //
                    //
                    //Sunumu değiştirmek için bir şeye dokunmamız gerekiyor mu?

                    return Container(
                      color: Colors.green,
                      child: Center(
                        child: Text("Page $index -- $value"),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
    );
  }
}
/**
 * 
 */