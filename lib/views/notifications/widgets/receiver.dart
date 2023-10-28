import 'package:back_office/views/home/home_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Receiver extends StatelessWidget {
  final String name, cpf, phone, avatar;
  final Function onTap;
  const Receiver({
    Key key,
    this.name = 'Fulano de tal da Silva Costa',
    this.cpf = '12345678901',
    this.phone = '+5561987654321',
    this.avatar,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider = HomeProvider();
    return Column(
      children: [
        SizedBox(height: 14),
        Material(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
              height: 50,
              width: 458,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(90),
                    child: avatar == null
                        ? Image.asset(
                            'assets/img/defaultUser.png',
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                            imageUrl: avatar,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                  ),
                  // CircleAvatar(
                  //   radius: 27,
                  //   backgroundImage: avatar == null
                  //       ? AssetImage('assets/img/defaultUser.png')
                  //       : CachedNetworkImageProvider(avatar),
                  // ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 386,
                        child: Text(
                          '$name',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff707070),
                          ),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff707070),
                          ),
                          children: [
                            TextSpan(text: 'Telefone: '),
                            TextSpan(
                                text:
                                    '${homeProvider.getTextMasked(phone, 'phone')}',
                                style: TextStyle(
                                    color: Color(0xff707070).withOpacity(.6))),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff707070),
                          ),
                          children: [
                            TextSpan(text: 'CPF: '),
                            TextSpan(
                                text:
                                    '${homeProvider.getTextMasked(cpf, 'cpf')}',
                                style: TextStyle(
                                    color: Color(0xff707070).withOpacity(.6))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
