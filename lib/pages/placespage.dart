import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deardiary_app/models/place.dart';
import 'package:deardiary_app/services/database.dart';
import 'package:deardiary_app/widgets/places_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PlacesPage extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const PlacesPage({Key? key, required this.auth, required this.firestore})
      : super(key: key);

  @override
  _PlacesPageState createState() => _PlacesPageState();
}

class _PlacesPageState extends State<PlacesPage> {
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Where do you want to go?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          Card(
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      cursorColor: Colors.teal,
                      style: const TextStyle(fontSize: 18),
                      key: const ValueKey("addCountry"),
                      controller: _countryController,
                      decoration: const InputDecoration(
                        hintText: "Country",
                        hintStyle: TextStyle(fontSize: 16),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.teal, width: 2.0),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      cursorColor: Colors.teal,
                      style: const TextStyle(fontSize: 18),
                      key: const ValueKey("addCity"),
                      controller: _cityController,
                      decoration: const InputDecoration(
                        hintText: "City",
                        hintStyle: TextStyle(fontSize: 16),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.teal, width: 2.0),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    key: const ValueKey("addButton"),
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (_cityController.text != "" ||
                          _countryController.text != "") {
                        setState(() {
                          Database(firestore: widget.firestore).addPlacesVisit(
                              uid: widget.auth.currentUser!.uid,
                              Country: _countryController.text,
                              City: _cityController.text);
                          _cityController.clear();
                          _countryController.clear();
                        });
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) => const AlertDialog(
                                  content: Text("Please fill all the fields."),
                                ));
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Places to visit",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: StreamBuilder(
              stream: Database(firestore: widget.firestore)
                  .streamPlaces(uid: widget.auth.currentUser!.uid),
              builder: (BuildContext context,
                  AsyncSnapshot<List<PlaceModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("You didn't add any places to visit :("),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (_, index) {
                      return PlacesCard(
                          place: snapshot.data![index],
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
        ],
      ),
    );
  }
}
