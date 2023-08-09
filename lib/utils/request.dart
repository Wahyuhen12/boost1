import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tirtekna/common/ui/app_dialog.dart';
import 'package:tirtekna/common/ui/app_loading_dialog.dart';
import 'package:tirtekna/utils/encrypt.dart';
import 'package:tirtekna/utils/user.dart';
import 'device.dart';

class ResponseApp {
  late String code;
  late String message;
  Map<String, dynamic>? data;
  Map<String, dynamic>? edata;
}

class Request {
  static final Request _request = Request._internal();

  Request._internal();

  factory Request() {
    return _request;
  }

  //PRIVATE
  late DeviceInfo _device;
  late Encrypt _encrypt;
  late User _user;

  final Map<String, String> _header = {};
  String? _apiUrl;
  int _timeout = 40;

  //initialize
  void initialize(DeviceInfo device, Encrypt encrypt, User user) {
    _header["x-agn-os"] = Platform.operatingSystemVersion;
    _header["Content-Type"] = "application/json";

    _device = device;
    _encrypt = encrypt;
    _user = user;
    _apiUrl = user.url;
  }

  _setAuthorizationBasic(String password, int timestamp) async {
    final hdd = _device.getHardwareID();
    String pass = _encrypt.toSHA1(timestamp.toString());
    if (password != "-") {
      pass = _encrypt.bcrypt(_encrypt.toSHA256(hdd + password));
    }
    _header["Authorization"] =
        'Basic ${_encrypt.b64Encode('${_encrypt.toSHA1(hdd)}:$pass')}';
  }

  _setAuthorizationBearer(bool isRefreshToken) async {
    if (isRefreshToken == true) {
      final refreshtoken = await _user.getTokenRefresh();
      print("ini refress $refreshtoken");
      _header["Authorization"] = 'Bearer $refreshtoken';
    } else {
      await _user.getToken();
      _header["Authorization"] = 'Bearer ${_user.token!}';
    }
  }

  //POST REQUEST
  Future<ResponseApp> post(String endpoint,
      {Map<String, dynamic>? body,
      String? pathimage,
      int? timeout,
      BuildContext? context,
      String? platform,
      bool? showLoading,
      String? password,
      bool? bearer}) async {
    final response = await _requestPOST(endpoint,
        body: body,
        pathimage: pathimage,
        timeout: timeout,
        context: context,
        platform: platform,
        showLoading: showLoading,
        password: password,
        bearer: bearer);

    if (response.code != "0000") {
      //SEND REFRESH TOKEN
      if (response.code == "120004") {
        //SEND REFRESH TOKEN
        final statusRefresh = await _sendRefreshTOKEN();
        if (statusRefresh == false) {
          _user.setLogout();
          _user.setNeedLogin(true);
          return response;
        }

        //CALL FUNCTION AGAIN
        final response2 = await _requestPOST(endpoint,
            body: body,
            pathimage: pathimage,
            timeout: timeout,
            context: context,
            platform: platform,
            showLoading: showLoading,
            password: password,
            bearer: bearer);
        //SET LOGOUT
        if (response2.code == "120002") {
          _user.setLogout();
          _user.setNeedLogin(true);
        }
        return response2;
      }

      //SET LOGOUT
      if (response.code == "120002") {
        _user.setLogout();
        _user.setNeedLogin(true);
      }
    }

    return response;
  }

  //POST REQUEST
  Future<bool> _sendRefreshTOKEN() async {
    final body = await _user.bodyEncrypt('refreshtoken', {'refresh': 'get'});

    final response = await _requestPOST("request",
        body: body, bearer: true, refreshtoken: true);

    if (response.code != "0000") {
      return false;
    }

    return true;
  }

  //POST REQUEST
  Future<ResponseApp> _requestPOST(String endpoint,
      {Map<String, dynamic>? body,
      String? pathimage,
      int? timeout,
      BuildContext? context,
      String? platform,
      bool? showLoading,
      String? password,
      bool? bearer,
      bool? refreshtoken}) async {
    //LOADING SHOW
    if (context != null && showLoading != null && showLoading) {
      if (platform == "Scan") {
        AppDialog.showLoadingScan(context, false, const LoadingDialog());
      } else {
        AppDialog.showLoadingLogin(context);
      }
    }

    //VARIABLE SET
    final Uri uri = Uri.parse("${_apiUrl!}/$endpoint");
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    late String errorCode = "";
    late String errorMessage = "";
    late String result = "";
    String bodyRequest = jsonEncode(body);

    _header["User-Agent"] = _device.getHardwareID();
    _header["x-agn-version"] = _device.getAppVersion();
    _header["x-agn-debug"] = _device.getHardwareIDRequest();
    _header["x-agn-apps"] = await _user.getAPPSNAME();
    _header["x-agn-timestamp"] = timestamp.toString();

    //CHECK PASSWORD
    if (password != null) {
      await _setAuthorizationBasic(password, timestamp);
    }

    if (bearer != null && bearer) {
      if (refreshtoken == null) {
        await _setAuthorizationBearer(false);
      } else {
        await _setAuthorizationBearer(refreshtoken);
      }
    }

    _timeout = timeout ?? _timeout;

    try {
      if (pathimage == null) {
        final response = await http
            .post(
              uri,
              headers: _header,
              body: bodyRequest,
            )
            .timeout(Duration(seconds: _timeout));

        if (response.statusCode == 200) {
          result = response.body;
          print("inir esult version $result");
        } else {
          errorCode = "HTTP-${response.statusCode}";
          errorMessage = "Response error from server.";
        }
      } else {
        http.MultipartRequest request = http.MultipartRequest('POST', uri);
        request.files
            .add(await http.MultipartFile.fromPath('files', pathimage));
        request.fields['data'] = bodyRequest;
        request.headers.addAll(_header);

        final response = await request.send();
        if (response.statusCode == 200) {
          var res = await response.stream.toBytes();
          result = String.fromCharCodes(res);
        } else {
          errorCode = "HTTP-${response.statusCode}";
          errorMessage = "Response error from server.";
        }
      }
    } on TimeoutException {
      errorCode = "HTTP-TIMEOUT";
      errorMessage = "Response timeout from server.";
    } on SocketException {
      errorCode = "HTTP-NOCONNECT";
      errorMessage = "You are not connected to internet";
    }

    //LOADING CLOSE
    if (context != null && showLoading != null && showLoading) {
      Navigator.pop(context);
    }

    var inirefresh = false;

    if (refreshtoken == null) {
    } else {
      inirefresh = refreshtoken;
    }

    return _decodeResponse(
        errorCode, errorMessage, result, timestamp, inirefresh);
  }

  //Decode JSON Response
  ResponseApp _decodeResponse(String errorCode, String errorMessage,
      String databody, int timestamp, bool refreshToken) {
    final ResponseApp response = ResponseApp();

    response.code = errorCode;
    response.message = errorMessage;

    if (errorCode.isNotEmpty) {
      return response;
    }

    List<dynamic> result;
    try {
      result = json.decode(databody);
    } on FormatException catch (_) {
      response.code = "HTTP-DECODE";
      response.message = "Error decode response from server";
      return response;
    }

    final status = result[0];
    final message = result[1];
    Map<String, dynamic>? data;
    Map<String, dynamic>? edata;

    if (result.length == 3) {
      data = result[2];
    }

    if (result.length == 4) {
      data = result[2];
      final resedata = _encrypt.mobileDecrypt(result[3],
          _encrypt.toMD5(timestamp.toString()), _device.getHardwareID());
      try {
        edata = json.decode(resedata);
      } on FormatException catch (_) {}
    }

    if (status == null) {
      response.code = "HTTP-DECODE";
      response.message = "Error format response from server";

      return response;
    }

    if (status != "0000") {
      response.code = status;
      response.message = message;
      return response;
    }

    _user.setNeedLogin(false);

    response.code = status;
    response.message = message;
    response.data = data;
    response.edata = edata;

    //CHECK CREDENTIAL
    if (edata != null) {
      //CHECK CKEY
      if (edata["setckey"] != null) {
        _user.setCKEY(edata["setckey"]);
      }

      //CHECK NAMA
      if (edata["setnama"] != null) {
        _user.setNama(edata["setnama"]);
      }

      //CHECK APPSNAME
      if (edata["setappsname"] != null) {
        _user.setAPPSNAME(edata["setappsname"]);
      }

      if (edata["setlevel"] != null) {
        _user.setLEVEL(edata["setlevel"]);
      }

      //CHECK PDAMNAME
      if (edata["setpdamname"] != null) {
        _user.setPDAMNAME(edata["setpdamname"]);
      }
      print("ini statusrefreshTOken $refreshToken");
      //CHECK TOKEN
      if (edata["settoken"] != null) {
        print("ini settoken $refreshToken");
        _user.setToken(edata["settoken"]);
      }

      //CHECK TOKEN REFRESH
      if (edata["setrefresh"] != null) {
        print("ini data refresh ${edata['setrefresh']}");
        _user.setTokenRefresh(edata['setrefresh']);
      }

      if (edata["setdataversion"] != null) {
        // print("ini data version ${edata['setdataversion']}");
        _user.setDATAVERSION(edata["setdataversion"]);
      }
    }

    return response;
  }
}
