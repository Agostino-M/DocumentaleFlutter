import 'dart:io';
import 'package:documentale_flutter/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const Documentale());
}

String userId = "";
bool isLoggedIn = false;

Future<bool> checkLogin() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? prefUserId = prefs.getString('username');
  final bool? prefIsLoggedIn = prefs.getBool('isUserLogged');

  if (prefUserId != null &&
      prefUserId != '' &&
      prefIsLoggedIn != null &&
      prefIsLoggedIn) {
    userId = prefUserId;
    isLoggedIn = prefIsLoggedIn;
    return true;
  }
  return false;
}

class Documentale extends StatelessWidget {
  const Documentale({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const LoginPage(),
    );
  }
}
