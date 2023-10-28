import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat_tile.dart';
import 'package:flutter/foundation.dart';

class Chats extends StatelessWidget {
  final List<DocumentSnapshot> chats;

  const Chats({Key key, this.chats}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) print('########chatschatschats: $chats');

    return Expanded(
      child: SingleChildScrollView(
        child: Column(children: [
          ChatTile(),
          ChatTile(),
          ChatTile(),
          ChatTile(),
        ]
            // List.generate(
            //   chats.length,
            //   (index) => ChatTile(
            //     chatModel: ChatModel.fromDocument(chats[index]),
            //   ),
            // ),
            ),
      ),
    );
  }
}
