import 'package:back_office/shared/models/data_models.dart';
import 'package:back_office/views/home/home_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'models/financial_model.dart';

class FinancialProvider extends ChangeNotifier {
  int _financialPage = 1;

  int get financialPage => _financialPage;

  incFinancialPage(financialPage) {
    _financialPage = financialPage;
    notifyListeners();
  }

  int _pageView = 0;

  int get pageView => _pageView;

  incPageView(pageView) {
    _pageView = pageView;
    notifyListeners();
  }

  int _pageCount = 0;

  int get pageCount => _pageCount;

  incPageCount(pageCount) {
    _pageCount = pageCount;
    notifyListeners();
  }

  FinancialModel _financialModel = FinancialModel();

  FinancialModel get financialModel => _financialModel;

  incfinancialModel(financialModel) {
    _financialModel = financialModel;
    notifyListeners();
  }

  bool _hideAccount = true;

  bool get hideAccount => _hideAccount;

  setHideAccount(hideAccount) {
    _hideAccount = hideAccount;
    notifyListeners();
  }

  List<FinancialGridModel> getFinancialsGridData(QuerySnapshot qs) {
    List<FinancialGridModel> financialsGrid = [];
    HomeProvider provider = HomeProvider();

    //if(kDebugMode) print('qsqsqsqsqsqs: $qs');

    qs.docs.forEach((financial) {
      //if(kDebugMode) print('finaaaaaaancial: $financial');
      FinancialModel financialModel =
          FinancialModel.fromDocument(financial.data());
      financialModel.type = provider.getPortugueseType(financialModel.type);
      financialModel.status = provider
          .getPortugueseStatus(financialModel.status, module: 'financial');
      //if(kDebugMode) print('financialModel: $financialModel');
      FinancialGridModel financialGridModel =
          FinancialGridModel(false, financialModel);
      //if(kDebugMode) print('financialGridModel: $financialGridModel');
      financialsGrid.add(financialGridModel);
      //if(kDebugMode) print('financialsGrid: $financialsGrid');
    });
    return financialsGrid;
  }

  Map<String, dynamic> _doctorDoc = {};

  Map<String, dynamic> get doctorDoc => _doctorDoc;

  Future<DataTestModel> getRegisterDataModel(
      FinancialModel financialModel) async {
    //if(kDebugMode) print('step: 1');
    //if(kDebugMode) print('financialModel.receiverId: ${financialModel.receiverId}');

    DocumentSnapshot _doctor = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(financialModel.receiverId)
        .get();
    _doctorDoc = _doctor.data();
    //if(kDebugMode) print('step: 2');
    //if(kDebugMode) print('_doctorDoc: $_doctorDoc');

    Map<String, dynamic> doctorMap = _doctor.data();
    List<TileTestModel> tiles = [
      TileTestModel('ID: ', financialModel.receiverId, 'receiverId'),
      TileTestModel('Nome Completo: ', financialModel.receiver, 'receiver'),
      TileTestModel('CPF: ', doctorMap['cpf'], 'cpf'),
      TileTestModel('CRM: ', doctorMap['crm'], 'crm'),
      TileTestModel('Saldo a liberar: ', financialModel.value, 'value'),
    ];
    //if(kDebugMode) print('step: 3');

    return DataTestModel(false, tiles: tiles);
  }

  financialStatement({
    Map<String, dynamic> doctor,
    DateTime dateTime,
    FinancialModel financialModel,
    BuildContext context,
  }) async {
    Map<String, dynamic> financialStatementMap = {
      'avaiable_balance': '<Valor disponível para o doutor>',
      'cpf': doctor['cpf'],
      'crm': doctor['crm'],
      'doctor_id': doctor['id'],
      'unavailable_balance': '<Saldo total do doutor>',
    };

    String period =
        '${dateTime.year.toString()}${dateTime.month.toString().padLeft(2, '0')}';

    Map<String, dynamic> periodBalance = {
      'available_balance': financialModel.value,
      // <Saldo total do doutor neste momendo>
      'unavailable_balance': 100,
      'withdraw_date': dateTime,
      // <VALOR QUE VAI SER TRANSERIDO OU FOI TRANSFERIDO>
      'withdrawed_balance': 0,
    };

    Map<String, dynamic> transactionRegister = {
      'date': dateTime,
      'id': '',
      'note': 'Balanço mensal',
      'receiver': doctor['fullname'],
      'receiver_id': doctor['id'],
      'sender': 'SuportName',
      'sender_id': '<user.uid>',
      'value': financialModel.value,
      'status': 'done',
      'type': 'doctor_transaction',
    };
    try {
      await FirebaseFirestore.instance
          .collection('financial_statements')
          .doc(doctor['id'])
          .update(financialStatementMap);
    } catch (e) {
      //if(kDebugMode) print('($e)');
      if (e.toString() ==
          'Bad state: cannot get a field on a DocumentSnapshotPlatform which does not exist') {
        await FirebaseFirestore.instance
            .collection('financial_statements')
            .doc(doctor['id'])
            .set(financialStatementMap);
      }
    }
    // await FirebaseFirestore.instance
    //     .collection('financial_statements')
    //     .doc(doctor['id'])
    //     .set({
    //   'avaiable_balance': '',
    //   'cpf': doctor['cpf'],
    //   'crm': doctor['crm'],
    //   'doctor_id': doctor['id'],
    //   'unavailable_balance': '',
    // });

    await FirebaseFirestore.instance
        .collection('financial_statements')
        .doc(doctor['id'])
        .collection('periods')
        .doc(period)
        .set(periodBalance);

    await FirebaseFirestore.instance
        .collection('transactions')
        .doc(financialModel.id)
        .update({
      'status': 'deposited',
    });

    await FirebaseFirestore.instance
        .collection('transactions')
        .add(transactionRegister)
        .then((value) => value.update({'id': value.id}));

    await FirebaseFirestore.instance
        .collection('transactions')
        .add(transactionRegister)
        .then((value) => value.set({'id': value.id}));
    Navigator.pop(context);

    Provider.of<FinancialProvider>(context, listen: false).incFinancialPage(1);
  }

  DataGridRow getDataGridRow(FinancialGridModel e) {
    HomeProvider homeProvider = HomeProvider();

    return DataGridRow(cells: [
      DataGridCell(columnName: 'id', value: e.financialModel.id),
      DataGridCell(columnName: 'sender', value: e.financialModel.sender),
      DataGridCell(columnName: 'receiver', value: e.financialModel.receiver),
      DataGridCell(
          columnName: 'value',
          value: homeProvider.formatedCurrency(e.financialModel.value)),
      DataGridCell(
          columnName: 'date',
          value: homeProvider.validateTimeStamp(e.financialModel.date, 'date')),
      DataGridCell(columnName: 'note', value: e.financialModel.note),
      DataGridCell(columnName: 'status', value: e.financialModel.status),
      DataGridCell(columnName: 'actions', value: e),
    ]);
  }

  bool _open = false;
  bool get open => _open;
  setOpen(open) {
    _open = open;
    notifyListeners();
  }
}
