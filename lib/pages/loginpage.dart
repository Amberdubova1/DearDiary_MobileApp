import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deardiary_app/Pages/registerpage.dart';
import 'package:deardiary_app/pages/forgotpassword.dart';
import 'package:deardiary_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const LoginPage({
    Key? key,
    required this.auth,
    required this.firestore,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 32),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      "Welcome to your personal diary!",
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
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 60),
                      child: Theme(
                        child: TextFormField(
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(fontSize: 18),
                            border: InputBorder.none,
                            icon: Icon(Icons.account_circle_rounded),
                            hintText: "Password",
                          ),
                          controller: _passwordController,
                          style: const TextStyle(fontSize: 18),
                        ),
                        data: Theme.of(context).copyWith(
                          colorScheme: ThemeData().colorScheme.copyWith(
                                primary: Colors.teal.shade500,
                              ),
                        ),
                      )),
                  const SizedBox(
                    height: 40,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 120),
                    onPressed: () async {
                      final String retVal =
                          await Auth(auth: widget.auth).signIn(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                      if (retVal == "Success") {
                        _emailController.clear();
                        _passwordController.clear();
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: Text(retVal),
                                ));
                      }
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.teal,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.grey),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.only(left: 60),
                            splashFactory: NoSplash.splashFactory,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPassword(
                                          auth: widget.auth,
                                          firestore: widget.firestore,
                                        )));
                          },
                        ),
                        TextButton(
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.grey),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.only(right: 60),
                            splashFactory: NoSplash.splashFactory,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage(
                                        auth: widget.auth,
                                        firestore: widget.firestore,
                                      )),
                            );
                          },
                        ),
                      ]),
                ]);
              }),
            )))
          ]),
        ),
      ),
    );
  }
}
