import 'package:url_launcher/url_launcher.dart';

class Url {
  static launchURL() async {
    Uri url = Uri.parse('https://techlogixit.com/');
    if (await launchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
