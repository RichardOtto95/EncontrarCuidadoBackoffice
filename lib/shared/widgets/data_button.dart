import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DataButton extends StatelessWidget {
  final Function onTap;
  final bool open;

  const DataButton({
    Key key,
    this.onTap,
    this.open = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: 23,
              width: 39,
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff707070), width: 2),
                  color: Color(0xffeaeaea),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(12))),
              alignment: Alignment.topCenter,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Transform.rotate(
                  // angle: math.pi / 2,
                  // child:
                  Positioned(
                    top: -3.5,
                    child: Transform.rotate(
                      angle: open ? math.pi : 0,
                      child: FaIcon(
                        FontAwesomeIcons.chevronDown,
                        color: Color(0xffaeaeae),
                        size: 17,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -3.5,
                    child: Transform.rotate(
                      angle: open ? math.pi : 0,
                      child: FaIcon(
                        FontAwesomeIcons.chevronDown,
                        color: Color(0xff707070),
                        size: 17,
                      ),
                    ),
                  ),
                  Container(
                    height: 25,
                    alignment: Alignment.bottomCenter,
                  ),
                  // )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 48,
        )
      ],
    );
  }
}
