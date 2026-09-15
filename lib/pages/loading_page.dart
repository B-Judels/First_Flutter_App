import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  final List<String> _frames = [
    "images/BD_Loader2_0degrees.png",
    "images/BD_Loader2_45degrees.png",
    "images/BD_Loader2_90degrees.png",
    "images/BD_Loader2_135degrees.png",
    "images/BD_Loader2_180degrees.png",
    "images/BD_Loader2_225degrees.png",
    "images/BD_Loader2_270degrees.png",
    "images/BD_Loader2_315degrees.png",
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1080),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Preload every frame before the animation starts.
    for (final frame in _frames) {
      precacheImage(AssetImage(frame), context);
    }

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final int frameIndex =
                      (_controller.value * _frames.length).floor() %
                      _frames.length;

                  return Image.asset(
                    _frames[frameIndex],
                    width: 220,
                    height: 220,
                    fit: BoxFit.contain,
                  );
                },
              ),
            ),

            SizedBox(height: 5),

            Center(
              child: Text(
                "Bermonkel Development",
                style: const TextStyle(fontFamily: 'Oswald', fontSize: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
