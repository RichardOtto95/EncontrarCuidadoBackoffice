import 'package:back_office/views/home/home_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'models/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  int _notificationPage = 1;

  int get notificationPage => _notificationPage;

  incNotificationPage(notificationPage) {
    _notificationPage = notificationPage;
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

  NotificationModel _notificationModel = NotificationModel();

  NotificationModel get notificationModel => _notificationModel;

  incnotificationModel(notificationModel) {
    _notificationModel = notificationModel;
    notifyListeners();
  }

  bool _notificationNotify = true;

  bool get notificationNotify => _notificationNotify;

  incNotificationNotify(notificationNotify) {
    _notificationNotify = notificationNotify;
    notifyListeners();
  }

  List<NotificationGridModel> getNotificationsGridData(QuerySnapshot qs) {
    HomeProvider provider = HomeProvider();
    List<NotificationGridModel> notificationsGrid = [];
    //if(kDebugMode) print('qsqsqsqsqsqs: $qs');

    qs.docs.forEach((notification) {
      //if(kDebugMode) print('paaaaaatient: ${notification.data()}');
      //if(kDebugMode) print("Id: ${notification.id}");
      NotificationModel notificationModel =
          NotificationModel.fromDocument(notification);
      //if(kDebugMode) print('notificationModel: $notificationModel');
      notificationModel.type =
          provider.getPortugueseType(notificationModel.type);
      notificationModel.status = provider.getPortugueseStatus(
          notificationModel.status,
          module: 'notification');
      // notificationModel.viewed = notificationModel.viewed ? 'Sim' : 'Não';
      NotificationGridModel notificationGridModel =
          NotificationGridModel(false, notificationModel);
      //if(kDebugMode) print('notificationGridModel: $notificationGridModel');
      notificationsGrid.add(notificationGridModel);
      //if(kDebugMode) print('notificationsGrid: $notificationsGrid');
    });
    return notificationsGrid;
  }

  List<Map<String, dynamic>> _doctorsSelected = [];

  List<Map<String, dynamic>> get doctorsSelected => _doctorsSelected;

  addDoctorSelected(Map<String, dynamic> doctorSelected) {
    bool contains = false;
    _doctorsSelected.forEach((doctor) {
      if (doctor['id'] == doctorSelected['id']) {
        contains = true;
      }
    });
    if (!contains) {
      _doctorsSelected.add(doctorSelected);
    }
    notifyListeners();
  }

  removeDoctorSelected(Map<String, dynamic> doctorSelected) {
    _doctorsSelected.remove(doctorSelected);
    notifyListeners();
  }

  cleanDoctorsSelected() {
    _doctorsSelected.clear();
    notifyListeners();
  }

  List<Map<String, dynamic>> _patientsSelected = [];

  List<Map<String, dynamic>> get patientsSelected => _patientsSelected;

  addPatientSelected(Map<String, dynamic> patientSelected) {
    bool contains = false;
    _patientsSelected.forEach((patient) {
      if (patient['id'] == patientSelected['id']) {
        contains = true;
      }
    });
    if (!contains) {
      _patientsSelected.add(patientSelected);
    }
    notifyListeners();
  }

  removePatientSelected(int index) {
    _patientsSelected.removeAt(index);
    notifyListeners();
  }

  cleanPatientsSelected() {
    _patientsSelected.clear();
    notifyListeners();
  }

  // Map<String, dynamic> _userSelected = {};

  // Map<String, dynamic> get userSelected => _userSelected;

  // setUserselected(userSelected) {
  //   _userSelected = userSelected;
  //   notifyListeners();
  // }

  Future sendMessage({
    bool sendForAll,
    bool isPatient,
    DateTime dateTime,
    String text,
    List<Map<String, dynamic>> users,
  }) async {
    //if(kDebugMode) print('sendForAll: $sendForAll');
    if (sendForAll) {
      //if(kDebugMode) print('mandando para todos');
      QuerySnapshot _receivers;
      //if(kDebugMode) print('patient: $isPatient');

      if (isPatient) {
        _receivers =
            await FirebaseFirestore.instance.collection('patients').get();
      } else {
        _receivers =
            await FirebaseFirestore.instance.collection('doctors').get();
      }

      _receivers.docs.forEach((receiver) async {
        NotificationModel notificationsModel = NotificationModel(
          createdAt: Timestamp.now(),
          dispatchedAt: Timestamp.fromDate(dateTime),
          receiverId: receiver.id,
          status: 'SCHEDULED',
          senderId: null,
          text: text,
          type: 'MANUAL',
          viewed: false,
        );
        //if(kDebugMode) print(
        //     'NotificationModel().toJson(notificationsModel) ${NotificationModel().toJson(notificationsModel)}');
        DocumentReference notification = await FirebaseFirestore.instance
            .collection('notifications')
            .add(NotificationModel().toJson(notificationsModel));
        await notification.update({'id': notification.id});

        DocumentReference userNotification =
            receiver.reference.collection('notifications').doc(notification.id);
        await userNotification
            .set(NotificationModel().toJson(notificationsModel));
        await userNotification.update({'id': notification.id});
      });
    } else {
      users.forEach(
        (user) async {
          //if(kDebugMode) print('Mandando para uma lista de usuário');
          NotificationModel notificationModel = NotificationModel(
            createdAt: Timestamp.now(),
            id: '',
            dispatchedAt: Timestamp.fromDate(dateTime),
            receiverId: user['id'],
            status: 'SCHEDULED',
            senderId: null,
            text: text,
            type: 'MANUAL',
            viewed: false,
          );
          //if(kDebugMode) print(
          //     'NotificationModel().toJson(notificationModel) ${NotificationModel().toJson(notificationModel)}');
          DocumentReference notification = await FirebaseFirestore.instance
              .collection('notifications')
              .add(NotificationModel().toJson(notificationModel));
          notification.update({'id': notification.id});

          if (isPatient) {
            DocumentReference patNot = FirebaseFirestore.instance
                .collection('patients')
                .doc(user['id'])
                .collection('notifications')
                .doc(notification.id);
            await patNot.set(NotificationModel().toJson(notificationModel));
            await patNot.update({'id': patNot.id});
          } else {
            DocumentReference docNot = FirebaseFirestore.instance
                .collection('doctors')
                .doc(user['id'])
                .collection('notifications')
                .doc(notification.id);
            await docNot.set(NotificationModel().toJson(notificationModel));
            await docNot.update({'id': docNot.id});
          }
        },
      );
    }
  }

  DataGridRow getDataGridRow(NotificationGridModel e) {
    return DataGridRow(cells: [
      DataGridCell(columnName: 'id', value: e.notificationModel.id),
      DataGridCell(
          columnName: 'receiver', value: e.notificationModel.receiverId),
      DataGridCell(columnName: 'text', value: e.notificationModel.text),
      DataGridCell(
          columnName: 'date',
          value: HomeProvider()
              .validateTimeStamp(e.notificationModel.dispatchedAt, 'date')),
      DataGridCell(columnName: 'status', value: e.notificationModel.status),
      DataGridCell(columnName: 'type', value: e.notificationModel.type),
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
