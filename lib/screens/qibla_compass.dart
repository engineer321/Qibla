import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qibla/services/launch_url.dart';
import 'package:qibla/utils/loading_screen.dart';
import 'package:qibla/utils/qibla_locator.dart';
import 'package:vibration/vibration.dart';

import '../main.dart';
import '../utils/compass.dart';

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
    void vibrateDevice() async {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 200);

        Future.delayed(const Duration(milliseconds: 200), () {});
      }
    }

    return StreamBuilder(
      stream: FlutterQiblah.qiblahStream,
      builder: (context, AsyncSnapshot<QiblahDirection> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        }

        final qiblahDirection = snapshot.data!;

        bool isPointingQibla =
            qiblahDirection.direction.round() == qiblaDirectionM.round();

        // // Check if the direction is within the threshold of the Qibla direction for vibration
        if (isPointingQibla) {
          vibrateDevice();
        }

        return SafeArea(
          child: Column(
            children: [
              SizedBox(height: mq.height * .04),
              Text(
                'Align the kaaba icon with the arrow for accurate Qibla direction.',
                softWrap: true,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    letterSpacing: -0.025),
              ),
              SizedBox(height: mq.height * .15),

              //KAABA IMAGE
              // SvgPicture.asset(
              //   AssetPath.kaaba,
              //   height: mq.height * .25,
              // ),
              SizedBox(
                child: Icon(
                  Icons.arrow_upward_outlined,
                  color:
                      isPointingQibla ? const Color(0xff16a34a) : Colors.black,
                  size: mq.height * .05,
                ),
              ),
              Compass(
                qiblaDirection: qiblahDirection,
              ),

              SizedBox(height: mq.height * .05),

              // ElevatedButton(
              //     onPressed: () => throw Exception(),
              //     child: const Text('Throw test Exception')),

              // //QIBLA DIRECTION DEGREE OF ANGLE
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: mq.height * .04, vertical: mq.height * .01),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: isPointingQibla
                      ? const Color(0xff16a34a)
                      : const Color(0xfff1f5f9),
                ),
                child: Text(
                  "Degree ${qiblahDirection.direction.toStringAsFixed(0)}°",
                  style: GoogleFonts.poppins(
                      color: isPointingQibla ? Colors.white : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: mq.height * .10),
              //Company details
              InkWell(
                onTap: Url.launchURL,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: 'powered by ',
                          style: GoogleFonts.leagueSpartan(
                            color: Colors.black,
                            fontSize: 16,
                          )),
                      TextSpan(
                          text: 'TechlogixIT',
                          style: GoogleFonts.leagueSpartan(
                            color: const Color(0xff058CCF),
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
