import 'dart:async';
import 'package:uts_toko_olahraga/Database/DbHelper.dart';
import 'package:uts_toko_olahraga/Model/User.dart';

class ReqLogin {
  DbHelper dbHelper = new DbHelper();
 Future<User> getLogin(String username, String password) {
    var result = dbHelper.getLogin(username,password);
    return result;
  }
}