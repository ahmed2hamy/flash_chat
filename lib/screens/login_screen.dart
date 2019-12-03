import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/custom_button.dart';
import 'package:flash_chat/components/error_message.dart';
import 'package:flash_chat/components/loading.dart';
import 'package:flash_chat/services/validation.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _obscureText = true;
  String emailAddress;
  String password;

  void loginCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatScreen()));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    loginCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Loading(
      isLoading: _isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    return Validation().validateEmail(value);
                  },
                  onChanged: (value) {
                    emailAddress = value;
                  },
                  decoration: kTextInputDecoration.copyWith(
                    labelText: 'Enter Your E-mail',
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  obscureText: _obscureText,
                  validator: (value) {
                    return Validation().validatePassword(value);
                  },
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextInputDecoration.copyWith(
                    labelText: 'Enter Your Password',
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                CustomButton(
                  color: Colors.lightBlueAccent,
                  text: 'Log In',
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: emailAddress, password: password);
                        if (user != null) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen()));
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      } catch (e) {
                        print(e);
                        setState(() {
                          _isLoading = false;
                          ErrorDialog()
                              .errorMessage(context: context, e: e.message);
                        });
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
