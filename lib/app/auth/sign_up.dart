import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_concepts/app/providers/auth.dart';
import 'package:provider/provider.dart';
import '../theme/constants.dart';
import 'login.dart';
import 'model.dart';
import 'dashboard.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();

  dynamic newUser = {};
  Map<String, dynamic> erros = {};

  bool isLoading = false;

  void resetFormState() {
    erros = {};
    newUser = {};
  }

  void showLoader(status) {
    setState(() {
      isLoading = status;
    });
  }

  void showErrors() {
    _form.currentState.validate();
  }

  void signUp() async {
    print("Signing up....");
    var auth = Provider.of<Auth>(context, listen: false);
    resetFormState();
    if (!_form.currentState.validate()) {
      // Invalid!
      print("Invalid form");
      return;
    }
    _form.currentState.save();

    //Validate the password_field
    if (newUser["password"] != newUser["confirm_password"]) {
      print(newUser);
      erros["confirm_password"] = "Passwords do not match.";
      showErrors();
      return;
    } else {
      print("password match");
    }
    print(newUser);
    showLoader(true);
    try {
      print("doing the actusa");
      var res = await auth.signUp(newUser);
      if (res.statusCode == 400) {
        // Handle all the requirements or some errors returned
        var bodyErrors = json.decode(res.body);
        print(res.body);
        bodyErrors.forEach((key, value) {
          if (value.runtimeType == String) {
            erros[key] = value;
          } else {
            erros[key] = value[0];
          }
        });
        print(erros);
        showErrors();
      } else if (res.statusCode == 201) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(DashboardScreen.routeName, (Route<dynamic> route) => false);
      }
      showLoader(false);
    } catch (error) {
      showLoader(false);
      print("error signing up");
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height - 70,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Create Profile",
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
              Form(
                key: _form,
                child: Column(
                  children: <Widget>[
                    makeInput(
                        label: "Name", required: true, fieldName: "first_name"),
                    makeInput(label: "Email Address", fieldName: "email"),
                    makeInput(label: "Mobile Number", fieldName: "phone"),
                    makeInput(
                        label: "Password",
                        fieldName: "password",
                        obscureText: true),
                    makeInput(
                        required: true,
                        label: "Confirm Password",
                        fieldName: "confirm_password",
                        obscureText: true)
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.only(right: 20, left: 20),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text:
                          'By continuing, I confirm that I have read & agree to the ',
                      style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w400,
                          color: kTextColor),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Terms & Conditions ',
                            style: TextStyle(
                                fontSize: 11,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.w700,
                                color: kTextColor)),
                        TextSpan(
                            text: 'and ', style: TextStyle(color: kTextColor)),
                        TextSpan(
                            text: 'Privacy Policy ',
                            style: TextStyle(
                                fontSize: 11,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.w700,
                                color: kTextColor)),
                      ],
                    ),
                  )),
              Container(
                padding: EdgeInsets.only(left: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: isLoading
                    ? CircularProgressIndicator()
                    : MaterialButton(
                        minWidth: double.infinity,
                        height: 40,
                        onPressed: signUp,
                        color: kPrimaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text("REGISTER",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Gotham',
                                fontSize: 14,
                                fontWeight: FontWeight.w400)),
                      ),
              ),
              Container(
                  padding: EdgeInsets.only(bottom: 7),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Sign in',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w700,
                              color: kPrimaryColor),
                        ),
                      )))
            ],
          ),
        ),
      ),
    );
  }

  Widget makeInput(
      {label,
      obscureText = false,
      required: false,
      fieldName = null,
      validator: null}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 16,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w400,
              color: kFieldTextColor),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
            onSaved: (value) {
              if (fieldName != null) {
                newUser[fieldName] = value;
              }
            },
            validator: (value) {
              var res = null;
// Check if any custom validators included and if required
              if (validator != null) {
                var cvalidator = validator(value);
                if (cvalidator != null) return cvalidator;
              }

// Check if required or not
              if (required && (value == null || value == '')) {
                res = "This field may not be blank.";
              }

// check if any errors available (From the server)
              if (erros.containsKey(fieldName)) {
                res = erros[fieldName];
              }
              return res;
            },
            obscureText: obscureText,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            )),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
