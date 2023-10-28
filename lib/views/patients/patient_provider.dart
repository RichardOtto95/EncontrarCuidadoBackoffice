import 'package:back_office/views/home/home_provider.dart';
import 'package:back_office/views/patients/models/patient_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PatientProvider extends ChangeNotifier {
  int _patientPage = 1;

  int get patientPage => _patientPage;

  incPatientPage(patientPage) {
    _patientPage = patientPage;
    notifyListeners();
  }

  int _pageView = 0;

  int get pageView => _pageView;

  incPageView(pageView) {
    _pageView = pageView;
    notifyListeners();
  }

  int _pageCount = 0;

  int get pageCount => _pageCount;

  incPageCount(pageCount) {
    _pageCount = pageCount;
    notifyListeners();
  }

  PatientModel _patientModel = PatientModel();

  PatientModel get patientModel => _patientModel;

  incpatientModel(patientModel) {
    _patientModel = patientModel;
    notifyListeners();
  }

  Map<String, dynamic> _patientMap = Map<String, dynamic>();

  Map<String, dynamic> get patientMap => _patientMap;

  incpatientMap(patientMap) {
    _patientMap = patientMap;
    notifyListeners();
  }

  List<PatientGridModel> getPatientsGridData(QuerySnapshot qs) {
    HomeProvider provider = HomeProvider();
    List<PatientGridModel> patientsGrid = [];
    //if(kDebugMode) print('qsqsqsqsqsqs: $qs');
    qs.docs.forEach((patient) {
      //if(kDebugMode) print('paaaaaatient: ${patient.data()}');
      PatientModel patientModel = PatientModel.fromDocument(patient.data());
      patientModel.type = provider.getPortugueseType(patientModel.type);
      patientModel.status =
          provider.getPortugueseStatus(patientModel.status, module: 'patient');
      patientModel.email = patientModel.email == null
          ? null
          : patientModel.email.toString().toLowerCase();
      //if(kDebugMode) print('patientModel: $patientModel');
      PatientGridModel patientGridModel = PatientGridModel(false, patientModel);
      //if(kDebugMode) print('patientGridModel: $patientGridModel');
      patientsGrid.add(patientGridModel);
      //if(kDebugMode) print('patientsGrid: $patientsGrid');
    });
    return patientsGrid;
  }

  // DateTime _selectedDate = DateTime.now();

  Timestamp _dateNasc = Timestamp.now();

  Timestamp get dateNasc => _dateNasc;

  setdateNasc(dateNasc) {
    _dateNasc = dateNasc;
    // notifyListeners();
  }

  incDateDasc(dateNasc) {
    _dateNasc = dateNasc;
    notifyListeners();
  }

  DataGridRow getDataGridRow(PatientGridModel e) {
    HomeProvider homeProvider = HomeProvider();
    return DataGridRow(cells: [
      DataGridCell(columnName: 'id', value: e.patientModel.id),
      DataGridCell(columnName: 'username', value: e.patientModel.username),
      DataGridCell(columnName: 'fullname', value: e.patientModel.fullname),
      DataGridCell(
          columnName: 'birthday',
          value:
              homeProvider.validateTimeStamp(e.patientModel.birthday, 'date')),
      DataGridCell(
          columnName: 'cpf',
          value: homeProvider.getTextMasked(e.patientModel.cpf, 'cpf')),
      DataGridCell(columnName: 'gender', value: e.patientModel.gender),
      DataGridCell(columnName: 'email', value: e.patientModel.email),
      DataGridCell(
          columnName: 'phone',
          value: homeProvider.getTextMasked(e.patientModel.phone, 'phone')),
      DataGridCell(columnName: 'status', value: e.patientModel.status),
      DataGridCell(columnName: 'type', value: e.patientModel.type),
      DataGridCell(columnName: 'actions', value: e),
    ]);
  }

  bool _open = false;
  bool get open => _open;
  setOpen(open) {
    _open = open;
    notifyListeners();
  }

  String _stateSelected = '';

  String get stateSelected => _stateSelected;

  setStateSelected(stateSelected) {
    _stateSelected = stateSelected;
    notifyListeners();
  }
}
