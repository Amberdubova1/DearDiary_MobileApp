import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deardiary_app/pages/StoriesPage.dart';
import 'package:deardiary_app/pages/placespage.dart';
import 'package:deardiary_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'SongsPage.dart';

class HomePage extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const HomePage({Key? key, required this.auth, required this.firestore})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> pageList = <Widget>[];

  @override
  void initState() {
    pageList.add(StoriesPage(
      auth: widget.auth,
      firestore: widget.firestore,
    ));
    pageList.add(SongsPage(
      auth: widget.auth,
      firestore: widget.firestore,
    ));
    pageList.add(PlacesPage(
      auth: widget.auth,
      firestore: widget.firestore,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Signed in: ${FirebaseAuth.instance.currentUser!.email}.',
          style: const TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
              onPressed: () {
                Auth(auth: widget.auth).signOut();
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pageList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Stories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.audiotrack),
            label: 'Songs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.place),
            label: 'Places',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal.shade700,
        unselectedItemColor: Colors.grey.shade600,
        onTap: _onItemTapped,
      ),
    );
  }
}
