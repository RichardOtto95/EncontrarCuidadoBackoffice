import 'package:back_office/shared/models/data_models.dart';
import 'package:back_office/shared/utilities.dart';
import 'package:back_office/shared/widgets/blue_button.dart';
import 'package:back_office/shared/widgets/central_container.dart';
import 'package:back_office/shared/widgets/data_tile.dart';
import 'package:back_office/shared/widgets/dialog_widget.dart';
import 'package:back_office/views/financial/models/financial_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import '../financial_provider.dart';

class FinancialData extends StatelessWidget {
  final DataTestModel dataTestModel;
  final FinancialModel financialModel;

  const FinancialData({
    Key key,
    this.dataTestModel,
    this.financialModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OverlayEntry overlayEntry;
    if (kDebugMode)
      print("FinancialModel: ${FinancialModel().toJson(financialModel)}");
    final _formKey = GlobalKey<FormState>();

    Map<String, dynamic> financialMap = {};

    return CentralContainer(
      paddingBottom: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: wXD(983, context),
            padding: EdgeInsets.fromLTRB(30, 28, 0, 30),
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: Color(0xff707070).withOpacity(.5)))),
            child: Row(
              children: [
                InkWell(
                  onTap: () =>
                      Provider.of<FinancialProvider>(context, listen: false)
                          .incFinancialPage(1),
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
                  '${dataTestModel.title}',
                  style: TextStyle(
                    fontSize: 28,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: List.generate(
                dataTestModel.tiles.length,
                (index) => DataTestTile(
                  // notes: [
                  //   {
                  //     'data': 'Pagamento',
                  //     'data_field': 'pending_income',
                  //   },
                  //   {
                  //     'data': 'Estornado',
                  //     'data_field': 'reverted',
                  //   },
                  //   {
                  //     'data': 'Estorno solicitado',
                  //     'data_field': 'revert',
                  //   },
                  //   {
                  //     'data': 'Pago',
                  //     'data_field': 'paid',
                  //   },
                  //   {
                  //     'data': 'Pagamento mensal',
                  //     'data_field': 'monthly_income',
                  //   },
                  // ],
                  // module: 'financial',
                  statuses: [
                    {
                      'data': 'Estornado',
                      'data_field': 'REFUND',
                    },
                    {
                      'data': 'Estorno solicitado',
                      'data_field': 'REFUND_REQUESTED_INCOME',
                    },
                    {
                      'data': 'Recebimento',
                      'data_field': 'INCOME',
                    },
                    {
                      'data': 'A estornar',
                      'data_field': 'PENDING_REFUND',
                    },
                    {
                      'data': 'Recebimento pendente',
                      'data_field': 'PENDING_INCOME',
                    },
                    {
                      'data': 'Pagamento',
                      'data_field': 'OUTCOME',
                    },
                  ],
                  types: [
                    {
                      'data': 'Caução',
                      'data_field': 'GUARANTEE',
                    },
                    {
                      'data': 'Estorno de caução',
                      'data_field': 'GUARANTEE_REFUND',
                    },
                    {
                      'data': 'Remanescente',
                      'data_field': 'REMAINING',
                    },
                    {
                      'data': 'Estorno de remanescente',
                      'data_field': 'REMAINING_REFUND',
                    },
                    {
                      'data': 'Assinatura',
                      'data_field': 'SUBSCRITION',
                    },
                    {
                      'data': 'Pagamento por fora',
                      'data_field': 'PAYOUT',
                    },
                  ],
                  type: dataTestModel.tiles[index].type,
                  edit: dataTestModel.edit,
                  data: dataTestModel.tiles[index].data,
                  title: dataTestModel.tiles[index].title,
                  onChanged: (val) {
                    financialMap[dataTestModel.tiles[index].type] = val;

                    if (kDebugMode) print('val: $val');
                    if (kDebugMode)
                      print(
                          '${dataTestModel.tiles[index].type} = ${financialMap[dataTestModel.tiles[index].type]} \n ');
                  },
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50, bottom: 100),
              child: Visibility(
                visible: dataTestModel.edit,
                child: financialModel.type == 'Assinatura' ||
                        financialModel.status == 'Estorno solicitado'
                    ? InkWell(
                        onTap: () => financialModel.type == 'Assinatura'
                            ? showDialog(
                                useRootNavigator: true,
                                context: context,
                                barrierDismissible: true,
                                builder: (dlContext) {
                                  return DialogWidget(
                                    title:
                                        'Tem certeza que deseja cancelar esta assinatura?',
                                    onConfirm: (text) async {
                                      if (kDebugMode)
                                        print("Confirm remove subscription");

                                      await callFunction("removeSignature", {
                                        "userId": financialModel.receiverId,
                                      });

                                      showToast(
                                          "Assinatura cancelada com sucesso");

                                      Navigator.pop(context);

                                      Provider.of<FinancialProvider>(context,
                                              listen: false)
                                          .incFinancialPage(1);
                                    },
                                    onCancel: () => Navigator.pop(context),
                                  );
                                },
                              )
                            : showDialog(
                                useRootNavigator: true,
                                context: context,
                                barrierDismissible: true,
                                builder: (dlContext) {
                                  return DialogWidget(
                                    hasJustification: true,
                                    title:
                                        'Tem certeza que deseja estornar esta transação? Justifique!',
                                    onConfirm: (text) async {
                                      overlayEntry = OverlayEntry(
                                        builder: (context) => Container(
                                          height: maxHeight(context),
                                          width: maxWidth(context),
                                          alignment: Alignment.center,
                                          color: Colors.black.withOpacity(.6),
                                          child: CircularProgressIndicator(),
                                        ),
                                      );

                                      Overlay.of(context).insert(overlayEntry);

                                      Future.delayed(Duration(seconds: 3));
                                      await callFunction("refundTransaction", {
                                        "transactionId": financialModel.id,
                                        "adminRefund": true,
                                      });
                                      showToast(
                                          "Estorno realizado com sucesso");
                                      // DocumentSnapshot docDoc =
                                      //     await FirebaseFirestore.instance
                                      //         .collection("doctors")
                                      //         .doc(financialModel.receiverId)
                                      //         .get();

                                      // DocumentSnapshot patDoc =
                                      //     await FirebaseFirestore.instance
                                      //         .collection("patients")
                                      //         .doc(financialModel.senderId)
                                      //         .get();

                                      // await docDoc.reference
                                      //     .collection('transactions')
                                      //     .doc(financialModel.id)
                                      //     .update({
                                      //   "status": "refund_pending",
                                      //   "note": text,
                                      // });

                                      // await patDoc.reference
                                      //     .collection('transactions')
                                      //     .doc(financialModel.id)
                                      //     .update({
                                      //   "status": "refund_pending",
                                      //   "note": text,
                                      // });

                                      // await FirebaseFirestore.instance
                                      //     .collection('transactions')
                                      //     .doc(financialModel.id)
                                      //     .update({
                                      //   "status": "refund_pending",
                                      //   "note": text,
                                      // });

                                      // callFunction("notifyUser", {
                                      //   "text":
                                      //       "A transação de código ${financialModel.appointmentId.substring(0, 5).toUpperCase()} foi reembolsada",
                                      //   "senderId": null,
                                      //   "receiverId": docDoc.id,
                                      //   "collection": "doctors",
                                      // });
                                      // callFunction("notifyUser", {
                                      //   "text":
                                      //       "A transação de código ${financialModel.appointmentId.substring(0, 5).toUpperCase()} foi reembolsada",
                                      //   "senderId": null,
                                      //   "receiverId": patDoc.id,
                                      //   "collection": "patients",
                                      // });
                                      overlayEntry.remove();
                                      Navigator.pop(context);
                                      Provider.of<FinancialProvider>(context,
                                              listen: false)
                                          .incFinancialPage(1);
                                    },
                                    onCancel: () => Navigator.pop(context),
                                  );
                                },
                              ),
                        child: Container(
                          height: 32,
                          width: 149,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            color: Color(0xffE63A31).withOpacity(.86),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            financialModel.type == 'Assinatura'
                                ? "Cancelar"
                                : 'Estornar',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Color(0xfffafafa),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(26, 32, 56, 23),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Provider.of<FinancialProvider>(context, listen: false)
                        .incFinancialPage(1);
                  },
                  child: Text(
                    '< Voltar',
                    style: TextStyle(
                        color: Color(0xff0000DA), fontSize: hXD(20, context)),
                  ),
                ),
                Visibility(
                  visible: dataTestModel.edit,
                  child: BlueButton(
                    text: 'Salvar',
                    onTap: () async {
                      DocumentSnapshot docDoc = await FirebaseFirestore.instance
                          .collection("doctors")
                          .doc(financialModel.receiverId)
                          .get();

                      DocumentSnapshot patDoc = await FirebaseFirestore.instance
                          .collection("patients")
                          .doc(financialModel.senderId)
                          .get();

                      if (_formKey.currentState.validate()) {
                        await docDoc.reference
                            .collection('transactions')
                            .doc(financialModel.id)
                            .update(financialMap);
                        try {
                          await patDoc.reference
                              .collection('transactions')
                              .doc(financialModel.id)
                              .update(financialMap);
                        } catch (e) {
                          if (kDebugMode) print("Error: $e");
                        }

                        await FirebaseFirestore.instance
                            .collection('transactions')
                            .doc(financialModel.id)
                            .update(financialMap);

                        Provider.of<FinancialProvider>(context, listen: false)
                            .incFinancialPage(1);
                      } else {
                        await Fluttertoast.showToast(
                          webPosition: 'center',
                          webBgColor:
                              "linear-gradient(to bottom, #41c3b3, #21bcce)",
                          msg: 'Verifique os campos novamente',
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
