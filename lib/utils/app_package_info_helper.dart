import 'package:package_info_plus/package_info_plus.dart';

class AppPackageInfoHelper {
  String? version;

  // Private constructor
  AppPackageInfoHelper._privateConstructor();

  // Static instance
  static final AppPackageInfoHelper _instance = AppPackageInfoHelper._privateConstructor();

  // Factory constructor to return the same instance
  factory AppPackageInfoHelper() {
    return _instance;
  }

  Future<void> initialize() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }
}