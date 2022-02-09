// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceModel {
  String? IDPlace;
  String? Country;
  String? City;
  bool? isVisited;

  PlaceModel({this.IDPlace, this.Country, this.City, this.isVisited});

  PlaceModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    IDPlace = documentSnapshot.id;
    Country = documentSnapshot['Country'] as String;
    City = documentSnapshot['City'] as String;
    isVisited = documentSnapshot['isVisited'] as bool;
  }
}
