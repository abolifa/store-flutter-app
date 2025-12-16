import 'package:package_info_plus/package_info_plus.dart';

class VersionHelper {
  static List<int> _parse(String version) {
    return version.split('.').map((e) => int.tryParse(e) ?? 0).toList();
  }

  static bool isLowerThan(String current, String required) {
    final a = _parse(current);
    final b = _parse(required);

    final maxLength = a.length > b.length ? a.length : b.length;

    for (var i = 0; i < maxLength; i++) {
      final av = i < a.length ? a[i] : 0;
      final bv = i < b.length ? b[i] : 0;

      if (av < bv) return true;
      if (av > bv) return false;
    }

    return false;
  }
}

class AppVersionService {
  static Future<String> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }
}
