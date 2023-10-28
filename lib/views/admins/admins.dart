import 'package:back_office/views/admins/widgets/admin_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'admins_provider.dart';
import 'models/admin_data_model.dart';
import 'models/admin_model.dart';
import 'widgets/admin_data.dart';

class Admins extends StatefulWidget {
  @override
  _AdminsState createState() => _AdminsState();
}

class _AdminsState extends State<Admins> {
  int adminPage = 1;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<AdminProvider>(
        builder: (context, value, child) {
          return SingleChildScrollView(
            physics: ScrollPhysics(),
            child: getAdminPage(
                adminPage: value.adminPage, adminModel: value.adminModel),
          );
        },
      ),
    );
  }

  Widget getAdminPage({int adminPage, AdminModel adminModel}) {
    switch (adminPage) {
      case 1:
        return AdminGrid();
        break;
      case 2:
        return AdminData(
          adminModel: adminModel,
          dataTestModel: getAdminData(
            'Detalhes do admin',
            AdminModel().toJson(adminModel),
            false,
          ),
        );
        break;
      case 3:
        return AdminData(
            adminModel: adminModel,
            dataTestModel: getAdminData(
              'Editar dados do admin',
              AdminModel().toJson(adminModel),
              true,
            ));
        break;
      default:
        return Padding(
          padding: EdgeInsets.only(top: 50),
          child: Text('Algo de errado nessa navegação'),
        );
    }
  }
}
