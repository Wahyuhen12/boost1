import 'package:tirtekna/utils/database.dart';
import 'package:tirtekna/utils/device.dart';
import 'package:tirtekna/utils/encrypt.dart';
import 'package:tirtekna/utils/request.dart';
import 'package:tirtekna/utils/user.dart';

class Apps {
  static final Apps _instance = Apps._internal();

  final DatabaseHelper db = DatabaseHelper.db;
  final DeviceInfo device = DeviceInfo();
  final Encrypt encrypt = Encrypt();
  final Request request = Request();
  final User user = User();

  // make this a singleton class
  Apps._internal();
  factory Apps() {
    return _instance;
  }

  Future initialize({String? path}) async {
    await device.initialize(encrypt, db);
    user.initialize(db, device, encrypt);
    request.initialize(device, encrypt, user);
    if (path != null) {
      db.path = path;
    }
  }
}
