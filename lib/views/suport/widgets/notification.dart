import 'package:flutter/material.dart';

class NotificationWidget extends StatelessWidget {
  final String notifications;

  const NotificationWidget({
    Key key,
    this.notifications,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: notifications != '0',
      child: Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xff2D62ED),
        ),
        alignment: Alignment.center,
        child: Text(
          '$notifications',
          style: TextStyle(
              color: Color(0xfffafafa),
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
