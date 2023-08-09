import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tirtekna/utils/database.dart';
import 'package:tirtekna/utils/encrypt.dart';
import 'package:tirtekna/common/setting/constanta.dart' as constanta;

class DeviceInfo {
  static final DeviceInfo _deviceInfo = DeviceInfo._internal();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  static final device = deviceInfoPlugin.androidInfo;
  static AndroidDeviceInfo? build;
  static PackageInfo? info;

  late DatabaseHelper _db;
  late Encrypt _encrypt;

  String? access;
  bool? isExpired;
  String? refresh;

  DeviceInfo._internal();
  factory DeviceInfo() {
    return _deviceInfo;
  }

  Future initialize(Encrypt encrypt, DatabaseHelper db) async {
    info = await PackageInfo.fromPlatform();
    build = await device;

    _db = db;
    _encrypt = encrypt;
  }

  //HardwareID
  String getHardwareID() {
    return build!.androidId.toString();
  }

  //HardwareIDRequest
  String getHardwareIDRequest() {
    Random random = Random();
    int randomNumber1 = random.nextInt(9999999) + 1111111;
    int randomNumber2 = random.nextInt(9999999) + 1111111;
    final hdd = randomNumber1.toString() +
        "{#}" +
        build!.androidId.toString() +
        "{#}" +
        randomNumber2.toString();

    return _encrypt.mobileEncode(hdd, String.fromCharCodes(constanta.skey));
  }

  //GetVersion
  String getVersion() {
    // var build = await device;
    return build!.manufacturer.toString();
  }

  //SDKkit
  String getSDK() {
    // var build = await device;
    return build!.version.sdkInt.toString();
  }

  //GetOS
  String getOS() {
    String? osver;
    if (Platform.isAndroid) {
      osver = "ANDROID";
    } else if (Platform.isIOS) {
      osver = "IOS";
    }
    // var build = await device;
    return osver! +
        " " +
        build!.version.sdkInt.toString() +
        " (" +
        build!.manufacturer.toString() +
        ")";
  }

  //GetAppVersion
  String getAppVersion() {
    return info!.version;
  }
}
