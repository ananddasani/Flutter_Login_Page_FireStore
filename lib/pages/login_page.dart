import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_sign_auth/controllers/auth_methods.dart';

import 'package:flutter_sign_auth/pages/sign_up_page.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "";
  String password = "";
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //---------------------------------------
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  //---------------------------------------

  bool allSet = false;
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
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
                  "Login Here",
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
                          setState(() {
                            email = val;
                          });
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
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      MaterialButton(
                        color: Colors.lightGreen,
                        elevation: 10,
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => singInOnPress(
                            context: context, email: email, password: password),
                      ),
                      SizedBox(height: 20),
                      // MaterialButton(
                      //   elevation: 10,
                      //   child: Image(
                      //     image: NetworkImage(
                      //         "https://onymos.com/wp-content/uploads/2020/10/google-signin-button-1024x260.png"),
                      //   ),
                      //   onPressed: () =>
                      //       signInWithGoogleOnPress(context: context),
                      // ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage()));
                        },
                        child: Text(
                          "New User ?",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Times New Roman",
                          ),
                        ),
                      )
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
