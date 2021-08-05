import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:testproject/screens/login_signup_page.dart';
import 'package:testproject/screens/wrapper.dart';
import 'package:testproject/services/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration With Firebase',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error!'),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: Center(
                child: Wrapper(
                  auth: Auth(),
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: Text('Loading'),
            ),
          );
        },
      ),
    );
  }
}
