import 'package:uts_toko_olahraga/EntryForm/ReqLogin.dart';
import 'package:uts_toko_olahraga/Model/User.dart';

abstract class LoginCallBack {
  void onLoginSuccess(User user);
  void onLoginError(String error);
}
class ResponLogin {
  LoginCallBack _callBack;
  ReqLogin loginRequest = new ReqLogin();
  ResponLogin(this._callBack);
  doLogin(String username, String password) {
    loginRequest
        .getLogin(username, password)
        .then((user) => _callBack.onLoginSuccess(user))
        .catchError((onError) => _callBack.onLoginError(onError.toString()));
  } 
}