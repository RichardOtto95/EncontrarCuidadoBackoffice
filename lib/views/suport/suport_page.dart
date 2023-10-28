// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:back_office/shared/utilities.dart';
import 'package:back_office/views/home/widgets/page_title.dart';
import 'package:back_office/views/suport/models/message_model.dart';
import 'package:back_office/views/suport/suport_provider.dart';
import 'package:back_office/views/suport/widgets/chat_tile.dart';
import 'package:back_office/views/suport/widgets/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'models/chat_model.dart';
import 'package:flutter/foundation.dart';

class Suport extends StatefulWidget {
  @override
  _SuportState createState() => _SuportState();
}

class _SuportState extends State<Suport> {
  TextEditingController txtcontrol = TextEditingController();
  FocusNode focus = FocusNode();
  SuportProvider suportProvider = SuportProvider();
  Stream support;
  String supportAvatar;

  @override
  void initState() {
    spAvatar();
    support = FirebaseFirestore.instance.collection('support').snapshots();
    super.initState();
  }

  spAvatar() {
    FirebaseFirestore.instance.collection('info').get().then((value) {
      supportAvatar = value.docs.first.get('support_avatar');
    });
  }

  sendMsg(String txt, String id, ChatModel chmd) async {
    String userId;
    String avatar;

    if (chmd.doctorId != null) {
      userId = chmd.doctorId;
      DocumentSnapshot duserDoc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(userId)
          .get();
      avatar = duserDoc.get('avatar');
    }
    if (chmd.patientId != null) {
      userId = chmd.patientId;
      DocumentSnapshot puserDoc = await FirebaseFirestore.instance
          .collection('patients')
          .doc(userId)
          .get();
      avatar = puserDoc.get('avatar');
    }

    await FirebaseFirestore.instance
        .collection('support')
        .doc(id)
        .update({'updated_at': Timestamp.now()});

    if (avatar == null) {
      avatar =
          'https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png';
    }

    DocumentSnapshot supportDoc =
        await FirebaseFirestore.instance.collection('support').doc(id).get();

    await supportDoc.reference.collection('messages').add({
      "author": 'support_team',
      "text": txt,
      "user_download": 'false',
      "sp_download": 'false',
      "extension": null,
      "data": null,
      "id": null,
      "file": null,
      "image": null,
      "created_at": Timestamp.now(),
    }).then((value) {
      value.update({'id': value.id});
    });

    await sendNotification(text: "Suporte: $txt", supportDoc: supportDoc);

    handleNotifications(id, true);
  }

  uploadFile(
      {@required Function(File file, String name, String type) onSelected}) {
    InputElement uploadInput = FileUploadInputElement()
      ..accept = '.pdf, .PDF, image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        String type = file.type.split('/').last;
        onSelected(file, file.name, type);
      });
    });
  }

  uploadToStorage(String supportId) async {
    await uploadFile(onSelected: (file, name, type) async {
      StorageReference storageRef =
          storage().ref().child('chat/$supportId/files/$name');

      UploadTaskSnapshot uploadTaskSnapshot = await storageRef.put(file).future;

      await uploadTaskSnapshot.ref.getDownloadURL().then((downloadURL) async {
        DocumentSnapshot supportDoc = await FirebaseFirestore.instance
            .collection('support')
            .doc(supportId)
            .get();

        supportDoc.reference.collection('messages').add({
          "author": 'support_team',
          "file": name,
          "image": null,
          "text": null,
          "id": null,
          "user_download": 'false',
          "sp_download": 'false',
          "data": downloadURL.toString(),
          "extension": type,
          "created_at": Timestamp.now(),
        }).then((value) async {
          await value.update({'id': value.id});
        });
        await sendNotification(
            text: "Suporte: [Arquivo]", supportDoc: supportDoc);
      });
      await FirebaseFirestore.instance
          .collection('support')
          .doc(supportId)
          .update({'updated_at': Timestamp.now()});
    });
  }

  void handleNotifications(String id, bool increase) {
    int usrnotf = 0;
    if (increase) {
      FirebaseFirestore.instance
          .collection('support')
          .doc(id)
          .get()
          .then((value) {
        if (value.get('sp_notifications') != null) {
          usrnotf = value.get('sp_notifications') + 1;
        }

        value.reference.update({
          'usr_notifications': usrnotf,
          'updated_at': Timestamp.now(),
        });
      });
    } else {
      FirebaseFirestore.instance
          .collection('support')
          .doc(id)
          .get()
          .then((value) {
        value.reference.update({
          'sp_notifications': 0,
        });
      });
    }
  }

  sendNotification({String text, DocumentSnapshot supportDoc}) async {
    //HttpsCallable
    var callable =
        FirebaseFunctions.instance.httpsCallable('supportNotification');
    if (kDebugMode) print('doctor_id: ${supportDoc['doctor_id']}');
    if (kDebugMode) print('patient_id: ${supportDoc['patient_id']}');
    if (kDebugMode) print('text: $text');
    if (supportDoc['doctor_id'] == null) {
      callable.call({
        'text': text,
        'receiverId': supportDoc['patient_id'],
        'collection': 'patients',
      });
    } else {
      callable.call({
        'text': text,
        'receiverId': supportDoc['doctor_id'],
        'collection': 'doctors',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: hXD(790, context) - hXD(32, context) - 68,
      width: wXD(1280, context) - wXD(303, context),
      margin: EdgeInsets.fromLTRB(
          wXD(48, context), hXD(32, context), wXD(48, context), 0),
      decoration: BoxDecoration(
        color: Color(0xfffafafa),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      alignment: Alignment.center,
      child: ChangeNotifierProvider<SuportProvider>(
          create: (context) => SuportProvider(),

          // stream: null,
          builder: (context, snapshot) {
            return Consumer<SuportProvider>(builder: (context, value, child) {
              return StreamBuilder(
                  stream: support,
                  builder: (context, chatsSnap) {
                    String input;
                    if (!chatsSnap.hasData) {
                      return Container(
                        child: Container(),
                      );
                    } else {
                      QuerySnapshot qs = chatsSnap.data;
                      List<DocumentSnapshot> lqs = qs.docs;

                      return StatefulBuilder(builder: (context, stateset) {
                        return Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          color: Color(0xff707070)
                                              .withOpacity(.3)))),
                              height: hXD(800, context),
                              width: wXD(230, context),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PageTitle(title: 'Suporte'),
                                  lqs.isEmpty
                                      ? Center(
                                          child: Container(
                                            padding: EdgeInsets.only(top: 100),
                                            child: Text(
                                                'Sem chats para serem listados'),
                                          ),
                                        )
                                      : Expanded(
                                          child: SingleChildScrollView(
                                            child: Column(
                                                children: lqs.map((e) {
                                              ChatModel chatModel;
                                              bool hasData = false;
                                              // try {
                                              chatModel =
                                                  ChatModel.fromDocument(e);
                                              hasData = true;
                                              // } catch (e) {
                                              //  if(kDebugMode) print("Erro: $e");
                                              //   hasData = false;
                                              // }
                                              return hasData
                                                  ? ChatTile(
                                                      showChat: () {
                                                        Provider.of<SuportProvider>(
                                                                context,
                                                                listen: false)
                                                            .setChaDocument(e);
                                                        if (kDebugMode)
                                                          print(
                                                              'value.chatDocument: ${value.chatDocument.id}');
                                                        value.chatPage =
                                                            ChatModel
                                                                .fromDocument(
                                                                    e);
                                                        handleNotifications(
                                                            e.id, false);
                                                      },
                                                      chatModel: chatModel,
                                                    )
                                                  : Container();
                                            }).toList()),
                                          ),
                                        )
                                ],
                              ),
                            ),
                            Container(
                                width: wXD(746, context),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    PageTitle(title: 'Chat'),
                                    Consumer<SuportProvider>(
                                        builder: (context, value, child) {
                                      return Expanded(
                                          child: value.chatDocument == null
                                              ? Center(
                                                  child: Text(
                                                      'Nenhum chat selecionado'))
                                              : StreamBuilder(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('support')
                                                      .doc(
                                                          value.chatDocument.id)
                                                      .collection('messages')
                                                      .orderBy('created_at',
                                                          descending: true)
                                                      .snapshots(),
                                                  builder:
                                                      (context, messagesSnap) {
                                                    if (!messagesSnap.hasData) {
                                                      return Center(
                                                          child: Container());
                                                    }
                                                    QuerySnapshot msgSnap =
                                                        messagesSnap.data;
                                                    List<DocumentSnapshot> lds =
                                                        msgSnap.docs;
                                                    return StreamBuilder(
                                                        stream: value
                                                                    .chatDocument
                                                                    .get(
                                                                        'doctor_id') !=
                                                                null
                                                            ? FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'doctors')
                                                                .doc(value
                                                                    .chatDocument
                                                                    .get(
                                                                        'doctor_id'))
                                                                .snapshots()
                                                            : FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'patients')
                                                                .doc(value
                                                                    .chatDocument
                                                                    .get(
                                                                        'patient_id'))
                                                                .snapshots(),
                                                        builder: (context,
                                                            snapshot) {
                                                          DocumentSnapshot
                                                              user =
                                                              snapshot.data;

                                                          if (!snapshot
                                                              .hasData) {
                                                            return Center(
                                                                child:
                                                                    CircularProgressIndicator());
                                                          }
                                                          String name = user
                                                              .get('username');
                                                          return ListView
                                                              .builder(
                                                                  itemCount:
                                                                      msgSnap
                                                                          .docs
                                                                          .length,
                                                                  reverse: true,
                                                                  shrinkWrap:
                                                                      true,
                                                                  scrollDirection:
                                                                      Axis
                                                                          .vertical,
                                                                  itemBuilder:
                                                                      (context,
                                                                          idx) {
                                                                    return Message(
                                                                      userAvatar:
                                                                          user.get(
                                                                              'avatar'),
                                                                      supportAvatar:
                                                                          supportAvatar,
                                                                      messageModel:
                                                                          MessageModel.fromDocument(
                                                                              lds[idx]),
                                                                      chatModel:
                                                                          value
                                                                              .chatPage,
                                                                      userId:
                                                                          'support_team',
                                                                      userName:
                                                                          name,

                                                                      //  author:  ,
                                                                    );
                                                                  });
                                                        });
                                                  }));
                                    }),
                                    value.chatDocument == null
                                        ? Container()
                                        : Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: hXD(10, context)),
                                            child: Row(
                                              children: [
                                                Spacer(),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 6),
                                                  width: wXD(620, context),
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color:
                                                            Color(0xff707070),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  30))),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: TextFormField(
                                                    focusNode: focus,
                                                    controller: txtcontrol,
                                                    onChanged: (t) {
                                                      input = t;
                                                    },
                                                    onFieldSubmitted: (key) {
                                                      sendMsg(
                                                          input,
                                                          value.chatDocument.id,
                                                          value.chatPage);
                                                      txtcontrol.clear();
                                                      input = null;
                                                      focus.requestFocus();
                                                    },
                                                    decoration: InputDecoration
                                                        .collapsed(
                                                            hintText:
                                                                'Digite uma mensagem...'),
                                                  ),
                                                ),
                                                Spacer(),
                                                InkWell(
                                                  onTap: () {
                                                    // setState(() {
                                                    sendMsg(
                                                        input,
                                                        value.chatDocument.id,
                                                        value.chatPage);

                                                    txtcontrol.clear();
                                                    input = null;
                                                    // });
                                                  },
                                                  child: Stack(
                                                    alignment:
                                                        Alignment.topRight,
                                                    children: [
                                                      Container(
                                                        height: 50,
                                                        width: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color:
                                                              Color(0xff00CCF2),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 7,
                                                        right: 7,
                                                        child: Transform.rotate(
                                                          angle: math.pi / -4,
                                                          child: Icon(
                                                            Icons.send_outlined,
                                                            size: 30,
                                                            color: Color(
                                                                0xfffafafa),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Spacer(),
                                                InkWell(
                                                  onTap: () {
                                                    uploadToStorage(
                                                        value.chatPage.id);
                                                  },
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Container(
                                                        height: 50,
                                                        width: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color:
                                                              Color(0xff00CCF2),
                                                        ),
                                                      ),
                                                      // Positioned(
                                                      //   top: 7,
                                                      //   right: 7,
                                                      //   child:
                                                      Transform.rotate(
                                                        angle: math.pi / -4,
                                                        child: Icon(
                                                          Icons
                                                              .attachment_outlined,
                                                          size: 30,
                                                          color:
                                                              Color(0xfffafafa),
                                                        ),
                                                      ),

                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                          )
                                  ],
                                ))
                          ],
                        );
                      });
                    }
                  });
            });
          }),
    );
  }
}
