import 'package:back_office/shared/root.dart';
import 'package:back_office/views/home/home.dart';
import 'package:back_office/views/sign_in/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainPage extends StatefulWidget {
  final String title;
  const MainPage({Key key, this.title = 'SplashPage'}) : super(key: key);
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  @override
  void initState() {
    //if(kDebugMode) print('_auth ========== :${Globals().autht()}');
    if (Globals().autht() == null) {
      Future.delayed(Duration.zero, () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => SignIn()));
      });
    } else if (Globals().autht() != null) {
      Future.delayed(Duration.zero, () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => Home()));
      });
    }
    FirebaseAuth.instance.idTokenChanges().listen((event) {
      //if(kDebugMode) print("On Data-========================================: $event");
      if (event != null) {
        FirebaseFirestore.instance
            .collection('admins')
            .where('mobile_full_number', isEqualTo: event.phoneNumber)
            .get()
            .then((value) {
          //if(kDebugMode) print('value: ${value.docs.first.data()}');
          Future.delayed(Duration.zero, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) => Home()));
          });
        }).onError((error, stackTrace) {
          Fluttertoast.showToast(
              msg: "Usuario nao permitido",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
              fontSize: 16.0);
          Future.delayed(Duration.zero, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) => SignIn()));
          });
        });
      } else {
        Future.delayed(Duration.zero, () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => SignIn()));
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Container()));

    // Container(
    //   child: Center(
    //     child: Image.asset(
    //       "assets/aiyou_splash.png",
    //     ),
    //   ),
    // );
    // appBar: AppBar(
    //  title: Text(widget.title),
    //  ),
    // body: Center(
    //  child: CircularProgressIndicator(),
    //  ));
    //}

    //@override
    //void dispose() {
    // super.dispose();
    // disposer();
  }
}
