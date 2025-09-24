import 'package:flutter/foundation.dart';
import 'package:network_info_plus/network_info_plus.dart';

import 'package:dart_ipify/dart_ipify.dart';

class IpHelper {
  static Future<String?> getPublicIp() async {
    try {
      final ip = await Ipify.ipv4();
      if (kDebugMode) print('[IpHelper] public IP: $ip');
      return ip;
    } catch (e) {
      if (kDebugMode) print('[IpHelper] Public IP fetch failed: $e');
      return null;
    }
  }

  static Future<String?> getLocalIp() async {
    try {
      final info = NetworkInfo();
      final ip = await info.getWifiIP();
      if (kDebugMode) print('[IpHelper] local IP: $ip');
      return ip;
    } catch (e) {
      if (kDebugMode) print('[IpHelper] Local IP fetch failed: $e');
      return null;
    }
  }

  static Future<String> getIpForLogin() async {
    final pub = await getPublicIp();
    if (pub?.isNotEmpty ?? false) return pub!;
    final local = await getLocalIp();
    return local ?? '';
  }
}

