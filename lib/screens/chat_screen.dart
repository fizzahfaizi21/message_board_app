import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  void sendMessage(String boardName) async {
    if (messageController.text.trim().isEmpty) return;

    final user = _auth.currentUser;
    final userDoc = await _firestore.collection('users').doc(user!.uid).get();
    final displayName = '${userDoc['firstName']} ${userDoc['lastName']}';

    await _firestore
        .collection('boards')
        .doc(boardName)
        .collection('messages')
        .add({
      'text': messageController.text.trim(),
      'sender': displayName,
      'timestamp': FieldValue.serverTimestamp(),
    });

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final boardName = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text(boardName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('boards')
                  .doc(boardName)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                final messages = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return ListTile(
                      title: Text(msg['sender']),
                      subtitle: Text(msg['text']),
                      trailing: Text(
                        msg['timestamp'] != null
                            ? (msg['timestamp'] as Timestamp)
                                .toDate()
                                .toLocal()
                                .toString()
                                .substring(0, 16)
                            : '',
                        style: TextStyle(fontSize: 10),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final board =
                        ModalRoute.of(context)!.settings.arguments as String;
                    sendMessage(board);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
