import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/home.dart';
import 'controller/video_controller.dart';
import 'common/video_window.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            const VideoWindow(),
          ],
        );
      },
      initialBinding: InitBinding(),
    );
  }
}


class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<VideoController>(VideoController());
  }
}
