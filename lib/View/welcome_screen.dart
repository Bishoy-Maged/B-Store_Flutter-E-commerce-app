import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'Role_based_login/login_screen.dart';
import 'Role_based_login/signup_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<void> _toggleLocale() async {
    final current = context.locale.languageCode;
    final newLocale = Locale(current == 'en' ? 'ar' : 'en');
    await context.setLocale(newLocale);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "B-Store",
          style: TextStyle(
            fontFamily: 'Suwannaphum',
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF06202B), Colors.teal],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: screenWidth > 600 ? 480 : screenWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logos
                    Row(
                      children: [
                        Expanded(
                          child: Image.asset(
                            "assets/logos/Logo.png",
                            height: screenHeight * 0.22 > 220 ? 220 : screenHeight * 0.22,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Image.network(
                            "https://city-tourist.de/assets/images/shopping-einkaufen-citytrip.jpg",
                            height: screenHeight * 0.22 > 220 ? 220 : screenHeight * 0.22,),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'welcome_title'.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontFamily: 'Suwannaphum',
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'welcome_subtitle'.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: 'Suwannaphum',
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SignupScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        // changed key here
                        child: Text('sign_up'.tr()),
                      ),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.black.withOpacity(0.2)),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        child: Text(
                          'sign_in'.tr(),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    TextButton(
                      onPressed: _toggleLocale,
                      child: Text(
                        context.locale.languageCode == 'en'
                            ? 'switch_to_arabic'.tr()
                            : 'switch_to_english'.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
