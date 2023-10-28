import 'package:back_office/shared/utilities.dart';
import 'package:back_office/views/suport/models/chat_model.dart';
import 'package:back_office/views/suport/widgets/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final ChatModel chatModel;
  final Function showChat;
  const ChatTile({Key key, this.chatModel, this.showChat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
          hoverColor: Color(0xff707070).withOpacity(.1),
          splashColor: Color(0xff707070).withOpacity(.3),
          onTap: showChat,
          child: chatModel.doctorId != null
              ? Container(
                  height: 82,
                  width: 350,
                  padding: EdgeInsets.symmetric(vertical: 9),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xff707070).withOpacity(.3),
                      ),
                    ),
                  ),
                  child: FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('doctors')
                          .doc(chatModel.doctorId)
                          .get(),
                      builder: (context, snapshot) {
                        DocumentSnapshot user = snapshot.data;
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Row(
                            children: [
                              CircleAvatar(
                                radius: 27,
                                backgroundImage: user.get('avatar') == null
                                    ? AssetImage('assets/img/defaultUser.png')
                                    : NetworkImage(user.get('avatar')),
                              ),
                              SizedBox(width: 10),
                              FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection('support')
                                      .doc(chatModel.id)
                                      .collection('messages')
                                      .orderBy('created_at', descending: true)
                                      .limit(1)
                                      .get(),
                                  builder: (context, msgSnap) {
                                    QuerySnapshot msg = msgSnap.data;
                                    String lastMsg = '';
                                    if (!msgSnap.hasData) {
                                      return Center(child: Container());
                                    }
                                    if (msg.docs.isNotEmpty &&
                                        msg.docs.first.get('text') != null) {
                                      lastMsg = msg.docs.first.get('text');
                                    }
                                    if (msg.docs.isNotEmpty &&
                                        msg.docs.first.get('image') != null) {
                                      lastMsg = msg.docs.first.get('image');
                                    }
                                    if (msg.docs.isNotEmpty &&
                                        msg.docs.first.get('file') != null) {
                                      lastMsg = msg.docs.first.get('file');
                                    }

                                    return Flexible(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: wXD(150, context),
                                            child: Text(
                                              '${user.get('username')}',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff000000),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            lastMsg.isNotEmpty
                                                ? '$lastMsg'
                                                : '',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff000000),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                              Flexible(
                                fit: FlexFit.loose,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: NotificationWidget(
                                    notifications: '${chatModel.supNotific}',
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                )
              : Container(
                  height: 82,
                  width: 350,
                  padding: EdgeInsets.symmetric(vertical: 9),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xff707070).withOpacity(.3),
                      ),
                    ),
                  ),
                  child: FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('patients')
                          .doc(chatModel.patientId)
                          .get(),
                      builder: (context, snapshot) {
                        DocumentSnapshot user = snapshot.data;

                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Row(
                            children: [
                              CircleAvatar(
                                radius: 27,
                                backgroundImage: user.get('avatar') == null
                                    ? AssetImage('assets/img/defaultUser.png')
                                    : NetworkImage(user.get('avatar')),
                              ),
                              SizedBox(width: 10),
                              FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection('support')
                                      .doc(chatModel.id)
                                      .collection('messages')
                                      .orderBy('created_at', descending: true)
                                      .limit(1)
                                      .get(),
                                  builder: (context, msgSnap) {
                                    QuerySnapshot msg = msgSnap.data;
                                    String lastMsg = '';
                                    if (!msgSnap.hasData) {
                                      return Center(child: Container());
                                    }
                                    if (msg.docs.isNotEmpty &&
                                        msg.docs.first.get('text') != null) {
                                      lastMsg = msg.docs.first.get('text');
                                    }
                                    if (msg.docs.isNotEmpty &&
                                        msg.docs.first.get('image') != null) {
                                      lastMsg = msg.docs.first.get('image');
                                    }
                                    if (msg.docs.isNotEmpty &&
                                        msg.docs.first.get('file') != null) {
                                      lastMsg = msg.docs.first.get('file');
                                    }

                                    return Flexible(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: wXD(150, context),
                                            child: Text(
                                              '${user.get('username')}',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff000000),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            lastMsg.isNotEmpty
                                                ? '$lastMsg'
                                                : '',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff000000),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                              Flexible(
                                fit: FlexFit.loose,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: NotificationWidget(
                                    notifications: '${chatModel.supNotific}',
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                ),
          // ),
        ));
  }
}
