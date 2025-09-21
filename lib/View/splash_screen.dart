import 'package:flutter/material.dart';
import '../main.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();


    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthStateHandler()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF06202B), Colors.teal],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeInOut,
            builder: (context, t, child) {
              final opacity = t;
              final scale = 0.95 + 0.05 * t;
              return Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: child,
                ),
              );
            },
            child: FractionallySizedBox(
              widthFactor: 0.8,
              heightFactor: 0.6,
              child: Image.asset(
                'assets/logos/BS Logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
