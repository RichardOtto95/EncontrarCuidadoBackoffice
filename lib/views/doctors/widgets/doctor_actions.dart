import 'package:back_office/shared/widgets/data_tile_provider.dart';
import 'package:back_office/shared/widgets/dialog_widget.dart';
import 'package:back_office/views/doctors/models/doctor_model.dart';
import 'package:back_office/views/financial/models/financial_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../doctors_provider.dart';

class DoctorActions extends StatelessWidget {
  final Function onView, onEdit, onDelete;
  final DoctorModel doctorModel;
  final FinancialModel financialModel;

  const DoctorActions({
    Key key,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.doctorModel,
    this.financialModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('admins')
          .where('mobile_full_number',
              isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
              alignment: Alignment.center, child: CircularProgressIndicator());
        } else {
          QuerySnapshot qs = snapshot.data;
          DocumentSnapshot ds = qs.docs.first;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              IconButton(
                onPressed: () {
                  Provider.of<DoctorProvider>(context, listen: false)
                      .incDoctorPage(2);
                  Provider.of<DoctorProvider>(context, listen: false)
                      .incdoctorModel(doctorModel);
                },
                icon: Icon(Icons.remove_red_eye,
                    size: 22, color: Color(0xff707070)),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  Provider.of<DataTileProvider>(context, listen: false)
                      .setStateSelected(doctorModel.state);
                  Provider.of<DataTileProvider>(context, listen: false)
                      .setCitySelected(doctorModel.city);
                  Provider.of<DoctorProvider>(context, listen: false)
                      .incDoctorPage(3);
                  Provider.of<DoctorProvider>(context, listen: false)
                      .incdoctorModel(doctorModel);
                },
                icon: Icon(Icons.edit, size: 22, color: Color(0xff707070)),
              ),
              Spacer(),
              !(ds['role'] == 'ADMIN')
                  ? Container()
                  : IconButton(
                      onPressed: () {
                        Provider.of<DoctorProvider>(context, listen: false)
                            .incDoctorPage(4);
                        Provider.of<DoctorProvider>(context, listen: false)
                            .incdoctorModel(doctorModel);
                      },
                      icon: Icon(
                        Icons.attach_money_outlined,
                        size: 22,
                        color: Color(0xff707070),
                      ),
                    ),
              ds['role'] == 'SUPPORT' ? Container() : Spacer(),
              IconButton(
                onPressed: () => showDialog(
                  useRootNavigator: true,
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return DialogWidget(
                      title: 'Tem certeza que deseja excluir este doutor?',
                      onCancel: () {
                        Navigator.pop(context);
                      },
                      onConfirm: (text) async {
                        await FirebaseFirestore.instance
                            .collection('doctors')
                            .doc(doctorModel.id)
                            .update({"status": "BLOCKED"});
                        Navigator.pop(context);
                        onDelete();
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
      },
    );
  }
}
