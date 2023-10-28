import 'package:back_office/shared/models/data_models.dart';

class DoctorDataTestModel {
  final Map<String, dynamic> doctorMap;

  DoctorDataTestModel(this.doctorMap);
}

List<List> getDoctorFilters() => [
      ['ID', 'id', 'doctors', 'id'],
      ['ID do doutor do secretário', 'doctor_id', 'doctors', 'doctor_id'],
      ['Data de criação', 'created_at', 'doctors', 'created_at'],
      [
        'Notificação desativada',
        'notification_disabled',
        'doctors',
        'notification_disabled'
      ],
      ['Conectado', 'connected', 'doctors', 'connected'],
      ['Nome de usuário', 'username', 'doctors', 'username'],
      ['Nome completo', 'fullname', 'doctors', 'fullname'],
      ['Data de nascimento', 'birthday', 'doctors', 'birthday'],
      ['CPF', 'cpf', 'doctors', 'cpf'],
      ['Gênero', 'gender', 'doctors', 'gender'],
      ['CRM', 'crm', 'doctors', 'crm'],
      ['RQE', 'rqe', 'doctors', 'rqe'],
      ['Especialidade', 'speciality_name', 'doctors', 'speciality_name'],
      ['Dias para retorno', 'return_period', 'doctors', 'return_period'],
      ['Preço', 'price', 'doctors', 'price'],
      ['Rede social', 'social', 'doctors', 'social'],
      ['E-mail', 'email', 'doctors', 'email'],
      ['Telefone', 'phone', 'doctors', 'phone'],
      ['Status', 'status', 'doctors', 'status'],
      ['Tipo', 'type', 'doctors', 'type'],
      ['Sobre', 'about_me', 'doctors', 'about_me'],
      ['Experiência', 'experience', 'doctors', 'experience'],
      [
        'Formação acadêmica',
        'academic_education',
        'doctors',
        'academic_education'
      ],
      ['Faixa etária', 'attendance', 'doctors', 'attendance'],
      [
        'Condições médicas',
        'medical_conditions',
        'doctors',
        'medical_conditions'
      ],
      ['Linguagens', 'language', 'doctors', 'language'],
      ['Nome da clínica', 'clinic_name', 'doctors', 'clinic_name'],
      ['Endereço', 'address', 'doctors', 'address'],
      ['Número do endereço', 'number_address', 'doctors', 'number_address'],
      ['Complemento', 'complement_address', 'doctors', 'complement_address'],
      ['Bairro', 'neighborhood', 'doctors', 'neighborhood'],
      ['País', 'country', 'doctors', 'country'],
      ['Estado', 'state', 'doctors', 'state'],
      ['Cidade', 'city', 'doctors', 'city'],
      ['CEP', 'cep', 'doctors', 'cep'],
    ];

DataTestModel getDoctorData(
    String title, Map<String, dynamic> doctorMap, bool edit) {
  List<TileTestModel> doctorData = [
    TileTestModel('ID: ', doctorMap['id'], 'id'),
    TileTestModel('Data de criação: ', doctorMap['created_at'], 'created_at'),
    TileTestModel(
      'Notificação ativada: ',
      doctorMap['notification_enabled'],
      'notification_enabled',
    ),
    TileTestModel('Conectado: ', doctorMap['connected'], 'connected'),
    TileTestModel('Nome de usuário: ', doctorMap['username'], 'username'),
    TileTestModel('Nome completo: ', doctorMap['fullname'], 'fullname'),
    TileTestModel('Data de nascimento: ', doctorMap['birthday'], 'birthday'),
    TileTestModel('CPF: ', doctorMap['cpf'], 'cpf'),
    TileTestModel('Gênero: ', doctorMap['gender'], 'gender'),
    TileTestModel('CRM: ', doctorMap['crm'], 'crm'),
    TileTestModel('RQE: ', doctorMap['rqe'], 'rqe'),
    TileTestModel(
      'Especialidade: ',
      doctorMap['speciality_name'],
      'speciality_name',
    ),
    TileTestModel(
      'Dias para retorno: ',
      doctorMap['return_period'],
      'return_period',
    ),
    TileTestModel('Preço: ', doctorMap['price'], 'price'),
    TileTestModel('Rede social: ', doctorMap['social'], 'social'),
    TileTestModel('E-mail: ', doctorMap['email'], 'email'),
    TileTestModel('Telefone: ', doctorMap['phone'], 'phone'),
    TileTestModel('Status: ', doctorMap['status'], 'status'),
    TileTestModel('Tipo: ', doctorMap['type'], 'type'),
    TileTestModel('Sobre: ', doctorMap['about_me'], 'about_me'),
    TileTestModel('Experiência: ', doctorMap['experience'], 'experience'),
    TileTestModel(
      'Formação acadêmica: ',
      doctorMap['academic_education'],
      'academic_education',
    ),
    TileTestModel('Faixa etária: ', doctorMap['attendance'], 'attendance'),
    TileTestModel(
      'Condições médicas: ',
      doctorMap['medical_conditions'],
      'medical_conditions',
    ),
    TileTestModel('Linguagens: ', doctorMap['language'], 'language'),
    TileTestModel('Nome da clínica: ', doctorMap['clinic_name'], 'clinic_name'),
    TileTestModel('Endereço: ', doctorMap['address'], 'address'),
    TileTestModel(
      'Número do endereço: ',
      doctorMap['number_address'],
      'number_address',
    ),
    TileTestModel(
      'Complemento: ',
      doctorMap['complement_address'],
      'complement_address',
    ),
    TileTestModel('Bairro: ', doctorMap['neighborhood'], 'neighborhood'),
    TileTestModel('País: ', doctorMap['country'], 'country'),
    TileTestModel('Estado: ', doctorMap['state'], 'state'),
    TileTestModel('Cidade: ', doctorMap['city'], 'city'),
    TileTestModel('CEP: ', doctorMap['cep'], 'cep'),
  ];
  if (doctorMap['type'] == 'Secretário(a)') {
    doctorData.insert(
        1,
        TileTestModel(
          'ID do doctor: ',
          doctorMap['doctor_id'],
          'doctor_id',
        ));
  }
  DataTestModel dataModel =
      DataTestModel(edit, tiles: doctorData, title: '$title');
  return dataModel;
}
