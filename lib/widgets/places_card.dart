import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deardiary_app/models/place.dart';
import 'package:deardiary_app/services/database.dart';
import 'package:flutter/material.dart';

class PlacesCard extends StatefulWidget {
  final PlaceModel place;
  final FirebaseFirestore firestore;
  final String uid;

  const PlacesCard(
      {Key? key,
      required this.place,
      required this.firestore,
      required this.uid})
      : super(key: key);

  @override
  _PlacesCardState createState() => _PlacesCardState();
}

class _PlacesCardState extends State<PlacesCard> {
  @override
  Widget build(BuildContext context) {
    Widget cancelButton = MaterialButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = MaterialButton(
      child: const Text("Delete"),
      onPressed: () {
        Database(firestore: widget.firestore).deletePlacesVisit(
          uid: widget.uid,
          IDPlace: widget.place.IDPlace as String,
        );
        Navigator.of(context).pop();
      },
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Text("Are you sure you want to delete: " +
                    (widget.place.City)! +
                    " | " +
                    (widget.place.Country)! +
                    "?"),
                actions: [
                  cancelButton,
                  continueButton,
                ],
              ),
            );
          },
          child: Row(
            children: [
              Expanded(
                child: Text(
                  (widget.place.City as String) +
                      ' | ' +
                      (widget.place.Country as String),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Checkbox(
                activeColor: Colors.teal,
                value: widget.place.isVisited,
                onChanged: (newValue) {
                  setState(() {});
                  Database(firestore: widget.firestore).updatePlacesToVisit(
                    uid: widget.uid,
                    IDPlace: widget.place.IDPlace as String,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
