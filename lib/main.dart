import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/email_confirmation_screen.dart';
import 'screens/clinics_list_screen.dart';
import 'services/otp_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const PsiApoioApp());
}

class PsiApoioApp extends StatelessWidget {
  const PsiApoioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PsiApoio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF26A69A)),
        useMaterial3: true,
      ),
      home: const _AuthGate(),
    );
  }
}

class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  String? _checkedUid;
  bool? _verified;

  bool _isGoogleUser(User user) =>
      user.providerData.any((p) => p.providerId == 'google.com');

  Future<void> _loadVerification(String uid) async {
    if (_checkedUid == uid) return;
    final result = await OtpService.isVerified(uid);
    if (mounted) {
      setState(() {
        _checkedUid = uid;
        _verified = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _Splash();
        }

        final user = snapshot.data;

        if (user == null) {
          _checkedUid = null;
          _verified = null;
          return const LoginScreen();
        }

        if (_isGoogleUser(user)) return const ClinicsListScreen();

        _loadVerification(user.uid);

        if (_checkedUid != user.uid || _verified == null) return const _Splash();
        if (_verified!) return const ClinicsListScreen();
        return EmailConfirmationScreen(email: user.email ?? '');
      },
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(color: Color(0xFF26A69A)),
      ),
    );
  }
}
