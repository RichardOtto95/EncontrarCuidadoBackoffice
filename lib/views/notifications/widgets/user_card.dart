import 'package:back_office/views/home/home_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final Function onRemove;
  final String avatar, username, type, cpf, phone;
  final bool disable;
  const UserCard({
    Key key,
    this.onRemove,
    this.avatar,
    this.username,
    this.type,
    this.cpf,
    this.phone,
    this.disable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _type = HomeProvider().getPortugueseType(type);
    // switch (type) {
    //   case 'dependent':
    //     break;
    //   default:
    // }
    return Center(
      child: Container(
        padding: EdgeInsets.fromLTRB(8, 9, 17, 13),
        margin: EdgeInsets.only(bottom: 20),
        height: 85,
        width: 290,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(17),
          ),
          border: Border.all(color: Color(0xff707070).withOpacity(.3)),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              offset: Offset(3, 3),
              color: Color(0x30000000),
            ),
          ],
          color: Color(0xfffafafa),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: avatar == null
                      ? Image.asset(
                          'assets/img/defaultUser.png',
                          height: 33,
                          width: 33,
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: avatar,
                          width: 33,
                          height: 33,
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username.length >= 20
                          ? '${username.substring(0, 20)}...'
                          : '$username',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: disable
                            ? Color(0xff484D54).withOpacity(.2)
                            : Color(0xff484D54),
                        // fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 3,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _type,
                            style: TextStyle(
                              color: disable
                                  ? Color(0xff484D54).withOpacity(.2)
                                  : Color(0xff484D54),
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'CPF: ${HomeProvider().getTextMasked(cpf, 'cpf')}',
                            style: TextStyle(
                              color: disable
                                  ? Color(0xff707070).withOpacity(.2)
                                  : Color(0xff707070).withOpacity(.8),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Telefone:  $phone',
                            style: TextStyle(
                              color: disable
                                  ? Color(0xff707070).withOpacity(.2)
                                  : Color(0xff707070).withOpacity(.8),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Spacer(),
                Container(
                  child: InkWell(
                    onTap: onRemove,
                    child: Icon(
                      Icons.close,
                      size: 23,
                      color: disable
                          ? Color(0xffDB2828).withOpacity(.3)
                          : Color(0xffDB2828),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
