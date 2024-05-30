import 'package:vibration/vibration.dart';

class DeviceUtils {
  void vibrateDevice(isVibrating) async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 200);
      // setState(() {
      //   isVibrating = true;
      // });
      Future.delayed(const Duration(microseconds: 200), () {
        // setState(() {
        //   isVibrating = false;
        // });
      });
    }
  }
}
