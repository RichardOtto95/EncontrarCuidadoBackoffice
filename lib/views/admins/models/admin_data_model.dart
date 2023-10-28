import 'package:back_office/shared/models/data_models.dart';

class AdminDataTestModel {
  final Map<String, dynamic> adminMap;

  AdminDataTestModel(this.adminMap);
}

DataTestModel getAdminData(
    String title, Map<String, dynamic> adminMap, bool edit) {
  List<TileTestModel> adminData = [
    TileTestModel('username', adminMap['username'], 'usarname'),
    TileTestModel('phone', adminMap['phone'], 'phone'),
    TileTestModel('role', adminMap['role'], 'role'),
    TileTestModel('avatar', adminMap['avatar'], 'avatar'),
  ];
  DataTestModel dataModel =
      DataTestModel(edit, tiles: adminData, title: '$title');
  return dataModel;
}
