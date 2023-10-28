import 'package:flutter/material.dart';

class DialogWidget extends StatelessWidget {
  final String title;
  final void Function(String text) onConfirm;
  final Function onCancel;
  final bool hasJustification;
  const DialogWidget({
    Key key,
    this.title,
    this.onConfirm,
    this.onCancel,
    this.hasJustification = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text = '';
    return AlertDialog(
      backgroundColor: Color(0xfffafafa),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25))),
      title: SelectableText(
        '$title',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xfa707070),
        ),
      ),
      actions: [
        Column(
          children: [
            hasJustification
                ? Container(
                    width: 300,
                    height: 50,
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff707070)),
                        borderRadius: BorderRadius.all(Radius.circular(17))),
                    child: TextFormField(
                      maxLines: 5,
                      autofocus: true,
                      onChanged: (val) => text = val,
                      decoration: InputDecoration.collapsed(
                          hintText: 'Digite a justificativa...'),
                    ),
                  )
                : Container(),
            Container(
              margin: EdgeInsets.only(bottom: 25, top: 10),
              // width: 400,
              child: Row(
                children: [
                  Spacer(flex: 2),
                  InkWell(
                    onTap: onCancel,
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
                          borderRadius: BorderRadius.all(Radius.circular(17)),
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
                    onTap: () => onConfirm(text),
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
                          borderRadius: BorderRadius.all(Radius.circular(17)),
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
                  Spacer(
                    flex: 2,
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}

class DialogAlert extends StatelessWidget {
  final String title;
  final Function onConfirm;
  const DialogAlert({
    Key key,
    this.title,
    this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xfffafafa),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25))),
      title: SelectableText(
        '$title',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xfa707070),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(bottom: 25, top: 10),
          // width: 400,
          alignment: Alignment.center,
          child: InkWell(
            onTap: onConfirm,
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
                  borderRadius: BorderRadius.all(Radius.circular(17)),
                  border: Border.all(color: Color(0x80707070)),
                  color: Color(0xfffafafa)),
              alignment: Alignment.center,
              child: Text(
                'Ok',
                style: TextStyle(
                    color: Color(0xff2185D0),
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ),
        )
      ],
    );
  }
}
