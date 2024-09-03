import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class DLNAVideoPlayer extends StatefulWidget {
  const DLNAVideoPlayer({Key? key}) : super(key: key);

  @override
  _DLNAVideoPlayerState createState() => _DLNAVideoPlayerState();
}

class _DLNAVideoPlayerState extends State<DLNAVideoPlayer> {
  static const platform = MethodChannel('com.example.my_app/dlna');
  late VideoPlayerController _controller;

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
    super.dispose();
  }

  // 调用原生方法进行投屏
  Future<void> _startDlnaCasting() async {
    try {
      await platform.invokeMethod('startDlnaCasting', {
        'url': _controller.dataSource, // 视频URL
      });
    } on PlatformException catch (e) {
      print("Failed to start DLNA casting: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player with DLNA'),
        actions: [
          IconButton(
            icon: Icon(Icons.cast),
            onPressed: _startDlnaCasting,
          ),
        ],
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
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
