import 'package:back_office/shared/utilities.dart';
import 'package:back_office/shared/widgets/central_container.dart';
import 'package:back_office/views/home/widgets/page_title.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: CentralContainer(
          paddingLeft: wXD(37, context),
          paddingRight: wXD(37, context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageTitle(
                title: 'Sobre',
                left: 0,
              ),
              StreamBuilder(
                  stream:
                      FirebaseFirestore.instance.collection('info').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    } else {
                      if (kDebugMode)
                        print(
                            'object========================${snapshot.data.docs.first['about_backoffice']}');
                      return Text(
                        '${snapshot.data.docs.first['about_backoffice']}',
                        style:
                            TextStyle(color: Color(0xff000000), fontSize: 18),
                      );
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
