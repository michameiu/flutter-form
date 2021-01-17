import 'package:flutter/material.dart';

import '../theme/constants.dart';
import 'login.dart';

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 4.0,
            toolbarHeight: 80,
            backgroundColor: Colors.white,
            title: Text('Forgot Password',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Nunito Sans',
                    fontSize: 22,
                    fontWeight: FontWeight.w900)),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            )),
        body: Center(
          child: Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                    child: Column(
                      children: <Widget>[
                        makeInput(label: "Email Address"),
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    height: 40,
                    minWidth: 327,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text("SEND MY PASSWORD",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Gotham',
                            fontSize: 16,
                            fontWeight: FontWeight.w400)),
                    color: kPrimaryColor,
                  )
                ],
              )),
        ));
  }
}

Widget makeInput({label, obscureText = false}) {
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
      TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        ),
      ),
    ],
  );
}
