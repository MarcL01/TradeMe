import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:trademe/models/MessageListTile.dart';

class MessagesPage extends StatefulWidget {
  MessagesPage({Key key}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  List<MessageListTile> messagesList;

  @override
  void initState() {
    this.messagesList = new List();
    super.initState();

    _loadMessages();
  }

  Future<Void> _loadMessages() async {
    messagesList.clear();
    setState(() {
      messagesList.add(MessageListTile(
          date: DateTime(2020, 4, 10),
          username: "Marco",
          lastMessage: "Yoyoyo so we trading?",
          userAvatar: ""));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Messages"),
      ),
      body: RefreshIndicator(
          child: ListView.builder(
            itemBuilder: (context, index) {
              MessageListTile msg = messagesList[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(msg.userAvatar),
                ),
                title: Text(msg.username),
                subtitle: Text(msg.lastMessage),
                trailing: Text(msg.date.toString()),
              );
            },
            itemCount: messagesList.length,
          ),
          onRefresh: _loadMessages),
    );
  }
}
