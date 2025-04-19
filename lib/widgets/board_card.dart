import 'package:flutter/material.dart';
import 'package:message_board_app/models/message_model.dart';

class BoardCard extends StatelessWidget {
  final BoardModel board;
  final VoidCallback onTap;

  const BoardCard({
    super.key,
    required this.board,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          radius: 25,
          child: Icon(
            _getIconForBoard(board.id),
            color: Colors.blue,
            size: 25,
          ),
        ),
        title: Text(
          board.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          board.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  IconData _getIconForBoard(String boardId) {
    switch (boardId) {
      case 'general':
        return Icons.forum;
      case 'tech':
        return Icons.computer;
      case 'gaming':
        return Icons.videogame_asset;
      case 'music':
        return Icons.music_note;
      case 'movies':
        return Icons.movie;
      default:
        return Icons.chat_bubble_outline;
    }
  }
}
