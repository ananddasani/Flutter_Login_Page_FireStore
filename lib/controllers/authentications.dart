import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final googleSignIn = GoogleSignIn();

ggoogleSignIn() async {
  GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

  if (googleSignInAccount != null) {
    //we got google authentication
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    //now we will be auth credential
    AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    //call firebase auth to sign in
    UserCredential result = await auth.signInWithCredential(credential);

    User? user = auth.currentUser;
    print(user!.uid);

    // return Future.value(true);
  }
  // return Future.value(false);
}

signUp(String _email, String _password) async {
  try {
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: _email, password: _password);

    // var user = result.user;
  } catch (e) {
    switch (e.toString()) {
      case 'email-already-in-use':
        print("email-already-in-use");
    }
  }

  // return Future.value(true);
}

signIn(String _email, String _password) async {
  try {
    UserCredential result = await auth.signInWithEmailAndPassword(
        email: _email, password: _password);

    // var user = result.user;
  } catch (e) {
    switch (e.toString()) {
      case 'email-already-in-use':
        print("invalid-email");
    }
  }

  // return Future.value(true);
}

SignOutUser() async {
  User? user = auth.currentUser;

  if (user!.providerData[1].providerId == 'google.com') {
    //next time google will not ask for which account you want to sign in for that use disconnect() instead of signOut()
    // await googleSignIn.signOut();

    await googleSignIn.disconnect();
  }

  //if signed in wiht email and password
  await auth.signOut();

  // return Future.value(true);
}
