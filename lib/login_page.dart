import 'package:documentale_flutter/home_page.dart';
import 'package:documentale_flutter/loading_spinner.dart';
import 'package:documentale_flutter/main.dart';
import 'package:documentale_flutter/simple_text_field.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLogged = false;
  String email = '';

  @override
  void initState() {
    super.initState();
  }

  Future<Null> loginUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', emailController.text);

    setState(() {
      email = emailController.text;
    });

    emailController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(11, 81, 187, 1),
            title: const Text('Documentale'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 64),
            child: Center(
              child: Column(
                children: intersperse(
                  const SizedBox(
                    height: 32,
                  ),
                  [
                    SimpleTextField(
                      textEditingController: emailController,
                      validator: (val) {
                        String p =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        //return val.contains(RegExp(p));
                        return val.isNotEmpty;
                      },
                      hintText: "Email",
                      labelText: "Email",
                    ),
                    SimpleTextField(
                      textEditingController: passwordController,
                      validator: (val) => val.isNotEmpty,
                      obscureText: true,
                      hintText: "Password",
                      labelText: "Password",
                    ),
                    ElevatedButton(
                      onPressed: () {
                        loginUser();

                        Navigator.of(context).pushReplacement(_createRoute());
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                        minimumSize:
                            MaterialStateProperty.all(const Size(150, 45)),
                        maximumSize:
                            MaterialStateProperty.all(const Size(400, 50)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )),
                        textStyle: MaterialStateProperty.all(
                          const TextStyle(fontSize: 18),
                        ),
                      ),
                      child: const Text('Login'),
                    )
                  ],
                ).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
