import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../api_connection/api_connection.dart';
import '../model/user.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;

  static const Color kCourtGreen = Color(0xFF0B3D2E);
  static const Color kAccentGreen = Color(0xFF1DB954);
  static const Color kMintTop = Color(0xFFD6F5E8);

  InputDecoration _dec({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: kCourtGreen.withOpacity(0.75)),
      suffixIcon: suffixIcon,
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: kCourtGreen.withOpacity(0.65)),
      hintStyle: const TextStyle(color: Colors.black38),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: kAccentGreen, width: 1.4),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      fillColor: Colors.white,
      filled: true,
    );
  }

  loginUser() async {
    try {
      var res = await http.post(
        Uri.parse(API.login),
        body: {
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        },
      );
      print(res.body);
      if (res.statusCode == 200) {
        var resBody = jsonDecode(res.body);

        if (resBody['success'] == true) {
          Fluttertoast.showToast(msg: "Welcome back!");
          emailController.clear();
          passwordController.clear();
        } else {
          Fluttertoast.showToast(msg: "Invalid email or password.");
        }
      } else {
        Fluttertoast.showToast(msg: "Server error. Try again.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [kMintTop, Colors.white],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, cons) {
              return ConstrainedBox(
                constraints: BoxConstraints(minHeight: cons.maxHeight),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 18),
                        child: Center(
                          child: Column(
                            children: const [
                              Icon(
                                Icons.sports_tennis,
                                size: 60,
                                color: kAccentGreen,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Bet4Fun",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                  color: kCourtGreen,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Live WTA • Rankings • Duels",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.94),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(40),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: kCourtGreen.withOpacity(0.12),
                                offset: const Offset(0, 12),
                                blurRadius: 26,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
                            child: Column(
                              children: [
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Log in",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: kCourtGreen,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Form(
                                  key: formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: emailController,
                                        validator: (val) => val == ""
                                            ? "Please write email"
                                            : null,
                                        decoration: _dec(
                                          label: "Email",
                                          hint: "Enter your email",
                                          icon: Icons.email,
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      Obx(
                                        () => TextFormField(
                                          controller: passwordController,
                                          obscureText: isObsecure.value,
                                          validator: (val) => val == ""
                                              ? "Please write password"
                                              : null,
                                          decoration: _dec(
                                            label: "Password",
                                            hint: "Your password",
                                            icon: Icons.vpn_key_sharp,
                                            suffixIcon: GestureDetector(
                                              onTap: () {
                                                isObsecure.value =
                                                    !isObsecure.value;
                                              },
                                              child: Icon(
                                                isObsecure.value
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: kCourtGreen.withOpacity(
                                                  0.7,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      Material(
                                        color: kCourtGreen,
                                        borderRadius: BorderRadius.circular(30),
                                        child: InkWell(
                                          onTap: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              loginUser();
                                            }
                                          },
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal: 28,
                                            ),
                                            child: Text(
                                              "Log in",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("New to Bet4Fun?"),
                                    TextButton(
                                      onPressed: () {
                                        Get.to(SignUpScreen());
                                      },
                                      child: const Text(
                                        "Sign up",
                                        style: TextStyle(
                                          color: kAccentGreen,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
