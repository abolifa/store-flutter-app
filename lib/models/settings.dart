class Settings {
  final String? contactEmail;
  final String? contactPhone;
  final String? contactAddress;
  final bool? androidMaintenanceMode;
  final bool? iosMaintenanceMode;
  final bool? webMaintenanceMode;
  final String? androidAppVersion;
  final String? iosAppVersion;
  final String? webAppVersion;
  final String? facebookUrl;
  final String? instagramUrl;
  final String? snapchatUrl;
  final String? tiktokUrl;

  Settings({
    this.contactEmail,
    this.contactPhone,
    this.contactAddress,
    this.androidMaintenanceMode,
    this.iosMaintenanceMode,
    this.webMaintenanceMode,
    this.androidAppVersion,
    this.iosAppVersion,
    this.webAppVersion,
    this.facebookUrl,
    this.instagramUrl,
    this.snapchatUrl,
    this.tiktokUrl,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      contactEmail: json['contact_email'] as String?,
      contactPhone: json['contact_phone'] as String?,
      contactAddress: json['contact_address'] as String?,
      androidMaintenanceMode: json['android_maintenance_mode'] as bool?,
      iosMaintenanceMode: json['ios_maintenance_mode'] as bool?,
      webMaintenanceMode: json['web_maintenance_mode'] as bool?,
      androidAppVersion: json['android_app_version'] as String?,
      iosAppVersion: json['ios_app_version'] as String?,
      webAppVersion: json['web_app_version'] as String?,
      facebookUrl: json['facebook_url'] as String?,
      instagramUrl: json['instagram_url'] as String?,
      snapchatUrl: json['snapchat_url'] as String?,
      tiktokUrl: json['tiktok_url'] as String?,
    );
  }
}
