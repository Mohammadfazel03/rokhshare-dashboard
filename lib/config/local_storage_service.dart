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

  void login(String accessToken, String refreshToken) {
    _preferences.setString(LocalStorageKey.accessToken.key, accessToken);
    _preferences.setString(LocalStorageKey.refreshToken.key, refreshToken);
  }

  void logout() {
    _preferences.remove(LocalStorageKey.accessToken.key);
    _preferences.remove(LocalStorageKey.refreshToken.key);
  }

  String? getAccessToken() {
    return _preferences.getString(LocalStorageKey.accessToken.key);
  }

  String? getRefreshToken() {
    return _preferences.getString(LocalStorageKey.refreshToken.key);
  }
}
