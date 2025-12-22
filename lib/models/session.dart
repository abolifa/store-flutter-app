import 'package:get_storage/get_storage.dart';

enum ProductViewType { grid, list }

enum SessionKey {
  authToken,
  keyLatitude,
  keyLongitude,
  isFirstOpen,
  userId,
  themeMode,
  productViewType,
}

class Session {
  static final GetStorage _box = GetStorage();

  static Future<void> set(SessionKey key, dynamic value) async {
    await _box.write(key.name, value);
  }

  static T? get<T>(SessionKey key) {
    final value = _box.read(key.name);
    if (value is T) return value;
    return null;
  }

  static Future<void> remove(SessionKey key) async {
    await _box.remove(key.name);
  }

  static Future<void> clear() async {
    await _box.erase();
  }

  static bool has(SessionKey key) {
    return _box.hasData(key.name);
  }
}
