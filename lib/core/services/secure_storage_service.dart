import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

class ProxySettings {
  final bool enabled;
  final String type; // 'MTProto', 'SOCKS5', 'HTTP'
  final String server;
  final int port;
  final String? username;
  final String? password;
  final String? secret;

  ProxySettings({
    required this.enabled,
    required this.type,
    required this.server,
    required this.port,
    this.username,
    this.password,
    this.secret,
  });

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'type': type,
        'server': server,
        'port': port,
        'username': username,
        'password': password,
        'secret': secret,
      };

  factory ProxySettings.fromJson(Map<String, dynamic> json) => ProxySettings(
        enabled: json['enabled'] ?? false,
        type: json['type'] ?? 'MTProto',
        server: json['server'] ?? '',
        port: json['port'] ?? 1080,
        username: json['username'],
        password: json['password'],
        secret: json['secret'],
      );
}

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  static const _apiIdKey = 'tdlib_api_id';
  static const _apiHashKey = 'tdlib_api_hash';
  static const _dbKey = 'tdlib_db_key';
  static const _proxyKey = 'tdlib_proxy_settings';

  Future<void> saveCredentials({required String apiId, required String apiHash}) async {
    await _storage.write(key: _apiIdKey, value: apiId);
    await _storage.write(key: _apiHashKey, value: apiHash);
  }

  Future<Map<String, String>?> getCredentials() async {
    final apiId = await _storage.read(key: _apiIdKey);
    final apiHash = await _storage.read(key: _apiHashKey);
    if (apiId != null && apiHash != null) {
      return {'apiId': apiId, 'apiHash': apiHash};
    }
    return null;
  }

  Future<void> clearCredentials() async {
    await _storage.delete(key: _apiIdKey);
    await _storage.delete(key: _apiHashKey);
  }

  Future<String> getDatabaseEncryptionKey() async {
    String? key = await _storage.read(key: _dbKey);
    if (key == null) {
      // Generate a stable local TDLib database encryption key.
      // TDLib JSON interface requires 'bytes' fields to be strictly Base64 encoded!
      final rawKey = '${DateTime.now().millisecondsSinceEpoch}nova_secure_db_key';
      final generatedKey = base64Encode(utf8.encode(rawKey));
      await _storage.write(key: _dbKey, value: generatedKey);
      key = generatedKey;
    }
    return key;
  }

  Future<void> clearDatabaseEncryptionKey() async {
    await _storage.delete(key: _dbKey);
  }

  Future<void> saveProxySettings(ProxySettings settings) async {
    await _storage.write(key: _proxyKey, value: jsonEncode(settings.toJson()));
  }

  Future<ProxySettings?> getProxySettings() async {
    final str = await _storage.read(key: _proxyKey);
    if (str != null) {
      try {
        return ProxySettings.fromJson(jsonDecode(str));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> clearProxySettings() async {
    await _storage.delete(key: _proxyKey);
  }
}
