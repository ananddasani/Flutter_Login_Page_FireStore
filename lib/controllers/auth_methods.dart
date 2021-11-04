import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_sign_auth/pages/home_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
GoogleSignIn googleSignIn = GoogleSignIn();

String? gName;
String? gEmail;
String? gImageUrl;

String errorMessage = "";
bool allSet = false;

//-----------------------signIn Method onPressed Login Button with email and password------------------
void singInOnPress(
    {required BuildContext context,
    required String email,
    required String password}) async {
  // String errorMessage = "";
  bool allSet = false;

  try {
    await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .whenComplete(() {
      allSet = true;
    });
  } on FirebaseAuthException catch (e) {
    allSet = false;

    customErrorDialog(context, e);
  }

  //move to home page is credentials are all ok
  if (allSet)
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
}

//----------------- Register New User Method onPressed Register Button----------------------------
void registerOnPress(
    {required BuildContext context,
    required String email,
    required String password}) async {
  bool allSet = false;
  // String errorMessage = "";

  try {
    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .whenComplete(() {
      allSet = true;
    });
  } on FirebaseAuthException catch (e) {
    allSet = false;

    customErrorDialog(context, e);
  }

  //add the user to DB
  if (allSet)
    firestore.collection('users').add({'email': email, 'password': password});

  //move to home page is credentials are all ok
  if (allSet)
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
}

//-----------------------signInWithGoogle Method onPressed Google Sign Button--------------------------------------

void signInWithGoogleOnPress({required BuildContext context}) async {
  final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn().catchError((onError) {
    print("Error $onError");
  });

  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication.catchError((onError) {
    print("Error $onError");
  });

  final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken);

  final UserCredential authCredential =
      await auth.signInWithCredential(credential).catchError((onError) {
    print("Error $onError");
  });

  final User? user = authCredential.user;

  assert(user!.email != null);
  assert(user!.displayName != null);
  assert(user!.photoURL != null);

  gName = user!.displayName;
  gEmail = user.email;
  gImageUrl = user.photoURL;

  final User? currentUser = auth.currentUser;
  assert(currentUser!.uid == currentUser.uid);

  await firestore
      .collection('gusers')
      .add({'email': gEmail, 'name': gName, 'image': gImageUrl});

  await Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => HomePage()));
}

//show Dialog according to erro
void customErrorDialog(BuildContext context, FirebaseAuthException e) {
  //check the exception
  switch (e.code) {
    //SignIn With Email & Password
    case "invalid-email":
      errorMessage = "Your email address appears to be malformed.";
      break;
    case "wrong-password":
      errorMessage = "Your password is wrong.";
      break;
    case "user-not-found":
      errorMessage = "Please Click New User & Register Yourself";
      break;
    case "user-disabled":
      errorMessage = "User with this email has been disabled.";
      break;

    //Register With Email & Password
    case "email-already-in-use":
      errorMessage = "This Email is already Registered.";
      break;
    case "weak-password":
      errorMessage =
          "Try Including Upper case, Lower case, Number, Special Character";
      break;

    //google Sign IN
    case "user-not-found":
      errorMessage = "User With this Credential not found";
      break;
    case "operation-not-allowed":
      errorMessage =
          "!!Developers!!\nEnable email/password accounts in the Firebase Console, under the Auth tab.";
      break;

    default:
      errorMessage = "An undefined Error happened.";
  }

  //show the dialog box for perticular error
  showDialog(
    context: context,
    builder: (context) {
      allSet = false;
      return AlertDialog(
        title: Text(e.code),
        content: Text(errorMessage),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
