import 'package:back_office/shared/models/card_model.dart';
import 'package:back_office/views/home/home_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class CardData extends StatelessWidget {
  final CardModel cardView;

  const CardData({Key key, this.cardView}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // String getText(num text) {
    //   if (text != null) {
    //     if (text is double) {
    //       return text.toInt().toString();
    //     } else {
    //       return text.toString();
    //     }
    //   } else {
    //     return '0';
    //   }
    // }

    String getDocumentsToday(QuerySnapshot qs, String field) {
      int docsToday = 0;
      double transactions = 0;
      String today = DateTime.now()
          .subtract(Duration(hours: 3))
          .toString()
          .substring(0, 11);

      qs.docs.forEach((DocumentSnapshot doc) {
        if (doc[field] != null) {
          String date = doc[field].toDate().toString().substring(0, 11);
          //if(kDebugMode) print('$date contains $today ?? ${date.contains(today)}');
          if (date.contains(today)) {
            if (cardView.type == 'transactions') {
              //if(kDebugMode) print("Transaction value: ${doc['value']}");
              double value = doc['value'].toDouble();
              if (kDebugMode)
                print(
                    "Doc: ${doc.id} value: ${doc['value']} type: ${doc['type']} status: ${doc['status']}");
              if (doc['type'] == "subscription" && doc['status'] == "active") {
                String lastDate =
                    doc['date'].toDate().toString().substring(0, 11);
                if (lastDate.contains(date)) {
                  transactions += value;
                }
              } else if (doc['status'] != "refund" &&
                  doc['type'] != "subscription") {
                transactions = transactions + value;
              }
            } else {
              docsToday += 1;
            }
          }
        }
      });
      if (cardView.type == 'transactions') {
        //if(kDebugMode) print('today: $today, transactions $transactions  \n ');
        String string = transactions.toInt().toString();
        //if(kDebugMode) print("Transactions: $transactions");
        transactions > 1000000
            ? string = '+${string.substring(0, (string.length - 6))} milhõ'
            : transactions > 1000
                ? string = '+${string.substring(0, (string.length - 3))} mil'
                : transactions < 100
                    ? string = HomeProvider().formatedCurrency(transactions)
                    : string = "R\$ $string";
        return string;
      } else {
        //if(kDebugMode) print('today: $today, docs $docsToday  \n ');
        return docsToday.toString();
      }

      // qs.docs.forEach((DocumentSnapshot doc) {
      //   DateTime dateTime = DateTime.now();
      //  if(kDebugMode) print('dateTime: ${dateTime.toString()}');
      //   if (doc[field] != null &&
      //       doc[field].toDate().toString().contains(dateTime.day.toString()) &&
      //       doc[field]
      //           .toDate()
      //           .toString()
      //           .contains(dateTime.month.toString()) &&
      //       doc[field].toDate().toString().contains(dateTime.year.toString())) {
      //     if (cardView.type == 'transactions') {
      //       transactions += doc['value'];
      //     } else {
      //       docsToday += 1;
      //       //if(kDebugMode) print('patientsToday: $patientsToday');
      //     }
      //   }
      // });
      // if (cardView.type == 'transactions') {
      //   String string = transactions.toInt().toString();
      //   string.length > 6
      //       ? string = '+${string.substring(0, (string.length - 6))} milhõ'
      //       : string.length > 3
      //           ? string = '+${string.substring(0, (string.length - 3))} mil'
      //           : string = string;
      //   return string;
      // } else {
      //   //if(kDebugMode) print('patientsToday: $patientsToday');
      //   return docsToday.toString();
      // }
    }

    String getValue(QuerySnapshot qs) {
      //if(kDebugMode) print('cardView.type: ${cardView.type}');
      switch (cardView.type) {
        case 'SUPPORT':
          return getDocumentsToday(qs, 'updated_at');
          break;
        default:
          return getDocumentsToday(qs, 'created_at');

          break;
      }
    }

    return Container(
      height: 181,
      width: 333,
      margin: EdgeInsets.fromLTRB(40, 40, 40, 0),
      padding: EdgeInsets.fromLTRB(16, 20, 19, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(23)),
        boxShadow: [
          BoxShadow(
              blurRadius: 3, offset: Offset(0, 3), color: Color(0x20000000))
        ],
        color: cardView.primaryColor,
      ),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            cardView.icon,
            size: 22,
            color: Color(0xfffafafa),
          ),
          Center(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(cardView.type)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SelectableText(
                      getValue(snapshot.data),
                      maxLines: 1,
                      scrollPhysics: AlwaysScrollableScrollPhysics(),
                      style: TextStyle(
                          height: 1,
                          color: Color(0xfffafafa),
                          fontSize: 70,
                          fontWeight: FontWeight.bold),
                    );
                  } else {
                    return Container(
                      height: 70,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
          SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText('${cardView.title}',
                  style: TextStyle(
                    color: Color(0xfffafafa),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  )),
              Spacer(),
              InkWell(
                onTap: () {
                  Provider.of<HomeProvider>(context, listen: false)
                      .incPage(cardView.page);
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                      color: cardView.secondaryColor),
                  alignment: Alignment.center,
                  child: Transform.rotate(
                      angle: -math.pi / 4,
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: Color(0xfffafafa),
                        size: 23,
                      )),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
