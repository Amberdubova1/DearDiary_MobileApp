import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deardiary_app/models/song.dart';
import 'package:deardiary_app/services/database.dart';
import 'package:deardiary_app/widgets/songs_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'addsongs.dart';

class SongsPage extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const SongsPage({Key? key, required this.auth, required this.firestore})
      : super(key: key);

  @override
  _SongsPageState createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Songs of remembrance",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Card(
              margin: const EdgeInsets.only(top: 30),
              child: StreamBuilder(
                stream: Database(firestore: widget.firestore)
                    .streamSongs(uid: widget.auth.currentUser!.uid),
                builder: (BuildContext context,
                    AsyncSnapshot<List<SongModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text("You don't have any songs of remembrance!"),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (_, index) {
                        return SongsCard(
                            song: snapshot.data![index],
                            firestore: widget.firestore,
                            uid: widget.auth.currentUser!.uid);
                      },
                    );
                  } else {
                    return const Center(
                      child: Text("loading..."),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn1",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSong(
                auth: widget.auth,
                firestore: widget.firestore,
              ),
            ),
          );
        },
        child: const Icon(Icons.audiotrack_outlined),
        backgroundColor: Colors.teal,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
