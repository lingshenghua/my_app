import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controller/video_controller.dart';
import 'package:video_player/video_player.dart';

class VideoWindow extends StatelessWidget {
  const VideoWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      VideoController controller = Get.find<VideoController>();

      if (!controller.isFloatingWindowVisible.value) {
        return const SizedBox.shrink();
      }

      return Positioned(
        top: controller.windowTop.value,
        left: controller.windowLeft.value,
        child: GestureDetector(
          onPanUpdate: (details) {
            controller.updateWindowPosition(
              controller.windowTop.value + details.delta.dy,
              controller.windowLeft.value + details.delta.dx,
            );
          },
          child: Material(
            elevation: 10,
            child: Container(
              width: 240,
              height: 120,
              color: Colors.black,
              child: controller.videoPlayerController.value.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: controller
                          .videoPlayerController.value.value.aspectRatio,
                      child:
                          VideoPlayer(controller.videoPlayerController.value),
                    )
                  : const CircularProgressIndicator(),
            ),
          ),
        ),
      );
    });
  }
}
