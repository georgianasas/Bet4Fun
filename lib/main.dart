
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'users/authentication/login_screen.dart';
import 'users/userPreferences/user_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bet4Fun',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      home: FutureBuilder(
        future: RememberUserPrefs.readUserInfo(),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.data == null) {
            return LoginScreen();
          } else {

            return LoginScreen();
            //return DashboardOfFragments();
          }
        },
      ),
    );
  }
}
