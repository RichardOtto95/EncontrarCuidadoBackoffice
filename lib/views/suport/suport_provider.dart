import 'package:back_office/views/suport/models/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class SuportProvider extends ChangeNotifier {
  User user = FirebaseAuth.instance.currentUser;
  ChatModel chat;
  ChatModel chatPage;

  String _txt;
  DocumentSnapshot chatDocument;

  setChaDocument(_chatDocument) {
    chatDocument = _chatDocument;
    notifyListeners();
  }

  DocumentSnapshot get c => chatDocument;
  ChatModel get cat => chat;
  ChatModel get chhat => chatPage;

  String get txt => _txt;
  incChatt(_chatt) {
    chatDocument = _chatt;
    notifyListeners();
  }

  incChat(_chat) {
    chat = _chat;
    notifyListeners();
  }

  bool _estornarView = false;

  bool get estornarView => _estornarView;

  incEstornarPage(estornarView) {
    _estornarView = estornarView;
    notifyListeners();
  }
}
