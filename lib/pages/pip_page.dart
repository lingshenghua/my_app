import 'package:flutter/material.dart';
import 'package:my_app/common/channel_plugin.dart';
import 'package:video_player/video_player.dart';

class PipPage extends StatefulWidget {
  const PipPage({super.key});

  @override
  PipPageState createState() => PipPageState();
}

class PipPageState extends State<PipPage> {
  final ChannelPlugin channelPlugin = ChannelPlugin();

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

  Future<void> enterPipMode() async {
    try {
      await channelPlugin.enterPipMode();
      print('Casting started');
    } catch (e) {
      print('Failed to start casting: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PiP Example'),
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
          if (_controller.value.isPlaying) {
            _controller.pause();
          } else {
            _controller.play();
          }
          setState(() {});
        },
        child: _controller.value.isPlaying
            ? const Icon(Icons.pause)
            : const Icon(Icons.play_arrow),
      ),
    );
  }
}
