import 'package:flutter/material.dart';

class Check extends StatelessWidget {
  final bool check;
  final Function onTap;

  const Check({Key key, this.check, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          color: check ? Color(0xff2676E1) : Color(0xfffafafa),
          borderRadius: BorderRadius.all(Radius.circular(90)),
          border: Border.all(color: Color(0xff707070).withOpacity(.3)),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              offset: Offset(0, 3),
              color: Color(0x30000000),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.check_rounded,
          color: Color(0xfffafafa),
          size: 15,
        ),
      ),
    );
  }
}
