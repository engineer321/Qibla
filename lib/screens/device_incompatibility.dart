import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qibla/constants/asset_path.dart';

import '../main.dart';

class DeviceIncompatibility extends StatelessWidget {
  const DeviceIncompatibility({super.key});

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AssetPath.compass_1),
          Center(
            child: Text(
              'Oops! Your device doesn\'t support the magnetometer sensor needed for this feature. Apologies for any inconvenience',
              textAlign: TextAlign.center,
              style: GoogleFonts.leagueSpartan(
                  fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: mq.height * .05),
          ElevatedButton(
            style: ButtonStyle(
                fixedSize: WidgetStateProperty.all(
                    Size(mq.width * .35, mq.height * .04))),
            onPressed: () {
              // exit(0);
              SystemNavigator.pop();
              // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
            child: Text('Exit',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w800, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
