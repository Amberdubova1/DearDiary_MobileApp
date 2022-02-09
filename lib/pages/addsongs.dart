import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deardiary_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AddSong extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const AddSong({Key? key, required this.auth, required this.firestore})
      : super(key: key);

  @override
  _AddSongState createState() => _AddSongState();
}

class _AddSongState extends State<AddSong> {
  final TextEditingController _momentController = TextEditingController();
  final TextEditingController _singerController = TextEditingController();
  final TextEditingController _songController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, colors: [
            Colors.white,
            Colors.teal.shade50,
            Colors.teal.shade100,
          ]),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 60,
                ),
                Column(
                  children: [
                    const Text(
                      "Remember with melodies!",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _singerController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(20),
                            ],
                            cursorColor: Colors.teal,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                              hintText: "Singer",
                            ),
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _songController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(20),
                            ],
                            cursorColor: Colors.teal,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                              hintText: "Song",
                            ),
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _momentController,
                  cursorColor: Colors.teal,
                  style: GoogleFonts.fuzzyBubbles(
                      fontSize: 22, color: Colors.grey.shade600),
                  decoration: InputDecoration(
                      labelText: 'Write your moment',
                      labelStyle:
                          GoogleFonts.raleway(fontSize: 20, color: Colors.teal),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.teal),
                        borderRadius: BorderRadius.circular(15),
                      )),
                  scrollPadding: const EdgeInsets.all(20.0),
                  keyboardType: TextInputType.multiline,
                  maxLines: 100,
                  autofocus: true,
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn2",
        onPressed: () async {
          if (_songController.text != "" && _momentController.text != "") {
            setState(() {
              Database(firestore: widget.firestore).addSong(
                  uid: widget.auth.currentUser!.uid,
                  Song: _songController.text,
                  Singer: _singerController.text,
                  Moment: _momentController.text);
              Navigator.pop(context);
            });
          } else {
            showDialog(
                context: context,
                builder: (context) => const AlertDialog(
                      content: Text("Please fill all the fields."),
                    ));
          }
        },
        child: const Icon(Icons.playlist_add),
        backgroundColor: Colors.teal,
      ), // This tr
      resizeToAvoidBottomInset: true,
    );
  }
}
