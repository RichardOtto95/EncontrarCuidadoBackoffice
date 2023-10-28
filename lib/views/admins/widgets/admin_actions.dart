import 'package:back_office/shared/widgets/dialog_widget.dart';
import 'package:back_office/views/admins/models/admin_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../admins_provider.dart';

class AdminActions extends StatelessWidget {
  final AdminModel adminModel;
  final Function onView, onEdit, onDelete;
  const AdminActions(
      {Key key, this.adminModel, this.onView, this.onEdit, this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(),
        IconButton(
          onPressed: () {
            Provider.of<AdminProvider>(context, listen: false)
                .incAdminPage(adminModel);
            Provider.of<AdminProvider>(context, listen: false)
                .incAdminModel(adminModel);
          },
          icon: Icon(Icons.remove_red_eye, size: 22, color: Color(0xff707070)),
        ),
        Spacer(),
        IconButton(
          onPressed: () {
            Provider.of<AdminProvider>(context, listen: false).incAdminPage(3);
            Provider.of<AdminProvider>(context, listen: false)
                .incAdminModel(adminModel);
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
                title: 'Tem certeza que deseja excluir este administrador?',
                onCancel: () {
                  Navigator.pop(context);
                },
                onConfirm: (text) async {
                  await FirebaseFirestore.instance
                      .collection('admins')
                      .doc(adminModel.username)
                      .delete();
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
}
