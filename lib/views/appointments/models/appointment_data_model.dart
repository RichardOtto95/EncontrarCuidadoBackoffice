import 'package:back_office/shared/models/data_models.dart';

class AppointmentDataTestModel {
  final Map<String, dynamic> appointmentMap;

  AppointmentDataTestModel(this.appointmentMap);
}

List<List> getPatientFilters() => [
      ['ID', 'id', 'appointments', 'id'],
      ['Id do  médico', 'doctor_id', 'doctors', 'id'],
      ['Id do paciente', 'patient_id', 'patients', 'id'],
      ['Data de criação', 'created_at', 'appointments', 'created_at'],
      ['Nome do paciente', 'patient_name', 'appointments', 'patient_name'],
      ['Tipo de visita', 'type', 'appointments', 'type'],
      ['Data', 'date', 'appointments', 'date'],
      ['Hora de início', 'hour', 'appointments', 'hour'],
      ['Hora final', 'end_hour', 'appointments', 'end_hour'],
      [
        'Primeira consulta com este doutor',
        'first_visit',
        'appointments',
        'first_visit'
      ],
      ['Sintomas de covid', 'covid_symptoms', 'appointments', 'covid_symptoms'],
      ['Anotação', 'note', 'appointments', 'note'],
      ['Preço', 'price', 'appointments', 'price'],
      ['Contato', 'contact', 'appointments', 'contact'],
      ['Avaliado', 'rated', 'appointments', 'rated'],
      ['Status', 'status', 'appointments', 'status'],
      ['Tipo', 'type', 'appointments', 'type'],
    ];

DataTestModel getAppointmentData(
    String title, Map<String, dynamic> appointmentMap, bool edit) {
  List<TileTestModel> appointmentData = [
    TileTestModel('ID: ', appointmentMap['id'], 'id'),
    TileTestModel('Id do  médico: ', appointmentMap['doctor_id'], 'doctor_id'),
    TileTestModel(
        'Id do paciente: ', appointmentMap['patient_id'], 'patient_id'),
    TileTestModel(
        'Data de criação: ', appointmentMap['created_at'], 'created_at'),
    TileTestModel(
      'Nome do paciente: ',
      appointmentMap['patient_name'],
      'patient_name',
    ),
    TileTestModel(
        'Tipo de visita: ', appointmentMap['type_of_visit'], 'type_of_visit'),
    TileTestModel('Data: ', appointmentMap['date'], 'date'),
    TileTestModel('Hora de início: ', appointmentMap['hour'], 'hour'),
    TileTestModel('Hora final: ', appointmentMap['end_hour'], 'end_hour'),
    TileTestModel(
      'Primeira consulta com este doutor: ',
      appointmentMap['first_appointment'],
      'first_appointment',
    ),
    TileTestModel(
      'Sintomas de covid: ',
      appointmentMap['greed_simptoms'],
      'greed_simptoms',
    ),
    TileTestModel('Anotação: ', appointmentMap['note'], 'note'),
    TileTestModel('Preço: ', appointmentMap['price'], 'price'),
    TileTestModel('Contato: ', appointmentMap['contact'], 'contact'),
    TileTestModel('Avaliado: ', appointmentMap['rated'], 'rated'),
    TileTestModel('Status: ', appointmentMap['status'], 'status'),
    TileTestModel('Tipo: ', appointmentMap['type'], 'type'),
  ];

  DataTestModel dataModel =
      DataTestModel(edit, tiles: appointmentData, title: '$title');
  return dataModel;
}
