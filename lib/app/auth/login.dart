import 'package:flutter/material.dart';
import 'package:flutter_concepts/app/providers/auth.dart';
import 'package:provider/provider.dart';
import '../theme/constants.dart';
import 'dashboard.dart';
import 'sign_up.dart';
import 'forgot_password.dart';

import 'model.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffold_key = GlobalKey<ScaffoldState>();
  bool _is_loading = false;
  final login_form = LoginForm();

  void _submit() {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    showLoader(true);
    print(login_form);
    final auth = Provider.of<Auth>(context, listen: false);

    auth.signIn(login_form.username, login_form.password).then((response) {
      print(response);
      if (response.statusCode == 200) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(DashboardScreen.routeName, (Route<dynamic> route) => false);
      }
      showLoader(false);
    }).catchError((error) {
      print('Failed/');
      print(error);
      final snackBar = SnackBar(
        content: Text('Confirm your credentials'),
        duration: Duration(seconds: 3),
      );
      _scaffold_key.currentState.showSnackBar(snackBar);
      showLoader(false);
    });
  }

  void showLoader(status) {
    setState(() {
      _is_loading = status;
    });
  }

  void dismissLoader(status) {
    setState(() {
      _is_loading = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold_key,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Sign in",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Nunito Sans',
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700))),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Email Address'),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Invalid username!';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              login_form.username = value;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            // controller: _passwordController,
                            validator: (value) {
                              if (value.isEmpty || value.length < 1) {
                                return 'Password is too short!';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              login_form.password = value;
                            },
                          ),
                        ],
                      ),
                    ),
                    /*  SizedBox(
                      height: 20,
                    ),
                    if (_is_loading)
                      CircularProgressIndicator()
                    else */
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: EdgeInsets.only(top: 22, left: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: _is_loading
                            ? CircularProgressIndicator()
                            : MaterialButton(
                                minWidth: double.infinity,
                                height: 40,
                                onPressed: _submit,
                                color: kPrimaryColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text("SIGN IN",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Gotham',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700)),
                              ),
                      ),
                    ),
                    Container(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordScreen()));
                            },
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: 'FORGOT PASSWORD ',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Gotham',
                                    fontWeight: FontWeight.w700,
                                    color: kPrimaryColor),
                              ),
                            ))),
                  ],
                ),
              ),
            ),
            Container(
                child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupScreen()));
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Create Account',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w700,
                            color: kPrimaryColor),
                      ),
                    ))),
            Container(
              height: MediaQuery.of(context).size.height / 3,
            ),
          ],
        ),
      ),
    );
  }
}
