import 'package:flutter/material.dart';
import 'package:message_board_app/models/message_model.dart';
import 'package:message_board_app/screens/chat_screen.dart';
import 'package:message_board_app/services/database_service.dart';
import 'package:message_board_app/widgets/app_drawer.dart';
import 'package:message_board_app/widgets/board_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final databaseService = DatabaseService();
    final List<BoardModel> boards = databaseService.getBoards();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Boards'),
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: boards.length,
        itemBuilder: (context, index) {
          final board = boards[index];
          return BoardCard(
            board: board,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(board: board),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
