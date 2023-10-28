import 'package:back_office/views/appointments/appointments_provider.dart';
import 'package:back_office/views/appointments/widgets/appointment_data.dart';
import 'package:back_office/views/appointments/widgets/appointment_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/appointment_data_model.dart';
import 'models/appointment_model.dart';

class Appointments extends StatefulWidget {
  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<AppointmentProvider>(
        builder: (context, value, child) {
          return SingleChildScrollView(
            physics: ScrollPhysics(),
            child: getAppointmentPage(
                appointmentPage: value.appointmentPage,
                appointmentModel: value.appointmentModel),
          );
        },
      ),
    );
  }

  Widget getAppointmentPage(
      {int appointmentPage, AppointmentModel appointmentModel}) {
    //if(kDebugMode) print(
    //     'AppointmentModel().toJson(appointmentModel): ${AppointmentModel().toJson(appointmentModel)}');
    switch (appointmentPage) {
      case 1:
        return AppointmentGrid(filters: getPatientFilters());
        break;
      case 2:
        return AppointmentData(
          appointmentModel: appointmentModel,
          dataTestModel: getAppointmentData('Detalhes do agendamento ',
              AppointmentModel().toJson(appointmentModel), false),
        );
        break;
      case 3:
        return AppointmentData(
            appointmentModel: appointmentModel,
            dataTestModel: getAppointmentData('Editar dados do agendamento',
                AppointmentModel().toJson(appointmentModel), true));
        break;
      default:
        return Padding(
          padding: EdgeInsets.only(top: 50),
          child: Text('Algo de errado nessa navegação'),
        );
    }
  }
}
