import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/custom_button.dart';
import 'package:flash_chat/components/error_message.dart';
import 'package:flash_chat/components/loading.dart';
import 'package:flash_chat/services/validation.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _obscureText = true;
  bool valid = true;
  String emailAddress;
  String password;

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
                    labelText: 'Enter Your Email',
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
                  color: Colors.blueAccent,
                  text: 'Register',
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        valid = true;
                        _isLoading = true;
                      });
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: emailAddress, password: password);
                        if (newUser != null) {
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
                    }else {
                      setState(() {
                        valid = false;
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'Password must: \n '
                  '- Be at least 8 letters long. \n '
                  '- Contain a capital letter. \n '
                  '- Contain a small letter. \n '
                  '- Contain a number.',
                  style: TextStyle(
                      letterSpacing: 1,
                      fontSize: 12,
                      color: valid ? Colors.grey : (Colors.red)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
