import 'dart:async';

import 'package:back_office/shared/utilities.dart';
import 'package:back_office/shared/widgets/blue_button.dart';
import 'package:back_office/shared/widgets/central_container.dart';
import 'package:back_office/shared/widgets/check.dart';
import 'package:back_office/shared/widgets/dialog_widget.dart';
import 'package:back_office/views/home/home_provider.dart';
import 'package:back_office/views/notifications/widgets/receiver.dart';
import 'package:back_office/views/notifications/widgets/user_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../notification_provider.dart';

class NotificationCreate extends StatefulWidget {
  @override
  _NotificationCreateState createState() => _NotificationCreateState();
}

class _NotificationCreateState extends State<NotificationCreate> {
  OverlayEntry _overlay;
  DateTime dateTime = DateTime.now();
  bool sendForAll = false;
  bool sendingNotifications = false;
  NotificationProvider notificationProvider = NotificationProvider();
  String text;
  FocusNode focusNode;
  FocusNode textFocus;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    focusNode = FocusNode();
    textFocus = FocusNode();
    super.initState();
  }

  OverlayEntry getOverlayProgressIndicator() {
    return OverlayEntry(
      builder: (context) => Container(
          color: Color(0x30000000),
          alignment: Alignment.center,
          child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider = HomeProvider();
    return Consumer<NotificationProvider>(builder: (context, value, child) {
      return CentralContainer(
        paddingBottom: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Color(0xff707070).withOpacity(.3)))),
              padding: EdgeInsets.fromLTRB(
                  wXD(22, context), hXD(23, context), 0, hXD(20, context)),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Provider.of<NotificationProvider>(context,
                            listen: false)
                        .incNotificationPage(1),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Criar notificação',
                        style: TextStyle(
                          fontSize: 28,
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Gestão das Notificações',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff707070),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: wXD(40, context),
                right: wXD(40, context),
                top: hXD(34, context),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  value.incNotificationNotify(true);
                                },
                                child: Text(
                                  'Pacientes',
                                  style: TextStyle(
                                      color: value.notificationNotify
                                          ? Color(0xff0000da)
                                          : Color(0xff212122),
                                      fontSize: 27,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              SizedBox(width: 78),
                              TextButton(
                                onPressed: () {
                                  value.incNotificationNotify(false);
                                },
                                child: Text(
                                  'Médicos',
                                  style: TextStyle(
                                      color: value.notificationNotify
                                          ? Color(0xff212122)
                                          : Color(0xff0000da),
                                      fontSize: 27,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                          AnimatedPositioned(
                            curve: Curves.decelerate,
                            duration: Duration(milliseconds: 300),
                            left: value.notificationNotify ? 0 : 198,
                            child: AnimatedContainer(
                              curve: Curves.decelerate,
                              duration: Duration(milliseconds: 300),
                              height: 2,
                              width: value.notificationNotify ? 120 : 102,
                              decoration: BoxDecoration(
                                  color: Color(0xff0000da),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7))),
                            ),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 27, right: 20),
                            child: ParameterTitle(
                              title: value.notificationNotify
                                  ? 'Todos os pacientes:'
                                  : 'Todos os médicos:',
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 2),
                            child: Check(
                              check: sendForAll,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                setState(() {
                                  sendForAll = !sendForAll;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 27),
                          child: Text(
                            'Destinatário',
                            style: TextStyle(
                                color: sendForAll
                                    ? Color(0x40000000)
                                    : Color(0xff000000),
                                fontSize: 22,
                                fontWeight: FontWeight.w400),
                          )),
                      ReceiverField(disable: sendForAll, focusNode: focusNode),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 27),
                        child: ParameterTitle(
                          title: 'Data:',
                        ),
                      ),
                      NotificationDate(
                        dateTime: dateTime,
                        onTap: () async {
                          dateTime =
                              await homeProvider.selectDate(context, dateTime);
                          setState(() {});
                          if (kDebugMode) print('datetime $dateTime');
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 27),
                        child: ParameterTitle(
                          title: 'Texto:',
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Container(
                          height: 250,
                          width: 500,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 25),
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xff707070).withOpacity(.8),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          child: TextFormField(
                            maxLines: 20,
                            focusNode: textFocus,
                            style: TextStyle(
                                color: Color(0xff707070).withOpacity(.5),
                                fontSize: 16),
                            decoration: InputDecoration.collapsed(
                                hintText:
                                    'Digite aqui a mensagem da notificação',
                                hintStyle: TextStyle(
                                    color: Color(0xff707070).withOpacity(.5),
                                    fontSize: 16)),
                            onChanged: (val) {
                              text = val;
                              if (kDebugMode) print('text: $text');
                            },
                            validator: (val) {
                              if (val == '') {
                                return 'Este campo não pode estar vazio';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        height: 600,
                        width: 350,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: sendForAll
                                ? Color(0xff707070).withOpacity(.2)
                                : Color(0xff707070).withOpacity(.8),
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: value.notificationNotify
                                ? value.patientsSelected.isEmpty
                                    ? [
                                        Center(
                                          child: Text(
                                            'Nenhum paciente selecionado',
                                            style: TextStyle(
                                              color: sendForAll
                                                  ? Color(0xff707070)
                                                      .withOpacity(.20)
                                                  : Color(0xff000000),
                                            ),
                                          ),
                                        )
                                      ]
                                    : List.generate(
                                        value.patientsSelected.length,
                                        (index) {
                                          List<Map<String, dynamic>> users =
                                              value.patientsSelected;
                                          return UserCard(
                                            disable: sendForAll,
                                            avatar: users[index]['avatar'],
                                            cpf: users[index]['cpf'],
                                            phone: users[index]['phone'],
                                            type: users[index]['type'],
                                            username: users[index]['username'],
                                            onRemove: () => value
                                                .removePatientSelected(index),
                                          );
                                        },
                                      )
                                : value.doctorsSelected.isEmpty
                                    ? [
                                        Center(
                                          child: Text(
                                            'Nenhum Doutor selecionado',
                                            style: TextStyle(
                                              color: sendForAll
                                                  ? Color(0xff707070)
                                                      .withOpacity(.20)
                                                  : Color(0xff000000),
                                            ),
                                          ),
                                        )
                                      ]
                                    : List.generate(
                                        value.doctorsSelected.length,
                                        (index) {
                                          List<Map<String, dynamic>> users =
                                              value.doctorsSelected;
                                          return UserCard(
                                            disable: sendForAll,
                                            avatar: users[index]['avatar'],
                                            cpf: users[index]['cpf'],
                                            phone: users[index]['phone'],
                                            type: users[index]['type'],
                                            username: users[index]['username'],
                                            onRemove: () =>
                                                value.removeDoctorSelected(value
                                                    .doctorsSelected[index]),
                                          );
                                        },
                                      ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: InkWell(
                          onTap: () => value.notificationNotify
                              ? value.cleanPatientsSelected()
                              : value.cleanDoctorsSelected(),
                          child: Icon(
                            Icons.close,
                            size: 23,
                            color: sendForAll
                                ? Color(0xffDB2828).withOpacity(.3)
                                : Color(0xffDB2828),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: sendForAll,
                        child: Container(
                          height: 600,
                          width: 350,
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            color: Color(0xff707070).withOpacity(.02),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(26, 32, 56, 23),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Provider.of<NotificationProvider>(context, listen: false)
                          .incNotificationPage(1);
                    },
                    child: Text(
                      '< Voltar',
                      style: TextStyle(
                          color: Color(0xff0000DA), fontSize: hXD(20, context)),
                    ),
                  ),
                  BlueButton(
                    text: 'Programar',
                    onTap: () async {
                      if (kDebugMode)
                        print('value.userSelected ${value.doctorsSelected}');
                      if (kDebugMode)
                        print('value.userSelected ${value.patientsSelected}');
                      if (value.notificationNotify &&
                          value.patientsSelected.isEmpty &&
                          !sendForAll) {
                        showDialog(
                          useRootNavigator: true,
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            return DialogAlert(
                              title:
                                  'Selecione pelo menos um paciênte ou a opção de enviar para todos!',
                              onConfirm: () {
                                Navigator.pop(context);
                                focusNode.requestFocus();
                              },
                            );
                          },
                        );
                      } else if (!value.notificationNotify &&
                          value.doctorsSelected.isEmpty &&
                          !sendForAll) {
                        showDialog(
                          useRootNavigator: true,
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            return DialogAlert(
                              title:
                                  'Selecione pelo menos um doutor(a) ou a opção de enviar para todos!',
                              onConfirm: () {
                                Navigator.pop(context);
                                focusNode.requestFocus();
                              },
                            );
                          },
                        );
                      } else if (!_formKey.currentState.validate()) {
                        showDialog(
                          useRootNavigator: true,
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            return DialogAlert(
                              title: 'Digite um texto!',
                              onConfirm: () {
                                Navigator.pop(context);
                                textFocus.requestFocus();
                              },
                            );
                          },
                        );
                      } else {
                        if (kDebugMode) print('text: $text');
                        this._overlay = getOverlayProgressIndicator();
                        Overlay.of(context).insert(this._overlay);
                        notificationProvider.sendMessage(
                          isPatient: value.notificationNotify,
                          dateTime: dateTime,
                          sendForAll: sendForAll,
                          text: text,
                          users: value.notificationNotify
                              ? value.patientsSelected
                              : value.doctorsSelected,
                        );
                        Provider.of<NotificationProvider>(context,
                                listen: false)
                            .cleanDoctorsSelected();
                        Provider.of<NotificationProvider>(context,
                                listen: false)
                            .cleanPatientsSelected();
                        Timer(Duration(seconds: 2), () {
                          this._overlay.remove();
                          Provider.of<NotificationProvider>(context,
                                  listen: false)
                              .incNotificationPage(1);
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class ReceiverField extends StatefulWidget {
  final bool disable;
  final FocusNode focusNode;
  const ReceiverField({Key key, this.disable, this.focusNode})
      : super(key: key);

  @override
  _ReceiverFieldState createState() => _ReceiverFieldState();
}

class _ReceiverFieldState extends State<ReceiverField> {
  // FocusNode _focusNode = FocusNode();

  OverlayEntry _overlayEntry;

  final LayerLink _layerLink = LayerLink();

  TextEditingController textEditingController;

  String text = '';

  @override
  void initState() {
    textEditingController = TextEditingController();
    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context).insert(this._overlayEntry);
      } else {
        this._overlayEntry.remove();
      }
    });

    super.initState();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    String getCollection() {
      if (context.read<NotificationProvider>().notificationNotify) {
        return 'patients';
      } else {
        return 'doctors';
      }
    }

    text = textEditingController.text;

    //if(kDebugMode) print(getCollection());

    List<dynamic> getUsersList(AsyncSnapshot docPatSnapshot) {
      if (text == '') {
        List users = docPatSnapshot.data.docs;
        // users.sort((a, b) {
        //   String aUsername = '';
        //   String bUsername = '';
        //   if (a['username'] == null) {
        //     aUsername = 'Sem nome';
        //   } else {
        //     aUsername = a['username'].toLowerCase();
        //   }
        //   if (b['username'] == null) {
        //     bUsername = 'Sem nome';
        //   } else {
        //     bUsername = b['username'].toLowerCase();
        //   }
        //   return aUsername.compareTo(bUsername);
        // });
        return users;
      } else {
        List usersFitered = [];
        QuerySnapshot qs = docPatSnapshot.data;
        qs.docs.forEach((user) {
          String userphone = user['phone'];
          String usercpf = user['cpf'];
          bool isDep = user['type'] == 'dependent';
          if (userphone.contains(text) && !isDep) {
            usersFitered.add(user);
          } else if (usercpf != null && !isDep) {
            if (usercpf.contains(text)) {
              usersFitered.add(user);
            }
          }
        });
        // usersFitered.sort((a, b) {
        //   String aUsername = '';
        //   String bUsername = '';
        //   if (a['username'] == null) {
        //     aUsername = 'Sem nome';
        //   } else {
        //     aUsername = a['username'].toLowerCase();
        //   }
        //   if (b['username'] == null) {
        //     bUsername = 'Sem nome';
        //   } else {
        //     bUsername = b['username'].toLowerCase();
        //   }
        //   return aUsername.compareTo(bUsername);
        // });
        return usersFitered;
      }
    }

    NotificationProvider notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    bool notificationNotify = notificationProvider.notificationNotify;
    // context.watch<NotificationProvider>().notificationNotify;
    return OverlayEntry(
        builder: (BuildContext context) => Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 5.0,
              // width: size.width,
              child: CompositedTransformFollower(
                offset: Offset(0, size.height + 5),
                link: this._layerLink,
                child: Container(
                  height: text == '' ? 0 : 300,
                  width: 500,
                  padding: EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                      color: Color(0xfffafafa),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 5,
                            color: Color(0x40000000))
                      ],
                      border:
                          Border.all(color: Color(0xff707070).withOpacity(.3)),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  alignment: Alignment.centerLeft,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection(getCollection())
                          // .where('phone')
                          // .orderBy('fullname')
                          .snapshots(),
                      builder: (streamContext, docPatSnapshot) {
                        if (!docPatSnapshot.hasData) {
                          return Container(
                              width: 490,
                              alignment: Alignment.center,
                              child: CircularProgressIndicator());
                        } else {
                          List lista = getUsersList(docPatSnapshot);
                          //if(kDebugMode) print('lista: ${lista[0].data()}');

                          if (lista.isEmpty) {
                            return Container(
                              width: 490,
                              height: 60,
                              alignment: Alignment.center,
                              child: Text(
                                'Não há ninguém com esse número ou cpf',
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff707070),
                                ),
                              ),
                            );
                          } else {
                            return Column(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 14),
                                      width: 490,
                                      child: Column(
                                        children: lista.map((user) {
                                          Map<String, dynamic> _user =
                                              user.data();
                                          return Receiver(
                                              avatar: _user['avatar'],
                                              name: _user['fullname'] == null
                                                  ? _user['username']
                                                  : _user['fullname'],
                                              phone: _user['phone'],
                                              cpf: _user['cpf'],
                                              onTap: () {
                                                textEditingController.text = '';
                                                if (kDebugMode)
                                                  print(
                                                      'notificationNotify: $notificationNotify');
                                                if (kDebugMode)
                                                  print('_user: $_user');
                                                notificationNotify
                                                    ? notificationProvider
                                                        .addPatientSelected(
                                                            _user)
                                                    : notificationProvider
                                                        .addDoctorSelected(
                                                            _user);
                                              });
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            );
                          }
                        }
                      }),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: this._layerLink,
      child: Container(
        height: 50,
        width: 500,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xff707070).withOpacity(widget.disable ? .3 : .8),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 450,
              child: TextFormField(
                enabled: !widget.disable,
                controller: textEditingController,
                focusNode: this.widget.focusNode,
                style: TextStyle(
                    color: Color(0xff707070).withOpacity(.5), fontSize: 16),
                decoration: InputDecoration.collapsed(
                    hintText: 'Buscar pelo telefone ou CPF',
                    hintStyle:
                        TextStyle(color: Color(0x50707070), fontSize: 16)),
                onChanged: (val) {
                  text = val;
                },
              ),
            ),
            Icon(
              Icons.search,
              color: Color(0xff707070).withOpacity(.5),
            )
          ],
        ),
      ),
    );
  }
}

class ParameterTitle extends StatelessWidget {
  final String title;

  const ParameterTitle({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      '$title',
      style: TextStyle(
          color: Color(0xff000000), fontSize: 22, fontWeight: FontWeight.w400),
    );
  }
}

class NotificationDate extends StatelessWidget {
  const NotificationDate({Key key, this.dateTime, this.onTap})
      : super(key: key);

  final DateTime dateTime;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 300,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xff707070).withOpacity(.8),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Row(
          children: [
            Container(
                width: 85,
                alignment: Alignment.center,
                child: Text(
                  dateTime.day.toString(),
                  style: TextStyle(
                      color: Color(0xff707070).withOpacity(.5), fontSize: 16),
                )),
            Text(
              '/',
              style: TextStyle(
                color: Color(0xff707070).withOpacity(.5),
                fontSize: 25,
              ),
            ),
            Container(
                width: 85,
                alignment: Alignment.center,
                child: Text(
                  dateTime.month.toString(),
                  style: TextStyle(
                      color: Color(0xff707070).withOpacity(.5), fontSize: 16),
                )),
            Text(
              '/',
              style: TextStyle(
                color: Color(0xff707070).withOpacity(.5),
                fontSize: 25,
              ),
            ),
            Container(
                width: 85,
                alignment: Alignment.center,
                child: Text(
                  dateTime.year.toString(),
                  style: TextStyle(
                      color: Color(0xff707070).withOpacity(.5), fontSize: 16),
                )),
          ],
        ),
      ),
    );
  }
}
