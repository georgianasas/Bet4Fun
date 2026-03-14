import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../api_connection/api_connection.dart';
import '../model/user.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;

  static const Color kCourtGreen = Color(0xFF0B3D2E);
  static const Color kAccentGreen = Color(0xFF1DB954);
  static const Color kMintTop = Color(0xFFD6F5E8);


  validateUserEmail() async {
    try {
      var res = await http.post(
        Uri.parse(API.validateEmail),
        body: {'user_email': emailController.text.trim()},
      );
     // print(res.body);
      if (res.statusCode == 200) {
        var resBodyOfValidateEmail = jsonDecode(res.body);

        if (resBodyOfValidateEmail['emailFound'] == true) {
          Fluttertoast.showToast(
            msg: "Email is already in someone else's use. Try another email.",
          );
        } else {
          registerAndSaveUserRecord();
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  registerAndSaveUserRecord() async {
    User userModel = User(
      1,
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    try {
      var res = await http.post(
        Uri.parse(API.signUp),
        body: userModel.toJson(),
      );
      print(res.body);
      if (res.statusCode == 200) {
        var resBodyOfSignUp = jsonDecode(res.body);
        if (resBodyOfSignUp['success'] == true) {
          Fluttertoast.showToast(
            msg: "Congratulations, you signed up successfully!",
          );
          setState(() {
            nameController.clear();
            emailController.clear();
            passwordController.clear();
          });
        } else {
          Fluttertoast.showToast(msg: "Error Occured, Try Again.");
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

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
                                    "Create account",
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
                                        controller: nameController,
                                        validator: (val) => val == ""
                                            ? "Please write name"
                                            : null,
                                        decoration: _dec(
                                          label: "Username",
                                          hint: "Your name",
                                          icon: Icons.person,
                                        ),
                                      ),
                                      const SizedBox(height: 18),
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
                                          validator: (val) => (val == null || val.isEmpty)
                                              ? "Please write password"
                                              : (val.length < 6)
                                              ? "Password must contain at least 6 characters"
                                              : null,

                                              decoration: _dec(
                                            label: "Password",
                                            hint: "Min. 6 characters",
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
                                                color:
                                                kCourtGreen.withOpacity(0.7),
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
                                              validateUserEmail();
                                            }
                                          },
                                          borderRadius:
                                          BorderRadius.circular(30),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal: 28,
                                            ),
                                            child: Text(
                                              "Create Account",
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
                                    const Text("Already playing Bet4Fun?"),
                                    TextButton(
                                      onPressed: () {
                                        Get.to(LoginScreen());
                                      },
                                      child: const Text(
                                        "Log in",
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


