import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<Map<String, dynamic>> boards = [
    {'name': 'General Chat', 'icon': Icons.forum, 'color': Colors.blue},
    {'name': 'Tech Talk', 'icon': Icons.computer, 'color': Colors.green},
    {'name': 'Random', 'icon': Icons.coffee, 'color': Colors.orange},
    {'name': 'Travel Adventures', 'icon': Icons.flight, 'color': Colors.purple},
    {'name': 'Movie Discussions', 'icon': Icons.movie, 'color': Colors.red},
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
      appBar: AppBar(
        title: Text(
          'Message Boards',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 6,
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF673AB7), Color(0xFF9C27B0)],
            ),
          ),
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.transparent),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Color(0xFF673AB7),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Message Board App',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.home, color: Colors.white),
                title: Text(
                  'Message Boards',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => Navigator.pushReplacementNamed(context, '/home'),
              ),
              ListTile(
                leading: Icon(Icons.person, color: Colors.white),
                title: Text('Profile', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pushNamed(context, '/profile'),
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.white),
                title: Text('Settings', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pushNamed(context, '/settings'),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF9CECFB), Color(0xFF65C7F7)],
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 16),
          itemCount: boards.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 6,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                leading: CircleAvatar(
                  backgroundColor: boards[index]['color'],
                  child: Icon(boards[index]['icon'], color: Colors.white),
                ),
                title: Text(
                  boards[index]['name'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF673AB7),
                ),
                onTap:
                    () => Navigator.pushNamed(
                      context,
                      '/chat',
                      arguments: boards[index]['name'],
                    ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Join a chat room to start messaging!')),
          );
        },
        backgroundColor: Color(0xFFFF9800),
        child: Icon(Icons.chat, color: Colors.white),
      ),
    );
  }
}
