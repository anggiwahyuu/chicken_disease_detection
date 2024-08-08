// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';

import 'package:gif/gif.dart';

class LoaderState extends StatefulWidget {
  const LoaderState({super.key});

  @override
  State<LoaderState> createState() => _LoaderStateState();
}

class _LoaderStateState extends State<LoaderState>
    with TickerProviderStateMixin {
  late final GifController controller1;

  @override
  void initState() {
    controller1 = GifController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Gif(
                image: const AssetImage("assets/images/loading-animation.gif"),
                controller: controller1,
                autostart: Autostart.loop,
                onFetchCompleted: () {
                  controller1.reset();
                  controller1.forward();
                },
              ),
            ),
            const Text("Sedang Mendeteksi..."),
          ],
        ),
      ),
    );
  }
}
