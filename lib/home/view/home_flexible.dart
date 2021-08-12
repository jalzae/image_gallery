import 'package:flutter/material.dart';
import 'dart:math' as math;

class MyAppSpace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final settings = context
            .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        final deltaExtent = settings!.maxExtent - settings.minExtent;
        final t =
            (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
                .clamp(0.0, 1.0);
        final fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
        const fadeEnd = 1.0;
        final opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);

        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 15),
              child: Opacity(
                opacity: 1 - opacity,
                child: Text('Collapsed Title', style: TextStyle(fontSize: 22)),
              ),
            ),
            Opacity(
              opacity: opacity,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned.fill(
                      child: Image.asset(
                    "assets/product.jpg",
                    fit: BoxFit.cover,
                  ))
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
