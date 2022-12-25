import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/io_client.dart';

class SSLHelper {
  static IOClient? _client;

  static IOClient get client => _client ?? IOClient();

  static Future<void> initializing() async {
    _client = await instance;
  }

  static Future<IOClient> get instance async =>
      _client ??= await createIoClient();

  static Future<IOClient> createIoClient() async {
    final context = SecurityContext(withTrustedRoots: false);
    final sslCert = await rootBundle.load('certificates/certificates.crt');

    final httpClient = HttpClient(context: context);

    context.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());

    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    return IOClient(httpClient);
  }
}
