import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final Timestamp createdAt;
  final String id;
  final String doctorId;
  final String patientId;
  final int usrNotific;
  final String usrAvatar;
  final String spAvatar;
  final int supNotific;
  final Timestamp updatedAt;

  ChatModel(
      {this.spAvatar,
      this.createdAt,
      this.id,
      this.doctorId,
      this.patientId,
      this.usrNotific,
      this.usrAvatar,
      this.supNotific,
      this.updatedAt});

  factory ChatModel.fromDocument(DocumentSnapshot doc) {
    return ChatModel(
      createdAt: doc['created_at'],
      doctorId: doc['doctor_id'],
      id: doc['id'],
      patientId: doc['patient_id'],
      supNotific: doc['sp_notifications'],
      spAvatar: doc['support_avatar'],
      updatedAt: doc['updated_at'],
      usrAvatar: doc['user_avatar'],
      usrNotific: doc['usr_notifications'],
    );
  }
}
