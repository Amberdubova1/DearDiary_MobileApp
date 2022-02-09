import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deardiary_app/models/song.dart';
import 'package:deardiary_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SongsCard extends StatefulWidget {
  final SongModel song;
  final FirebaseFirestore firestore;
  final String uid;

  const SongsCard(
      {Key? key,
      required this.song,
      required this.firestore,
      required this.uid})
      : super(key: key);

  @override
  _SongsCardState createState() => _SongsCardState();
}

class _SongsCardState extends State<SongsCard> {
  @override
  Widget build(BuildContext context) {
    Widget continueButton = MaterialButton(
      child: const Center(child: Text("Back")),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        // Remove the item from the data source.
        setState(() {
          Database(firestore: widget.firestore).deleteSong(
              uid: widget.uid, IDSong: widget.song.IDSong as String);
        });
      },
      background: Container(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
        color: Colors.red,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      contentPadding:
                          const EdgeInsets.only(left: 25, right: 25),
                      title: Center(
                          child: Text(widget.song.Singer.toString() +
                              " — " +
                              widget.song.Song.toString())),
                      titleTextStyle:
                          const TextStyle(color: Colors.teal, fontSize: 18),
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      content: SizedBox(
                        height: 200,
                        width: 400,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                widget.song.Moment.toString(),
                                style: GoogleFonts.fuzzyBubbles(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [continueButton],
                    ));
          },
          child: Row(
            children: [
              const SizedBox(
                height: 34,
              ),
              Expanded(
                child: Text(
                  (widget.song.Song as String),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
              ),
              Text(
                (widget.song.Singer as String) + "\t\t->",
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
