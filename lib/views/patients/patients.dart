import 'package:back_office/shared/widgets/data_tile_provider.dart';
import 'package:back_office/views/patients/models/patient_data_models.dart';
import 'package:back_office/views/patients/models/patient_model.dart';
import 'package:back_office/views/patients/patient_provider.dart';
import 'package:back_office/views/patients/widgets/patient_data.dart';
import 'package:back_office/views/patients/widgets/patient_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Patients extends StatefulWidget {
  @override
  _PatientsState createState() => _PatientsState();
}

class _PatientsState extends State<Patients> {
  int patientPage = 1;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ChangeNotifierProvider(
      create: (context) => DataTileProvider(),
      child: Consumer<PatientProvider>(
        builder: (context, value, child) {
          return SingleChildScrollView(
            child: getPatientPage(
              patientPage: value.patientPage,
              patientModel: value.patientModel,
            ),
          );
        },
      ),
    ));
  }

  Widget getPatientPage({int patientPage, PatientModel patientModel}) {
    switch (patientPage) {
      case 1:
        return PatientGrid(
          filters: getPatientFilters(),
        );
        break;
      case 2:
        return PatientData(
          patientModel: patientModel,
          dataTestModel: getPatientData(
            'Dados do paciente',
            patientModel,
            false,
          ),
        );
        break;
      case 3:
        return PatientData(
          patientModel: patientModel,
          dataTestModel: getPatientData(
            'Editar dados do paciente',
            patientModel,
            true,
          ),
        );
        break;
      default:
        return Padding(
          padding: EdgeInsets.only(top: 50),
          child: Text('Algo de errado nessa navegação'),
        );
    }
  }
}
