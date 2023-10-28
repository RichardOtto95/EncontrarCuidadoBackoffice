import 'package:back_office/shared/models/data_models.dart';
import 'package:back_office/views/patients/models/patient_model.dart';
import 'package:flutter/foundation.dart';

class PatientDataTestModel {
  final PatientModel patientModel;

  PatientDataTestModel(this.patientModel);
}

List<List> getPatientFilters() {
  return [
    ['ID', 'id', 'patients', 'id'],
    ['Id do reponsável', 'responsible_id', 'patients', 'responsible_id'],
    ['Data de criação', 'created_at', 'patients', 'created_at'],
    ['Conectado', 'connected', 'patients', 'connected'],
    [
      'Notificação desativada',
      'notification_disabled',
      'patients',
      'notification_disabled'
    ],
    ['Nome de usuário', 'username', 'patients', 'username'],
    ['Nome completo', 'fullname', 'patients', 'fullname'],
    ['Data de nascimento', 'birthday', 'patients', 'birthday'],
    ['CPF', 'cpf', 'patients', 'cpf'],
    ['Gênero', 'gender', 'patients', 'gender'],
    ['E-mail', 'email', 'patients', 'email'],
    ['Telefone', 'phone', 'patients', 'phone'],
    ['Status', 'status', 'patients', 'status'],
    ['Tipo', 'type', 'patients', 'type'],
    ['Endereço', 'address', 'patients', 'address'],
    ['Número do endereço', 'number_address', 'patients', 'number_address'],
    ['Complemento', 'complement_address', 'patients', 'complement_address'],
    ['Bairro', 'neighborhood', 'patients', 'neighborhood'],
    ['País', 'country', 'patients', 'country'],
    ['Estado', 'state', 'patients', 'state'],
    ['Cidade', 'city', 'patients', 'city'],
    ['CEP', 'cep', 'patients', 'cep'],
  ];
}

DataTestModel getPatientData(
    String title, PatientModel patientModel, bool edit) {
  List<TileTestModel> patientData = [
    TileTestModel('ID: ', patientModel.id, 'id'),
    TileTestModel('Data de criação: ', patientModel.createdAt, 'created_at'),
    TileTestModel('Conectado: ', patientModel.connected, 'connected'),
    TileTestModel(
      'Notificação ativada: ',
      patientModel.notificationEnabled,
      'notification_enabled',
    ),
    TileTestModel('Nome de usuário: ', patientModel.username, 'username'),
    TileTestModel('Nome completo: ', patientModel.fullname, 'fullname'),
    TileTestModel('Data de nascimento: ', patientModel.birthday, 'birthday'),
    TileTestModel('CPF: ', patientModel.cpf, 'cpf'),
    TileTestModel('Gênero: ', patientModel.gender, 'gender'),
    TileTestModel('E-mail: ', patientModel.email, 'email'),
    TileTestModel('Telefone: ', patientModel.phone, 'phone'),
    TileTestModel('Status: ', patientModel.status, 'status'),
    TileTestModel('Tipo: ', patientModel.type, 'type'),
    TileTestModel('Endereço: ', patientModel.address, 'address'),
    TileTestModel(
      'Número do endereço: ',
      patientModel.numberAddress,
      'number_address',
    ),
    TileTestModel(
      'Complemento: ',
      patientModel.complementAddress,
      'complement_address',
    ),
    TileTestModel('Bairro: ', patientModel.neighborhood, 'neighborhood'),
    TileTestModel('País: ', patientModel.country, 'country'),
    TileTestModel('Estado: ', patientModel.state, 'state'),
    TileTestModel('Cidade: ', patientModel.city, 'city'),
    TileTestModel('CEP: ', patientModel.cep, 'cep'),
  ];
  if (kDebugMode) print('patientModel.type: ${patientModel.type}');
  if (patientModel.type == 'Dependente') {
    patientData.insert(
        1,
        TileTestModel('ID do responsável: ', patientModel.responsibleId,
            'responsible_id'));
  }
  DataTestModel dataModel =
      DataTestModel(edit, tiles: patientData, title: '$title');
  return dataModel;
}
