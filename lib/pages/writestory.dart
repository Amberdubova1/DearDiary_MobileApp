import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deardiary_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class WriteStory extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const WriteStory({Key? key, required this.auth, required this.firestore})
      : super(key: key);

  @override
  _WriteStoryState createState() => _WriteStoryState();
}

class _WriteStoryState extends State<WriteStory> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  late DateTime _dateTime;
  final DateTime _dateToday = DateTime.now();
  late String _datePick = DateFormat("dd/MM/yyyy").format(_dateToday);

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
                    TextFormField(
                      controller: _titleController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(20),
                      ],
                      cursorColor: Colors.teal,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                        border: InputBorder.none,
                        hintText: "Title",
                      ),
                      style: GoogleFonts.fuzzyBubbles(
                        fontSize: 28,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    MaterialButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          _dateTime = (await showDatePicker(
                              context: context,
                              builder: (context, child) => Theme(
                                    data: ThemeData().copyWith(
                                        textTheme: GoogleFonts.ralewayTextTheme(
                                          Theme.of(context).textTheme,
                                        ),
                                        colorScheme: const ColorScheme.light(
                                          primary: Colors.teal,
                                        )),
                                    child: child!,
                                  ),
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2018),
                              lastDate: DateTime(2030)))!;
                          setState(() {
                            _datePick =
                                DateFormat("dd/MM/yyyy").format(_dateTime);
                          });
                        },
                        child: FittedBox(
                          child: Text(_datePick,
                              style: GoogleFonts.raleway(
                                color: Colors.grey.shade700,
                                fontSize: 18,
                              )),
                        )),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _contentController,
                  cursorColor: Colors.teal,
                  style: GoogleFonts.fuzzyBubbles(
                      fontSize: 22, color: Colors.grey.shade600),
                  decoration: InputDecoration(
                      labelText: 'Write your story',
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
          if (_titleController.text != "" && _contentController.text != "") {
            setState(() {
              _dateTime = DateTime.now();
              Timestamp _dateTimestamp = Timestamp.fromDate(_dateTime);
              Database(firestore: widget.firestore).addStory(
                  uid: widget.auth.currentUser!.uid,
                  Content: _contentController.text,
                  Title: _titleController.text,
                  Date: _datePick,
                  createdAt: _dateTimestamp);
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
        child: const Icon(Icons.post_add),
        backgroundColor: Colors.teal,
      ), // This tr
      resizeToAvoidBottomInset: true,
    );
  }
}
