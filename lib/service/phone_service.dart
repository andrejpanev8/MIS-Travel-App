import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class PhoneService {
  PhoneService._privateConstructor();
  static final PhoneService instance = PhoneService._privateConstructor();
  factory PhoneService() => instance;
  final UrlLauncherPlatform launcher = UrlLauncherPlatform.instance;

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launcher.launchUrl(launchUri.toString(), const LaunchOptions());
  }
}
