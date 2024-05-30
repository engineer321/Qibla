import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qibla/constants/asset_path.dart';

class DeviceIncompatibility extends StatelessWidget {
  const DeviceIncompatibility({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe7e7e7),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AssetPath.compass_1),
          const Center(
            child: Text(
              // 'Device does not support magnetometer sensor',
              'Oops! Your device doesn\'t support the magnetometer sensor needed for this feature. Apologies for any inconvenience',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // exit(0);
              SystemNavigator.pop();
              // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}
