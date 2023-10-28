import 'package:back_office/shared/models/data_models.dart';
import 'package:back_office/shared/utilities.dart';
import 'package:back_office/shared/widgets/blue_button.dart';
import 'package:back_office/shared/widgets/central_container.dart';
import 'package:back_office/shared/widgets/data_tile.dart';
import 'package:back_office/views/ratings/models/rating_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import '../rating_provider.dart';

class RatingData extends StatelessWidget {
  final DataTestModel dataTestModel;
  final RatingModel ratingModel;

  const RatingData({
    Key key,
    this.dataTestModel,
    this.ratingModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    Map<String, dynamic> ratingMap = {};
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
                      Provider.of<RatingProvider>(context, listen: false)
                          .incRatingPage(1),
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
                  child: ratingModel.photo == null
                      ? Image.asset(
                          'assets/img/defaultUser.png',
                          height: 55,
                          width: 55,
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: ratingModel.photo,
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
            child: Column(
              children: List.generate(
                dataTestModel.tiles.length,
                (index) => DataTestTile(
                  statuses: [
                    {
                      'data': 'Visível',
                      'data_field': 'VISIBLE',
                    },
                    {
                      'data': 'Reportada',
                      'data_field': 'REPORTED',
                    },
                    {
                      'data': 'Inativo',
                      'data_field': 'INACTIVE',
                    },
                  ],
                  edit: dataTestModel.edit,
                  type: dataTestModel.tiles[index].type,
                  data: dataTestModel.tiles[index].data,
                  title: dataTestModel.tiles[index].title,
                  onChanged: (var val) {
                    ratingMap[dataTestModel.tiles[index].type] = val;
                    if (kDebugMode) print('\nval: $val');
                    if (kDebugMode)
                      print(
                          '${dataTestModel.tiles[index].type} = ${ratingMap[dataTestModel.tiles[index].type]}  ');
                  },
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
                    Provider.of<RatingProvider>(context, listen: false)
                        .incRatingPage(1);
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
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        await FirebaseFirestore.instance
                            .collection('ratings')
                            .doc(ratingModel.id)
                            .update(ratingMap);
                        try {
                          await FirebaseFirestore.instance
                              .collection('doctors')
                              .doc(ratingModel.doctorId)
                              .collection('ratings')
                              .doc(ratingModel.id)
                              .update(ratingMap);
                        } catch (e) {
                          if (kDebugMode) print(e);
                          if (e
                              .toString()
                              .contains('Requested entity was not found.')) {
                            if (kDebugMode) print('contaaaaaaaaaaaaaaains');
                            await FirebaseFirestore.instance
                                .collection('doctors')
                                .doc(ratingModel.doctorId)
                                .collection('ratings')
                                .doc(ratingModel.id)
                                .set(RatingModel().toJson(ratingModel));
                            await FirebaseFirestore.instance
                                .collection('doctors')
                                .doc(ratingModel.doctorId)
                                .collection('ratings')
                                .doc(ratingModel.id)
                                .update(ratingMap);
                          }
                        }
                        Provider.of<RatingProvider>(context, listen: false)
                            .incRatingPage(1);
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
