import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  TextEditingController? firstNameController;
  TextEditingController? lastNameController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final uid = _auth.currentUser!.uid;
    final doc = await _firestore.collection('users').doc(uid).get();
    firstNameController = TextEditingController(text: doc['firstName']);
    lastNameController = TextEditingController(text: doc['lastName']);
    setState(() => isLoading = false);
  }

  Future<void> updateProfile() async {
    final uid = _auth.currentUser!.uid;
    await _firestore.collection('users').doc(uid).update({
      'firstName': firstNameController!.text.trim(),
      'lastName': lastNameController!.text.trim(),
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Profile updated.')));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading)
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: 'First Name')),
            TextField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: 'Last Name')),
            SizedBox(height: 16),
            ElevatedButton(
                onPressed: updateProfile, child: Text('Update Profile')),
          ],
        ),
      ),
    );
  }
}
