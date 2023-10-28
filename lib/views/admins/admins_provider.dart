import 'package:back_office/views/admins/models/admin_model.dart';
import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AdminProvider extends ChangeNotifier {
  int _adminPage = 1;
  int get adminPage => _adminPage;

  incAdminPage(adminPage) {
    _adminPage = adminPage;
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

  AdminModel _adminModel = AdminModel();

  AdminModel get adminModel => _adminModel;

  incAdminModel(adminModel) {
    _adminModel = adminModel;
    notifyListeners();
  }

  Map<String, dynamic> _adminMap = Map<String, dynamic>();

  Map<String, dynamic> get adminMap => _adminMap;

  incAdminMap(adminMap) {
    _adminMap = adminMap;
    notifyListeners();
  }

  List<AdminGridModel> getAdmingridData(QuerySnapshot qs) {
    //if(kDebugMode) print('qs func =========================================: ${qs}');
    List<AdminGridModel> adminsGrid = [];
    if (kDebugMode) print('qs.docs.length: ${qs.docs.length}');
    qs.docs.forEach((admin) {
      AdminModel adminModel = AdminModel.fromDocument(admin.data());

      if (kDebugMode) print(admin.data());
      AdminGridModel adminGridModel = AdminGridModel(false, adminModel);
      adminsGrid.add(adminGridModel);
    });
    if (kDebugMode)
      print(
          'adminsGrid func =========================================: $adminsGrid');

    return adminsGrid;
  }

  String validate(Timestamp object) {
    if (object == null) {
      return 'null';
    } else {
      return object.toDate().toString().substring(0, 10);
    }
  }

  DataGridRow getDataGridRow(AdminGridModel e) {
    //HomeProvider homeProvider = HomeProvider();
    return DataGridRow(cells: [
      DataGridCell(columnName: 'username', value: e.adminModel.username),
      DataGridCell(columnName: 'role', value: e.adminModel.role)
    ]);
  }

  bool _open = false;
  bool get open => _open;
  setOpen(open) {
    _open = open;
    notifyListeners();
  }
}
