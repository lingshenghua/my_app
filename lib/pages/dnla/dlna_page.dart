import 'package:flutter/material.dart';
import 'package:my_app/common/channel_plugin.dart';
import 'package:upnp2/upnp.dart' as upnp;

class DlnaDevice {
  final String friendlyName;
  final String url;

  DlnaDevice(this.friendlyName, this.url);
}

class DlnaPage extends StatefulWidget {
  const DlnaPage({super.key});

  @override
  DlnaPageState createState() => DlnaPageState();
}

class DlnaPageState extends State<DlnaPage> {
  final ChannelPlugin channelPlugin = ChannelPlugin();

  List<DlnaDevice> devices = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    discoverDevices();
  }

  Future<void> discoverDevices() async {
    setState(() {
      isLoading = true;
    });

    final disc = upnp.DeviceDiscoverer();
    await disc.start(ipv6: false);

    final List<DlnaDevice> foundDevices = [];
    final clients = disc.quickDiscoverClients();

    await for (final client in clients) {
      try {
        final dev = await client.getDevice();
        foundDevices
            .add(DlnaDevice(dev!.friendlyName.toString(), dev.url.toString()));
        // if (dev != null && (dev.deviceType!.contains('MediaRenderer') || dev.deviceType!.contains('MediaServer'))) {
        //   foundDevices.add(DLNADevice(dev.friendlyName.toString(), dev.url.toString()));
        // }
      } catch (e) {
        print('Error: $e');
      }
    }

    setState(() {
      devices = foundDevices;
      isLoading = false;
    });
  }

  Future<void> castToDevice(String deviceUrl, String mediaUrl) async {
    try {
      await channelPlugin.castToDevice(deviceUrl, mediaUrl);
      print('Casting started');
    } catch (e) {
      print('Failed to start casting: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DLNA Devices'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : devices.isEmpty
              ? const Center(child: Text('No devices found'))
              : ListView.builder(
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    final device = devices[index];
                    return ListTile(
                      title: Text(device.friendlyName),
                      subtitle: Text(device.url),
                      onTap: () {
                        /// 你可以在这里处理设备点击事件，比如启动投屏
                        const mediaUrl =
                            'https://stream7.iqilu.com/10339/upload_transcode/202002/09/20200209105011F0zPoYzHry.mp4';
                        castToDevice(device.url, mediaUrl);
                        print('Selected Device: ${device.friendlyName}');
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: discoverDevices,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
