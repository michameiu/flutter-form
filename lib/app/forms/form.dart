import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class MyInput {
  final String label;
  final String fieldName;
  final bool required;
  final TextInputType keyboardType;
  final bool obscureText;

  const MyInput({
    this.fieldName,
    this.label,
    this.required = false,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });
}

class MyCustomForm extends StatefulWidget {
  final HttpMethod httpMethod;
  final int successHttpStatusCode;
  final String url;
  final Function onLoading;
  final Function onSuccess;
  final Function onError;
  final GlobalKey<FormState> formKey;
  final List<MyInput> fields;
  Map<String, dynamic> form_data;

  Map<String, dynamic> form_errors;

  MyCustomForm({
    Key key,
    @required this.httpMethod,
    @required this.successHttpStatusCode,
    @required this.url,
    this.onLoading,
    this.onSuccess,
    this.onError,
    this.fields,
    @required this.formKey,
  }) : super(key: key);

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  Map<String, dynamic> form_data = {};
  Map<String, dynamic> form_errors = {};

  get headers {
    print("getting headers");
    return {"Content-Type": "application/json"};
  }

  void resetFormState() {
    form_errors = {};
    form_data = {};
  }

  void showLoader(status) {
    widget.onLoading(status);
  }

  void showErrors() {
    widget.formKey.currentState.validate();
  }

  void createForm(){

  }


  void makeHttpCall() async {
    resetFormState();
    if (!widget.formKey.currentState.validate()) {
      // Invalid!
      print("Invalid form");
      return;
    }
    widget.formKey.currentState.save();

    showLoader(true);
    http.Response response;
    var body = json.encode(form_data);
    try {
      switch (widget.httpMethod) {
        case HttpMethod.GET:
          // TODO: Handle this case.
          break;
        case HttpMethod.POST:
          response = await http.post(widget.url, body: body, headers: headers);
          break;
        case HttpMethod.PUT:
          // TODO: Handle this case.
          break;
        case HttpMethod.PATCH:
          response = await http.post(widget.url, body: body, headers: headers);
          break;
      }
      //Handle the response
      if (response.statusCode == widget.successHttpStatusCode) {
        widget.onSuccess(response);
      } else if (response.statusCode == 400) {
        var bodyErrors = json.decode(response.body);
        print(response.body);
        bodyErrors.forEach((key, value) {
          if (value.runtimeType == String) {
            form_errors[key] = value;
          } else {
            form_errors[key] = value[0];
          }
        });
        print(form_errors);
        showErrors();
        widget.onError(response);
      } else {
        widget.onError(response);
      }
      showLoader(false);
    } catch (error) {
      showLoader(false);
      print("got this error");
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.formKey,
        child: Column(
          children: [
            ...widget.fields.map((e) => makeInput(
                label: e.label,
                fieldName: e.fieldName,
                required: e.required,
                obscureText: e.obscureText,
                keyboardType: e.keyboardType)),
            MaterialButton(
              minWidth: double.infinity,
              onPressed: makeHttpCall,
              height: 40,
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Text(widget.httpMethod.toText(),
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Gotham',
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
            )
          ],
        ));
  }

  Widget makeInput(
      {label,
      obscureText = false,
      required: false,
      fieldName = null,
      keyboardType = null,
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
              color: Colors.blue),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
            onSaved: (value) {
              if (fieldName != null) {
                form_data[fieldName] = value;
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
              if (form_errors.containsKey(fieldName)) {
                res = form_errors[fieldName];
              }
              return res;
            },
            obscureText: obscureText,
            keyboardType: keyboardType ?? TextInputType.text,
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
