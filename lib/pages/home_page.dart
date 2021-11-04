import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sign_auth/pages/login_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleSignIn googleSignIn = GoogleSignIn();

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Signed In"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "You Signed In Successfully",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
            MaterialButton(
              color: Colors.redAccent,
              elevation: 10,
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                // await googleSignIn.disconnect();

                auth.signOut().whenComplete(() {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }).catchError((e) {
                  print(e);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
