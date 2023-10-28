import 'package:back_office/shared/utilities.dart';
import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final String title;
  final double left;

  PageTitle({Key key, this.title = '', this.left = 32}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: wXD(left, context),
        top: hXD(30, context),
        bottom: hXD(40, context),
      ),
      child: Text(
        '$title',
        style: TextStyle(color: Color(0xff000000), fontSize: 28),
      ),
    );
  }
}
