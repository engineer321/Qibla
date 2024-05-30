import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qibla/constants/asset_path.dart';
import 'package:qibla/utils/qibla_locator.dart';
import 'package:vibration/vibration.dart';

import '../main.dart';
import '../utils/loading_indicator.dart';

class QiblaCompass extends StatefulWidget {
  const QiblaCompass({super.key});

  @override
  State<QiblaCompass> createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<QiblaCompass> {
  double currentLatitude = 0.0;
  double currentLongitude = 0.0;
  double qiblaDirectionM = 0.0;

  // FOR FETCHING CURRENT LOCATION
  Future<void> getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentLatitude = position.latitude;
        currentLongitude = position.longitude;
      });
      if (kDebugMode) {
        print('latitude : $currentLatitude');
        print('longitude : $currentLongitude');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting location: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getLocation().then((_) {
      // Calculate Qibla direction once location is obtained
      setState(() {
        qiblaDirectionM = QiblaLocator.calculateQiblaDirection(
            currentLatitude, currentLongitude);
        if (kDebugMode) {
          print('Qibla direction: $qiblaDirectionM');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isVibrating = false;

    void vibrateDevice() async {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 200);
        setState(() {
          isVibrating = true;
        });
        Future.delayed(const Duration(microseconds: 200), () {
          setState(() {
            isVibrating = false;
          });
        });
      }
    }

    return StreamBuilder(
      stream: FlutterQiblah.qiblahStream,
      builder: (context, AsyncSnapshot<QiblahDirection> snapshot) {
        // print('snapshot : $snapshot');

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicator();
        }

        final qiblahDirection = snapshot.data!;

        //FROM FLUTTER QIBLAH PACKAGE
        final angle = ((qiblahDirection.qiblah * (pi / 180)) * -1);

        // // Check if the direction is within the threshold of the Qibla direction for vibration
        if (qiblahDirection.direction.round() == qiblaDirectionM.round()) {
          vibrateDevice();
        }

        return SafeArea(
          child: Column(
            children: [
              SizedBox(height: mq.height * .02),
              const Text(
                'Align the arrow with the Kaaba image for accurate Qibla direction.',
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'leagueSpartan',
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: mq.height * .06),

              //KAABA IMAGE
              SvgPicture.asset(
                AssetPath.kaaba,
                height: mq.height * .25,
              ),

              SizedBox(height: mq.height * .05),

              //QIBLA DIRECTION NEEDLE
              Transform.rotate(
                angle: angle,
                alignment: Alignment.center,
                child: Image.asset(
                  AssetPath.qiblaDirection,
                  color: isVibrating ? Colors.green : Colors.black,
                  height: mq.height * .3,
                ),
              ),

              SizedBox(height: mq.height * .05),
              ElevatedButton(
                  onPressed: () => throw Exception(),
                  child: const Text('Throw test Exception')),

              //QIBLA DIRECTION DEGREE OF ANGLE
              Text(
                "Direction : ${qiblahDirection.direction.toStringAsFixed(0)}°",
                style: const TextStyle(
                  fontFamily: 'leagueSpartan',
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Transform.rotate(
// angle: (qiblahDirection.qiblah * (pi / 180) * -1),
// alignment: Alignment.center,
// child: compassSvg,
// ),
// ---------------------

// child: Stack(
// alignment: Alignment.center,
// children: [
// Transform.rotate(
// angle: (qiblahDirection.direction * (pi / 180) * -1),
// child: SvgPicture.asset(AssetPath.compassSvg),
// ),
// Transform.rotate(
// angle: (qiblahDirection.qiblah * (pi / 180) * -1),
// alignment: Alignment.center,
// child: SvgPicture.asset(
// AssetPath.kaabaNeedleSvg,
// height: 300,
// fit: BoxFit.contain,
// ),
// ),
// Positioned(
// bottom: mq.height * .03,
// child: Column(
// children: [
// Text(
// "Direction : ${qiblahDirection.direction.round()}°",
// style: const TextStyle(
// fontFamily: 'leagueSpartan',
// fontSize: 25,
// fontWeight: FontWeight.w600,
// ),
// ),
// Text(
// "Offset : ${qiblahDirection.offset.toStringAsFixed(2)}°",
// style: const TextStyle(
// fontFamily: 'leagueSpartan',
// fontSize: 25,
// fontWeight: FontWeight.w600,
// ),
// ),
// ],
// ),
// )
// ],
// ),

//-------------
// Text(
//   directionText,
//   style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
// ),
// Text(
//   "Offset : ${qiblahDirection.offset.toStringAsFixed(0)}°",
//   // style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
// ),
// Transform.rotate(
//   angle: (qiblahDirection.offset * (pi / 180) * -1),
//   alignment: Alignment.center,
//   child: needleSvg,
// ),
