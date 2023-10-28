import 'package:back_office/shared/utilities.dart';
import 'package:flutter/material.dart';

class DesprogramDialog extends StatelessWidget {
  final Function onConfirm;
  final Function onCancel;

  const DesprogramDialog({Key key, this.onConfirm, this.onCancel})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCancel,
      child: Container(
        height: maxHeight(context),
        width: maxWidth(context),
        color: Color(0x50000000),
        alignment: Alignment.topRight,
        padding:
            EdgeInsets.only(right: wXD(400, context), top: hXD(268, context)),
        child: Container(
          padding: EdgeInsets.only(top: 5),
          height: 144,
          width: 430,
          decoration: BoxDecoration(
              color: Color(0xfffafafa),
              borderRadius: BorderRadius.all(Radius.circular(33))),
          child: Column(
            children: [
              Spacer(),
              SelectableText(
                'Tem certeza que deseja estornar este pagamento?',
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
                        'Sim',
                        style: TextStyle(
                            color: Color(0xff2185D0),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
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
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
