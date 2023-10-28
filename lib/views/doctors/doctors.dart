import 'package:back_office/shared/widgets/data_tile_provider.dart';
import 'package:back_office/views/doctors/register_deposit.dart';
import 'package:back_office/views/doctors/widgets/doctor_data.dart';
import 'package:back_office/views/doctors/widgets/doctor_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'doctors_provider.dart';
import 'models/doctor_data_model.dart';
import 'models/doctor_model.dart';

class Doctors extends StatefulWidget {
  @override
  _DoctorsState createState() => _DoctorsState();
}

class _DoctorsState extends State<Doctors> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ChangeNotifierProvider(
      create: (context) => DataTileProvider(),
      child: Consumer<DoctorProvider>(
        builder: (context, value, child) {
          return getDoctorPage(
              doctorPage: value.doctorPage, doctorModel: value.doctorModel);
        },
      ),
    ));
  }

  Widget getDoctorPage({int doctorPage, DoctorModel doctorModel}) {
    switch (doctorPage) {
      case 1:
        return DoctorGrid(
          filters: getDoctorFilters(),
        );
        break;
      case 2:
        return DoctorData(
          doctorModel: doctorModel,
          dataTestModel: getDoctorData(
            'Detalhes do médico',
            DoctorModel().toJson(doctorModel),
            false,
          ),
        );
        break;
      case 3:
        return DoctorData(
            doctorModel: doctorModel,
            dataTestModel: getDoctorData(
              'Editar dados do médico',
              DoctorModel().toJson(doctorModel),
              true,
            ));
        break;
      case 4:
        return RegisterDeposit(
          doctorModel: doctorModel,
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
