import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String author;
  final Timestamp createdAt;
  final String data;
  final String extension;
  final String file;
  final String id;
  final String text;
  final String image;
  final String usrDownload;
  final String spDownload;

  MessageModel(
      {this.author,
      this.createdAt,
      this.data,
      this.extension,
      this.file,
      this.id,
      this.text,
      this.image,
      this.usrDownload,
      this.spDownload});

  factory MessageModel.fromDocument(DocumentSnapshot doc) {
    return MessageModel(
      author: doc['author'],
      createdAt: doc['created_at'],
      data: doc['data'],
      extension: doc['extension'],
      file: doc['file'],
      id: doc['id'],
      text: doc['text'],
      image: doc['image'],
      usrDownload: doc['user_download'],
      spDownload: doc['sp_download'],
    );
  }
}
