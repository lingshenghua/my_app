import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controller/video_controller.dart';
import 'package:my_app/pages/dnla/dlna_page.dart';
import 'package:my_app/pages/pip/pip_page.dart';
import 'package:my_app/pages/scroll/nested.dart';
import 'package:my_app/pages/scroll/page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final VideoController controller = Get.put(VideoController());

  Widget _buildContainer() {
    return Container(
      height: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo App"),
      ),
      body: Center(
          child: Column(
        children: [
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const DlnaPage()));
            },
            child: const Text("Go to DlnaPage Page"),
          ),
          _buildContainer(),
          ElevatedButton(
            onPressed: () {
              // Permissions.systemAlertWindow(() {
              if (controller.isFloatingWindowVisible.value) {
                controller.hideFloatingWindow();
              }
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => PipPage()));
              // });
            },
            child: const Text("Go to PipPage Page"),
          ),
          _buildContainer(),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const NestedScrollPage()));
              // });
            },
            child: const Text("Go to NestedScrollPage Page"),
          ),
          _buildContainer(),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyPageView()));
              // });
            },
            child: const Text("Go to MyPageView Page"),
          ),
          const Spacer(), //
        ],
      )),
    );
  }
}
