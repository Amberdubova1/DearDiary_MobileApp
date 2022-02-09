import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deardiary_app/pages/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const ForgotPassword({
    Key? key,
    required this.auth,
    required this.firestore,
  }) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
              Colors.teal.shade700,
              Colors.teal.shade300,
              Colors.teal.shade400
            ]),
          ),
          child: Column(children: <Widget>[
            const SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.all(60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Center(
                    child: Text(
                      "Reset password!",
                      style: TextStyle(color: Colors.white, fontSize: 32),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      "Go to your email to reset your password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: Form(
                    child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80),
                    topRight: Radius.circular(80),
                  )),
              child: Builder(builder: (BuildContext context) {
                return Column(children: <Widget>[
                  const SizedBox(
                    height: 80,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 60),
                    child: Theme(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(fontSize: 18),
                          border: InputBorder.none,
                          icon: Icon(Icons.account_circle_rounded),
                          hintText: "Email",
                        ),
                        controller: _emailController,
                        style: const TextStyle(fontSize: 18),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      data: Theme.of(context).copyWith(
                        colorScheme: ThemeData().colorScheme.copyWith(
                              primary: Colors.teal.shade500,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 120),
                    onPressed: () async {
                      try {
                        if (_emailController.text != "null") {
                          await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: _emailController.text.trim());
                          showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                    content: Text(
                                        "Password reset link has been sent to your email."),
                                  ));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage(
                                        auth: widget.auth,
                                        firestore: widget.firestore,
                                      )));
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                    content:
                                        Text("Please write your email address"),
                                  ));
                        }
                      } on FirebaseAuthException catch (e) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: Text(e.message!),
                                ));
                      }
                    },
                    child: const Text(
                      "Reset password",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.teal,
                  ),
                  TextButton(
                    child: const Text(
                      "Go to login page",
                      style: TextStyle(
                          fontWeight: FontWeight.w300, color: Colors.grey),
                    ),
                    style: TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginPage(
                                  auth: widget.auth,
                                  firestore: widget.firestore,
                                )),
                      );
                    },
                  ),
                ]);
              }),
            )))
          ]),
        ),
      ),
    );
  }
}
