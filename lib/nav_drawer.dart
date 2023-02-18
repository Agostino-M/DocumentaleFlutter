import 'package:documentale_flutter/folder_list_page.dart';
import 'package:documentale_flutter/home_page.dart';
import 'package:documentale_flutter/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  Future<Null> logout() async {
    //TODO spostare in nav_drawer
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', '');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(
            height: 120.0,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Color.fromRGBO(11, 81, 187, 1)),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.create_new_folder),
            title: const Text('Nuovo fascicolo'),
            onTap: () => {
              Navigator.of(context).pop(),
              Navigator.of(context)
                  .pushReplacement(_createRoute(const HomePage()))
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text('Calendario'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.folder_copy),
            title: const Text('Lista fascicoli'),
            onTap: () => {
              Navigator.of(context).pop(),
              Navigator.of(context)
                  .pushReplacement(_createRoute(const FolderListPage()))
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Il tuo profilo'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text('Il tuo gruppo'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Esci'),
            onTap: () => {
              logout(),
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Uscita effettuata con successo.'))),
              Navigator.of(context)
                  .pushReplacement(_createRoute(const LoginPage()))
            },
          ),
        ],
      ),
    );
  }
}

Route _createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
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
