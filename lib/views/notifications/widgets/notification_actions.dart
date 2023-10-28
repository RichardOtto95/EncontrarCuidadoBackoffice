import 'package:back_office/shared/widgets/dialog_widget.dart';
import 'package:back_office/views/notifications/models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notification_provider.dart';

class NotificationActions extends StatelessWidget {
  final Function onView, onEdit, onDelete;
  final NotificationModel notificationModel;

  const NotificationActions({
    Key key,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.notificationModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(),
        IconButton(
          onPressed: () {
            Provider.of<NotificationProvider>(context, listen: false)
                .incNotificationPage(2);
            Provider.of<NotificationProvider>(context, listen: false)
                .incnotificationModel(notificationModel);
          },
          icon: Icon(Icons.remove_red_eye, size: 22, color: Color(0xff707070)),
        ),
        Spacer(),
        notificationModel.status == 'Enviada'
            ? Container()
            : IconButton(
                onPressed: () {
                  Provider.of<NotificationProvider>(context, listen: false)
                      .incNotificationPage(3);
                  Provider.of<NotificationProvider>(context, listen: false)
                      .incnotificationModel(notificationModel);
                },
                icon: Icon(Icons.edit, size: 22, color: Color(0xff707070)),
              ),
        notificationModel.status == 'Enviada' ? Container() : Spacer(),
        notificationModel.status == 'Enviada'
            ? Container()
            : IconButton(
                onPressed: () => showDialog(
                  useRootNavigator: true,
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return DialogWidget(
                      title:
                          'Tem certeza que deseja cancelar esta notificação agendada?',
                      onCancel: () {
                        Navigator.pop(context);
                      },
                      onConfirm: (text) async {
                        await FirebaseFirestore.instance
                            .collection('notifications')
                            .doc(notificationModel.id)
                            .update({"status": "CANCELED"});

                        onDelete();

                        Navigator.pop(context);
                      },
                    );
                  },
                ),
                icon: Icon(Icons.delete, size: 22, color: Color(0xff707070)),
              ),
        notificationModel.status == 'Enviada' ? Container() : Spacer(),
      ],
    );
  }
}
