import 'package:back_office/shared/models/data_models.dart';
import 'package:back_office/shared/utilities.dart';
import 'package:back_office/shared/widgets/blue_button.dart';
import 'package:back_office/shared/widgets/central_container.dart';
import 'package:back_office/shared/widgets/data_tile.dart';
import 'package:back_office/views/posts/models/post_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../post_provider.dart';

class PostData extends StatelessWidget {
  final DataTestModel dataTestModel;
  final PostModel postModel;

  const PostData({
    Key key,
    this.dataTestModel,
    this.postModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    Map<String, dynamic> postMap = {};
    if (kDebugMode) print('imagem ${postModel.image}');
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
                  onTap: () => Provider.of<PostProvider>(context, listen: false)
                      .incPostPage(1),
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
              ],
            ),
          ),
          Form(
            key: _formKey,
            child: Column(children: [
              ...List.generate(
                dataTestModel.tiles.length,
                (index) => DataTestTile(
                  statuses: [
                    {
                      'data': 'Reportada',
                      'data_field': 'REPORTED',
                    },
                    {
                      'data': 'Visível',
                      'data_field': 'VISIBLE',
                    },
                    {
                      'data': 'Excluída',
                      'data_field': 'DELETED',
                    },
                  ],
                  // types: [
                  //   {
                  //     'data': 'Balanço financeiro',
                  //     'data_field': 'financial_statement',
                  //   },
                  //   {
                  //     'data': 'Balanço financeiro realizado',
                  //     'data_field': 'financial_statement_done',
                  //   },
                  // ],
                  edit: dataTestModel.edit,
                  type: dataTestModel.tiles[index].type,
                  data: dataTestModel.tiles[index].data,
                  title: dataTestModel.tiles[index].title,
                  onChanged: (val) {
                    postMap[dataTestModel.tiles[index].type] = val;
                    if (kDebugMode) print('val: $val');
                    if (kDebugMode)
                      print(
                          '${dataTestModel.tiles[index].type} = ${postMap[dataTestModel.tiles[index].type]} \n ');
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: postModel.image == null
                      ? Container(
                          width: 640,
                          height: 360,
                          color: Colors.grey.shade500,
                        )
                      : CachedNetworkImage(
                          imageUrl: postModel.image,
                          width: 640,
                          height: 360,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              // Center(
              //   child: Container(
              //     height: MediaQuery.of(context).size.height * .3,
              //     width: MediaQuery.of(context).size.width * .9,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.all(
              //         Radius.circular(18),
              //       ),
              //     ),
              //     child: ClipRRect(
              //       borderRadius: BorderRadius.circular(18),
              //       child: CachedNetworkImage(
              //         fit: BoxFit.cover,
              //         imageUrl: postModel.image,
              //         placeholder: (context, url) =>
              //             Center(child: CircularProgressIndicator()),
              //         errorWidget: (context, url, error) =>
              //             Image.asset('assets/img/defaultUser.png'),
              //       ),
              //     ),
              //   ),
              // ),
            ]),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(26, 32, 56, 23),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Provider.of<PostProvider>(context, listen: false)
                        .incPostPage(1);
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
                      if (kDebugMode) print('Post Id: ${postModel.id}');
                      if (_formKey.currentState.validate()) {
                        FirebaseFirestore.instance
                            .collection('posts')
                            .doc(postModel.id)
                            .update(postMap);
                        FirebaseFirestore.instance
                            .collection('doctors')
                            .doc(postModel.doctorId)
                            .collection('feed')
                            .where('id', isEqualTo: postModel.id)
                            .get()
                            .then((value) =>
                                value.docs.first.reference.update(postMap));
                        FirebaseFirestore.instance
                            .collection('patients')
                            .get()
                            .then((patients) =>
                                patients.docs.forEach((patient) {
                                  patient.reference
                                      .collection('feed')
                                      .get()
                                      .then((posts) =>
                                          posts.docs.forEach((post) {
                                            if (post['id'] == postModel.id) {
                                              post.reference.update(postMap);
                                            }
                                          }));
                                }));
                        // .doc(postModel.doctorId)
                        // .collection('posts')
                        // .where('id', isEqualTo: postModel.id)
                        // .get()
                        // .then((value) =>
                        //     value.docs.first.reference.update(postMap));

                        Provider.of<PostProvider>(context, listen: false)
                            .incPostPage(1);
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
