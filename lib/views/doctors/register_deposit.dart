import 'package:back_office/shared/utilities.dart';
import 'package:back_office/shared/widgets/blue_button.dart';
import 'package:back_office/shared/widgets/central_container.dart';
import 'package:back_office/shared/widgets/data_tile.dart';
import 'package:back_office/shared/widgets/dialog_widget.dart';
import 'package:back_office/views/home/home_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'doctors_provider.dart';
import 'models/doctor_model.dart';

class RegisterDeposit extends StatefulWidget {
  final DoctorModel doctorModel;

  RegisterDeposit({Key key, this.doctorModel}) : super(key: key);

  @override
  _RegisterDepositState createState() => _RegisterDepositState();
}

class _RegisterDepositState extends State<RegisterDeposit> {
  DateTime dateTime = DateTime.now();
  num balanceAvailable = 0;
  num balanceToRelease = 0;
  DoctorProvider doctorProvider = DoctorProvider();
  List<DocumentSnapshot> lastMonthTrs = [];

  String formatedCurrency(num value) {
    var numberFormat = new NumberFormat("#,##0.00", "pt_BR");
    var newValue = numberFormat.format(value);
    return newValue;
  }

  num getBalanceAvailable(QuerySnapshot trscs) {
    if (kDebugMode)
      print('gggggggggggggggggggg getBalanceAvailable ${trscs.docs.length}');
    balanceAvailable = 0;
    DateTime firstDayPreviousMonth =
        DateTime.utc(DateTime.now().year, DateTime.now().month - 1, 1);

    if (kDebugMode)
      print('gggggggggggggggggggg firstDayLastMonth $firstDayPreviousMonth ');

    DateTime firstDayCurrentMonth = DateTime.utc(
      DateTime.now().year,
      DateTime.now().month,
      1,
    );

    if (kDebugMode)
      print('gggggggggggggggggggg lastDayLastMonth $firstDayCurrentMonth ');

    trscs.docs.forEach((element) {
      if (kDebugMode) print('fffffffffffffff forEach ${element.id}');

      DateTime createdAt = new DateTime.fromMillisecondsSinceEpoch(
          element.get('created_at').millisecondsSinceEpoch);

      if (kDebugMode) print('createdAt ======================$createdAt');

      if (kDebugMode)
        print(
            'createdAt > firstDayLastMonth ======================${createdAt.isAfter(firstDayPreviousMonth)}');

      if (kDebugMode)
        print(
            'createdAt < lastDayLastMonth ======================${createdAt.isBefore(firstDayCurrentMonth)}');

      if (createdAt.isAfter(firstDayPreviousMonth) &&
          createdAt.isBefore(firstDayCurrentMonth)) {
        balanceAvailable += element.get('value');
        lastMonthTrs.add(element);
      }
    });
    if (kDebugMode)
      print('balanceAvailable ======================$balanceAvailable');
    return balanceAvailable;
  }

  num getBalanceToRelease(QuerySnapshot trscs) {
    if (kDebugMode)
      print('gggggggggggggggggggg getBalanceToRelease ${trscs.docs.length}');
    balanceToRelease = 0;

    DateTime firstDayCurrentMonth =
        DateTime.utc(DateTime.now().year, DateTime.now().month, 1);

    // DateTime lastDayCurrentMonth = DateTime.utc(
    //   DateTime.now().year,
    //   DateTime.now().month + 1,
    // ).subtract(Duration(days: 1));

    DateTime lastDayCurrentMonth = DateTime.utc(
      DateTime.now().year,
      DateTime.now().month + 1,
      1,
    );

    if (kDebugMode)
      print('gggggggggggggggggggg firstDayCurrentMonth $firstDayCurrentMonth ');
    if (kDebugMode)
      print('gggggggggggggggggggg lastDayCurrentMonth $lastDayCurrentMonth ');

    trscs.docs.forEach((element) {
      if (kDebugMode) print('fffffffffffffff forEach ${element.id}');

      DateTime createdAt = new DateTime.fromMillisecondsSinceEpoch(
          element.get('created_at').millisecondsSinceEpoch);

      if (kDebugMode) print('createdAt ======================$createdAt');

      if (kDebugMode)
        print(
            'createdAt > firstDayLastMonth ======================${createdAt.isAfter(firstDayCurrentMonth)}');

      if (kDebugMode)
        print(
            'createdAt < lastDayLastMonth ======================${createdAt.isBefore(lastDayCurrentMonth)}');

      if (kDebugMode)
        print(
            'element.get(value) ======================${element.get('value')}');

      if (createdAt.isAfter(firstDayCurrentMonth) &&
          createdAt.isBefore(lastDayCurrentMonth)) {
        balanceToRelease += element.get('value');
      }
    });
    if (kDebugMode)
      print('balanceAvailable ======================$balanceToRelease');
    return balanceToRelease;
  }

  toPay() async {
    DocumentReference transactionRef =
        await FirebaseFirestore.instance.collection('transactions').add({
      'created_at': Timestamp.now(),
      'updated_at': Timestamp.now(),
      'note': 'monthly_income',
      'reciever': widget.doctorModel.username,
      'reciever_id': widget.doctorModel.id,
      'sender': "EncontrarCuidado",
      'sender_id': null,
      'status': 'INCOME',
      'type': 'PAYOUT',
      'value': balanceAvailable,
      'appointment_id': null,
    });

    await transactionRef.update({
      'id': transactionRef.id,
    });

    await FirebaseFirestore.instance
        .collection('doctors')
        .doc(widget.doctorModel.id)
        .collection('transactions')
        .doc(transactionRef.id)
        .set({
      'created_at': Timestamp.now(),
      'updated_at': Timestamp.now(),
      'note': 'monthly_income',
      'reciever': widget.doctorModel.username,
      'reciever_id': widget.doctorModel.id,
      'sender': "EncontrarCuidado",
      'sender_id': null,
      'status': 'INCOME',
      'type': 'PAYOUT',
      'value': balanceAvailable,
      'id': transactionRef.id,
      'appointment_id': null,
    });

    lastMonthTrs.forEach((element) async {
      await element.reference.update({
        'status': 'INCOME',
      });
      await FirebaseFirestore.instance
          .collection('transactions')
          .doc(element.id)
          .update({
        'status': 'INCOME',
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider = HomeProvider();

    return CentralContainer(
      paddingBottom: 0,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('doctors')
              .doc(widget.doctorModel.id)
              .collection('transactions')
              .where('status', isEqualTo: 'PENDING_INCOME')
              .snapshots(),
          builder: (context, snapshots) {
            if (!snapshots.hasData) {
              return Container(
                height: 600,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            } else {
              QuerySnapshot trs = snapshots.data;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: wXD(983, context),
                    padding: EdgeInsets.fromLTRB(30, 28, 0, 30),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Color(0xff707070).withOpacity(.5)))),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Provider.of<DoctorProvider>(context,
                                  listen: false)
                              .incDoctorPage(1),
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          child: Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Color(0xff707070).withOpacity(.5),
                              size: 30,
                            ),
                          ),
                        ),
                        SelectableText(
                          'Registrar depósito',
                          style: TextStyle(
                            fontSize: 28,
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(children: [
                    DataTile(
                      title: 'ID: ',
                      data: widget.doctorModel.id ?? '- - -',
                    ),
                    DataTile(
                      title: 'Nome completo: ',
                      data: widget.doctorModel.username ?? '- - -',
                    ),
                    DataTile(
                      title: 'CPF: ',
                      data: HomeProvider()
                              .getTextMasked(widget.doctorModel.cpf, 'cpf') ??
                          '- - -',
                    ),
                    DataTile(
                      title: 'CRM: ',
                      data: widget.doctorModel.crm ?? '- - -',
                    ),
                    DataTile(
                        title: 'Saldo a liberar: ',
                        data: '${formatedCurrency(getBalanceToRelease(trs))}'),
                  ]),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(height: 60),
                        SelectableText(
                          'Saldo disponível: ${formatedCurrency(getBalanceAvailable(trs))}',
                          maxLines: 1,
                          cursorColor: Colors.grey,
                          showCursor: true,
                          enableInteractiveSelection: true,
                          toolbarOptions: ToolbarOptions(
                              copy: true,
                              selectAll: true,
                              cut: false,
                              paste: false),
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 19),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SelectableText(
                              'Data:   ',
                              maxLines: 1,
                              cursorColor: Colors.grey,
                              showCursor: true,
                              enableInteractiveSelection: true,
                              toolbarOptions: ToolbarOptions(
                                  copy: true,
                                  selectAll: true,
                                  cut: false,
                                  paste: false),
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            DateField(
                              dateTime: dateTime,
                              onTap: () async {
                                dateTime = await homeProvider.selectDate(
                                  context,
                                  dateTime,
                                );
                                if (kDebugMode) print('date time: $dateTime');
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                        // SizedBox(height: 170)
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(26, 32, 56, 23),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Provider.of<DoctorProvider>(context, listen: false)
                                .incDoctorPage(1);
                          },
                          child: Text(
                            '< Voltar',
                            style: TextStyle(
                                color: Color(0xff0000DA),
                                fontSize: hXD(20, context)),
                          ),
                        ),
                        balanceAvailable > 0
                            ? BlueButton(
                                text: 'Registrar',
                                onTap: () {
                                  showDialog(
                                    useRootNavigator: true,
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (dialogContext) {
                                      return DialogWidget(
                                        onCancel: () {
                                          Navigator.pop(dialogContext);
                                        },
                                        onConfirm: (text) async {
                                          await toPay();
                                          lastMonthTrs.clear();
                                          balanceAvailable = 0;
                                          Navigator.pop(dialogContext);
                                        },
                                        title:
                                            'Tem certeza que deseja registrar este depósito?',
                                      );
                                    },
                                  );
                                },
                              )
                            : Container()
                      ],
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}

class Receiver extends StatelessWidget {
  final String title;

  const Receiver({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      width: 460,
      alignment: Alignment.centerLeft,
      child: Text(
        '$title',
        // overflow: TextOverflow.ellipsis,
        style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: 22,
          fontWeight: FontWeight.w400,
          color: Color(0xff707070),
        ),
      ),
    );
  }
}

class ParameterTitle extends StatelessWidget {
  final String title;

  const ParameterTitle({
    Key key,
    this.title,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      '$title',
      style: TextStyle(
        color: Color(0xff000000),
        fontSize: 22,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class DateField extends StatelessWidget {
  final DateTime dateTime;
  final Function onTap;
  const DateField({
    Key key,
    this.dateTime,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        width: 213,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xff707070).withOpacity(.8),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              alignment: Alignment.center,
              child: Text(
                '${dateTime.day}',
                maxLines: 1,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '/',
              style: TextStyle(
                color: Color(0xff707070).withOpacity(.5),
                fontSize: 25,
              ),
            ),
            Container(
              width: 56,
              alignment: Alignment.center,
              child: Text(
                '${dateTime.month}',
                maxLines: 1,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '/',
              style: TextStyle(
                color: Color(0xff707070).withOpacity(.5),
                fontSize: 25,
              ),
            ),
            Container(
              width: 56,
              alignment: Alignment.center,
              child: Text(
                '${dateTime.year}',
                maxLines: 1,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
