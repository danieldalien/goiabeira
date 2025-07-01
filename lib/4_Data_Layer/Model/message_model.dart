enum MessageType { error, warning, info, success }

class MessageModel {
  final String message;
  final MessageType type;

  MessageModel({required this.message, required this.type});

  MessageModel.empty() : message = '', type = MessageType.info;
}
