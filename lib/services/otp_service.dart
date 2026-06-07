import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class OtpService {
  static final _db = FirebaseFirestore.instance;

  static String _generateCode() {
    final rng = Random.secure();
    return List.generate(6, (_) => rng.nextInt(10)).join();
  }

  static Future<void> sendOtp({
    required String email,
    required String uid,
  }) async {
    final code = _generateCode();
    final expiresAt = DateTime.now().add(const Duration(hours: 1));

    await _db.collection('otps').doc(uid).set({
      'code': code,
      'email': email,
      'expiresAt': Timestamp.fromDate(expiresAt),
      'verified': false,
    });

    await _sendEmail(email: email, code: code);
  }

  static Future<bool> verifyOtp({
    required String uid,
    required String code,
  }) async {
    final doc = await _db.collection('otps').doc(uid).get();
    if (!doc.exists) return false;

    final data = doc.data()!;
    final storedCode = data['code'] as String;
    final expiresAt = (data['expiresAt'] as Timestamp).toDate();
    final alreadyVerified = data['verified'] as bool? ?? false;

    if (alreadyVerified) return true;
    if (DateTime.now().isAfter(expiresAt)) return false;
    if (storedCode != code) return false;

    await _db.collection('otps').doc(uid).update({'verified': true});
    return true;
  }

  static Future<bool> isVerified(String uid) async {
    final doc = await _db.collection('otps').doc(uid).get();
    if (!doc.exists) return false;
    return doc.data()?['verified'] == true;
  }

  static Future<void> _sendEmail({
    required String email,
    required String code,
  }) async {
    final response = await http.post(
      Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'service_id': AppConfig.emailJsServiceId,
        'template_id': AppConfig.emailJsTemplateId,
        'user_id': AppConfig.emailJsPublicKey,
        'template_params': {
          'to_email': email,
          'passcode': code,
        },
      }),
    );
    debugPrint('EmailJS status: ${response.statusCode} | body: ${response.body}');
    if (response.statusCode != 200) {
      throw Exception('EmailJS erro ${response.statusCode}: ${response.body}');
    }
  }
}
