import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pip_view/pip_view.dart';
import 'package:video_player/video_player.dart';

class PipVideoPlayer extends StatefulWidget {
  const PipVideoPlayer({super.key});

  @override
  _PipVideoPlayerState createState() => _PipVideoPlayerState();
}

class _PipVideoPlayerState extends State<PipVideoPlayer> {
  static const platform = MethodChannel('com.example.my_app/pip');
  late VideoPlayerController _controller;
  bool _isInPipMode = false; // 添加状态来跟踪是否进入 PiP 模式

  Future<void> _enterPipMode() async {
    try {
      await platform.invokeMethod('enterPipMode');
      setState(() {
        _isInPipMode = true; // 更新状态以指示 PiP 模式已启动
      });
    } on PlatformException catch (e) {
      print("Failed to enter PiP mode: ${e.message}");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://stream7.iqilu.com/10339/upload_transcode/202002/09/20200209105011F0zPoYzHry.mp4'))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PIPView(
      builder: (context, isFloating) {
        return Scaffold(
          appBar: _isInPipMode
              ? null
              : AppBar(
                  title: Text('Video Player with PiP'),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.picture_in_picture),
                      onPressed: _enterPipMode,
                    ),
                  ],
                ),
          body: Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : CircularProgressIndicator(),
          ),
          floatingActionButton: _isInPipMode
              ? null
              : FloatingActionButton(
                  onPressed: () {
                    if (_controller.value.isInitialized) {
                      PIPView.of(context)?.presentBelow(PipVideoPlayer());
                    }
                    // setState(() {
                    //   if (_controller.value.isPlaying) {
                    //     _controller.pause();
                    //   } else {
                    //     _controller.play();
                    //   }
                    // });
                  },
                  child: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                ),
        );
      },
    );
  }
}
