import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:crypto/crypto.dart';
import 'package:dbcrypt/dbcrypt.dart';

class Encrypt {
  static final Encrypt _encrypt = Encrypt._internal();

  Encrypt._internal();
  factory Encrypt() {
    return _encrypt;
  }

  String toMD5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  String toSHA1(String input) {
    return sha1.convert(utf8.encode(input)).toString();
  }

  String toSHA256(String input) {
    return sha256.convert(utf8.encode(input)).toString();
  }

  String mobileEncrypt(String source, String keystr, String ivstr) {
    final key = Key.fromUtf8(keystr);
    final iv = IV.fromUtf8(ivstr);

    if (source.length < 64) {
      source = source
          .padRight(64, "{S#${String.fromCharCode(36)}}$source")
          .substring(0, 64);
    }

    final encrypter = Encrypter(AES(key, mode: AESMode.gcm));

    final encrypted = encrypter.encrypt(
      source,
      iv: iv,
    );
    // print(encrypted.base16);
    return encrypted.base16;
  }

  String mobileDecrypt(String source, String keystr, String ivstr) {
    final key = Key.fromUtf8(keystr);
    final iv = IV.fromUtf8(ivstr);

    final encrypter = Encrypter(AES(key, mode: AESMode.gcm));

    String decrypted = encrypter.decrypt16(
      source,
      iv: iv,
    );
    decrypted = _trimpad(decrypted);

    return decrypted;
  }

  //Mobile Encode
  String mobileEncode(String source, String skey, [int nmod = 4]) {
    if (source.isEmpty) {
      return "";
    }

    if (skey.isEmpty) {
      return "";
    }

    if (source.length < 64) {
      source = source
          .padRight(64, "{S#${String.fromCharCode(36)}}$source")
          .substring(0, 64);
    }

    skey = _createSKEY(skey);

    int lenstr = source.length;
    int lenkey = skey.length;
    String result = "";

    for (int i = 0; i < lenstr; i++) {
      String keychar = _substr(skey, (i % lenkey) - nmod, 1);
      String keychar2 = _substr(skey, (i % lenkey), 1);

      int nkey = keychar[0].codeUnitAt(0) % nmod;
      int char = (source[i].codeUnitAt(0) +
              (keychar[0].codeUnitAt(0) ^ keychar2[0].codeUnitAt(0))) ^
          (233 - nkey);

      result = result + String.fromCharCode(char);
    }

    return safeb64mobileEncode(result);
  }

  //Mobile Decode
  String mobileDecode(String source, String skey, [int nmod = 4]) {
    if (source.isEmpty) {
      return "";
    }

    if (skey.isEmpty) {
      return "";
    }

    source = safeb64mobileDecode(source);

    skey = _createSKEY(skey);
    int lenstr = source.length;
    int lenkey = skey.length;
    String result = "";
    for (int i = 0; i < lenstr; i++) {
      String keychar = _substr(skey, (i % lenkey) - nmod, 1);
      String keychar2 = _substr(skey, (i % lenkey), 1);

      int nkey = keychar[0].codeUnitAt(0) % nmod;
      int char = (source[i].codeUnitAt(0) ^ (233 - nkey)) -
          (keychar[0].codeUnitAt(0) ^ keychar2[0].codeUnitAt(0));
      result = result + String.fromCharCode(char);
    }

    return _trimpad(result);
  }

  //CREATE SKEY
  String _createSKEY(String key) {
    int lenKEY = key.length;
    String ordinalFirst = key[0].codeUnitAt(0).toString();
    String ordinalLast = key[lenKEY - 1].codeUnitAt(0).toString();
    key = ordinalFirst + key;

    String value;
    String result = key;
    int intpos = int.parse(ordinalFirst.substring(0, 1));
    value = result.substring(0, intpos);
    value = value + intpos.toString()[0];
    value = value + String.fromCharCode(0);
    int lenres = result.length;
    value = value + result.substring(intpos, lenres);
    result = value;

    intpos = int.parse(ordinalLast.substring(0, 1));
    value = String.fromCharCode(27) + result.substring(0, intpos);
    value = value + String.fromCharCode(127);
    value = "${value}4JJ1akbar";
    lenres = result.length;
    value = value + result.substring(intpos, lenres);

    return value;
  }

  //SAFE BASE64 ENCODE
  String b64Encode(String source) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String mobileEncodedSample = stringToBase64.encode(source);
    return mobileEncodedSample;
  }

  //SAFE BASE64 ENCODE
  String safeb64mobileEncode(String source) {
    final base64mobileEncode = base64.encoder;
    String mobileEncodedSample = base64mobileEncode.convert(source.codeUnits);
    mobileEncodedSample = mobileEncodedSample.replaceAll("+", "-");
    mobileEncodedSample = mobileEncodedSample.replaceAll("/", "_");
    mobileEncodedSample = mobileEncodedSample.replaceAll("=", "");
    return mobileEncodedSample;
  }

  //SAFE BASE64 ENCODE
  String safeb64mobileDecode(String source) {
    source = source.replaceAll("-", "+");
    source = source.replaceAll("_", "/");

    int mod4 = source.length % 4;
    if (mod4 != 0) {
      source = source + _substr("====", mod4);
    }

    try {
      final base64mobileEncode = base64.decoder;
      final mobileDecodeSample = base64mobileEncode.convert(source);
      return String.fromCharCodes(mobileDecodeSample);
    } catch (e) {
      return "";
    }
  }

  // PADSTRING
  String _padString(
    String str,
    int blocksize,
  ) {
    int lenstr = str.length;
    int padding = blocksize - lenstr % blocksize;
    String padtext = String.fromCharCode(20) * padding;
    return str + padtext;
  }

  //SUBSTRING
  String _substr(String str, int pos, [int? length]) {
    int lenstr = str.length;
    int length = lenstr;

    if (pos < 0) {
      pos = lenstr + pos;
      if (pos < 0) {
        pos = 0;
      }
    }

    if (pos >= lenstr) {
      return "";
    }

    str = str.substring(pos, lenstr);
    lenstr = str.length;

    if (length < 0) {
      length = lenstr + length;
    }

    if (length > lenstr) {
      length = lenstr;
    }

    return str.substring(0, length);
  }

  String _trimpad(String source) {
    final a = source.split("{S#${String.fromCharCode(36)}}");
    return a[0];
  }

  String bcrypt(String password) {
    DBCrypt dBCrypt = DBCrypt();
    String salt = dBCrypt.gensaltWithRounds(12);
    final hashedPwd = dBCrypt.hashpw(password, salt);
    return hashedPwd;
  }

  bool bcryptCheck(String plainPwd, String hashedPwd) {
    DBCrypt dBCrypt = DBCrypt();
    return dBCrypt.checkpw(plainPwd, hashedPwd);
  }
}
