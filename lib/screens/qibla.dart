import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qibla/utils/qibla_locator.dart';

import '../main.dart';

class Qibla extends StatefulWidget {
  const Qibla({super.key});

  @override
  State<Qibla> createState() => _QiblaState();
}

String assetName = 'assets/images/needle.svg';

class _QiblaState extends State<Qibla> {
  bool isVibrating = false;

  double currentLatitude = 0.0;
  double currentLongitude = 0.0;
  double qiblaDirection = 0.0;

  @override
  void initState() {
    super.initState();
    getLocation().then((_) {
      // Calculate Qibla direction once location is obtained
      qiblaDirection = QiblaLocator.calculateQiblaDirection(
          currentLatitude, currentLongitude);
      print('Qibla direction: $qiblaDirection');
      setState(() {});
    });
  }

  // FOR FETCHING CURRENT LOCATION
  Future<void> getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentLatitude = position.latitude;
        currentLongitude = position.longitude;
      });
      print('latitude : $currentLatitude');
      print('longitude : $currentLongitude');
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    // Calculate the angle between the current direction and the Qibla direction
    final angle = qiblaDirection * (pi / 180) * -1;

    // Display the degree of direction
    String directionText = "Qibla: ${qiblaDirection.toStringAsFixed(0)}°";

    return Scaffold(
        body: Column(
      children: [
        SizedBox(height: mq.height * .05),
        // Image of Kaaba
        SvgPicture.asset(
          'assets/images/kaaba-svg.svg',
          height: mq.height * .25,
        ),
        SizedBox(height: mq.height * .02),
        // Compass needle
        Transform.rotate(
          angle: angle,
          alignment: Alignment.center,
          child: Image(
            image: const AssetImage('assets/images/qibla_direction.png'),
            height: mq.height * .45,
          ),
        ),
        SizedBox(height: mq.height * .1),
        // Text displaying direction
        Text(
          directionText,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ],
    ));
  }
}

// AnimatedBuilder(
// animation: animation!,
// builder: (context, child) => Transform.rotate(
// angle: animation!.value,
// child: Image(
// image: const AssetImage(
// 'assets/images/qibla_direction.png'),
// height: mq.height * .5,
// width: mq.width * .6,
// ),
// ),
// ),

//   String qiblahNeedle = 'assets/images/needle.svg';
// String compass = 'assets/images/compass.svg';
// Animation<double>? animation;
// AnimationController? _animationController;
// double begin = 0.0;

// animation = Tween(
//   begin: begin,
//   end: (qiblahDirection!.qiblah * (pi / 180) * -1),
// ).animate(_animationController!);
//
// //UPDATE VALUES
// begin = (qiblahDirection.qiblah * (pi / 180) * -1);
// _animationController!.forward(from: 0);

// Positioned(
//   top: mq.height * .353,
//   left: mq.width * .47,
//   child: SizedBox(
//     child: AnimatedBuilder(
//       animation: Tween(
//         begin: begin,
//         end: (qiblahDirection.qiblah * (pi / 180) * -1),
//       ).animate(animationController),
//       builder: (context, child) => Transform.rotate(
//         angle: animation!.value,
//         child: Center(
//           child: SvgPicture.asset(
//             qiblahNeedle,
//             semanticsLabel: ' Qibla needle',
//             height: 250,
//             width: 50,
//           ),
//         ),
//       ),
//     ),
//   ),
// )
