import 'package:back_office/shared/utilities.dart';
import 'package:back_office/shared/widgets/nav_bar_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Map<String, dynamic> data = {
  // 'id': null,
  // 'avatar': null,
  // 'author': '123456',
  'created_at': Timestamp.now(),
  'date': Timestamp.now(),
  'id': '',
  // 'note': 'nota nota nota',
  // 'receiver': '4wKgHTRDMAqwdaVcikfW',
  // 'receiver_id': '4wKgHTRDMAqwdaVcikfW',
  'doctor_id': 'abcdefghijklmnopqrst',
  // 'sender': 'Marina da Silva',
  // 'sender_id': '6pjnA9DFL0bYgBRomZ3aLjDQSdD2',
  'patient_id': 'abcdefghijklmnopqrst',
  'hour': Timestamp.now(),
  // 'avaliation': 5.0,
  'price': 350,
  'status': 'status',
  // 'text': 'texto texto texto texto texto',
  'type': 'tipo',
  // 'cpf': null,
  // 'email': null,
  // 'fullname': null,
  // 'phone': '+5561123456789',
  // 'username': null,
  // 'birthday': null,
  // 'gender': null,
  // 'cep': null,
  // 'address': null,
  // 'number_address': null,
  // 'complement_address': null,
  // 'neighborhood': null,
  // 'city': null,
  // 'value': 700,
  // 'state': null,
  // 'notification_enabled': null
};
Map<String, dynamic> doctor = {
  'type': 'doctor',
  'social': null,
  'complement_address': null,
  'speciality': null,
  'gender': null,
  'avatar': null,
  'speciality_name': null,
  'fullname': null,
  'rqe': null,
  'city': null,
  'new_ratings': null,
  'cpf': null,
  'medical_conditions': null,
  'experience': null,
  'address': null,
  'number_address': null,
  'landline': null,
  'phone': '',
  'language': null,
  'attendance': null,
  'academic_education': null,
  'birthday': null,
  'notification_enabled': true,
  'clinic_name': null,
  'invitation_to_position': null,
  'username': '',
  'doctor_id': null,
  'neighborhood': null,
  'about_me': null,
  'state': null,
  'created_at': Timestamp.now(),
  'email': null,
  'id': '',
  'cep': null,
  'crm': null
};

class NavSideBar extends StatelessWidget {
  final Function onExit;
  final bool suport;
  const NavSideBar({
    Key key,
    this.onExit,
    this.suport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = wXD(200, context);
    return Listener(
      onPointerDown: (event) {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        color: Color(0xff212122),
        height: MediaQuery.of(context).size.height,
        width: width,
        child: Column(
          children: [
            Container(
              width: width,
              height: hXD(100, context),
              decoration: BoxDecoration(
                color: Color(0xff1b1b1b),
              ),
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(
                  left: wXDM(21, context, min: 21), top: hXDM(24, context)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          QuerySnapshot financialQuery = await FirebaseFirestore
                              .instance
                              .collection("transactions")
                              .get();

                          financialQuery.docs.forEach((transaction) async {
                            try {
                              if (kDebugMode)
                                print(
                                    "data: ${transaction.get("receiver_id")}");
                            } catch (e) {
                              if (kDebugMode)
                                print("EEEEEEEEEEEEEEE: ${e.toString()};");
                              if (e.toString() ==
                                  "Bad state: field does not exist within the DocumentSnapshotPlatform") {
                                await transaction.reference
                                    .update({"receiver_id": null});
                              }
                            }
                          });
                        },
                        child: Image.asset(
                          'assets/img/logo_name.png',
                          height: hXDM(37, context),
                          width: wXDM(117, context, min: 117),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(right: wXDM(5, context, min: 5)),
                        child: SelectableText(
                          'Backoffice',
                          style: TextStyle(
                              color: Color(0xffaeaeae),
                              fontSize: hXD(10, context)),
                        ),
                      ),
                    ],
                  ),
                  // InkWell(
                  //   // onTap: () async {
                  //   //   // await FirebaseFirestore.instance
                  //   //   //     .collection('doctors')
                  //   //   //     .get()
                  //   //   //     .then((value) => value.docs.forEach((element) {
                  //   //   //           // element.reference.update({'connected': false});
                  //   //   //         }));
                  //   //   await FirebaseFirestore.instance
                  //   //       .collection('transactions')
                  //   //       .get()
                  //   //       .then((value) => value.docs.forEach((element) {
                  //   //             element.reference
                  //   //                 .update({'created_at': Timestamp.now()});
                  //   //             // Map<String, dynamic> patMap =
                  //   //             //     PatientModel().toJson(PatientModel());
                  //   //             // patMap.forEach((key, value) {
                  //   //             //   if (!element.data().containsKey(key)) {
                  //   //             //     element.reference.update({key: null});
                  //   //             //   }
                  //   //             // });
                  //   //           }));
                  //   // },
                  //   child: Stack(
                  //     alignment: Alignment.topRight,
                  //     children: [
                  //       Container(
                  //         height: hXDM(40, context),
                  //         width: wXDM(60, context, min: 60),
                  //         padding: EdgeInsets.only(
                  //             right: wXDM(10, context, min: 10)),
                  //         alignment: Alignment.topRight,
                  //         child: Icon(
                  //           Icons.keyboard_arrow_left_rounded,
                  //           color: Color(0xffaeaeae),
                  //           size: hXDM(35, context),
                  //         ),
                  //       ),
                  //       Positioned(
                  //         child: Icon(
                  //           Icons.keyboard_arrow_left_rounded,
                  //           color: Color(0xff707070),
                  //           size: hXDM(35, context),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
            Container(
              // height: 800,
              child: Column(
                children: [
                  SizedBox(
                    height: hXDM(17, context),
                  ),
                  NavBarTile(
                    page: 1,
                    icon: Icons.house_outlined,
                    title: 'Home',
                  ),
                  NavBarTile(
                    page: 11,
                    icon: Icons.supervised_user_circle,
                    title: 'Admins',
                  ),
                  NavBarTile(
                    page: 2,
                    icon: Icons.people_outline,
                    title: 'Pacientes',
                  ),
                  NavBarTile(
                    page: 3,
                    icon: Icons.medical_services_outlined,
                    title: 'Médicos',
                  ),
                  NavBarTile(
                    page: 4,
                    icon: Icons.calendar_today_outlined,
                    title: 'Agendamentos',
                  ),
                  NavBarTile(
                    page: 5,
                    icon: Icons.star_border,
                    title: 'Avaliações',
                  ),
                  NavBarTile(
                    page: 6,
                    icon: Icons.edit_sharp,
                    title: 'Postagens',
                  ),
                  !suport
                      ? NavBarTile(
                          page: 7,
                          icon: Icons.money_rounded,
                          title: 'Financeiro',
                        )
                      : Container(),
                  NavBarTile(
                    page: 8,
                    icon: Icons.headset_mic,
                    title: 'Suporte',
                  ),
                  NavBarTile(
                    page: 9,
                    icon: Icons.notifications_none_rounded,
                    title: 'Notificações',
                  ),
                  NavBarTile(
                    page: 10,
                    icon: Icons.info_outline,
                    title: 'Sobre',
                  ),

                  // Spacer(),
                  BackTile(
                    icon: FontAwesomeIcons.signOutAlt,
                    title: 'Sair',
                    onTap: onExit,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptySideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = wXD(200, context);
    return Listener(
      onPointerDown: (event) {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        color: Color(0xff212122),
        height: MediaQuery.of(context).size.height,
        width: width,
        child: Column(
          children: [
            Container(
              width: width,
              height: hXD(100, context),
              decoration: BoxDecoration(
                color: Color(0xff1b1b1b),
              ),
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(
                  left: wXDM(21, context, min: 21), top: hXDM(24, context)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset(
                        'assets/img/logo_name.png',
                        height: hXDM(37, context),
                        width: wXDM(117, context, min: 117),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(right: wXDM(5, context, min: 5)),
                        child: SelectableText(
                          'Backoffice',
                          style: TextStyle(
                              color: Color(0xffaeaeae),
                              fontSize: hXD(10, context)),
                        ),
                      ),
                    ],
                  ),
                  // InkWell(
                  //   // onTap: () async {
                  //   //   // await FirebaseFirestore.instance
                  //   //   //     .collection('doctors')
                  //   //   //     .get()
                  //   //   //     .then((value) => value.docs.forEach((element) {
                  //   //   //           // element.reference.update({'connected': false});
                  //   //   //         }));
                  //   //   await FirebaseFirestore.instance
                  //   //       .collection('transactions')
                  //   //       .get()
                  //   //       .then((value) => value.docs.forEach((element) {
                  //   //             element.reference
                  //   //                 .update({'created_at': Timestamp.now()});
                  //   //             // Map<String, dynamic> patMap =
                  //   //             //     PatientModel().toJson(PatientModel());
                  //   //             // patMap.forEach((key, value) {
                  //   //             //   if (!element.data().containsKey(key)) {
                  //   //             //     element.reference.update({key: null});
                  //   //             //   }
                  //   //             // });
                  //   //           }));
                  //   // },
                  //   child: Stack(
                  //     alignment: Alignment.topRight,
                  //     children: [
                  //       Container(
                  //         height: hXDM(40, context),
                  //         width: wXDM(60, context, min: 60),
                  //         padding: EdgeInsets.only(
                  //             right: wXDM(10, context, min: 10)),
                  //         alignment: Alignment.topRight,
                  //         child: Icon(
                  //           Icons.keyboard_arrow_left_rounded,
                  //           color: Color(0xffaeaeae),
                  //           size: hXDM(35, context),
                  //         ),
                  //       ),
                  //       Positioned(
                  //         child: Icon(
                  //           Icons.keyboard_arrow_left_rounded,
                  //           color: Color(0xff707070),
                  //           size: hXDM(35, context),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  // height: 800,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 50),
                      CircularProgressIndicator()
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
