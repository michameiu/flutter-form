import 'package:flutter/material.dart';
import 'package:flutter_concepts/app/forms/form.dart';
import 'package:flutter_concepts/app/models/http_exception.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = "/dashboard";
  GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: MyCustomForm(
            httpMethod: HttpMethod.POST,
            formKey: _form,
            successHttpStatusCode: 201,
            buttonText: "Sign Up",
            fields: [
              MyInput(
                fieldName: "first_name",
                label: "First Name",
              ),
              MyInput(
                  fieldName: "email",
                  label: "Email",
                  keyboardType: TextInputType.emailAddress),
              MyInput(
                fieldName: "password",
                label: "Password",
                obscureText: true,
              ),
              MyInput(
                  fieldName: "e_date",
                  label: "Enrollment Date",
                  keyboardType: TextInputType.datetime),
            ],
            url: "https://bwsapi.sisitech.dev/api/v1/timps/",
            onLoading: (value) {
              print("On loading $value");
            },
            onError: (res) {
              print("daam Error occured");
              print(res.statusCode);
              print(res.body);
            },
            onSuccess: (res) {
              print("Success");
              print(res.body);
            },
          ),
        ),
      ),
    );
  }
}
