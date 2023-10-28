import 'package:back_office/shared/models/data_models.dart';
import 'package:back_office/shared/utilities.dart';
import 'package:back_office/shared/widgets/blue_button.dart';
import 'package:back_office/shared/widgets/central_container.dart';
import 'package:back_office/shared/widgets/data_tile.dart';
import 'package:back_office/views/notifications/models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../notification_provider.dart';

class NotificationData extends StatelessWidget {
  final DataTestModel dataTestModel;
  final NotificationModel notificationModel;

  const NotificationData({
    Key key,
    this.dataTestModel,
    this.notificationModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    if (kDebugMode)
      print('notificationModel.status: ${notificationModel.status}');
    Map<String, dynamic> notificationMap = {};
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
                      Provider.of<NotificationProvider>(context, listen: false)
                          .incNotificationPage(1),
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
                      'data': 'Programada',
                      'data_field': 'SCHEDULED',
                    },
                    {
                      'data': 'Enviada',
                      'data_field': 'SENDED',
                    },
                  ],
                  types: [
                    {
                      'data': 'Mensagem',
                      'data_field': 'MESSAGE',
                    },
                    {
                      'data': 'Alerta',
                      'data_field': 'AUTO',
                    },
                    {
                      'data': 'Alerta',
                      'data_field': 'MANUAL',
                    },
                  ],
                  edit: dataTestModel.edit,
                  type: dataTestModel.tiles[index].type,
                  data: dataTestModel.tiles[index].data,
                  title: dataTestModel.tiles[index].title,
                  onChanged: (val) {
                    notificationMap[dataTestModel.tiles[index].type] = val;
                    if (kDebugMode)
                      print(
                          '${dataTestModel.tiles[index].type}: ${notificationMap[dataTestModel.tiles[index].type]} ');
                  },
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
                    Provider.of<NotificationProvider>(context, listen: false)
                        .incNotificationPage(1);
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
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        await FirebaseFirestore.instance
                            .collection('notifications')
                            .doc(notificationModel.id)
                            .update(notificationMap);
                        if (kDebugMode)
                          print(
                              'notificationModel.id: ${notificationModel.id}');
                        if (kDebugMode)
                          print('notificationMap: $notificationMap');
                        try {
                          await FirebaseFirestore.instance
                              .collection('patients')
                              .doc(notificationModel.receiverId)
                              .collection('notifications')
                              .doc(notificationModel.id)
                              .update(notificationMap);
                        } catch (e) {
                          if (kDebugMode) print('eeeeeeeeeeeee $e');

                          await FirebaseFirestore.instance
                              .collection('doctors')
                              .doc(notificationModel.receiverId)
                              .collection('notifications')
                              .doc(notificationModel.id)
                              .update(notificationMap);
                        }

                        Provider.of<NotificationProvider>(context,
                                listen: false)
                            .incNotificationPage(1);
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
