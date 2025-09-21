import 'package:b_store/main.dart';
import 'package:b_store/View/Role_based_login/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import '../welcome_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final auth = FirebaseAuth.instance;
  late String email;
  late String password;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureText = true;
  var formKey = GlobalKey<FormState>();

  Future<void> _setLoggedInAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthStateHandler()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Color(0xFF06202B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //------Back Button & Login Text-------//
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                              const MainScreen(),
                              transitionsBuilder:
                                  (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                              transitionDuration: const Duration(milliseconds: 500),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 80),
                      Center(
                        child: Text(
                          "login".tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 1000.ms)
                            .slideY(begin: -0.5, duration: 1000.ms),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  //------Image-------//
                  Image.asset(
                    "assets/images/3094352.png",
                    width: 280,
                    height: 280,
                  ),

                  const SizedBox(height: 20),

                  //------Email TextField-------//
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'email_required'.tr();
                      }
                      return null;
                    },
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'email_address'.tr(),
                      labelStyle: const TextStyle(color: Colors.white),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      prefixIcon: const Icon(Icons.mail, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 15),

                  //----Password TextField-----//
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'password_required'.tr();
                      } else if (value.length < 6) {
                        return 'password_min'.tr();
                      }
                      return null;
                    },
                    onChanged: (value) {
                      password = value;
                    },
                    obscureText: _obscureText,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'password'.tr(),
                      labelStyle: const TextStyle(color: Colors.white),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.remove_red_eye_rounded
                              : Icons.visibility_off_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  //-------Login Button-------//
                  SizedBox(
                    width: 150,
                    height: 40,
                    child: MaterialButton(
                      onPressed: () async {
                        try {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const Center(child: CircularProgressIndicator());
                            },
                          );

                          // attempt sign in
                          var userCredential = await auth.signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );

                          // close loading
                          if (mounted && Navigator.of(context, rootNavigator: true).canPop()) {
                            Navigator.of(context).pop();
                          }

                          if (!mounted) return;
                          if (userCredential.user != null) {
                            showGeneralDialog(
                              context: context,
                              barrierDismissible: false,
                              barrierLabel: "LoginSuccessDialog",
                              barrierColor: Colors.black54,
                              transitionDuration: const Duration(milliseconds: 300),
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return Center(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: ScaleTransition(
                                      scale: CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOutBack,
                                      ),
                                      child: AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        title: const Text(
                                          "Account sign-in successfully",
                                          textAlign: TextAlign.center,
                                        ),
                                        actionsAlignment: MainAxisAlignment.center,
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              // set pref and navigate to AuthStateHandler
                                              await _setLoggedInAndNavigate();
                                            },
                                            child: const Text("Close"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              transitionBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            );
                          }
                        } catch (e) {
                          // close loading if open
                          if (mounted && Navigator.of(context, rootNavigator: true).canPop()) {
                            Navigator.of(context).pop();
                          }
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('error'.tr()),
                                content: Text(e.toString()),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('ok'.tr()),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'login_button'.tr(),
                        style: const TextStyle(
                          color: Color(0xFF06202B),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Sign Up Link:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'dont_have_account'.tr(),
                        style: const TextStyle(
                          color: Colors.teal,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.bottomToTop,
                              alignment: Alignment.center,
                              duration: const Duration(milliseconds: 400),
                              child: const SignupScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'sign_up'.tr(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
