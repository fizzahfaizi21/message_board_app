import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<Map<String, dynamic>> boards = [
    {'name': 'General Chat', 'icon': Icons.forum},
    {'name': 'Tech Talk', 'icon': Icons.computer},
    {'name': 'Random', 'icon': Icons.coffee},
  ];

  Future<void> ensureBoardsExist() async {
    final batch = _firestore.batch();
    for (var board in boards) {
      final docRef = _firestore.collection('boards').doc(board['name']);
      final doc = await docRef.get();
      if (!doc.exists) {
        batch.set(docRef, {'createdAt': FieldValue.serverTimestamp()});
      }
    }
    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    ensureBoardsExist(); // Create boards on first load (safe for dev)

    return Scaffold(
      appBar: AppBar(title: Text('Message Boards')),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text('Menu')),
            ListTile(
              title: Text('Message Boards'),
              onTap: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: boards.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(boards[index]['icon']),
            title: Text(boards[index]['name']),
            onTap: () => Navigator.pushNamed(
              context,
              '/chat',
              arguments: boards[index]['name'],
            ),
          );
        },
      ),
    );
  }
}
