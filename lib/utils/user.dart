import 'dart:convert';

import 'package:tirtekna/utils/database.dart';
import 'package:tirtekna/utils/device.dart';
import 'package:tirtekna/utils/encrypt.dart';
import 'package:tirtekna/common/setting/constanta.dart' as constanta;

class User {
  static final User _user = User._internal();

  User._internal();

  factory User() {
    return _user;
  }

  //PRIVATE
  late DatabaseHelper _db = DatabaseHelper.db;
  late DeviceInfo _device;
  late Encrypt _encrypt;
  String? _hwid;
  String? _msetting;
  String? url;
  String? token;

  void initialize(DatabaseHelper db, DeviceInfo device, Encrypt encrypt) {
    _db = db;
    _device = device;
    _encrypt = encrypt;
    _hwid = _device.getHardwareID();
    _msetting = _decodeConstanta(constanta.tableSetting);
    url = _decodeConstanta(constanta.url);
  }

  String _decodeConstanta(List<int> chr) {
    final p = _encrypt.safeb64mobileEncode(String.fromCharCodes(chr));
    return _encrypt.mobileDecode(p, String.fromCharCodes(constanta.skey));
  }

  String _key(List<int> chr) {
    return _encrypt.mobileEncode(_decodeConstanta(chr), _hwid!);
  }

  Future<String> getSetting(List<int> key) async {
    String result = "";
    await _db.queryRows(_msetting!, 'id = ?', [_key(key)]).then((value) => {
          result = value.isNotEmpty && value[0]['value'] != null
              ? value[0]['value']
              : ""
        });

    if (result.isNotEmpty) {
      result = _encrypt.mobileDecode(result, _hwid!);
    } else {
      await _db.insertIgnore(_msetting!, {'id': _key(key)});
    }

    return result;
  }

  void setSetting(List<int> key, String value) async {
    await _db.insertReplace(_msetting!, {'id': _key(key), 'value': value});
  }

  Future<String> getCKEY() async {
    return await getSetting(constanta.settingIDCKEY);
  }

  void setCKEY(String value) {
    setSetting(constanta.settingIDCKEY, value);
  }

  void setAPPSNAME(String value) {
    setSetting(constanta.settingAPPSNAME, value);
  }

  void setDATAVERSION(String value) {
    setSetting(constanta.SettingDATAVERSION, value);
  }

  void setLEVEL(String value) {
    setSetting(constanta.settingLEVEL, value);
  }

  void setisNeedLogin(String value) {
    setSetting(constanta.settingIDNEEDLOGIN, value);
  }

  void setPDAMNAME(String value) {
    setSetting(constanta.settingPDAMNAME, value);
  }

  Future<String> getDATAVERSION() async {
    return await getSetting(constanta.SettingDATAVERSION);
  }

  Future<String> getPDAMNAME() async {
    return await getSetting(constanta.settingPDAMNAME);
  }

  Future<String> getLEVEL() async {
    return await getSetting(constanta.settingLEVEL);
  }

  Future<String> getAPPSNAME() async {
    String namaApps = await getSetting(constanta.settingAPPSNAME);
    if (namaApps.isEmpty) {
      namaApps = "-";
    }
    return _encrypt.mobileEncode(
        namaApps, String.fromCharCodes(constanta.skey));
  }

  Future<String> getNama() async {
    return await getSetting(constanta.settingIDNAMA);
  }

  void setNama(String value) {
    setSetting(constanta.settingIDNAMA, value);
  }

  Future<bool> getToken() async {
    final result = await getSetting(constanta.settingIDTOKEN);
    bool noexpiredToken = true;
    Map<String, dynamic>? data;
    try {
      data = json.decode(result);
    } on FormatException catch (_) {
      return false;
    }

    if (data!['access'] != null) {
      final dataacces = _encrypt.mobileDecode(data['access'], _hwid!);
      token = dataacces;
    }

    if (data['expired'] != null) {
      final expired = data['expired'] * 1000;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      if (expired <= timestamp) {
        noexpiredToken = false;
      }
    }

    return noexpiredToken;
  }

  void setToken(String value) {
    setSetting(constanta.settingIDTOKEN, value);
  }

  Future<String> getTokenRefresh() async {
    return await getSetting(constanta.settingIDTOKENREFRESH);
  }

  void setTokenRefresh(String value) {
    setSetting(constanta.settingIDTOKENREFRESH, value);
  }

  Future<String> getPassword(String value) async {
    final password = await getSetting(constanta.settingIDPKEY);
    if (password.isEmpty) {
      return 'empty';
    }

    if (password == _encrypt.toSHA256(_hwid! + value)) {
      return 'ok';
    }

    return 'wrong';
  }

  void setPassword(String value) {
    final password =
        _encrypt.mobileEncode(_encrypt.toSHA256(_hwid! + value), _hwid!);
    setSetting(constanta.settingIDPKEY, password);
  }

  Future<bool> isLogin() async {
    final result = await getSetting(constanta.settingIDLOGIN);
    if (result.isEmpty) {
      return false;
    }

    if (result == '111111') {
      return true;
    }

    return false;
  }

  void setLogin() {
    final value = _encrypt.mobileEncode("111111", _hwid!);
    setSetting(constanta.settingIDLOGIN, value);
  }

  void setResolution(String value) {
    final _value = _encrypt.mobileEncode(value, _hwid!);
    setSetting(constanta.settingIDRESOLUSI, _value);
  }

  Future<String> getResoltuion() async {
    final result = await getSetting(constanta.settingIDRESOLUSI);

    return result;
  }

  void setCompress(String value) {
    final _value = _encrypt.mobileEncode(value, _hwid!);
    setSetting(constanta.settingIDCOMPRESION, _value);
  }

  Future<String> getCompress() async {
    final result = await getSetting(constanta.settingIDCOMPRESION);

    return result;
  }

  void setLogout() {
    final value = _encrypt.mobileEncode("000000", _hwid!);
    setSetting(constanta.settingIDLOGIN, value);
  }

  Future<bool> isNeedLogin() async {
    final result = await getSetting(constanta.settingIDNEEDLOGIN);

    if (result.isEmpty || result == "000000") {
      return true;
    }

    if (result == '111111') {
      return false;
    }

    return true;
  }

  void setNotAutoSend() {
    final value = _encrypt.mobileEncode("111111", _hwid!);
    setSetting(constanta.settingIDAUTOSEND, value);
  }

  void setAutoSend() {
    final value = _encrypt.mobileEncode("000000", _hwid!);
    setSetting(constanta.settingIDAUTOSEND, value);
  }

  Future<bool> isAutoSend() async {
    final result = await getSetting(constanta.settingIDAUTOSEND);

    if (result.isEmpty) {
      return true;
    }

    if (result == '111111') {
      return false;
    }

    return true;
  }

  void setNeedLogin(bool needLogin) {
    final value =
        _encrypt.mobileEncode(needLogin == true ? "000000" : "111111", _hwid!);
    setSetting(constanta.settingIDNEEDLOGIN, value);
  }

  Future<int> getServiceDuration() async {
    final value = await getSetting(constanta.settingIDSERVICEDURATION);
    if (value.isEmpty) {
      return 15;
    }
    return int.parse(value);
  }

  void setServiceDuration(int duration) {
    final value = _encrypt.mobileEncode(duration.toString(), _hwid!);
    setSetting(constanta.settingIDSERVICEDURATION, value);
  }

  Future<Map<String, dynamic>> bodyEncrypt(
      String module, Map<String, dynamic> data) async {
    final ckey = await getCKEY();
    final databody = jsonEncode(data);
    final databodyencrypt =
        _encrypt.mobileEncrypt(databody, _encrypt.toMD5(ckey), _hwid!);

    Map<String, String> databody2 = {'module': module, 'data': databodyencrypt};

    final dataencode = _encrypt.mobileEncode(jsonEncode(databody2), _hwid!);
    return {'data': dataencode};
  }
}
