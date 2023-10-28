import 'package:cloud_firestore/cloud_firestore.dart';

class RatingModel {
  RatingModel({
    this.photo,
    this.appointmentId,
    this.username,
    this.id,
    this.doctorId,
    this.patientId,
    this.createdAt,
    this.avaliation,
    this.text,
    this.status,
  });
  final double avaliation;
  final Timestamp createdAt;
  final String doctorId;
  final String id;
  final String patientId;
  final String photo;
  final String appointmentId;
  String status;
  final String text;
  final String username;

  factory RatingModel.fromDocument(DocumentSnapshot doc) {
    return RatingModel(
      createdAt: doc['created_at'],
      doctorId: doc['doctor_id'],
      avaliation: doc['avaliation'],
      id: doc['id'],
      patientId: doc['patient_id'],
      status: doc['status'],
      text: doc['text'],
      photo: doc['photo'],
      appointmentId: doc['appointment_id'],
      username: doc['username'],
    );
  }

  Map<String, dynamic> toJson(RatingModel rating) => {
        'id': rating.id,
        'doctor_id': rating.doctorId,
        'patient_id': rating.patientId,
        'created_at': rating.createdAt,
        'avaliation': rating.avaliation,
        'text': rating.text,
        'status': rating.status,
        'photo': rating.photo,
        'appointment_id': rating.appointmentId,
        'username': rating.username,
      };
}

class RatingGridModel {
  final bool selected;
  final RatingModel ratingModel;
  RatingGridModel(this.selected, this.ratingModel);
}
