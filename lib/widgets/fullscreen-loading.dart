

import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';

class FullScreenLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Loading(
          size: 50.0,
          indicator: BallSpinFadeLoaderIndicator(),
          color: Colors.grey,
        )
      ],
    );
  }
}
