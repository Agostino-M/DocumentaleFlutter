import 'package:documentale_flutter/nav_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text('Page 2'),
      ),
    );
  }
}
