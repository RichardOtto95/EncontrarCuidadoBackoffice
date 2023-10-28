import 'package:flutter/material.dart';

import '../utilities.dart';

class CentralContainer extends StatelessWidget {
  final Widget child;
  final double paddingBottom;
  final double paddingRight;
  final double paddingLeft;
  const CentralContainer({
    Key key,
    this.child,
    this.paddingBottom = 40,
    this.paddingRight = 0,
    this.paddingLeft = 0,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) =>
          FocusScope.of(context).requestFocus(new FocusNode()),
      child: Container(
        padding: EdgeInsets.only(
            bottom: paddingBottom, right: paddingRight, left: paddingLeft),
        width: wXD(983, context),
        margin: EdgeInsets.symmetric(
          horizontal: wXD(48, context),
          vertical: hXD(32, context),
        ),
        decoration: BoxDecoration(
          color: Color(0xfffafafa),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        alignment: Alignment.topCenter,
        child: child,
      ),
    );
  }
}
