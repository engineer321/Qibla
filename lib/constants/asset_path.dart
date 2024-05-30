import 'package:flutter_svg/svg.dart';

class AssetPath {
  static const compassSvg = 'assets/images/compass.svg';
  static const compass_1 = 'assets/images/compass-1.svg';
  static const qiblaDirection = 'assets/images/qibla_direction.png';
  static const kaaba = 'assets/images/kaaba-svg.svg';
  static const needle = 'assets/images/needle.svg';
  static const kaabaNeedleSvg = 'assets/images/kaaba-needle.svg';

  final needleSvg = SvgPicture.asset(
    'assets/images/needle.svg',
    height: 250,
    width: 50,
  );
  final compass = SvgPicture.asset(
    'assets/images/compass.svg',
    height: 250,
    width: 50,
  );
  final kaabaSvg = SvgPicture.asset(
    'assets/images/kaaba-svg.svg',
    height: 250,
    width: 50,
  );
}
