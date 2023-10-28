import 'package:back_office/shared/models/data_models.dart';
import 'package:back_office/shared/utilities.dart';
import 'package:back_office/shared/widgets/blue_button.dart';
import 'package:back_office/shared/widgets/central_container.dart';
import 'package:back_office/shared/widgets/data_tile.dart';
import 'package:back_office/views/admins/models/admin_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import '../admins_provider.dart';

class AdminData extends StatelessWidget {
  final DataTestModel dataTestModel;
  final AdminModel adminModel;

  AdminData({Key key, this.dataTestModel, this.adminModel}) : super(key: key);

  final Map<String, dynamic> adminMap = {};

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return CentralContainer(
      paddingBottom: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: wXD(983, context),
            padding: EdgeInsets.fromLTRB(30, 28, 0, 30),
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: Color(0xff707070).withOpacity(.5)))),
            child: Row(
              children: [
                InkWell(
                  onTap: () =>
                      Provider.of<AdminProvider>(context, listen: false)
                          .incAdminPage(1),
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color(0xff707070).withOpacity(.5),
                      size: 30,
                    ),
                  ),
                ),
                SelectableText(
                  '${dataTestModel.title}',
                  style: TextStyle(
                    fontSize: 28,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: List.generate(
                dataTestModel.tiles.length,
                (index) => DataTestTile(
                  statuses: [
                    {
                      'data': 'Online',
                      'data_field': 'online',
                    },
                    {
                      'data': 'Offline',
                      'data_field': 'offline',
                    },
                  ],
                  types: [
                    {
                      'data': 'Doutor(a)',
                      'data_field': 'doctor',
                    },
                    {
                      'data': 'Secretário(a)',
                      'data_field': 'secretary',
                    },
                  ],
                  onChanged: (dynamic val) {
                    switch (dataTestModel.tiles[index].type) {
                      case 'phone':
                        this.adminMap[dataTestModel.tiles[index].type] =
                            '+$val';
                        break;
                    }
                    if (kDebugMode) print('val: $val');
                    if (kDebugMode) print('map: ${this.adminMap}');
                    //if(kDebugMode) print(
                    //     '${dataTestModel.tiles[index].type} = ${this.doctorMap[dataTestModel.tiles[index].type]} \n');
                  },
                  edit: dataTestModel.edit,
                  type: dataTestModel.tiles[index].type,
                  data: dataTestModel.tiles[index].data,
                  title: dataTestModel.tiles[index].title,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(26, 32, 56, 23),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Provider.of<AdminProvider>(context, listen: false)
                        .incAdminPage(1);
                  },
                  child: Text(
                    '< Voltar',
                    style: TextStyle(
                        color: Color(0xff0000DA), fontSize: hXD(20, context)),
                  ),
                ),
                Visibility(
                  visible: dataTestModel.edit,
                  child: BlueButton(
                    text: 'Salvar',
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        if (kDebugMode) print('admin map: $this.adminMap');
                        FirebaseFirestore.instance
                            .collection('admins')
                            .doc(adminModel.username)
                            .update(this.adminMap);
                        Provider.of<AdminProvider>(context, listen: false)
                            .incAdminPage(1);
                      } else {
                        Fluttertoast.showToast(
                          webPosition: 'center',
                          webBgColor:
                              "linear-gradient(to bottom, #41c3b3, #21bcce)",
                          msg: 'Verifique os campos novamente',
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
