import 'package:flutter/material.dart';
import 'package:my_app/pages/dlna_page.dart';
import 'package:my_app/pages/pip_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PipPage()));
            },
            child: const Text("Go to PipPage Page"),
          ),
          const Spacer(),
        ],
      )),
    );
  }
}
