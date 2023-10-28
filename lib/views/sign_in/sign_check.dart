import 'package:back_office/shared/utilities.dart';
import 'package:back_office/views/sign_in/sign_provider.dart';
import 'package:back_office/views/sign_in/widgets/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/foundation.dart';

class SignCheck extends StatefulWidget {
  final ConfirmationResult resulConfirm;

  const SignCheck({Key key, this.resulConfirm}) : super(key: key);

  @override
  _SignCheckState createState() => _SignCheckState();
}

class _SignCheckState extends State<SignCheck> {
  String code;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) print('resulConfirm${widget.resulConfirm}');
    return Scaffold(
      backgroundColor: Color(0xffeaeaea),
      body: ChangeNotifierProvider<SignInProvider>(
          create: (context) => SignInProvider(),

          // stream: null,
          builder: (context, snapshot) {
            return Consumer<SignInProvider>(builder: (context, value, child) {
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
                                'Código de verificação',
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
                        Spacer(flex: 3),
                        SelectableText(
                          'Digite o código de verificação enviado por SMS',
                          style: TextStyle(
                            color: Color(0xff212122),
                            fontSize: hXD(23, context),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Spacer(flex: 3),
                        Container(
                          color: Color(0xfffafafa),
                          width: 301,
                          child: PinCodeTextField(
                            autoFocus: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'))
                            ],
                            autoDismissKeyboard: false,
                            onSubmitted: (e) {
                              value.verifyCode(
                                  code, widget.resulConfirm, context);
                            },
                            keyboardType: TextInputType.number,
                            length: 6,
                            animationType: AnimationType.fade,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.underline,
                              fieldHeight: 50,
                              fieldWidth: 40,
                              inactiveColor: Color(0x30707070), //
                              selectedColor: Color(0xff41c3b3),
                              activeColor: Color(0xff21bcce),
                            ),
                            backgroundColor: Color(0xfffafafa),
                            animationDuration: Duration(milliseconds: 300),
                            onChanged: (value) {
                              setState(() {
                                code = value;
                                if (kDebugMode) print(code);
                              });
                            },
                            beforeTextPaste: (text) {
                              return true;
                            },
                            appContext: context,
                          ),
                        ),
                        Spacer(flex: 2),
                        value.loadCircular
                            ? Container(
                                width: wXD(238, context),
                                height: hXD(45, context),
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  color: Color(0xff21bcce),
                                  valueColor: AlwaysStoppedAnimation(
                                    Color(0xff41c3b3),
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  value.verifyCode(
                                      code, widget.resulConfirm, context);
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
                        Spacer(
                          flex: 6,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            });
          }),
      floatingActionButton: Container(
        margin: EdgeInsets.only(
          left: wXD(100, context),
          bottom: hXD(35, context),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Text(
            '< Voltar',
            style:
                TextStyle(color: Color(0xff0000DA), fontSize: hXD(20, context)),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
