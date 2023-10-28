import 'package:back_office/views/home/home_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'models/doctor_model.dart';

class DoctorProvider extends ChangeNotifier {
  int _doctorPage = 1;

  int get doctorPage => _doctorPage;

  incDoctorPage(doctorPage) {
    _doctorPage = doctorPage;
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

  DoctorModel _doctorModel = DoctorModel();

  DoctorModel get doctorModel => _doctorModel;

  incdoctorModel(doctorModel) {
    _doctorModel = doctorModel;
    notifyListeners();
  }

  List<DoctorGridModel> getDoctorsGridData(QuerySnapshot qs) {
    HomeProvider provider = HomeProvider();
    List<DoctorGridModel> doctorsGrid = [];
    //if(kDebugMode) print('@\$% qs: $qs');
    qs.docs.forEach((doctor) {
      //if(kDebugMode) print('@\$% doctor: $doctor');
      //if(kDebugMode) print(doctor.data());
      DoctorModel doctorModel = DoctorModel.fromDocument(doctor.data());
      // try {
      // } catch (e) {
      //  if(kDebugMode) print(e);
      //  if(kDebugMode) print(doctor.data());
      // }
      doctorModel.type = provider.getPortugueseType(doctorModel.type);
      doctorModel.status = provider.getPortugueseStatus(doctorModel.status);
      doctorModel.email = doctorModel.email == null
          ? '- - -'
          : doctorModel.email.toString().toLowerCase();
      //if(kDebugMode) print('@\$% doctorModel: $doctorModel');
      DoctorGridModel doctorGridModel = DoctorGridModel(false, doctorModel);
      //if(kDebugMode) print('@\$% doctorGridModel: $doctorGridModel');
      doctorsGrid.add(doctorGridModel);
    });
    return doctorsGrid;
  }

  String validate(Timestamp object) {
    if (object == null) {
      return 'null';
    } else {
      return object.toDate().toString().substring(0, 10);
    }
  }

  DataGridRow getDataGridRow(DoctorGridModel e) {
    HomeProvider homeProvider = HomeProvider();
    return DataGridRow(cells: [
      DataGridCell(columnName: 'id', value: e.doctorModel.id),
      DataGridCell(columnName: 'username', value: e.doctorModel.username),
      DataGridCell(columnName: 'fullname', value: e.doctorModel.fullname),
      DataGridCell(
          columnName: 'birthday',
          value:
              homeProvider.validateTimeStamp(e.doctorModel.birthday, 'date')),
      DataGridCell(
          columnName: 'cpf',
          value: homeProvider.getTextMasked(e.doctorModel.cpf, 'cpf')),
      DataGridCell(columnName: 'gender', value: e.doctorModel.gender),
      DataGridCell(columnName: 'crm', value: e.doctorModel.crm),
      DataGridCell(columnName: 'email', value: e.doctorModel.email),
      DataGridCell(
          columnName: 'phone',
          value: homeProvider.getTextMasked(e.doctorModel.phone, 'phone')),
      DataGridCell(columnName: 'status', value: e.doctorModel.status),
      DataGridCell(columnName: 'type', value: e.doctorModel.type),
      DataGridCell(columnName: 'actions', value: e),
    ]);
  }

  bool _open = false;
  bool get open => _open;
  setOpen(open) {
    _open = open;
    notifyListeners();
  }
}
