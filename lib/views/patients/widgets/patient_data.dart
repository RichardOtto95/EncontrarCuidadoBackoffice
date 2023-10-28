import 'package:back_office/shared/models/data_models.dart';
import 'package:back_office/shared/utilities.dart';
import 'package:back_office/shared/widgets/blue_button.dart';
import 'package:back_office/shared/widgets/central_container.dart';
import 'package:back_office/shared/widgets/data_tile.dart';
import 'package:back_office/shared/widgets/data_tile_provider.dart';
import 'package:back_office/views/patients/models/patient_model.dart';
import 'package:back_office/views/patients/patient_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PatientData extends StatelessWidget {
  final DataTestModel dataTestModel;
  final PatientModel patientModel;

  const PatientData({
    Key key,
    this.patientModel,
    this.dataTestModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    List<Map<String, String>> statuses = [
      {
        'data': 'Ativo',
        'data_field': 'ACTIVE',
      },
      {
        'data': 'Bloqueado',
        'data_field': 'BLOCKED',
      },
    ];
    if (patientModel.responsibleId != null) {
      statuses.add(
        {
          'data': 'Removido',
          'data_field': 'REMOVED',
        },
      );
    }
    Map<String, dynamic> patientMap = {};
    if (kDebugMode) print('$patientMap');
    // context.read<PatientProvider>().setStateSelected(patientModel.state);
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
                      Provider.of<PatientProvider>(context, listen: false)
                          .incPatientPage(1),
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
                  '${dataTestModel.title}',
                  style: TextStyle(
                    fontSize: 28,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: patientModel.avatar == null
                      ? Image.asset(
                          'assets/img/defaultUser.png',
                          height: 55,
                          width: 55,
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: patientModel.avatar,
                          width: 55,
                          height: 55,
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(width: 40)
              ],
            ),
          ),
          Form(
              key: _formKey,
              child:
                  Consumer<DataTileProvider>(builder: (context, value, child) {
                return Column(
                  children: List.generate(
                    dataTestModel.tiles.length,
                    (index) => DataTestTile(
                      module: 'patient',
                      state: value.stateSelected,
                      statuses: statuses,
                      types: [
                        {
                          'data': 'Titular',
                          'data_field': 'HOLDER',
                        },
                        {
                          'data': 'Dependente',
                          'data_field': 'DEPENDENT',
                        },
                      ],
                      onChanged: (dynamic val) {
                        if (val == '') {
                          patientMap.remove(dataTestModel.tiles[index].type);
                        } else {
                          switch (dataTestModel.tiles[index].type) {
                            case 'phone':
                              patientMap[dataTestModel.tiles[index].type] =
                                  '+$val';
                              break;
                            case 'state':
                              value.setStateSelected(val);
                              value.setCitySelected(null);
                              patientMap['city'] = null;
                              patientMap[dataTestModel.tiles[index].type] = val;
                              break;
                            case 'city':
                              value.setCitySelected(val);
                              patientMap[dataTestModel.tiles[index].type] = val;
                              break;
                            default:
                              patientMap[dataTestModel.tiles[index].type] = val;
                              break;
                          }
                          if (kDebugMode) print('val: $val');
                          if (kDebugMode)
                            print(
                                '${dataTestModel.tiles[index].type} = ${patientMap[dataTestModel.tiles[index].type]} \n');
                          if (kDebugMode) print('$patientMap \n ');
                        }
                      },
                      edit: dataTestModel.edit,
                      type: dataTestModel.tiles[index].type,
                      data: dataTestModel.tiles[index].data,
                      title: dataTestModel.tiles[index].title,
                    ),
                  ),
                );
              })),
          Padding(
            padding: EdgeInsets.fromLTRB(26, 32, 56, 23),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Provider.of<PatientProvider>(context, listen: false)
                        .incPatientPage(1);
                  },
                  child: Text(
                    '< Voltar',
                    style: TextStyle(
                        color: Color(0xff0000DA), fontSize: hXD(20, context)),
                  ),
                ),
                Visibility(
                  visible: dataTestModel.edit,
                  child: BlueButton(
                    text: 'Salvar',
                    onTap: () {
                      if (kDebugMode)
                        print('patientModel.id: ${patientModel.id}');
                      if (kDebugMode) print('patientMap: $patientMap');
                      if (_formKey.currentState.validate()) {
                        if (kDebugMode) print('Patient Map $patientMap');
                        FirebaseFirestore.instance
                            .collection('patients')
                            .doc(patientModel.id)
                            .update(patientMap);
                        Provider.of<PatientProvider>(context, listen: false)
                            .incPatientPage(1);
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
