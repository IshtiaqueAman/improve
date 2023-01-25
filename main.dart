import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Improve());
}

//Checks wether user is loged in or not, if not login page is shown if yes home page is shown
class Improve extends StatelessWidget {
  const Improve({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        home: SafeArea(
          child: Scaffold(
            body: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      children: const [
                        Text("Something went wrong"),
                        Text("Check your internet connection")
                      ],
                    ),
                  );
                } else if (snapshot.hasData) {
                  return Home();
                } else {
                  return const Authenticate();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

//Sign in page
class Authenticate extends StatelessWidget {
  const Authenticate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text("Sign in"),
          onPressed: () {
            final provider =
                Provider.of<GoogleSignInProvider>(context, listen: false);
            provider.googleLogIn();
            provider.addUserToFirestore();
          },
        ),
      ),
    );
  }
}

//Sign in operation handling class class
class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogIn() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      await addUserToFirestore();
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future addUserToFirestore() async {
    if (_user == null) return;
    final user = FirebaseAuth.instance.currentUser!;
    final _userID = user.uid;

    // Check if the user already exists in the collection
    final snapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: _user!.email)
        .get();
    if (snapshot.docs.isEmpty) {
      // Add the user to the collection if they do not exist
      await FirebaseFirestore.instance.collection('user').doc(_userID).set({
        'name': _user!.displayName,
        'email': _user!.email,
      });
      await FirebaseFirestore.instance
          .collection('user/$_userID/improve')
          .doc('1')
          .set({
        'Bad': {},
        'BadTotal': 0,
        'DateBad': {DateTime.now().toIso8601String().split("T")[0]: 0},
        'GoodTotal': 0,
        'DateGood': {DateTime.now().toIso8601String().split("T")[0]: 0},
        'Good': {}
      });
    }
    notifyListeners();
  }

  Future logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
