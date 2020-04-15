class MessageListTile {
  final DateTime date;
  final String username;
  final String userAvatar;
  final String lastMessage;
  final bool hasNewMessage;

  MessageListTile(
      {this.date,
      this.username,
      this.lastMessage,
      this.hasNewMessage,
      this.userAvatar});
}
