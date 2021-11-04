import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_sign_auth/controllers/auth_methods.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //to save email and password given by the user
  String email = "";
  String password = "";

  //_formKey for Validation
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up Page"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FlutterLogo(
                size: 50,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Welcome New User\nSign Up Here",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                        validator: MultiValidator([
                          RequiredValidator(errorText: "Email is Required"),
                          EmailValidator(errorText: "Email is not Valid"),
                        ]),
                        onChanged: (val) {
                          email = val;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: MultiValidator([
                          RequiredValidator(errorText: "Password is Required"),
                          MaxLengthValidator(15, errorText: "Max length 15"),
                          MinLengthValidator(6,
                              errorText: "Atleast 6 characters Required")
                        ]),
                        onChanged: (val) {
                          password = val;
                        },
                      ),
                      SizedBox(height: 20),
                      MaterialButton(
                        color: Colors.lightGreen,
                        elevation: 10,
                        child: Text(
                          "Register",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => registerOnPress(
                            context: context, email: email, password: password),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
