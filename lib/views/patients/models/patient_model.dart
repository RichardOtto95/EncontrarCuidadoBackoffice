import 'package:cloud_firestore/cloud_firestore.dart';

class PatientModel {
  String id;
  String responsibleId;
  String avatar;
  Timestamp createdAt;
  String email;
  String fullname;
  String phone;
  String username;
  Timestamp birthday;
  String gender;
  String cep;
  String cpf;
  String state;
  String address;
  String numberAddress;
  String complementAddress;
  String neighborhood;
  String city;
  String country;
  String status;
  String type;
  bool notificationEnabled;
  bool connected;
  List addressKeys;

  PatientModel({
    this.type,
    this.responsibleId,
    this.country,
    this.id,
    this.cpf,
    this.avatar,
    this.createdAt,
    this.email,
    this.fullname,
    this.phone,
    this.username,
    this.birthday,
    this.gender,
    this.cep,
    this.address,
    this.numberAddress,
    this.complementAddress,
    this.neighborhood,
    this.city,
    this.status,
    this.state,
    this.notificationEnabled,
    this.connected,
    this.addressKeys,
  });

  factory PatientModel.fromDocument(Map<String, dynamic> doc) {
    return PatientModel(
      id: doc['id'],
      avatar: doc['avatar'],
      createdAt: doc['created_at'],
      cpf: doc['cpf'],
      email: doc['email'],
      fullname: doc['fullname'],
      phone: doc['phone'],
      username: doc['username'],
      birthday: doc['birthday'],
      gender: doc['gender'],
      cep: doc['cep'],
      address: doc['address'],
      numberAddress: doc['number_address'],
      complementAddress: doc['complement_address'],
      neighborhood: doc['neighborhood'],
      city: doc['city'],
      status: doc['status'],
      state: doc['state'],
      type: doc['type'],
      notificationEnabled: doc['notification_enabled'],
      country: doc['country'],
      responsibleId: doc['responsible_id'],
      connected: doc['connected'],
      addressKeys: doc['address_keys'],
    );
  }
  Map<String, dynamic> convertUser(PatientModel patient) {
    Map<String, dynamic> map = {};
    map['id'] = patient.id;
    map['avatar'] = patient.avatar;
    map['created_at'] = patient.createdAt;
    map['cpf'] = patient.cpf;
    map['email'] = patient.email;
    map['fullname'] = patient.fullname;
    map['phone'] = patient.phone;
    map['username'] = patient.username;
    map['birthday'] = patient.birthday;
    map['gender'] = patient.gender;
    map['cep'] = patient.cep;
    map['address'] = patient.address;
    map['numberAddress'] = patient.numberAddress;
    map['complementAddress'] = patient.complementAddress;
    map['neighborhood'] = patient.neighborhood;
    map['city'] = patient.city;
    map['status'] = patient.status;
    map['state'] = patient.state;
    map['type'] = patient.type;
    map['notification_enabled'] = patient.notificationEnabled;
    map['country'] = patient.country;
    map['responsible_id'] = patient.responsibleId;
    map['connected'] = patient.connected;
    map['address_keys'] = patient.addressKeys;

    return map;
  }

  Map<String, dynamic> toJson(PatientModel patient) => {
        'id': patient.id,
        'avatar': patient.avatar,
        'created_at': patient.createdAt,
        'cpf': patient.cpf,
        'email': patient.email,
        'fullname': patient.fullname,
        'phone': patient.phone,
        'username': patient.username,
        'birthday': patient.birthday,
        'gender': patient.gender,
        'cep': patient.cep,
        'address': patient.address,
        'number_address': patient.numberAddress,
        'complement_address': patient.complementAddress,
        'neighborhood': patient.neighborhood,
        'city': patient.city,
        'status': patient.status,
        'type': patient.type,
        'state': patient.state,
        'notification_enabled': patient.notificationEnabled,
        'country': patient.country,
        'responsible_id': patient.responsibleId,
        'connected': patient.connected,
        'address_keys': patient.addressKeys,
      };
}

class PatientGridModel {
  final bool selected;
  final PatientModel patientModel;

  PatientGridModel(this.selected, this.patientModel);
}
