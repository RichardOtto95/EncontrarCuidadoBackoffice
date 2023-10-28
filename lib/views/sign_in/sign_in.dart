import 'package:back_office/shared/utilities.dart';
import 'package:back_office/views/sign_in/sign_provider.dart';
import 'package:back_office/views/sign_in/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

var maskFormatter = new MaskTextInputFormatter(
    mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

class _SignInState extends State<SignIn> {
  String tel;
  TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => Home(),
    //     ));
    return Scaffold(
      backgroundColor: Color(0xffeaeaea),
      body: ChangeNotifierProvider<SignInProvider>(
        create: (context) => SignInProvider(),

        // stream: null,
        builder: (context, snapshot) {
          return Consumer<SignInProvider>(
            builder: (context, value, child) {
              return Column(
                children: [
                  NavBar(),
                  Spacer(),
                  Container(
                    width: wXD(1170, context),
                    height: hXD(672, context),
                    decoration: BoxDecoration(
                        color: Color(0xfffafafa),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(8))),
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: wXD(35, context)),
                              margin: EdgeInsets.symmetric(
                                horizontal: wXD(10, context),
                                vertical: hXD(30, context),
                              ),
                              height: hXD(135, context),
                              width: wXD(1066, context),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 5,
                                    color: Color(0x30000000),
                                    offset: Offset(0, 3),
                                  ),
                                ],
                                color: Color(0xfffafafa),
                              ),
                              alignment: Alignment.centerLeft,
                              child: SelectableText(
                                'Bem vindo(a)!',
                                style: TextStyle(
                                  color: Color(0xff41C3B3),
                                  fontSize: hXD(28, context),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Positioned(
                              right: wXD(30, context),
                              bottom: hXD(30, context),
                              child: Image.asset(
                                'assets/img/entrando.png',
                                width: hXD(220, context),
                              ),
                            )
                          ],
                        ),
                        Spacer(flex: 4),
                        Text(
                          'Entrar',
                          style: TextStyle(
                            color: Color(0xff41C3B3),
                            fontSize: hXD(28, context),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Spacer(flex: 2),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText(
                              'Telefone',
                              style: TextStyle(
                                color: Color(0xff41C3B3),
                                fontSize: hXD(20, context),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Container(
                              width: wXD(238, context),
                              height: hXD(45, context),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Color(0xff41C3B3),
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(11),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4,
                                      offset: Offset(0, 3),
                                      color: Color(0x30000000),
                                    )
                                  ],
                                  color: Color(0xfffafafa)),
                              child: TextFormField(
                                controller: textController,
                                autofocus: true,
                                inputFormatters: [maskFormatter],
                                textAlign: TextAlign.center,
                                onEditingComplete: () async {
                                  if (kDebugMode)
                                    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAA");
                                  if (tel != null)
                                    value.verifyNumber(tel, context);
                                  textController.clear();
                                  tel = null;
                                },
                                onChanged: (text) {
                                  text = maskFormatter.getUnmaskedText();
                                  if (kDebugMode)
                                    print('Telefone: value: $text');
                                  setState(() {
                                    tel = text;
                                    if (kDebugMode) print('text: $tel');
                                  });
                                },
                                keyboardType: TextInputType.number,
                                // maxLength: 15,
                                decoration: InputDecoration.collapsed(
                                  hintText: '(99)99999-9999',
                                  hintStyle: TextStyle(
                                    color: Color(0xff707070).withOpacity(.4),
                                    fontSize: hXD(20, context),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Spacer(flex: 2),
                        value.loadCircular
                            ? Container(
                                width: wXD(238, context),
                                height: hXD(45, context),
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  color: Color(0xff21bcce),
                                  valueColor:
                                      AlwaysStoppedAnimation(Color(0xff41c3b3)),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  if (kDebugMode)
                                    print("BBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
                                  if (tel != null)
                                    value.verifyNumber(tel, context);
                                  textController.clear();
                                  tel = null;
                                },
                                child: Container(
                                  width: wXD(238, context),
                                  height: hXD(45, context),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 3,
                                        color: Color(0xff41C3B3),
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(11),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 4,
                                          offset: Offset(0, 3),
                                          color: Color(0x30000000),
                                        )
                                      ],
                                      color: Color(0xff41c3b3)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: wXD(50, context),
                                    ),
                                    child: Text(
                                      'Entrar',
                                      style: TextStyle(
                                        color: Color(0xfffafafa),
                                        fontSize: hXD(28, context),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        Spacer(flex: 11),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
