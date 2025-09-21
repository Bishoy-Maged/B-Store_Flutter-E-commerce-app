import 'package:b_store/View/Role_based_login/User/user_home_screen.dart';
import 'package:b_store/View/Role_based_login/login_screen.dart';
import 'package:b_store/View/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Theme/app_theme.dart';
import 'View/Role_based_login/Admin/Screen/admin_home_screen.dart';
import 'firebase_options.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize localization
  await EasyLocalization.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      saveLocale: true,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,

      home: const SplashScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == '/auth') {
          return MaterialPageRoute(builder: (_) => const AuthStateHandler());
        }
        return null;
      },
    );
  }
}

class AuthStateHandler extends StatefulWidget {
  const AuthStateHandler({super.key});

  @override
  State<AuthStateHandler> createState() => _AuthStateHandlerState();
}

class _AuthStateHandlerState extends State<AuthStateHandler> {
  User? _currentUser;
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _initializeAuthState();
  }

  void _initializeAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (!mounted) return;
      setState(() {
        _currentUser = user;
      });
      if (user != null) {
        try {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
          if (!mounted) return;
          setState(() {
            _userRole = (userDoc.data()?['role'] as String?) ?? 'User';
          });
        } catch (_) {
          if (!mounted) return;
          setState(() {
            _userRole = 'User';
          });
        }
      } else {
        if (!mounted) return;
        setState(() {
          _userRole = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return const LoginScreen();
    }
    if (_userRole == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return _userRole!.toLowerCase() == 'admin'
        ? const AdminHomeScreen()
        : const UserHomeScreen();
  }
}
