import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:message_board_app/models/message_model.dart';
import 'package:message_board_app/models/user_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference messagesCollection =
      FirebaseFirestore.instance.collection('messages');

  // Get user stream
  Stream<UserModel?> getUserStream(String uid) {
    return usersCollection.doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  // Get messages stream for a specific board
  Stream<List<MessageModel>> getMessagesStream(String boardId) {
    return messagesCollection
        .where('boardId', isEqualTo: boardId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(_messageListFromSnapshot);
  }

  // Create a message
  Future<void> createMessage(MessageModel message) async {
    return await messagesCollection.add(message.toMap());
  }

  // Message list from snapshot
  List<MessageModel> _messageListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return MessageModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  // Hard-coded boards for the assignment
  List<BoardModel> getBoards() {
    return [
      BoardModel(
        id: 'general',
        name: 'General',
        imageUrl: 'assets/images/general.png',
        description: 'General discussion board',
      ),
      BoardModel(
        id: 'tech',
        name: 'Technology',
        imageUrl: 'assets/images/tech.png',
        description: 'Tech discussions and news',
      ),
      BoardModel(
        id: 'gaming',
        name: 'Gaming',
        imageUrl: 'assets/images/gaming.png',
        description: 'All about games and gaming',
      ),
      BoardModel(
        id: 'music',
        name: 'Music',
        imageUrl: 'assets/images/music.png',
        description: 'Music discussions and recommendations',
      ),
      BoardModel(
        id: 'movies',
        name: 'Movies & TV',
        imageUrl: 'assets/images/movies.png',
        description: 'Film and television discussions',
      ),
    ];
  }

  // Update user settings
  Future<void> updateUserSettings(String uid, Map<String, dynamic> data) async {
    return await usersCollection.doc(uid).update(data);
  }

  // Get user by uid
  Future<UserModel?> getUserById(String uid) async {
    DocumentSnapshot doc = await usersCollection.doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }
}
