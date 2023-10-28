import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  NotificationModel({
    this.viewed,
    this.createdAt,
    this.receiverId,
    this.type,
    this.id,
    this.dispatchedAt,
    this.text,
    this.senderId,
    this.status,
  });
  final String id;
  final String receiverId;
  final String text;
  final Timestamp createdAt;
  final Timestamp dispatchedAt;
  bool viewed;
  String status;
  String type;
  String senderId;

  factory NotificationModel.fromDocument(DocumentSnapshot doc) {
    return NotificationModel(
      createdAt: doc['created_at'],
      receiverId: doc['receiver_id'],
      type: doc['type'],
      id: doc['id'],
      dispatchedAt: doc['dispatched_at'],
      text: doc['text'],
      status: doc['status'],
      viewed: doc['viewed'],
      // senderId: doc['sender_id'],
    );
  }

  Map<String, dynamic> toJson(NotificationModel notificationModel) => {
        'created_at': notificationModel.createdAt,
        'receiver_id': notificationModel.receiverId,
        'type': notificationModel.type,
        'id': notificationModel.id,
        'dispatched_at': notificationModel.dispatchedAt,
        'text': notificationModel.text,
        'status': notificationModel.status,
        'viewed': notificationModel.viewed,
        'sender_id': notificationModel.senderId,
      };
}

class NotificationGridModel {
  final bool selected;
  final NotificationModel notificationModel;
  NotificationGridModel(this.selected, this.notificationModel);
}
