import 'dart:io';
import 'package:documentale_flutter/home_page.dart';
import 'package:documentale_flutter/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const Documentale());
}

MaterialColor mycolor = const MaterialColor(
  0x0B51BB,
  <int, Color>{
    50: Color.fromRGBO(11, 81, 187, 0.1),
    100: Color.fromRGBO(11, 81, 187, 0.2),
    200: Color.fromRGBO(11, 81, 187, 0.3),
    300: Color.fromRGBO(11, 81, 187, 0.4),
    400: Color.fromRGBO(11, 81, 187, 0.5),
    500: Color.fromRGBO(11, 81, 187, 0.6),
    600: Color.fromRGBO(11, 81, 187, 0.7),
    700: Color.fromRGBO(11, 81, 187, 0.8),
    800: Color.fromRGBO(11, 81, 187, 0.9),
    900: Color.fromRGBO(11, 81, 187, 1),
  },
);

Future<String> checkLogin() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String email = prefs.getString('email') ?? '';
  return email;
}

class Documentale extends StatelessWidget {
  const Documentale({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData(primarySwatch: mycolor),
        home: FutureBuilder(
          future: checkLogin(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text('Error');
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                print("Hello ${snapshot.data}");
                return const HomePage();
              } else {
                return const LoginPage();
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          },
        ));
  }
}
