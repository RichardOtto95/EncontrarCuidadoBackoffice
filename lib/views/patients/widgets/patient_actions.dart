import 'package:back_office/shared/widgets/data_tile_provider.dart';
import 'package:back_office/shared/widgets/dialog_widget.dart';
import 'package:back_office/views/patients/models/patient_model.dart';
import 'package:back_office/views/patients/patient_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientActions extends StatelessWidget {
  final Function onView, onEdit, onDelete;
  final PatientModel patientModel;

  const PatientActions({
    Key key,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.patientModel,
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
            Provider.of<PatientProvider>(context, listen: false)
                .incPatientPage(2);

            Provider.of<PatientProvider>(context, listen: false)
                .incpatientModel(patientModel);
            Provider.of<PatientProvider>(context, listen: false)
                .incpatientMap(PatientModel().toJson(patientModel));
          },
          icon: Icon(Icons.remove_red_eye, size: 22, color: Color(0xff707070)),
        ),
        Spacer(),
        IconButton(
          onPressed: () {
            Provider.of<DataTileProvider>(context, listen: false)
                .setStateSelected(patientModel.state);
            Provider.of<DataTileProvider>(context, listen: false)
                .setCitySelected(patientModel.city);
            Provider.of<PatientProvider>(context, listen: false)
                .incpatientModel(patientModel);
            Provider.of<PatientProvider>(context, listen: false)
                .incpatientMap(PatientModel().toJson(patientModel));
            Provider.of<PatientProvider>(context, listen: false)
                .incPatientPage(3);
          },
          icon: Icon(Icons.edit, size: 22, color: Color(0xff707070)),
        ),
        Spacer(),
        IconButton(
          onPressed: () => showDialog(
            useRootNavigator: true,
            context: context,
            barrierDismissible: true,
            builder: (dialogContext) {
              return DialogWidget(
                onCancel: () {
                  Navigator.pop(context);
                },
                onConfirm: (text) async {
                  await FirebaseFirestore.instance
                      .collection('patients')
                      .doc(patientModel.id)
                      .update({"status": "BLOCKED"});

                  onDelete();

                  Navigator.pop(dialogContext);
                },
                title: 'Tem certeza que deseja excluir este paciente?',
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
