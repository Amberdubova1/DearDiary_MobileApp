import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deardiary_app/models/story.dart';
import 'package:deardiary_app/pages/writestory.dart';
import 'package:deardiary_app/services/database.dart';
import 'package:deardiary_app/widgets/stories_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StoriesPage extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const StoriesPage({Key? key, required this.auth, required this.firestore})
      : super(key: key);

  @override
  _StoriesPageState createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          const Text(
            "For all the unspoken words",
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
                    .streamStories(uid: widget.auth.currentUser!.uid),
                builder: (BuildContext context,
                    AsyncSnapshot<List<StoryModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text("You don't have any story written!"),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (_, index) {
                        return StoriesCard(
                            story: snapshot.data![index],
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
              builder: (context) => WriteStory(
                auth: widget.auth,
                firestore: widget.firestore,
              ),
            ),
          );
        },
        child: const Icon(Icons.mode_edit_outline_outlined),
        backgroundColor: Colors.teal,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
