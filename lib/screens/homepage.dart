import 'package:flutter/material.dart';
import 'package:testproject/services/auth.dart';

class HomePage extends StatelessWidget {
  HomePage(
      {Key? key,
      required this.auth,
      required this.userId,
      required this.onSingedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSingedOut;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Home'),
      ),
      body: Center(
        child: Text('Welcome Home!'),
      ),
    );
  }
}
