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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Text('Welcome Home!'),
      ),
    );
  }

//  _signOut() async {
//     try {

//       await auth.signOut();
//       onSignedOut();
//     } catch (e) {
//       print(e);
//     }
//   }

  // void _openSettings() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (BuildContext context) {
  //         return Scaffold(
  //           appBar: AppBar(
  //             title: Text('Settings'),
  //           ),
  //           body: Column(
  //             children: [
  //               RaisedButton(onPressed: () {
  //                 _signOut();
  //                 Navigator.pop(context);
  //               })
  //             ],
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
}
