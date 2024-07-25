import 'package:shared_preferences/shared_preferences.dart';

enum LocalStorageKey {
  accessToken("accessToken"),
  refreshToken("refreshToken");

  final String key;

  const LocalStorageKey(this.key);
}

class LocalStorageService {
  final SharedPreferences _preferences;

  LocalStorageService({required SharedPreferences preferences})
      : _preferences = preferences;

  Future<bool> login(String accessToken, String refreshToken) async {
    var res = await Future.wait([
      _preferences.setString(LocalStorageKey.refreshToken.key, refreshToken),
      _preferences.setString(LocalStorageKey.accessToken.key, accessToken)
    ]);
    return res.every((e) => e == true);
  }

  Future<bool> logout() async {
    var res = await Future.wait([
      _preferences.remove(LocalStorageKey.accessToken.key),
      _preferences.remove(LocalStorageKey.refreshToken.key)
    ]);
    return res.every((e) => e == true);
  }

  String? getAccessToken() {
    return _preferences.getString(LocalStorageKey.accessToken.key);
  }

  String? getRefreshToken() {
    return _preferences.getString(LocalStorageKey.refreshToken.key);
  }
}
