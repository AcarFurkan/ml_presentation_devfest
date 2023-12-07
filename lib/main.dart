import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ml_presentation_devfest/feature/desktop/presentation_page/view/presentation_page.dart';
import 'package:ml_presentation_devfest/core/draw_dots/draw_cubit.dart';
import 'package:ml_presentation_devfest/feature/mobile/presentation_control_page/viewmodel/cubit/presentation_cubit.dart';

import 'feature/mobile/onboard_presentation/view/onboard_page.dart';
import 'firebase_options.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (Platform.isAndroid || Platform.isIOS) {
    cameras = await availableCameras();
  }
//  cameras = await availableCameras();

  runApp(const MyApp());
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return (Platform.isAndroid || Platform.isIOS)
        ? MaterialApp(
            debugShowCheckedModeBanner: false,
            home: BlocProvider<PresentationCubit>(
              create: (context) => PresentationCubit(),
              child: const HomeMobile(),
            ))
        : Platform.isMacOS
            ? MaterialApp(
                debugShowCheckedModeBanner: false,
                scrollBehavior: AppScrollBehavior(),
                home: BlocProvider(
                    create: (context) => DrawCubit(),
                    child: const HomeDesktop()))
            : const MaterialApp(home: HomeError());
  }
}

class HomeMobile extends StatelessWidget {
  const HomeMobile({super.key});

  @override
  Widget build(BuildContext context) => const OnBoardPage();
}

class HomeDesktop extends StatelessWidget {
  const HomeDesktop({super.key});

  @override
  Widget build(BuildContext context) => const PresentationPage();
}

class HomeError extends StatelessWidget {
  const HomeError({super.key});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text("Device Not Supported")));
}
