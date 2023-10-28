import 'package:back_office/shared/widgets/dialog_widget.dart';
import 'package:back_office/views/appointments/models/appointment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../appointments_provider.dart';

class AppointmentActions extends StatelessWidget {
  final Function onView, onEdit, onDelete;
  final AppointmentModel appointmentModel;

  const AppointmentActions({
    Key key,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.appointmentModel,
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
            Provider.of<AppointmentProvider>(context, listen: false)
                .incAppointmentModel(appointmentModel);
            Provider.of<AppointmentProvider>(context, listen: false)
                .incAppointmentPage(2);
          },
          icon: Icon(Icons.remove_red_eye, size: 22, color: Color(0xff707070)),
        ),
        Spacer(),
        IconButton(
          onPressed: () {
            Provider.of<AppointmentProvider>(context, listen: false)
                .incAppointmentModel(appointmentModel);
            Provider.of<AppointmentProvider>(context, listen: false)
                .incAppointmentPage(3);
          },
          icon: Icon(Icons.edit, size: 22, color: Color(0xff707070)),
        ),
        Spacer(),
        IconButton(
          onPressed: () => showDialog(
            useRootNavigator: true,
            context: context,
            barrierDismissible: true,
            builder: (context) {
              return DialogWidget(
                title: 'Tem certeza que deseja excluir esta consulta?',
                onCancel: () => Navigator.pop(context),
                onConfirm: (text) async {
                  await FirebaseFirestore.instance
                      .collection('appointments')
                      .doc(appointmentModel.id)
                      .update({"status": "CANCELED"});

                  onDelete();

                  Navigator.pop(context);
                },
              );
            },
          ),
          icon: Icon(Icons.delete, size: 22, color: Color(0xff707070)),
        ),
        Spacer(),
      ],
    );
  }
}
