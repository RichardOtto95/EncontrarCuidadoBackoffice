import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final Timestamp createdAt;
  final Timestamp date;
  final Timestamp hour;
  final Timestamp endHour;

  final String doctorId;
  final String scheduleId;
  final String patientId;
  String id;
  String status;
  String type;
  final String contact;
  final String patientName;
  final String note;
  final String dependentId;

  final bool greedSimptoms;
  final bool firstVisit;
  final bool rated;

  final double price;

  AppointmentModel({
    this.dependentId,
    this.rated = false,
    this.note,
    this.contact,
    this.patientName,
    this.greedSimptoms,
    this.firstVisit,
    this.createdAt,
    this.date,
    this.hour,
    this.endHour,
    this.doctorId,
    this.scheduleId,
    this.patientId,
    this.id,
    this.status,
    this.type,
    this.price,
  });

  factory AppointmentModel.fromDocumentSnapshot(DocumentSnapshot doc) =>
      AppointmentModel(
        dependentId: doc['dependent_id'],
        note: doc['note'],
        contact: doc['contact'],
        patientName: doc['patient_name'],
        greedSimptoms: doc['covid_symptoms'],
        firstVisit: doc['first_visit'],
        createdAt: doc['created_at'],
        date: doc['date'],
        hour: doc['hour'],
        endHour: doc['end_hour'],
        doctorId: doc['doctor_id'],
        scheduleId: doc['schedule_id'],
        patientId: doc['patient_id'],
        id: doc['id'],
        status: doc['status'],
        type: doc['type'],
        price: doc['price'],
        rated: doc['rated'],
      );

  Map<String, dynamic> toJson(AppointmentModel appointment) => {
        'dependent_id': appointment.dependentId,
        'note': appointment.note,
        'contact': appointment.contact,
        'patient_name': appointment.patientName,
        'greed_simptoms': appointment.greedSimptoms,
        'first_visit': appointment.firstVisit,
        'created_at': appointment.createdAt,
        'date': appointment.date,
        'hour': appointment.hour,
        'end_hour': appointment.endHour,
        'doctor_id': appointment.doctorId,
        'schedule_id': appointment.scheduleId,
        'patient_id': appointment.patientId,
        'id': appointment.id,
        'status': appointment.status,
        'type': appointment.type,
        'price': appointment.price,
        'rated': appointment.rated,
      };
}

class AppointmentGridModel {
  final bool selected;
  final AppointmentModel appointmentModel;
  AppointmentGridModel(this.selected, this.appointmentModel);
}
