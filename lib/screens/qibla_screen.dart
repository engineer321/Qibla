import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qibla/screens/qibla_compass.dart';

import '../main.dart';
import '../utils/loading_indicator.dart';
import '../utils/location_error_widget.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

// String qiblahNeedle = 'assets/images/needle.svg';
// String compass = 'assets/images/compass.svg';
// Animation<double>? animation;
// AnimationController? _animationController;
// double begin = 0.0;

class _QiblaScreenState extends State<QiblaScreen>
    with TickerProviderStateMixin {
  final _locationStreamController =
      StreamController<LocationStatus>.broadcast();

  Stream<LocationStatus> get stream => _locationStreamController.stream;

  @override
  void initState() {
    super.initState();
    _checkLocationStatus();
  }

  @override
  void dispose() {
    _locationStreamController.close();
    FlutterQiblah().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffe7e7e7),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: stream,
          builder: (context, AsyncSnapshot<LocationStatus> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingIndicator();
            }
            if (snapshot.data!.enabled == true) {
              switch (snapshot.data!.status) {
                case LocationPermission.always:
                case LocationPermission.whileInUse:
                  return const QiblaCompass();

                case LocationPermission.denied:
                  return LocationErrorWidget(
                    error: "Location service permission denied",
                    callback: _checkLocationStatus,
                  );
                case LocationPermission.deniedForever:
                  return LocationErrorWidget(
                    error: "Location service Denied Forever !",
                    callback: _checkLocationStatus,
                  );
                // case GeolocationStatus.unknown:
                //   return LocationErrorWidget(
                //     error: "Unknown Location service error",
                //     callback: _checkLocationStatus,
                //   );
                default:
                  return const SizedBox();
              }
            } else {
              return LocationErrorWidget(
                error: "Please enable Location service",
                callback: _checkLocationStatus,
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _checkLocationStatus() async {
    final locationStatus = await FlutterQiblah.checkLocationStatus();
    if (locationStatus.enabled &&
        locationStatus.status == LocationPermission.denied) {
      await FlutterQiblah.requestPermissions();
      final s = await FlutterQiblah.checkLocationStatus();
      _locationStreamController.sink.add(s);
    } else {
      _locationStreamController.sink.add(locationStatus);
    }
  }
}

// final qiblahDirection = snapshot.data;
// animation = Tween(
//   begin: begin,
//   end: (qiblahDirection!.qiblah * (pi / 180) * -1),
// ).animate(_animationController!);
//
// //UPDATE VALUES
// begin = (qiblahDirection.qiblah * (pi / 180) * -1);
// _animationController!.forward(from: 0);
//
// return Stack(
//   // mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     // Container(
//     //   constraints: const BoxConstraints.expand(),
//     //   child: Image(
//     //     image: const AssetImage('assets/images/kaba.jpeg'),
//     //     fit: BoxFit.cover,
//     //     opacity: AnimationController(vsync: this, value: 0.8),
//     //     height: mq.width * .8,
//     //   ),
//     // ),
//     Positioned(
//       child: Center(
//         child: SvgPicture.asset(
//           compass,
//           semanticsLabel: 'Compass',
//           height: 250,
//           width: 50,
//         ),
//       ),
//     ),
//
//     Positioned(
//       top: mq.height * .353,
//       left: mq.width * .47,
//       child: SizedBox(
//         child: AnimatedBuilder(
//           animation: animation!,
//           builder: (context, child) => Transform.rotate(
//             angle: animation!.value,
//             child: Center(
//               child: SvgPicture.asset(
//                 qiblahNeedle,
//                 semanticsLabel: ' Qibla needle',
//                 height: 250,
//                 width: 50,
//               ),
//             ),
//             // Image(
//             //   image: const AssetImage(
//             //       'assets/images/qibla_direction.png'),
//             //   height: mq.height * .5,
//             //   width: mq.width * .6,
//             // ),
//           ),
//         ),
//       ),
//     ),
//     Positioned(
//         top: mq.height * .5,
//         child: ElevatedButton(
//             onPressed: () async {
//               Vibration.vibrate(duration: 1000);
//               // if (await Vibration.hasVibrator() != null) {
//               //   print('entered');
//               //   print(' Data $Vibration.hasVibrator()');
//               //
//               // }
//             },
//             child: const Text('Vibrate')))
//
//     // Positioned(
//     //   bottom: mq.height * .2,
//     //   left: mq.width * .15,
//     //   child: Image(
//     //     image: const AssetImage('assets/images/needle.png'),
//     //     height: mq.height * .2,
//     //   ),
//     // ),
//   ],
// );
