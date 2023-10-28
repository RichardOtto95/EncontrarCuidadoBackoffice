import 'package:back_office/views/notifications/widgets/notification_create.dart';
import 'package:back_office/views/notifications/widgets/notification_data.dart';
import 'package:back_office/views/notifications/widgets/notification_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'notification_provider.dart';
import 'models/notification_data_model.dart';
import 'models/notification_model.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  int notificationPage = 1;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<NotificationProvider>(
        builder: (context, value, child) {
          return SingleChildScrollView(
            child: getNotificationPage(
                notificationPage: value.notificationPage,
                notificationModel: value.notificationModel),
          );
        },
      ),
    );
  }

  Widget getNotificationPage(
      {int notificationPage, NotificationModel notificationModel}) {
    switch (notificationPage) {
      case 1:
        return NotificationGrid(filters: getNotificationsFilters());
        break;
      case 2:
        return NotificationData(
          notificationModel: notificationModel,
          dataTestModel: getNotificationData(
            'Detalhes da notificação',
            NotificationModel().toJson(notificationModel),
            false,
          ),
        );
        break;
      case 3:
        return NotificationData(
            notificationModel: notificationModel,
            dataTestModel: getNotificationData(
              'Editar dados da notificação',
              NotificationModel().toJson(notificationModel),
              true,
            ));
        break;
      case 4:
        return NotificationCreate();
      default:
        return Padding(
          padding: EdgeInsets.only(top: 50),
          child: Text('Algo de errado nessa navegação'),
        );
    }
  }
}
