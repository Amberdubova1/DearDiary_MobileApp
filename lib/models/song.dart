// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class SongModel {
  String? IDSong;
  String? Song;
  String? Singer;
  String? Moment;

  SongModel({this.IDSong, this.Song, this.Singer, this.Moment});

  SongModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    IDSong = documentSnapshot.id;
    Song = documentSnapshot['Song'] as String;
    Singer = documentSnapshot['Singer'] as String;
    Moment = documentSnapshot['Moment'] as String;
  }
}
