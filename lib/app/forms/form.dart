import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:dio/dio.dart';

import '../models/http_exception.dart';

class MyInput {
  final String label;
  final String fieldName;
  final bool required;
  final TextInputType keyboardType;
  final bool obscureText;
  final GlobalKey<FormFieldState> fieldStateKey;

  const MyInput({
    this.fieldName,
    this.label,
    this.fieldStateKey,
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
  String buttonText;
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
    this.buttonText = null,
    @required this.formKey,
  }) : super(key: key);

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

extension HttNoNullBody on Map<String, dynamic> {
  String toHttpNullBody() {
    var params = {};
    this.forEach((key, value) {
      if (value != null && value != "") {
        params[key] = value;
      }
    });
    return json.encode(params);
  }

  MyInput parseMyInput() {
    return MyInput(
      label: "${this["label"]}${this["required"] ? '*' : ''}",
      fieldName: this["key"],
      required: this["required"],
    );
  }

// List<MyInput> parseToMyInputs(){
//   this.map((key, value) => this);
// }
}

class _MyCustomFormState extends State<MyCustomForm> {
  Map<String, dynamic> form_data = {};
  Map<String, dynamic> form_errors = {};
  bool _isLoading = false;
  final List<MyInput> dynamicFields = [];
  final _formFieldKey = GlobalKey<FormFieldState>();
  List<Map<String, GlobalKey<FormFieldState>>> fieldStateKeys = [];

  get headers {
    print("getting headers");
    return {"Content-Type": "application/json"};
  }

  void resetFormState() {
    form_errors = {};
    form_data = {};
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.fields == null) {
      print("no fields found, getting dynamic fields..");
    } else {
      print("no need to get dynamic forms..");
    }
    createForm();
  }

  void showLoader(status) {
    widget.onLoading(status);
    setState(() {
      _isLoading = status;
    });
  }

  void showErrors() {
    widget.formKey.currentState.validate();
  }

  void createForm() async {
    try {
      dynamicFields.clear();
      // var response = await http.;
      // Response response = await Dio().request(widget.url);
      showLoader(true);
      HttpClient client = new HttpClient();
      print("getting fields");
      client
          .openUrl("OPTIONS", Uri.parse(widget.url))
          .then((HttpClientRequest request) {
        request.headers.add("Authorization", "Bearer micha");
        return request.close();
      }).then((HttpClientResponse response) {
        showLoader(false);
        print(response.statusCode);
        response.transform(utf8.decoder).listen((contents) {
          if (response.statusCode != 200) {
            print("GOt ${response.statusCode}");
            print(contents);
            showLoader(false);
            return;
          }
          var data = json.decode(contents) as Map<String, dynamic>;
          widget.buttonText = data["name"];
          print("actions for ${widget.httpMethod.toText()}");
          if (!data.containsKey("actions")) {
            print("No actions found..");
            showLoader(false);
            return;
          }
          var fields = data["actions"][widget.httpMethod.toText()]
              as Map<String, dynamic>;
          if (fields == null) {
            return;
          }
          fields.forEach((key, value) {
            print(value);
            var readOnly = value["read_only"];
            if (!readOnly) {
              var required = value["required"];
              final _formFieldKey = GlobalKey<FormFieldState>();
              // _formFieldKey.currentState.validate();
              fieldStateKeys.add({key: _formFieldKey});
              dynamicFields.add(MyInput(
                label: "${value["label"]}${required ? '*' : ''}",
                fieldName: key,
                fieldStateKey: _formFieldKey,
                required: value["required"],
              ));
            }
          });
          setState(() {});
        });
      });
    } catch (error) {
      showLoader(false);
      print("Error loading options...");
      print(error);
    }
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
    var body = form_data.toHttpNullBody();
    print(body);
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
    return SingleChildScrollView(
      child: Form(
          key: widget.formKey,
          child: Column(
            children: [
              ...dynamicFields.map((e) => makeInput(
                  label: e.label,
                  fieldName: e.fieldName,
                  required: e.required,
                  obscureText: e.obscureText,
                  fieldStateKey: e.fieldStateKey,
                  keyboardType: e.keyboardType)),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : MaterialButton(
                      minWidth: double.infinity,
                      onPressed: makeHttpCall,
                      height: 40,
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                          widget.buttonText ?? widget.httpMethod.toText(),
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Gotham',
                              fontSize: 14,
                              fontWeight: FontWeight.w400)),
                    )
            ],
          )),
    );
  }

  Widget makeInput(
      {label,
      obscureText = false,
      required: false,
      fieldName = null,
      keyboardType = null,
      validator: null,
      fieldStateKey = null}) {
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
            key: fieldStateKey,
            onChanged: (value) {
              setState(() {
                fieldStateKey.currentState.validate();
              });
            },
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
