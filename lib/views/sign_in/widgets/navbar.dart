import 'package:back_office/shared/utilities.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final double width;

  const NavBar({Key key, this.width}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double _width;
    if (width == 0) {
      _width = maxWidth(context);
    }
    return Container(
      width: _width,
      height: hXD(84, context),
      color: Color(0xff212122),
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.only(left: wXD(30, context), top: hXD(10, context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset(
              'assets/img/logo_name.png',
              height: hXD(45, context),
            ),
            SelectableText(
              'Backoffice',
              style: TextStyle(
                  color: Color(0xfffafafa), fontSize: hXD(10, context)),
            )
          ],
        ),
      ),
    );
  }
}
