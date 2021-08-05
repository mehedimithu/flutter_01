import 'package:flutter/material.dart';

class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({Key? key}) : super(key: key);

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
      if (_formMode == FormMode.LOGIN) {
        //Log the user in
        print("Logged in user");
      } else {
        //create a new user
        print("Signup new user");
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
}
