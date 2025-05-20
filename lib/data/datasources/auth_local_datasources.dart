import 'package:food_delivery_resto_app/data/models/response/login_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDatasources {
  Future<void> saveAuthData(LoginResponseModel loginResponseModel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_data', loginResponseModel.toJson() as String);
  }

  Future<void> removeAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_data');
  }

  Future<LoginResponseModel?> getAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? authData = prefs.getString('auth_data');
    if (authData != null) {
      return LoginResponseModel.fromJson(authData as Map<String, dynamic>);
    }
    return null;
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('auth_data');
  }
}
