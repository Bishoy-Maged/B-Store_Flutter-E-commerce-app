import 'package:b_store/main.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'login_screen.dart';
import '../welcome_screen.dart';
import '../../Services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final authService = AuthService();
  late String email;
  late String password;
  String? selectedRole;
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final phonenumberController = TextEditingController();
  final addressController = TextEditingController();
  bool _obscureText = true;
  var formKey = GlobalKey<FormState>();

  // Updated: returns bool (true on success, false on failure)
  Future<bool> signUpWithFirebase() async {
    try {
      await authService.signUp(
        firstName: firstnameController.text,
        lastName: lastnameController.text,
        email: emailController.text,
        password: passwordController.text,
        phone: phonenumberController.text,
        address: addressController.text,
        role: selectedRole,
      );

      // Just close the loading dialog and return success
      if (mounted && Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      return true;
    } on FirebaseAuthException catch (e) {
      if (mounted && Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'authentication_failed'.tr())),
      );
      return false;
    } on FirebaseException catch (e) {
      if (mounted && Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'database_error'.tr())),
      );
      return false;
    } on TimeoutException {
      if (mounted && Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('request_timed_out'.tr())),
      );
      return false;
    } catch (e) {
      if (mounted && Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr('unexpected_error', namedArgs: {'error': e.toString()}))),
      );
      return false;
    }
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
              colors: [Color(0xFF06202B), Colors.teal],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //------Back Button & Sign Up Text-------//
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
                                transitionDuration:
                                const Duration(milliseconds: 500),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 65),
                        Text(
                          'sign_up'.tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 1000.ms)
                            .slideY(begin: -0.5, duration: 1000.ms),
                      ],
                    ),
                    const SizedBox(height: 20),

                    //------Image-------//
                    Image.asset(
                      "assets/images/sign-up-concept-illustration.png",
                      width: 280,
                      height: 280,
                    ),

                    const SizedBox(height: 20),

                    //------First Name & Last Name TextField-------//
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: firstnameController,
                            keyboardType: TextInputType.name,
                            style: const TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'first_name_required'.tr();
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'first_name'.tr(),
                              labelStyle: const TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                const BorderSide(color: Colors.white, width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                const BorderSide(color: Colors.white, width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                const BorderSide(color: Colors.red, width: 1.5),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                const BorderSide(color: Colors.red, width: 2),
                              ),
                              prefixIcon: const Icon(Icons.person, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: lastnameController,
                            keyboardType: TextInputType.name,
                            style: const TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'last_name_required'.tr();
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'last_name'.tr(),
                              labelStyle: const TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                const BorderSide(color: Colors.white, width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                const BorderSide(color: Colors.white, width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                const BorderSide(color: Colors.red, width: 1.5),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                const BorderSide(color: Colors.red, width: 2),
                              ),
                              prefixIcon: const Icon(Icons.person_outline,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
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
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                          const BorderSide(color: Colors.white, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                          const BorderSide(color: Colors.white, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                          const BorderSide(color: Colors.red, width: 1.5),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                          const BorderSide(color: Colors.red, width: 2),
                        ),
                        prefixIcon: const Icon(Icons.mail, color: Colors.white),
                      ),
                    ),

                    const SizedBox(height: 20),

                    //------Password TextField-------//
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
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                          const BorderSide(color: Colors.white, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                          const BorderSide(color: Colors.white, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                          const BorderSide(color: Colors.red, width: 1.5),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                          const BorderSide(color: Colors.red, width: 2),
                        ),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
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

                    const SizedBox(height: 20),

                    //------Confirm Password TextField-------//
                    TextFormField(
                      controller: confirmpasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'password_required'.tr();
                        } else if (value.length < 6) {
                          return 'password_min'.tr();
                        } else if (value != passwordController.text) {
                          return 'confirm_password_not_match'.tr();
                        }
                        return null;
                      },
                      obscureText: _obscureText,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'confirm_password'.tr(), // Optional: add a new key for label
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(color: Colors.white, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(color: Colors.white, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(color: Colors.red, width: 1.5),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(color: Colors.red, width: 2),
                        ),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
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

                    const SizedBox(height: 20),

                    //-----Phone Number TextField-------//
                    TextFormField(
                      controller: phonenumberController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'phone_required'.tr();
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'phone_number'.tr(),
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                          const BorderSide(color: Colors.white, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                          const BorderSide(color: Colors.white, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                          const BorderSide(color: Colors.red, width: 1.5),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                          const BorderSide(color: Colors.red, width: 2),
                        ),
                        prefixIcon: const Icon(Icons.phone, color: Colors.white),
                      ),
                    ),

                    const SizedBox(height: 20),

                    //------Address TextField-------//
                    TextFormField(
                      controller: addressController,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'address_required'.tr();
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'address'.tr(),
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                          const BorderSide(color: Colors.white, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                          const BorderSide(color: Colors.white, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                          const BorderSide(color: Colors.red, width: 1.5),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                          const BorderSide(color: Colors.red, width: 2),
                        ),
                        prefixIcon:
                        const Icon(Icons.location_on, color: Colors.white),
                      ),
                    ),

                    const SizedBox(height: 20),

                    //----Dropdown menu for Role----//
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'role_required'.tr();
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'role'.tr(),
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                          const BorderSide(color: Colors.white, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                          const BorderSide(color: Colors.white, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                          const BorderSide(color: Colors.red, width: 1.5),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                          const BorderSide(color: Colors.red, width: 2),
                        ),
                        prefixIcon: const Icon(Icons.hail, color: Colors.white),
                      ),
                      items: ["Admin", "User"].map((role) {
                        // Keep the stored value as "Admin"/"User" (logic unchanged)
                        // but show localized labels for display
                        final displayKey = role == "Admin" ? 'admin' : 'user';
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(
                            displayKey.tr(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedRole = newValue;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    //------Sign Up Button-------//
                    SizedBox(
                      width: 140,
                      height: 40,
                      child: MaterialButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) =>
                              const Center(child: CircularProgressIndicator()),
                            );

                            // Await signup and get success status
                            final success = await signUpWithFirebase();

                            // Show dialog only on success
                            if (!mounted) return;
                            if (success) {
                              showGeneralDialog(
                                context: context,
                                barrierDismissible: false,
                                barrierLabel: "SuccessDialog",
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
                                            "Account created successfully",
                                            textAlign: TextAlign.center,
                                          ),
                                          actionsAlignment: MainAxisAlignment.center,
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pushReplacement(
                                                  PageTransition(
                                                    type: PageTransitionType.fade,
                                                    child: const AuthStateHandler(), // ✅ Navigate ONLY here
                                                    duration: const Duration(milliseconds: 500),
                                                    reverseDuration:
                                                    const Duration(milliseconds: 300),
                                                  ),
                                                );
                                              },
                                              child: const Text("Close"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                transitionBuilder:
                                    (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              );
                            }
                          }
                        },
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'sign_up_button'.tr(),
                          style: const TextStyle(color: Color(0xFF06202B)),
                        ),
                      ),
                    ),

                    //----------Switch to login---------//
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'already_have_account'.tr(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.topToBottom,
                                alignment: Alignment.center,
                                duration: const Duration(milliseconds: 400),
                                child: const LoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'login'.tr(),
                            style: const TextStyle(color: Color(0xFF06202B)),
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
      ),
    );
  }
}
