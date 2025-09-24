import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class EncryptionHelper {
  static const _keyStorageKey = 'aes_key';
  static const _ivStorageKey = 'aes_iv';
  static final _storage = FlutterSecureStorage();

  static Future<Key> _getKey() async {
    String? storedKey = await _storage.read(key: _keyStorageKey);

    if (storedKey == null) {
      storedKey = 'HqE4dUkwLbXzR0IG';
      await _storage.write(key: _keyStorageKey, value: storedKey);
    }

    return Key.fromUtf8(storedKey);
  }

  static Future<IV> _getIV() async {
    String? storedIv = await _storage.read(key: _ivStorageKey);

    if (storedIv == null) {
      storedIv = 'HqE4dUkwLbXzR0IG';
      await _storage.write(key: _ivStorageKey, value: storedIv);
    }

    return IV.fromUtf8(storedIv);
  }

  static Future<String> encryptData(Map<String, dynamic> data) async {
    final key = await _getKey();
    final iv = await _getIV();
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final jsonData = jsonEncode(data);
    final encrypted = encrypter.encrypt(jsonData, iv: iv);
    return encrypted.base64;
  }

  static Future<Map<String, dynamic>> decryptData(String encryptedData) async {
    final key = await _getKey();
    final iv = await _getIV();
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final decrypted = encrypter.decrypt64(encryptedData, iv: iv);
    return jsonDecode(decrypted);
  }

  static Future<List<dynamic>> decryptDataList(String encryptedData) async {
    final key = await _getKey();
    final iv = await _getIV();
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final decrypted = encrypter.decrypt64(encryptedData, iv: iv);
    return jsonDecode(decrypted) as List<dynamic>;
  }
}
