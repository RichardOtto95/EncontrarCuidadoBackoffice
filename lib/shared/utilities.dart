import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart';

double wXD(double size, BuildContext context) {
  double finalValue = MediaQuery.of(context).size.width * size / 1280;
  return finalValue;
}

double wXDM(double size, BuildContext context, {double min}) {
  double finalValue = MediaQuery.of(context).size.width * size / 1280;
  if (finalValue <= min) {
    return min;
  } else {
    return finalValue;
  }
}

double hXD(double size, BuildContext context) {
  double finalValue = MediaQuery.of(context).size.height * size / 801;
  return finalValue;
}

double hXDM(double size, BuildContext context) {
  double finalValue = MediaQuery.of(context).size.height * size / 801;
  if (finalValue <= size) {
    return size;
  } else {
    return finalValue;
  }
}

double maxWidth(BuildContext context) {
  double maxWidth = MediaQuery.of(context).size.width;
  return maxWidth;
}

double maxHeight(BuildContext context) {
  double maxWidth = MediaQuery.of(context).size.height;
  return maxWidth;
}

Future callFunction(String function, Map<String, dynamic> params) async {
  HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(function);
  try {
    if (kDebugMode) print('no try');
    return await callable.call(params);
  } on FirebaseFunctionsException catch (e) {
    if (kDebugMode) print('caught firebase functions exception');
    if (kDebugMode) print(e);
    if (kDebugMode) print(e.code);
    if (kDebugMode) print(e.message);
    if (kDebugMode) print(e.details);
    return false;
  } catch (e) {
    if (kDebugMode) print('caught generic exception');
    if (kDebugMode) print(e);
    return false;
  }
}

Future<bool> showToast(String msg) => Fluttertoast.showToast(
      webPosition: 'center',
      webBgColor: "linear-gradient(to bottom, #41c3b3, #21bcce)",
      msg: msg,
    );
