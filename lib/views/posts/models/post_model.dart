import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  PostModel({
    this.doctorName,
    this.likeCount,
    this.id,
    this.doctorId,
    this.createdAt,
    this.text,
    this.status,
    this.image,
  });
  final String image;
  final Timestamp createdAt;
  final String doctorId;
  final String doctorName;
  final String id;
  final int likeCount;
  String status;
  final String text;

  factory PostModel.fromDocument(Map<String, dynamic> doc) {
    return PostModel(
      id: doc['id'],
      doctorId: doc['dr_id'],
      createdAt: doc['created_at'],
      text: doc['text'],
      status: doc['status'],
      image: doc['bgr_image'],
      doctorName: doc['dr_name'],
      likeCount: doc['like_count'],
    );
  }

  Map<String, dynamic> toJson(PostModel model) => {
        'id': model.id,
        'dr_id': model.doctorId,
        'created_at': model.createdAt,
        'text': model.text,
        'status': model.status,
        'bgr_image': model.image,
        'dr_name': model.doctorName,
        'like_count': model.likeCount,
      };
}

class PostGridModel {
  final bool selected;
  final PostModel postModel;
  PostGridModel(this.selected, this.postModel);
}
