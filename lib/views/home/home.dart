import 'package:back_office/shared/root.dart';
import 'package:back_office/shared/widgets/back_pop.dart';
import 'package:back_office/shared/widgets/nav_side_bar.dart';
import 'package:back_office/views/admins/admins.dart';
import 'package:back_office/views/admins/admins_provider.dart';
import 'package:back_office/views/ratings/ratings.dart';
import 'package:back_office/views/ratings/rating_provider.dart';
import 'package:back_office/views/doctors/doctors.dart';
import 'package:back_office/views/doctors/doctors_provider.dart';
import 'package:back_office/views/financial/financial.dart';
import 'package:back_office/views/financial/financial_provider.dart';
import 'package:back_office/views/financial/widgets/reverse.dart';
import 'package:back_office/views/home/home_provider.dart';
import 'package:back_office/views/home/widgets/about.dart';
import 'package:back_office/views/home/widgets/home_body.dart';
import 'package:back_office/views/home/widgets/top_bar.dart';
import 'package:back_office/views/notifications/notification_provider.dart';
import 'package:back_office/views/notifications/notifications.dart';
import 'package:back_office/views/patients/patient_provider.dart';
import 'package:back_office/views/patients/patients.dart';
import 'package:back_office/views/posts/post_provider.dart';
import 'package:back_office/views/posts/posts.dart';
import 'package:back_office/views/appointments/appointments.dart';
import 'package:back_office/views/appointments/appointments_provider.dart';
import 'package:back_office/views/sign_in/sign_in.dart';
import 'package:back_office/views/suport/suport_page.dart';
import 'package:back_office/views/suport/suport_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final FirebaseAuth user;

  const Home({Key key, this.user}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // User _auth = Globals().autht();
  bool back = false;
  bool reverse = false;
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    //if(kDebugMode) print(
    //     'FirebaseAuth.instance.currentUser.uid: ${FirebaseAuth.instance.currentUser.phoneNumber}');
    return ChangeNotifierProvider(
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Color(0xffeaeaea),
          body: Stack(
            children: [
              Row(
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('admins')
                        .where('mobile_full_number',
                            isEqualTo:
                                FirebaseAuth.instance.currentUser.phoneNumber)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        QuerySnapshot qs = snapshot.data;
                        DocumentSnapshot ds = qs.docs.first;
                        return NavSideBar(
                          suport: !(ds['role'] == 'ADMIN'),
                          onExit: () {
                            setState(() {
                              back = true;
                            });
                          },
                        );
                      } else {
                        return EmptySideBar();
                      }
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TopBar(),
                      Consumer<HomeProvider>(
                        builder: (context, value, child) {
                          switch (value.page) {
                            case 1:
                              return HomeBody();
                              break;
                            case 2:
                              return ChangeNotifierProvider(
                                  create: (BuildContext context) =>
                                      PatientProvider(),
                                  child: Patients());
                              break;
                            case 3:
                              return ChangeNotifierProvider(
                                  create: (BuildContext context) =>
                                      DoctorProvider(),
                                  child: Doctors());
                              break;
                            case 4:
                              return ChangeNotifierProvider(
                                  create: (BuildContext context) =>
                                      AppointmentProvider(),
                                  child: Appointments());
                              break;
                            case 5:
                              return ChangeNotifierProvider(
                                  create: (BuildContext context) =>
                                      RatingProvider(),
                                  child: Ratings());
                              break;
                            case 6:
                              return ChangeNotifierProvider(
                                  create: (BuildContext context) =>
                                      PostProvider(),
                                  child: Posts());
                              break;
                            case 7:
                              return ChangeNotifierProvider(
                                  create: (BuildContext context) =>
                                      FinancialProvider(),
                                  child: Financial(
                                    reverse: reverse,
                                    // onReverseClick: () {
                                    //   setState(() {
                                    //     reverse = true;
                                    //   });
                                    // },
                                  ));
                              break;
                            case 8:
                              return ChangeNotifierProvider(
                                  create: (context) => SuportProvider(),
                                  child: Suport());
                              break;
                            case 9:
                              return ChangeNotifierProvider(
                                  create: (BuildContext context) =>
                                      NotificationProvider(),
                                  child: Notifications());
                              break;
                            case 10:
                              return About();
                              break;
                            case 11:
                              return ChangeNotifierProvider(
                                  create: (BuildContext context) =>
                                      AdminProvider(),
                                  child: Admins());
                              break;
                            default:
                              return Center(
                                child: Text('Erro na exibição'),
                              );
                          }
                        },
                      )
                    ],
                  )
                ],
              ),
              ReversePop(
                reverse: reverse,
                onConfirm: () {
                  setState(() {
                    reverse = false;
                  });
                  Provider.of<HomeProvider>(context, listen: false)
                      .incEstornarPage(false);
                },
                onCancel: () {
                  setState(() {
                    reverse = false;
                  });
                },
              ),
              BackPop(
                back: back,
                onCancel: () {
                  setState(() {
                    back = !back;
                  });
                },
                onConfirm: () {
                  Globals().authSignOut();
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return SignIn();
                    },
                  ));
                },
              )
            ],
          ),
        );
      },
      create: (context) {
        return HomeProvider();
      },
    );
  }
}
