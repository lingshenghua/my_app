import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class PipVideoPlayer extends StatefulWidget {
  const PipVideoPlayer({super.key});

  @override
  _PipVideoPlayerState createState() => _PipVideoPlayerState();
}

class _PipVideoPlayerState extends State<PipVideoPlayer> {
  static const platform = MethodChannel('com.example.my_app/pip');
  late VideoPlayerController _controller;
  bool _isFullScreen = false; // 用于跟踪全屏状态

  Future<void> _enterPipMode() async {
    try {
      await platform.invokeMethod('enterPipMode');
    } on PlatformException catch (e) {
      print("Failed to enter PiP mode: ${e.message}");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
          'https://stream7.iqilu.com/10339/upload_transcode/202002/09/20200209105011F0zPoYzHry.mp4'),
    )..initialize().then((_) {
      setState(() {});
      _controller.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); // 退出时恢复竖屏模式
    super.dispose();
  }

  // 进入或退出全屏模式
  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });

    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isFullScreen
          ? null
          : AppBar(
        title: Text('Video Player with PiP'),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_in_picture),
            onPressed: _enterPipMode,
          ),
          IconButton(
            icon: Icon(Icons.fullscreen),
            onPressed: _toggleFullScreen,
          ),
        ],
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? Stack(
          children: [
            AspectRatio(
              aspectRatio: _isFullScreen
                  ? MediaQuery.of(context).size.aspectRatio
                  : _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            if (_isFullScreen) // 仅在全屏模式下显示退出全屏按钮
              Positioned(
                top: 20,
                left: 20,
                child: IconButton(
                  icon: Icon(Icons.fullscreen_exit, color: Colors.white),
                  onPressed: _toggleFullScreen,
                ),
              ),
          ],
        )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: _isFullScreen
          ? null
          : FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
