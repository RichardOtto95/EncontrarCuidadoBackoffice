import 'package:back_office/shared/models/data_models.dart';

import 'post_model.dart';

class PostDataTestModel {
  final PostModel postModel;

  PostDataTestModel(this.postModel);
}

List<List> getPostFilters() => [
      ['ID', 'id', 'posts', 'id'],
      ['Id do  médico', 'dr_id', 'posts', 'dr_id'],
      ['Data de criação', 'created_at', 'posts', 'created_at'],
      ['Curtidas', 'like_count', 'posts', 'like_count'],
      ['Texto', 'text', 'posts', 'text'],
      ['Status', 'status', 'posts', 'status'],
    ];

DataTestModel getPostData(
    String title, Map<String, dynamic> postMap, bool edit) {
  List<TileTestModel> postData = [
    TileTestModel('ID: ', postMap['id'], 'id'),
    TileTestModel('Id do  médico: ', postMap['dr_id'], 'dr_id'),
    TileTestModel('Data de criação: ', postMap['created_at'], 'created_at'),
    TileTestModel('Curtidas: ', postMap['like_count'], 'like_count'),
    TileTestModel('Texto : ', postMap['text'], 'text'),
    TileTestModel('Status: ', postMap['status'], 'status'),
    // TileTestModel('Imagem: ', postMap['bgr_image'], 'bgr_image'),
  ];
  DataTestModel dataModel =
      DataTestModel(edit, tiles: postData, title: '$title');
  return dataModel;
}
