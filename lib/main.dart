import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deardiary_app/Pages/loginpage.dart';
import 'package:deardiary_app/pages/homepage.dart';
import 'package:deardiary_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: GoogleFonts.ralewayTextTheme(
        Theme.of(context)
            .textTheme, // If this is not set, then ThemeData.light().textTheme is used.
      )),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text("Error"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return const Root();
          }
          return const Scaffold(
            body: Center(
              child: Text("Loading"),
            ),
          );
        },
      ),
    );
  }
}

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth(auth: _auth).user,
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data?.uid == null) {
              return LoginPage(auth: _auth, firestore: _firestore);
            } else {
              return HomePage(auth: _auth, firestore: _firestore);
            }
          } else {
            return const Scaffold(
              body: Center(
                child: Text("Loading.."),
              ),
            );
          }
        });
  }
}
