import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  const BlueButton({Key key, this.onTap, this.text = 'Salvar'})
      : super(key: key);
  final Function onTap;
  final String text;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 32,
        width: 149,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff41C3B3),
                  Color(0xff21BCCE),
                ])),
        alignment: Alignment.center,
        child: Text(
          '$text',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Color(0xfffafafa),
          ),
        ),
      ),
    );
  }
}
