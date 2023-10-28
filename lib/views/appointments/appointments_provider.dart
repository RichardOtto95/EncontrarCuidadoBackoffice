import 'package:back_office/views/home/home_provider.dart';
import 'package:back_office/views/appointments/models/appointment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AppointmentProvider extends ChangeNotifier {
  int _appointmentPage = 1;

  int get appointmentPage => _appointmentPage;

  incAppointmentPage(appointmentPage) {
    _appointmentPage = appointmentPage;
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

  AppointmentModel _appointmentModel = AppointmentModel();

  AppointmentModel get appointmentModel => _appointmentModel;

  incAppointmentModel(appointmentModel) {
    _appointmentModel = appointmentModel;
    notifyListeners();
  }

  List<AppointmentGridModel> getAppointmentsGridData(QuerySnapshot qs) {
    List<AppointmentGridModel> appointmentsGrid = [];
    HomeProvider provider = HomeProvider();
    //if(kDebugMode) print('qsqsqsqsqsqs: $qs');
    qs.docs.forEach((appointment) {
      //if(kDebugMode) print('paaaaaatient: ${appointment.data()}');
      AppointmentModel appointmentModel =
          AppointmentModel.fromDocumentSnapshot(appointment);
      appointmentModel.type = provider.getPortugueseType(appointmentModel.type);
      appointmentModel.status =
          provider.getPortugueseStatus(appointmentModel.status);
      //if(kDebugMode) print('appointmentModel: $appointmentModel');
      AppointmentGridModel appointmentGridModel =
          AppointmentGridModel(false, appointmentModel);
      //if(kDebugMode) print('appointmentGridModel: $appointmentGridModel');
      appointmentsGrid.add(appointmentGridModel);
      //if(kDebugMode) print('appointmentsGrid: $appointmentsGrid');
    });
    return appointmentsGrid;
  }

  String validate(Timestamp object) {
    if (object == null) {
      return 'null';
    } else {
      return object.toDate().toString().substring(0, 10);
    }
  }

  DataGridRow getDataGridRow(AppointmentGridModel e) {
    HomeProvider homeProvider = HomeProvider();
    return DataGridRow(cells: [
      DataGridCell(columnName: 'id', value: e.appointmentModel.id),
      DataGridCell(columnName: 'doctorId', value: e.appointmentModel.doctorId),
      DataGridCell(
          columnName: 'appointmentId', value: e.appointmentModel.patientId),
      DataGridCell(
        columnName: 'date',
        value: homeProvider.validateTimeStamp(e.appointmentModel.date, 'date'),
      ),
      DataGridCell(
        columnName: 'hour',
        value: homeProvider.validateTimeStamp(e.appointmentModel.hour, 'hour'),
      ),
      DataGridCell(
          columnName: 'price',
          value: homeProvider.formatedCurrency(e.appointmentModel.price)),
      DataGridCell(columnName: 'status', value: e.appointmentModel.status),
      DataGridCell(columnName: 'type', value: e.appointmentModel.type),
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
