import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorModel {
  String id;
  String avatar;
  String phone;
  String username;
  String fullname;
  Timestamp birthday;
  String cpf;
  String gender;
  String crm;
  String rqe;
  String email;
  String social;
  String clinicName;
  String cep;
  String address;
  String numberAddress;
  String complementAddress;
  String neighborhood;
  String city;
  String state;
  bool notificationEnabled;
  bool connected;
  Timestamp createdAt;
  String aboutMe;
  String academicEducation;
  String experience;
  String medicalConditions;
  String attendance;
  String language;
  String speciality;
  String type;
  String doctorId;
  int newRatings;
  int returnPeriod;
  String landline;
  String specialityName;
  String invitationToPosition;
  String status;
  String country;
  String hospital;
  List addressKeys;
  double price;

  DoctorModel(
      {this.returnPeriod = 30,
      this.price = 0,
      this.id,
      this.country,
      this.status,
      this.avatar,
      this.phone,
      this.username,
      this.fullname,
      this.birthday,
      this.cpf,
      this.gender,
      this.crm,
      this.rqe,
      this.email,
      this.social,
      this.clinicName,
      this.cep,
      this.address,
      this.numberAddress,
      this.complementAddress,
      this.neighborhood,
      this.city,
      this.state,
      this.notificationEnabled,
      this.createdAt,
      this.aboutMe,
      this.academicEducation,
      this.attendance,
      this.experience,
      this.language,
      this.medicalConditions,
      this.speciality,
      this.type,
      this.doctorId,
      this.newRatings,
      this.landline,
      this.specialityName,
      this.invitationToPosition,
      this.connected,
      this.hospital,
      this.addressKeys});

  factory DoctorModel.fromDocument(Map<String, dynamic> doc) {
    return DoctorModel(
      id: doc['id'],
      avatar: doc['avatar'],
      phone: doc['phone'],
      username: doc['username'],
      fullname: doc['fullname'],
      birthday: doc['birthday'],
      cpf: doc['cpf'],
      gender: doc['gender'],
      crm: doc['crm'],
      rqe: doc['rqe'],
      email: doc['email'],
      social: doc['social'],
      clinicName: doc['clinic_name'],
      cep: doc['cep'],
      address: doc['address'],
      numberAddress: doc['number_address'],
      complementAddress: doc['complement_address'],
      neighborhood: doc['neighborhood'],
      city: doc['city'],
      state: doc['state'],
      notificationEnabled: doc['notification_enabled'],
      createdAt: doc['created_at'],
      aboutMe: doc['about_me'],
      academicEducation: doc['academic_education'],
      attendance: doc['attendance'],
      experience: doc['experience'],
      language: doc['language'],
      medicalConditions: doc['medical_conditions'],
      speciality: doc['speciality'],
      type: doc['type'],
      doctorId: doc['doctor_id'],
      newRatings: doc['new_ratings'],
      landline: doc['landline'],
      specialityName: doc['speciality_name'],
      invitationToPosition: doc['invitation_to_position'],
      addressKeys: doc['address_keys'],
      price: doc['price'].toDouble(),
      returnPeriod: doc['return_period'],
      status: doc['status'],
      connected: doc['connected'],
      country: doc['country'],
      hospital: doc['hospital'],
    );
  }

  Map<String, dynamic> convertUser(DoctorModel doctor) {
    Map<String, dynamic> map = {};
    map['id'] = doctor.id;
    map['avatar'] = doctor.avatar;
    map['phone'] = doctor.phone;
    map['username'] = doctor.username;
    map['fullname'] = doctor.fullname;
    map['birthday'] = doctor.birthday;
    map['cpf'] = doctor.cpf;
    map['gender'] = doctor.gender;
    map['crm'] = doctor.crm;
    map['rqe'] = doctor.rqe;
    map['email'] = doctor.email;
    map['social'] = doctor.social;
    map['clinic_name'] = doctor.clinicName;
    map['cep'] = doctor.cep;
    map['address'] = doctor.address;
    map['number_address'] = doctor.numberAddress;
    map['complement_address'] = doctor.complementAddress;
    map['neighborhood'] = doctor.neighborhood;
    map['city'] = doctor.city;
    map['state'] = doctor.state;
    map['notification_enabled'] = doctor.notificationEnabled;
    map['created_at'] = doctor.createdAt;
    map['about_me'] = doctor.aboutMe;
    map['academic_education'] = doctor.academicEducation;
    map['experience'] = doctor.experience;
    map['attendance'] = doctor.attendance;
    map['language'] = doctor.language;
    map['medical_conditions'] = doctor.medicalConditions;
    map['speciality'] = doctor.speciality;
    map['type'] = doctor.type;
    map['doctor_id'] = doctor.doctorId;
    map['new_ratings'] = doctor.newRatings;
    map['landline'] = doctor.landline;
    map['speciality_name'] = doctor.specialityName;
    map['invitation_to_position'] = doctor.invitationToPosition;
    map['address_keys'] = doctor.addressKeys;
    map['price'] = doctor.price;
    map['return_period'] = doctor.returnPeriod;
    map['status'] = doctor.status;
    map['connected'] = doctor.connected;
    return map;
  }

  Map<String, dynamic> toJson(DoctorModel doctor) => {
        'id': doctor.id,
        'avatar': doctor.avatar,
        'phone': doctor.phone,
        'username': doctor.username,
        'fullname': doctor.fullname,
        'birthday': doctor.birthday,
        'cpf': doctor.cpf,
        'gender': doctor.gender,
        'crm': doctor.crm,
        'rqe': doctor.rqe,
        'email': doctor.email,
        'social': doctor.social,
        'clinic_name': doctor.clinicName,
        'cep': doctor.cep,
        'address': doctor.address,
        'number_address': doctor.numberAddress,
        'complement_address': doctor.complementAddress,
        'neighborhood': doctor.neighborhood,
        'city': doctor.city,
        'state': doctor.state,
        'notification_enabled': doctor.notificationEnabled,
        'created_at': doctor.createdAt,
        'about_me': doctor.aboutMe,
        'academic_education': doctor.academicEducation,
        'experience': doctor.experience,
        'attendance': doctor.attendance,
        'language': doctor.language,
        'medical_conditions': doctor.medicalConditions,
        'speciality': doctor.speciality,
        'type': doctor.type,
        'doctor_id': doctor.doctorId,
        'new_ratings': doctor.newRatings,
        'landline': doctor.landline,
        'speciality_name': doctor.specialityName,
        'invitation_to_position': doctor.invitationToPosition,
        'address_keys': doctor.addressKeys,
        'price': doctor.price,
        'return_period': doctor.returnPeriod,
        'status': doctor.status,
        'connected': doctor.connected,
        'country': doctor.country,
        'hospital': doctor.hospital,
      };
}

class DoctorGridModel {
  final bool selected;
  final DoctorModel doctorModel;

  DoctorGridModel(this.selected, this.doctorModel);
}
