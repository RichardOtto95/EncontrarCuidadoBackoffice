import 'package:back_office/shared/models/data_models.dart';

import 'financial_model.dart';

class FinancialDataTestModel {
  final FinancialModel financialModel;

  FinancialDataTestModel(this.financialModel);
}

List<List> getFinancialFilters() => [
      ['ID', 'id', 'transactions', 'id'],
      ['Data de criação', 'created_at', 'transactions', 'created_at'],
      ['Data de atualização', 'updated_at', 'transactions', 'updated_at'],
      ['ID do pagamento', 'payment_intent', 'transactions', 'payment_intent'],
      ['Remetente', 'sender', 'transactions', 'sender'],
      ['ID do Remetente', 'sender_id', 'transactions', 'sender_id'],
      ['Destinatário', 'receiver', 'transactions', 'receiver'],
      // ['ID de inscrição', 'guarantee', 'transactions', 'guarantee'],
      ['ID do Destinatário', 'receiver_id', 'transactions', 'receiver_id'],
      ['ID da consulta', 'appointment_id', 'transactions', 'appointment_id'],
      ['Justificativa', 'note', 'transactions', 'note'],
      ['Valor', 'value', 'transactions', 'value'],
      ['Status', 'status', 'transactions', 'status'],
      ['Tipo', 'type', 'transactions', 'type'],
    ];

DataTestModel getFinancialData(
    String title, Map<String, dynamic> financialMap, bool edit) {
  //if(kDebugMode) print('Financial Map: $financialMap');
  List<TileTestModel> tileList = [
    TileTestModel('ID: ', financialMap['id'], 'id'),
    TileTestModel(
        'Data de criação: ', financialMap['created_at'], 'created_at'),
    TileTestModel('Data: ', financialMap['date'], 'date'),
    TileTestModel('Caução: ', financialMap['guarantee'], 'guarantee'),
    TileTestModel(
        'ID do pagamento: ', financialMap['payment_intent'], 'payment_intent'),
    TileTestModel('Remetente: ', financialMap['sender'], 'sender'),
    TileTestModel('ID do Remetente: ', financialMap['sender_id'], 'sender_id'),
    TileTestModel('Destinatário: ', financialMap['receiver'], 'receiver'),
    TileTestModel(
        'ID do Destinatário: ', financialMap['receiver_id'], 'receiver_id'),
    TileTestModel(
        'ID da consulta: ', financialMap['appointment_id'], 'appointment_id'),
    TileTestModel('Justificativa: ', financialMap['note'], 'note'),
    TileTestModel('Valor: ', financialMap['value'], 'value'),
    TileTestModel('Status: ', financialMap['status'], 'status'),
    TileTestModel('Tipo: ', financialMap['type'], 'type'),
  ];
  //if(kDebugMode) print(
  //     "financialMap['type'] == 'Assinatura' ?? ${financialMap['type'] == "Assinatura"} - ${financialMap['type']}");
  if (financialMap['type'] == "Assinatura") {
    tileList.insert(
      10,
      TileTestModel(
        'ID de inscrição: ',
        financialMap['subscription_id'],
        'subscription_id',
      ),
    );
    tileList.insert(
      11,
      TileTestModel(
        'ID da fatura: ',
        financialMap['invoice_id'],
        'invoice_id',
      ),
    );
  }
  DataTestModel dataModel =
      DataTestModel(edit, tiles: tileList, title: '$title');
  return dataModel;
}
