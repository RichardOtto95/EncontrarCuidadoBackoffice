import 'package:back_office/shared/utilities.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  // final String avatar, phone, username;
  // final bool adm;
  // const TopBar({
  //   Key key,
  //   this.avatar,
  //   this.phone,
  //   this.adm = false,
  //   this.username,
  // }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth(context) - wXD(200, context),
      height: 68,
      decoration: BoxDecoration(color: Color(0xfffafafa), boxShadow: [
        BoxShadow(color: Color(0x40000000), offset: Offset(0, 4), blurRadius: 6)
      ]),
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(right: 42, top: 11, bottom: 13),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('admins')
                .where('mobile_full_number',
                    isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  child: CircularProgressIndicator(),
                );
              } else {
                DocumentSnapshot ds = snapshot.data.docs.first;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 7),
                        SelectableText(
                          '${ds['username']}',
                          style: TextStyle(
                            color: Color(0xff707070),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SelectableText(
                          ds['role'] == 'SUPPORT'
                              ? 'Suporte'
                              : ds['role'] == 'ADMIN'
                                  ? 'Administrador'
                                  : 'Não definido',
                          style: TextStyle(
                            color: Color(0xff707070),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                      ],
                    ),
                    SizedBox(width: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: ds['avatar'] == null
                          ? Image.asset(
                              'assets/img/defaultUser.png',
                              height: 44,
                              width: 44,
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: ds['avatar'],
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[400],
                              ),
                            ),
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
