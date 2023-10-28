import 'package:back_office/shared/models/data_models.dart';

class RatingDataTestModel {
  final Map<String, dynamic> appointmentMap;

  RatingDataTestModel(this.appointmentMap);
}

List<List> getRatingFilters() => [
      ['ID', 'id', 'ratings', 'id'],
      ['ID do  médico', 'doctor_id', 'doctors', 'id'],
      ['ID do  agendamento', 'appointment_id', 'ratings', 'appointment_id'],
      ['ID do paciente', 'patient_id', 'patients', 'id'],
      ['Data de criação', 'created_at', 'ratings', 'created_at'],
      ['Nome do paciente', 'username', 'ratings', 'username'],
      ['Nota', 'avaliation', 'ratings', 'avaliation'],
      ['Texto', 'text', 'ratings', 'text'],
      ['Status', 'status', 'ratings', 'status'],
    ];

DataTestModel getRatingData(
  String title,
  Map<String, dynamic> ratingMap,
  bool edit,
) {
  List<TileTestModel> ratingData = [
    TileTestModel('ID: ', ratingMap['id'], 'id'),
    TileTestModel('Id do  médico: ', ratingMap['doctor_id'], 'doctor_id'),
    TileTestModel('Data de criação: ', ratingMap['created_at'], 'created_at'),
    TileTestModel(
      'Id do  agendamento: ',
      ratingMap['appointment_id'],
      'appointment_id',
    ),
    TileTestModel('Id do paciente: ', ratingMap['patient_id'], 'patient_id'),
    TileTestModel('Nome do paciente: ', ratingMap['username'], 'username'),
    TileTestModel('Nota: ', ratingMap['avaliation'], 'avaliation'),
    TileTestModel('Texto : ', ratingMap['text'], 'text'),
    TileTestModel('Status: ', ratingMap['status'], 'status'),
  ];
  DataTestModel dataModel =
      DataTestModel(edit, tiles: ratingData, title: '$title');
  return dataModel;
}
