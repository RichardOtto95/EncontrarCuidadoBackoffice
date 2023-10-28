import 'package:flutter/material.dart';

import '../utilities.dart';

class TitleBar extends StatelessWidget {
  TitleBar({
    Key key,
    this.title,
    this.subTitle,
    this.button,
  }) : super(key: key);

  final Widget button;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: wXD(983, context),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Color(0xff707070).withOpacity(.3)))),
      padding: EdgeInsets.fromLTRB(
          wXD(45, context), hXD(23, context), 0, hXD(20, context)),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$title',
                style: TextStyle(
                  fontSize: 28,
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$subTitle',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xff707070),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Spacer(),
          getButton(),
        ],
      ),
    );
  }

  getButton() {
    if (button == null) {
      return Container();
    } else {
      return button;
    }
  }
}
