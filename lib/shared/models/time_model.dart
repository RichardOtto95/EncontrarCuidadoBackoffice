import 'package:cloud_firestore/cloud_firestore.dart';

class TimeModel {
  String date(Timestamp timestamp) {
    return '${timestamp.toDate().day.toString().padLeft(2, '0')}/${timestamp.toDate().month.toString().padLeft(2, '0')}/${timestamp.toDate().year.toString()}';
  }

  String hour(Timestamp timestamp) {
    return '${timestamp.toDate().hour.toString().padLeft(2, '0')}:${timestamp.toDate().minute.toString().padLeft(2, '0')}';
  }
}
