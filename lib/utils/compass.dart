import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/asset_path.dart';
import '../main.dart';

class Compass extends StatelessWidget {
  final QiblahDirection qiblaDirection;

  const Compass({super.key, required this.qiblaDirection});

  @override
  Widget build(BuildContext context) {
    final qd = qiblaDirection;
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.rotate(
          angle: ((qd.direction * (pi / 180)) * -1),
          child: SvgPicture.asset(
            // colorFilter:
            //     const ColorFilter.mode(Colors.green, BlendMode.modulate),
            colorFilter: const ColorFilter.srgbToLinearGamma(),
            AssetPath.compass_2,

            height: mq.height * .38,
          ),
        ),

        //COMPASS NEEDLE
        Transform.rotate(
          angle: ((qd.qiblah * (pi / 180)) * -1),
          child: Center(
            child: SvgPicture.asset(
              AssetPath.needleWithKaaba,
              height: mq.height * .38,
            ),
          ),
        ),
      ],
    );
  }
}
