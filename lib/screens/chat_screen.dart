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
  bool isSending = false;

  void sendMessage(String boardName) async {
    if (messageController.text.trim().isEmpty) return;

    setState(() {
      isSending = true;
    });

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
          'userId': user.uid,
        });

    setState(() {
      isSending = false;
      messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final boardName = ModalRoute.of(context)!.settings.arguments as String;
    final currentUserId = _auth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(boardName, style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Active chat room: $boardName')),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://i.imgur.com/wW5JOeU.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.3),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    _firestore
                        .collection('boards')
                        .doc(boardName)
                        .collection('messages')
                        .orderBy('timestamp', descending: false)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF673AB7),
                        ),
                      ),
                    );
                  final messages = snapshot.data!.docs;
                  if (messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 80,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'No messages yet!\nBe the first to say hello!',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isCurrentUser = msg['userId'] == currentUserId;

                      return Align(
                        alignment:
                            isCurrentUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding: EdgeInsets.all(12),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isCurrentUser
                                    ? Color(0xFF673AB7)
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                msg['sender'],
                                style: TextStyle(
                                  color:
                                      isCurrentUser
                                          ? Colors.white70
                                          : Colors.purple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                msg['text'],
                                style: TextStyle(
                                  color:
                                      isCurrentUser
                                          ? Colors.white
                                          : Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                msg['timestamp'] != null
                                    ? (msg['timestamp'] as Timestamp)
                                        .toDate()
                                        .toLocal()
                                        .toString()
                                        .substring(0, 16)
                                    : '',
                                style: TextStyle(
                                  fontSize: 10,
                                  color:
                                      isCurrentUser
                                          ? Colors.white70
                                          : Colors.black54,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, -2),
                    blurRadius: 4,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Type message...',
                        prefixIcon: Icon(
                          Icons.emoji_emotions,
                          color: Colors.amber,
                        ),
                        suffixIcon: Icon(Icons.attach_file, color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFF9800),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon:
                          isSending
                              ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Icon(Icons.send, color: Colors.white),
                      onPressed:
                          isSending
                              ? null
                              : () {
                                final board =
                                    ModalRoute.of(context)!.settings.arguments
                                        as String;
                                sendMessage(board);
                              },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
