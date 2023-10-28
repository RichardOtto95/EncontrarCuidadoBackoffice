import 'package:back_office/shared/models/data_models.dart';

import 'notification_model.dart';

class NotificationDataTestModel {
  final NotificationModel notificationTestModel;

  NotificationDataTestModel(this.notificationTestModel);
}

List<List> getNotificationsFilters() => [
      ['ID', 'id', 'notifications', 'id'],
      ['Data de criação', 'created_at', 'notifications', 'created_at'],
      ['Id do destinatário', 'receiver_id', 'notifications', 'receiver_id'],
      ['Data de envio', 'dispatched_at', 'notifications', 'dispatched_at'],
      ['Texto', 'text', 'notifications', 'text'],
      ['Status', 'status', 'notifications', 'status'],
      ['Visualizada', 'viewed', 'notifications', 'viewed'],
      ['Tipo', 'type', 'notifications', 'type'],
    ];

DataTestModel getNotificationData(
    String title, Map<String, dynamic> notificationMap, bool edit) {
  List<TileTestModel> notificationData = [
    TileTestModel('ID: ', notificationMap['id'], 'id'),
    TileTestModel(
        'Data de criação: ', notificationMap['created_at'], 'created_at'),
    TileTestModel(
        'Id do destinatário: ', notificationMap['receiver_id'], 'receiver_id'),
    TileTestModel('Data: ', notificationMap['date'], 'date'),
    TileTestModel('Texto: ', notificationMap['text'], 'text'),
    TileTestModel('Status: ', notificationMap['status'], 'status'),
    TileTestModel('Visualizada: ', notificationMap['viewed'], 'viewed'),
    TileTestModel('Tipo: ', notificationMap['type'], 'type'),
  ];
  DataTestModel dataTestModel =
      DataTestModel(edit, tiles: notificationData, title: '$title');
  return dataTestModel;
}
