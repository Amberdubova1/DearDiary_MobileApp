// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deardiary_app/models/place.dart';
import 'package:deardiary_app/models/song.dart';
import 'package:deardiary_app/models/story.dart';

class Database {
  final FirebaseFirestore firestore;

  Database({required this.firestore});

//STORIES
  Stream<List<StoryModel>> streamStories({required String uid}) {
    try {
      return firestore
          .collection("Stories")
          .doc(uid)
          .collection("stories")
          .orderBy("createdAt", descending: true)
          .snapshots()
          .map((query) {
        List<StoryModel> retVal = <StoryModel>[];
        for (final DocumentSnapshot doc in query.docs) {
          retVal.add(StoryModel.fromDocumentSnapshot(documentSnapshot: doc));
        }
        return retVal;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addStory(
      {required String uid,
      required String Content,
      required String Title,
      required String Date,
      required Timestamp createdAt}) async {
    try {
      firestore.collection("Stories").doc(uid).collection("stories").add({
        "Title": Title,
        "StoryContent": Content,
        "Date": Date,
        "createdAt": createdAt
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteStory({
    required String IDStory,
    required String uid,
  }) async {
    try {
      firestore
          .collection("Stories")
          .doc(uid)
          .collection("stories")
          .doc(IDStory)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

//PLACES
  Stream<List<PlaceModel>> streamPlaces({required String uid}) {
    try {
      return firestore
          .collection("Places")
          .doc(uid)
          .collection("places")
          .snapshots()
          .map((query) {
        List<PlaceModel> retVal = <PlaceModel>[];
        for (final DocumentSnapshot doc in query.docs) {
          retVal.add(PlaceModel.fromDocumentSnapshot(documentSnapshot: doc));
        }
        return retVal;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addPlacesVisit({
    required String uid,
    required String Country,
    required String City,
  }) async {
    try {
      firestore
          .collection("Places")
          .doc(uid)
          .collection("places")
          .add({"Country": Country, "City": City, "isVisited": false});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePlacesVisit({
    required String IDPlace,
    required String uid,
  }) async {
    try {
      firestore
          .collection("Places")
          .doc(uid)
          .collection("places")
          .doc(IDPlace)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePlacesToVisit(
      {required String uid, required String IDPlace}) async {
    try {
      bool isVisited;
      DocumentSnapshot document = await firestore
          .collection('Places')
          .doc(uid)
          .collection("places")
          .doc(IDPlace)
          .get();
      isVisited = document['isVisited'];
      if (isVisited == true) {
        firestore
            .collection("Places")
            .doc(uid)
            .collection("places")
            .doc(IDPlace)
            .update({"isVisited": false});
      } else {
        firestore
            .collection("Places")
            .doc(uid)
            .collection("places")
            .doc(IDPlace)
            .update({"isVisited": true});
      }
    } catch (e) {
      rethrow;
    }
  }

//SONGS

  Stream<List<SongModel>> streamSongs({required String uid}) {
    try {
      return firestore
          .collection("Songs")
          .doc(uid)
          .collection("songs")
          .snapshots()
          .map((query) {
        List<SongModel> retVal = <SongModel>[];
        for (final DocumentSnapshot doc in query.docs) {
          retVal.add(SongModel.fromDocumentSnapshot(documentSnapshot: doc));
        }
        return retVal;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addSong(
      {required String uid,
      required String Singer,
      required String Song,
      required String Moment}) async {
    try {
      firestore.collection("Songs").doc(uid).collection("songs").add({
        "Singer": Singer,
        "Song": Song,
        "Moment": Moment,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteSong({
    required String IDSong,
    required String uid,
  }) async {
    try {
      firestore
          .collection("Songs")
          .doc(uid)
          .collection("songs")
          .doc(IDSong)
          .delete();
    } catch (e) {
      rethrow;
    }
  }
}
