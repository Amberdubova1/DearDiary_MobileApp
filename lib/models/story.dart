// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModel {
  String? IDStory;
  String? Title;
  String? Date;
  String? StoryContent;
  Timestamp? createdAt;

  StoryModel(
      {this.IDStory, this.Date, this.StoryContent, this.Title, this.createdAt});

  StoryModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    IDStory = documentSnapshot.id;
    Title = documentSnapshot['Title'] as String;
    Date = documentSnapshot['Date'] as String;
    StoryContent = documentSnapshot['StoryContent'] as String;
    createdAt = documentSnapshot['createdAt'] as Timestamp;
  }
}
