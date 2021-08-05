import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testproject/screens/homepage.dart';
import 'package:testproject/services/auth.dart';

class LoginSignupPage extends StatefulWidget {
  LoginSignupPage({required this.auth, required this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  _LoginSignupPageState createState() => _LoginSignupPageState();
}

enum FormMode { LOGIN, SIGNUP }

class _LoginSignupPageState extends State<LoginSignupPage> {
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;

  FormMode _formMode = FormMode.LOGIN;

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmit() async {
    if (_validateAndSave()) {
      String userId = "";
      if (_formMode == FormMode.LOGIN) {
        try {
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email,
            password: _password,
          );
          userId = userCredential.user!.uid;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            _showErrorOrSussDialog('Not found', _email + 'can not found');
            print('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            _showErrorOrSussDialog('Error!', _email + 'is incorrect');
            print('Wrong password provided for that user.');
          }
        } catch (e) {
          _showErrorOrSussDialog('Error!', 'e');
          print(e);
        }
      } else {
        //create a new account
        try {
          UserCredential userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _email,
            password: _password,
          );
          _showErrorOrSussDialog(
              'Success!', 'Please login with corrent username and password');
          userId = userCredential.user!.uid;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            _showErrorOrSussDialog(
                'Weak password', 'Please use strong password');
            print('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            _showErrorOrSussDialog('Error!', 'This email is already used');
            print('The account already exists for that email.');
          }
        } catch (e) {
          _showErrorOrSussDialog('Error!', 'e');
          print(e);
        }
      }
      if (userId.length > 0 && userId != null && _formMode == FormMode.LOGIN) {
        widget.onSignedIn();
      }
    }
  }

  void _changeFromToSignup() {
    _formKey.currentState!.reset();
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _changeFromToLogin() {
    _formKey.currentState!.reset();
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        toolbarHeight: 65,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 02),
        child: Column(
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Image(
                      image: AssetImage('assets/images/img1.jpg'),
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 18),
                    _buildEmailInput(),
                    _buildPasswordInput(),
                    _buildLoginAndSignuButton(),
                    _buildSwitchFromLoginToSignupBtn(),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildEmailInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          hintText: "Email",
          icon: Icon(
            Icons.mail,
            color: Colors.grey,
          ),
        ),
        validator: (value) => value!.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value!.trim(),
      ),
    );
  }

  Widget _buildPasswordInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: Colors.grey,
          ),
        ),
        validator: (value) =>
            value!.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value!.trim(),
      ),
    );
  }

  Widget _buildLoginAndSignuButton() {
    return SizedBox(
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: RaisedButton(
          elevation: 5.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Colors.blue,
          child: _formMode == FormMode.LOGIN
              ? Text(
                  'Login',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                )
              : Text('Create An Account',
                  style: TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: _validateAndSubmit,
        ),
      ),
    );
  }

  Widget _buildSwitchFromLoginToSignupBtn() {
    return FlatButton(
      minWidth: MediaQuery.of(context).size.width,
      onPressed: _formMode == FormMode.LOGIN
          ? _changeFromToSignup
          : _changeFromToLogin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _formMode == FormMode.LOGIN
              ? Text('Don\'t have an account?\t Signup')
              : Text(
                  'Already have an account?\t Login',
                  style: TextStyle(color: Colors.amber),
                ),
        ],
      ),
    );
  }

  void _showErrorOrSussDialog(String messageTitle, String messageText) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(messageTitle),
            content: Text(messageText),
            actions: [
              FlatButton(
                  onPressed: () {
                    if (messageTitle == "Success!") {
                      _changeFromToLogin();
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text("Dismiss"))
            ],
          );
        });
  }
}
