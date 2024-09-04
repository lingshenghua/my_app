import 'package:flutter/services.dart';

class ChannelPlugin {
  static const MethodChannel _channel =
      MethodChannel('com.example.my_app/plugin');

  /// 投屏
  Future<void> castToDevice(String deviceUrl, String mediaUrl) async {
    try {
      await _channel.invokeMethod('castToDevice', {
        'deviceUrl': deviceUrl,
        'mediaUrl': mediaUrl,
      });
    } catch (e) {
      throw 'Error casting to device: $e';
    }
  }

  /// 画中画
  Future<void> enterPipMode() async {
    try {
      await _channel.invokeMethod('enterPipMode');
    } catch (e) {
      print('Failed to enter PiP mode: $e');
    }
  }
}
