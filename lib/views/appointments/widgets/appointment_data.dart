import 'package:back_office/shared/models/data_models.dart';
import 'package:back_office/shared/utilities.dart';
import 'package:back_office/shared/widgets/blue_button.dart';
import 'package:back_office/shared/widgets/central_container.dart';
import 'package:back_office/shared/widgets/data_tile.dart';
import 'package:back_office/views/appointments/models/appointment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import '../appointments_provider.dart';

class AppointmentData extends StatefulWidget {
  final DataTestModel dataTestModel;
  final AppointmentModel appointmentModel;

  const AppointmentData({
    Key key,
    this.dataTestModel,
    this.appointmentModel,
  }) : super(key: key);

  @override
  _AppointmentDataState createState() => _AppointmentDataState();
}

class _AppointmentDataState extends State<AppointmentData> {
  Map<String, dynamic> appointmentMap = {};

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return CentralContainer(
      paddingBottom: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: wXD(983, context),
            padding: EdgeInsets.fromLTRB(30, 28, 0, 30),
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: Color(0xff707070).withOpacity(.5)))),
            child: Row(
              children: [
                InkWell(
                  onTap: () =>
                      Provider.of<AppointmentProvider>(context, listen: false)
                          .incAppointmentPage(1),
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color(0xff707070).withOpacity(.5),
                      size: 30,
                    ),
                  ),
                ),
                SelectableText(
                  '${widget.dataTestModel.title}',
                  style: TextStyle(
                    fontSize: 28,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: List.generate(
                widget.dataTestModel.tiles.length,
                (index) => DataTestTile(
                  statuses: [
                    {
                      'data': 'Programada',
                      'data_field': 'SCHEDULED',
                    },
                    {
                      'data': 'Aguardando atendimento',
                      'data_field': 'AWAITING',
                    },
                    {
                      'data': 'Não compareceu',
                      'data_field': 'ABSENT',
                    },
                    {
                      'data': 'Cancelada',
                      'data_field': 'CANCELED',
                    },
                    {
                      'data': 'Concluído',
                      'data_field': 'CONCLUDED',
                    },
                    {
                      'data': 'Encaixe solicitado',
                      'data_field': 'FIT_REQUESTED',
                    },
                    {
                      'data': 'Encaixe recusado',
                      'data_field': 'REFUSED',
                    },
                    {
                      'data': 'Aguardando retorno',
                      'data_field': 'WAITING_RETURN',
                    },
                  ],
                  types: [
                    {
                      'data': 'Consulta',
                      'data_field': 'SCHEDULE',
                    },
                    {
                      'data': 'Retorno',
                      'data_field': 'RETURN',
                    },
                    {
                      'data': 'Encaixe',
                      'data_field': 'FIT',
                    },
                    {
                      'data': 'Reagendamento',
                      'data_field': 'RESQUEDULE',
                    },
                  ],
                  onChanged: (dynamic val) {
                    switch (widget.dataTestModel.tiles[index].type) {
                      case 'phone':
                        appointmentMap[widget.dataTestModel.tiles[index].type] =
                            '+$val';
                        break;
                      default:
                        appointmentMap[widget.dataTestModel.tiles[index].type] =
                            val;
                        break;
                    }
                    if (kDebugMode) print('val: $val');
                    if (kDebugMode)
                      print(
                          '${widget.dataTestModel.tiles[index].type} = ${appointmentMap[widget.dataTestModel.tiles[index].type]} \n ');
                  },
                  edit: widget.dataTestModel.edit,
                  type: widget.dataTestModel.tiles[index].type,
                  data: widget.dataTestModel.tiles[index].data,
                  title: widget.dataTestModel.tiles[index].title,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(26, 32, 56, 23),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Provider.of<AppointmentProvider>(context, listen: false)
                        .incAppointmentPage(1);
                  },
                  child: Text(
                    '< Voltar',
                    style: TextStyle(
                        color: Color(0xff0000DA), fontSize: hXD(20, context)),
                  ),
                ),
                Visibility(
                  visible: widget.dataTestModel.edit,
                  child: BlueButton(
                    text: 'Salvar',
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        await FirebaseFirestore.instance
                            .collection('appointments')
                            .doc(widget.appointmentModel.id)
                            .update(appointmentMap);
                        await FirebaseFirestore.instance
                            .collection('patients')
                            .doc(widget.appointmentModel.patientId)
                            .collection('appointments')
                            .doc(widget.appointmentModel.id)
                            .update(appointmentMap);
                        Provider.of<AppointmentProvider>(context, listen: false)
                            .incAppointmentPage(1);
                      } else {
                        Fluttertoast.showToast(
                          webPosition: 'center',
                          webBgColor:
                              "linear-gradient(to bottom, #41c3b3, #21bcce)",
                          msg: 'Verifique os campos novamente',
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
