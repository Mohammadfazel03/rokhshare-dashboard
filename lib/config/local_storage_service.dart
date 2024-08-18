import 'package:shared_preferences/shared_preferences.dart';

enum LocalStorageKey {
  accessToken("accessToken"),
  refreshToken("refreshToken");

  final String key;

  const LocalStorageKey(this.key);
}

class LocalStorageService {
  final SharedPreferencesAsync _preferences;
  final Map<String, Object?> _cache;

  LocalStorageService({required SharedPreferencesAsync preferences})
      : _preferences = preferences,
        _cache = {};

  Future<void> login(String accessToken, String refreshToken) async {
    await _preferences.setString(
        LocalStorageKey.refreshToken.key, refreshToken);
    await _preferences.setString(LocalStorageKey.accessToken.key, accessToken);
  }

  Future<void> updateAccessToken(String accessToken) async {
    _cache.remove(LocalStorageKey.accessToken.key);
    await _preferences.setString(LocalStorageKey.accessToken.key, accessToken);
  }

  Future<void> logout() async {
    _cache.remove(LocalStorageKey.accessToken.key);
    _cache.remove(LocalStorageKey.refreshToken.key);
    await _preferences.remove(LocalStorageKey.accessToken.key);
    await _preferences.remove(LocalStorageKey.refreshToken.key);
  }

  Future<String?> getAccessToken() async {
    if (_cache.containsKey(LocalStorageKey.accessToken.key)) {
      return (_cache[LocalStorageKey.accessToken.key]) as String?;
    }
    var token = await _preferences.getString(LocalStorageKey.accessToken.key);
    if (token != null) {
      _cache[LocalStorageKey.accessToken.key] = token;
    }
    return token;
  }

  Future<String?> getRefreshToken() async {
    if (_cache.containsKey(LocalStorageKey.refreshToken.key)) {
      return (_cache[LocalStorageKey.refreshToken.key]) as String?;
    }
    var token = await _preferences.getString(LocalStorageKey.refreshToken.key);
    if (token != null) {
      _cache[LocalStorageKey.refreshToken.key] = token;
    }
    return token;
  }
}
