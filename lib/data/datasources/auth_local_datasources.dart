
import 'package:food_delivery_resto_app/data/models/response/auth_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDatasources {
   Future<void> saveAuthData(AuthResponseModel authResponseModel) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('auth_data', authResponseModel.toJson());
  }

  Future<void> removeAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_data');
  }

  Future<AuthResponseModel?> getAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? authData = prefs.getString('auth_data');
    if (authData != null) {
      return AuthResponseModel.fromJson(authData);
    }
    return null;
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('auth_data');
  }
}
