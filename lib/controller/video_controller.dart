import 'package:get/get.dart';
import 'package:my_app/common/channel_plugin.dart';
import 'package:video_player/video_player.dart';

class VideoController extends GetxController {
  final ChannelPlugin channelPlugin = ChannelPlugin();

  late Rx<VideoPlayerController> videoPlayerController;
  var isFloatingWindowVisible = false.obs;
  var windowTop = 50.0.obs;
  var windowLeft = 50.0.obs;

  @override
  void onInit() {
    super.onInit();

    /// 初始化视频控制器
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(
          'https://stream7.iqilu.com/10339/upload_transcode/202002/09/20200209105011F0zPoYzHry.mp4'),
    ).obs;

    videoPlayerController.value.initialize().then((_) {
      videoPlayerController.value.play();
      update();
    });
  }

  @override
  void onClose() {
    videoPlayerController.value.dispose();
    super.onClose();
  }

  void showFloatingWindow() {
    isFloatingWindowVisible.value = true;
  }

  void hideFloatingWindow() {
    isFloatingWindowVisible.value = false;
  }

  void updateWindowPosition(double top, double left) {
    windowTop.value = top;
    windowLeft.value = left;
  }
}
