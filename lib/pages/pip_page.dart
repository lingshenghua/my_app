import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controller/video_controller.dart';
import 'package:video_player/video_player.dart';

class PipPage extends StatelessWidget {
  const PipPage({super.key});

  @override
  Widget build(BuildContext context) {
    final VideoController controller = Get.put(VideoController());

    return Scaffold(
      appBar: AppBar(title: const Text('PipPage')),
      body: Column(
        children: [
          Center(
            child: Obx(
              () => controller.videoPlayerController.value.value.isInitialized
                  ? controller.isFloatingWindowVisible.value
                      ? Container(
                          height: 200,
                          alignment: Alignment.center,
                          child: const Text('视频正在以画中画的形式播放'),
                        )
                      : AspectRatio(
                          aspectRatio: controller
                              .videoPlayerController.value.value.aspectRatio,
                          child: VideoPlayer(
                              controller.videoPlayerController.value),
                        )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
          ElevatedButton(
            onPressed: controller.showFloatingWindow,
            child: const Text('显示悬浮视频窗口'),
          ),
        ],
      ),
    );
  }
}
