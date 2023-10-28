import 'package:back_office/shared/utilities.dart';
import 'package:back_office/views/home/widgets/card_data.dart';
import 'package:back_office/shared/models/card_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home_provider.dart';

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List cardList = [
      CardModel(
        icon: Icons.people_outline,
        title: 'Novos pacientes hoje',
        primaryColor: Color(0xff7D00B5),
        secondaryColor: Color(0xffBA58E6),
        type: 'patients',
        page: 2,
      ),
      CardModel(
        icon: Icons.medical_services_outlined,
        primaryColor: Color(0xff39D5CF),
        secondaryColor: Color(0xff1BA7A1),
        title: 'Novos médicos hoje',
        type: 'doctors',
        page: 3,
      ),
      CardModel(
        icon: Icons.calendar_today,
        primaryColor: Color(0xffFF007C),
        secondaryColor: Color(0xffA72D68),
        title: 'Novos agendamentos hoje',
        type: 'appointments',
        page: 4,
      ),
      CardModel(
        icon: Icons.star_border,
        primaryColor: Color(0xff2D62ED),
        secondaryColor: Color(0xff789AF3),
        title: 'Novas avaliações hoje',
        type: 'ratings',
        page: 5,
      ),
      CardModel(
        icon: Icons.edit,
        primaryColor: Color(0xff7033FF),
        secondaryColor: Color(0xff789AF3),
        title: 'Novas postagens hoje',
        type: 'posts',
        page: 6,
      ),
      CardModel(
        icon: Icons.money,
        primaryColor: Color(0xffFFAF62),
        secondaryColor: Color(0xffFF7D56),
        title: 'Faturamento hoje',
        type: 'transactions',
        page: 7,
      ),
      CardModel(
        icon: Icons.headset_mic,
        primaryColor: Color(0xffFF4F46),
        secondaryColor: Color(0xffFF7D56),
        title: 'Novos chamados hoje',
        type: 'support',
        page: 8,
      ),
      CardModel(
        icon: Icons.notifications_none,
        primaryColor: Color(0xffFFBB00),
        secondaryColor: Color(0xffFFCF64),
        title: 'Notificações disparadas hoje',
        type: 'notifications',
        page: 9,
      ),
    ];
    List supportCardList = [
      CardModel(
        icon: Icons.people_outline,
        title: 'Novos pacientes hoje',
        primaryColor: Color(0xff7D00B5),
        secondaryColor: Color(0xffBA58E6),
        type: 'patients',
        page: 2,
      ),
      CardModel(
        icon: Icons.medical_services_outlined,
        primaryColor: Color(0xff39D5CF),
        secondaryColor: Color(0xff1BA7A1),
        title: 'Novos médicos hoje',
        type: 'doctors',
        page: 3,
      ),
      CardModel(
        icon: Icons.calendar_today,
        primaryColor: Color(0xffFF007C),
        secondaryColor: Color(0xffA72D68),
        title: 'Novos agendamentos hoje',
        type: 'appointments',
        page: 4,
      ),
      CardModel(
        icon: Icons.star_border,
        primaryColor: Color(0xff2D62ED),
        secondaryColor: Color(0xff789AF3),
        title: 'Novas avaliações hoje',
        type: 'ratings',
        page: 5,
      ),
      CardModel(
        icon: Icons.edit,
        primaryColor: Color(0xff7033FF),
        secondaryColor: Color(0xff789AF3),
        title: 'Novas postagens hoje',
        type: 'posts',
        page: 6,
      ),
      // CardModel(
      //   icon: Icons.money,
      //   primaryColor: Color(0xffFFAF62),
      //   secondaryColor: Color(0xffFF7D56),
      //   title: 'Faturamento hoje',
      //   type: 'transactions',
      //   page: 7,
      // ),
      CardModel(
        icon: Icons.headset_mic,
        primaryColor: Color(0xffFF4F46),
        secondaryColor: Color(0xffFF7D56),
        title: 'Novos chamados hoje',
        type: 'support',
        page: 8,
      ),
      CardModel(
        icon: Icons.notifications_none,
        primaryColor: Color(0xffFFBB00),
        secondaryColor: Color(0xffFFCF64),
        title: 'Notificações disparadas hoje',
        type: 'notifications',
        page: 9,
      ),
    ];
    return Expanded(
      child: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('admins')
              .where('mobile_full_number',
                  isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                width: wXD(983, context),
                margin: EdgeInsets.only(top: 60),
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            } else {
              QuerySnapshot qs = snapshot.data;
              DocumentSnapshot ds = qs.docs.first;
              //if(kDebugMode) print('Ds role: ${ds['role']} ');

              return Container(
                padding: EdgeInsets.only(bottom: 40),
                width: wXD(983, context),
                margin: EdgeInsets.symmetric(
                  horizontal: wXD(48, context),
                  vertical: hXD(16, context),
                ),
                decoration: BoxDecoration(
                  color: Color(0xfffafafa),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: wXD(35, context)),
                      height: 135,
                      width: wXD(983, context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Color(0x30000000),
                            offset: Offset(0, 3),
                          ),
                        ],
                        color: Color(0xfffafafa),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(),
                              SelectableText(
                                'Home',
                                style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: hXD(25, context),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Spacer(),
                              Container(
                                  width: wXD(450, context),
                                  child: SelectableText(
                                    '${ds['username']}',
                                    maxLines: 1,
                                    scrollPhysics: ClampingScrollPhysics(),
                                    // overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Color(0xff000000),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )),
                              Spacer(),
                            ],
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Provider.of<HomeProvider>(context, listen: false)
                                  .launchInWebViewOrVC(
                                      'https://console.firebase.google.com/u/0/project/encontrar-cuidado-project/overview');
                            },
                            child: Image.asset(
                                'assets/img/carinhanafrentedopc.png'),
                          ),
                          SizedBox(
                            width: wXD(28, context),
                          )
                        ],
                      ),
                    ),
                    // CardData(cardView: cardList[0])
                    !(ds['role'] == 'ADMIN')
                        ? Wrap(
                            direction: Axis.horizontal,
                            // spacing: 30,
                            children: List.generate(
                                supportCardList.length,
                                (index) => CardData(
                                      cardView: supportCardList[index],
                                    )))
                        : Wrap(
                            direction: Axis.horizontal,
                            // spacing: 30,
                            children: List.generate(
                                cardList.length,
                                (index) => CardData(
                                      cardView: cardList[index],
                                    )))
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
