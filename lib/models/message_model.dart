class MessageModel {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final DateTime timestamp;
  final String boardId;

  MessageModel({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
    required this.boardId,
  });

  factory MessageModel.fromMap(Map<String, dynamic> data, String id) {
    return MessageModel(
      id: id,
      text: data['text'] ?? '',
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? '',
      timestamp: data['timestamp'] != null
          ? DateTime.parse(data['timestamp'])
          : DateTime.now(),
      boardId: data['boardId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'senderName': senderName,
      'timestamp': timestamp.toIso8601String(),
      'boardId': boardId,
    };
  }
}

class BoardModel {
  final String id;
  final String name;
  final String imageUrl;
  final String description;

  BoardModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
  });
}
