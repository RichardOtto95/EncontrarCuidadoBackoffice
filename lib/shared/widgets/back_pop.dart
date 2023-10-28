import 'package:back_office/shared/utilities.dart';
import 'package:flutter/material.dart';

class BackPop extends StatelessWidget {
  final bool back;
  final Function onCancel, onConfirm;
  const BackPop({Key key, this.back, this.onCancel, this.onConfirm})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: back,
      child: InkWell(
        onTap: onCancel,
        child: Container(
          height: maxHeight(context),
          width: maxWidth(context),
          color: !back ? Colors.transparent : Color(0x50000000),
          // duration: Duration(milliseconds: 300),
          // curve: Curves.decelerate,
          child: Center(
            child: Container(
              padding: EdgeInsets.only(top: 5),
              height: 144,
              width: 303,
              decoration: BoxDecoration(
                  color: Color(0xfffafafa),
                  borderRadius: BorderRadius.all(Radius.circular(33))),
              child: Column(
                children: [
                  Spacer(),
                  SelectableText(
                    'Tem certeza que deseja sair?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xfa707070),
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Spacer(),
                      InkWell(
                        onTap: onCancel,
                        // () {
                        //   setState(() {
                        //     back = !back;
                        //   });
                        // },
                        child: Container(
                          height: 47,
                          width: 98,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 3),
                                    blurRadius: 5,
                                    color: Color(0x28000000))
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(17)),
                              border: Border.all(color: Color(0x80707070)),
                              color: Color(0xfffafafa)),
                          alignment: Alignment.center,
                          child: Text(
                            'Não',
                            style: TextStyle(
                                color: Color(0xff2185D0),
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: onConfirm,
                        // () {
                        //   Navigator.pop(context);
                        // },
                        child: Container(
                          height: 47,
                          width: 98,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 3),
                                    blurRadius: 5,
                                    color: Color(0x28000000))
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(17)),
                              border: Border.all(color: Color(0x80707070)),
                              color: Color(0xfffafafa)),
                          alignment: Alignment.center,
                          child: Text(
                            'Sim',
                            style: TextStyle(
                                color: Color(0xff2185D0),
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
      // child: Confirmation(),
    );
  }
}
