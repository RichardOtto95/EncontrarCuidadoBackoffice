import 'package:back_office/shared/models/data_models.dart';
import 'package:back_office/shared/utilities.dart';
import 'package:back_office/shared/widgets/blue_button.dart';
import 'package:back_office/shared/widgets/central_container.dart';
import 'package:back_office/shared/widgets/data_tile.dart';
import 'package:back_office/shared/widgets/data_tile_provider.dart';
import 'package:back_office/views/doctors/models/doctor_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:flutter/foundation.dart';
import '../doctors_provider.dart';

class DoctorData extends StatelessWidget {
  final DataTestModel dataTestModel;
  final DoctorModel doctorModel;

  DoctorData({
    Key key,
    this.dataTestModel,
    this.doctorModel,
  }) : super(key: key);

  final Map<String, dynamic> doctorMap = {};

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) print('doctorModel: ${DoctorModel().toJson(doctorModel)}');
    final _formKey = GlobalKey<FormState>();

    //if(kDebugMode) print('doctorModel: ${DoctorModel().toJson(doctorModel)}');

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
                      Provider.of<DoctorProvider>(context, listen: false)
                          .incDoctorPage(1),
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
                  child: doctorModel.avatar == null
                      ? Image.asset(
                          'assets/img/defaultUser.png',
                          height: 55,
                          width: 55,
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: doctorModel.avatar,
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
            child: Consumer<DataTileProvider>(builder: (context, value, child) {
              return Column(
                children: List.generate(
                  dataTestModel.tiles.length,
                  (index) => DataTestTile(
                    state: value.stateSelected,
                    statuses: [
                      {
                        'data': 'Ativo',
                        'data_field': 'ACTIVE',
                      },
                      // {
                      //   'data': 'Inativo',
                      //   'data_field': 'inactive',
                      // },
                      {
                        'data': 'Bloqueado',
                        'data_field': 'BLOCKED',
                      },
                      // {
                      //   'data': 'Expirado',
                      //   'data_field': 'expired',
                      // },
                    ],
                    types: [
                      {
                        'data': 'Doutor(a)',
                        'data_field': 'DOCTOR',
                      },
                      {
                        'data': 'Secretário(a)',
                        'data_field': 'SECRETARY',
                      },
                    ],
                    onChanged: (dynamic val) {
                      switch (dataTestModel.tiles[index].type) {
                        case 'phone':
                          this.doctorMap[dataTestModel.tiles[index].type] =
                              '+$val';
                          break;
                        case 'state':
                          value.setStateSelected(val);
                          value.setCitySelected(null);
                          this.doctorMap['city'] = null;
                          this.doctorMap[dataTestModel.tiles[index].type] = val;
                          break;
                        case 'city':
                          value.setCitySelected(val);
                          this.doctorMap[dataTestModel.tiles[index].type] = val;
                          break;
                        case 'speciality_name':
                          if (kDebugMode) print(val);
                          this.doctorMap['speciality_name'] = val.first;
                          this.doctorMap['speciality'] = val.last;
                          break;
                        default:
                          this.doctorMap[dataTestModel.tiles[index].type] = val;
                          break;
                      }
                      if (kDebugMode) print('val: $val');
                      if (kDebugMode) print('map: ${this.doctorMap}');
                      //if(kDebugMode) print(
                      //     '${dataTestModel.tiles[index].type} = ${this.doctorMap[dataTestModel.tiles[index].type]} \n');
                    },
                    edit: dataTestModel.edit,
                    type: dataTestModel.tiles[index].type,
                    data: dataTestModel.tiles[index].data,
                    title: dataTestModel.tiles[index].title,
                  ),
                ),
              );
            }),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(26, 32, 56, 23),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Provider.of<DoctorProvider>(context, listen: false)
                        .incDoctorPage(1);
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
                      if (_formKey.currentState.validate()) {
                        if (kDebugMode) print('doctor map: $this.doctorMap');
                        FirebaseFirestore.instance
                            .collection('doctors')
                            .doc(doctorModel.id)
                            .update(this.doctorMap);
                        Provider.of<DoctorProvider>(context, listen: false)
                            .incDoctorPage(1);
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
