import 'package:back_office/shared/root.dart';
import 'package:back_office/views/home/home.dart';
import 'package:back_office/views/sign_in/sign_check.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignInProvider extends ChangeNotifier {
  int _financialPage = 1;

  int get financialPage => _financialPage;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userVerifyId;
  ConfirmationResult resulConfirm;
  incFinancialPage(financialPage) {
    _financialPage = financialPage;
    notifyListeners();
  }

  incfinancialModel(financialModel) {
    // _financialModel = financialModel;
    notifyListeners();
  }

  bool _hideAccount = true;

  bool get hideAccount => _hideAccount;

  setHideAccount(hideAccount) {
    _hideAccount = hideAccount;
    notifyListeners();
  }

  bool _loadCircular = false;

  bool get loadCircular => _loadCircular;

  setLoadCircular(bool loadCircular) {
    _loadCircular = loadCircular;
    notifyListeners();
  }

  Future<bool> validateUserPhone(phoneMobile) async {
    bool validate = false;
    await FirebaseFirestore.instance
        .collection('admins')
        .where('mobile_full_number', isEqualTo: phoneMobile)
        .get()
        .then((value) {
      if (value.docs.first.exists) {
        validate = true;
      } else {
        if (kDebugMode) print('Toast 1');
        Fluttertoast.showToast(
            msg: "Usuário não autorizado",
            webPosition: 'center',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            webBgColor: "linear-gradient(to bottom, #41c3b3, #21bcce)",
            textColor: Colors.white,
            fontSize: 16.0);
        validate = false;
        setLoadCircular(false);
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) print('Toast 2');
      Fluttertoast.showToast(
          msg: "Usuário não autorizado",
          webPosition: 'center',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          webBgColor: "linear-gradient(to bottom, #41c3b3, #21bcce)",
          textColor: Colors.white,
          fontSize: 16.0);
      setLoadCircular(false);
      validate = false;
    });
    return validate;
  }

  Future verifyNumber(String userPhone, context) async {
    setLoadCircular(true);
    if (userPhone == null) {
      Fluttertoast.showToast(
          msg: "Digite seu número para continuar",
          webPosition: 'center',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          webBgColor: "linear-gradient(to bottom, #41c3b3, #21bcce)",
          textColor: Colors.white,
          fontSize: 16.0);
      setLoadCircular(false);
      return;
    } else if (userPhone.length != 11) {
      Fluttertoast.showToast(
          msg: "Digite o número corretamente",
          webPosition: 'center',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          webBgColor: "linear-gradient(to bottom, #41c3b3, #21bcce)",
          textColor: Colors.white,
          fontSize: 16.0);
      setLoadCircular(false);
      return;
    }
    if (kDebugMode) print('userPhone: $userPhone');
    String phoneMobile = '+55' + userPhone;
    if (kDebugMode) print('phoneMobile: $phoneMobile');
    QuerySnapshot _doctors = await FirebaseFirestore.instance
        .collection('doctors')
        .where('phone', isEqualTo: phoneMobile)
        .get();
    QuerySnapshot _patients = await FirebaseFirestore.instance
        .collection('patients')
        .where('phone', isEqualTo: phoneMobile)
        .get();

    if (_doctors.docs.isNotEmpty || _patients.docs.isNotEmpty) {
      Fluttertoast.showToast(
          msg:
              "Esse número de usuário não tem permissão para acessar este aplicativo",
          webPosition: 'center',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          webBgColor: "linear-gradient(to bottom, #41c3b3, #21bcce)",
          textColor: Colors.white,
          fontSize: 16.0);
      setLoadCircular(false);
    } else if (await validateUserPhone(phoneMobile)) {
      if (kDebugMode) print('phoneMobile: $phoneMobile');
      resulConfirm = await _auth.signInWithPhoneNumber(phoneMobile);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  SignCheck(resulConfirm: resulConfirm)));
      setLoadCircular(false);
    }
    // String verifID;
    //if(kDebugMode) print('phne ===$userPhone');

    //if(kDebugMode) print('phne ===$phoneMobile');
    // setLoadCircular(false);
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (BuildContext context) => SignCheck(
    //               resulConfirm: resulConfirm,
    //             )));
  }

  Future verifyCode(
      String code, ConfirmationResult resulConfirm, context) async {
    setLoadCircular(true);

    if (kDebugMode)
      print(
          'resulConfirm.verificationId ==========1: ${resulConfirm.verificationId}');

    if (kDebugMode) print('code: $code');
    if (code.length != 6) {
      Fluttertoast.showToast(
          msg: "Digite o código corretamente",
          webPosition: 'center',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          webBgColor: "linear-gradient(to bottom, #41c3b3, #21bcce)",
          textColor: Colors.white,
          fontSize: 16.0);
      setLoadCircular(false);
    } else {
      try {
        UserCredential userCredential = await resulConfirm.confirm(code);
        Globals().changeInteger(_auth);
        User user = userCredential.user;
        if (kDebugMode) print('userCredential: $userCredential');
        if (kDebugMode)
          print('_auth.currentUser ==========2: ${_auth.currentUser}');

        //  Globals().autht();
        if (kDebugMode) print('### user: $user');
        if (kDebugMode) print('### user: ${user.phoneNumber}');
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ));
        setLoadCircular(false);
      } on FirebaseAuthException catch (e) {
        if (kDebugMode) print('Failed with error code: ${e.code}');
        switch (e.code) {
          case 'invalid-verification-code':
            setLoadCircular(false);
            return Fluttertoast.showToast(
                msg: "Código inválido",
                webPosition: 'center',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                webBgColor: "linear-gradient(to bottom, #41c3b3, #21bcce)",
                textColor: Colors.white,
                fontSize: 16.0);
            break;
          default:
            setLoadCircular(false);
            if (kDebugMode) print('Case of ${e.code} not defined');
        }
      }
    }
  }
}
