import 'package:cloud_firestore/cloud_firestore.dart';

class FinancialModel {
  FinancialModel({
    this.updatedAt,
    this.invoiceId,
    this.subscriptionId,
    this.paymentIntent,
    this.guarantee,
    this.appointmentId,
    this.createdAt,
    this.type,
    this.receiverId,
    this.id,
    this.sender,
    this.senderId,
    this.receiver,
    this.value,
    this.date,
    this.note,
    this.status,
  });

  final String id;
  final String sender;
  final String senderId;
  final String receiver;
  final String receiverId;
  final String appointmentId;
  final String subscriptionId;
  final String invoiceId;
  final String paymentIntent;
  final double value;
  final Timestamp date;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final bool guarantee;
  String note;
  String status;
  String type;

  factory FinancialModel.fromDocument(Map<String, dynamic> doc) {
    return FinancialModel(
      date: doc['date'],
      id: doc['id'],
      note: doc['note'],
      receiver: doc['receiver'],
      receiverId: doc['receiver_id'],
      sender: doc['sender'],
      senderId: doc['sender_id'],
      status: doc['status'],
      type: doc['type'],
      value: doc['value'],
      createdAt: doc['created_at'],
      appointmentId: doc['appointment_id'],
      guarantee: doc['guarantee'],
      paymentIntent: doc['payment_intent'],
      subscriptionId:
          doc['type'] == 'subscription' || doc['type'] == 'Assinatura'
              ? doc['subscription_id']
              : null,
      invoiceId: doc["invoice_id"],
      updatedAt: doc["updated_at"],
    );
  }
  Map<String, dynamic> toJson(FinancialModel financialModel) => {
        'date': financialModel.date,
        'id': financialModel.id,
        'note': financialModel.note,
        'receiver': financialModel.receiver,
        'receiver_id': financialModel.receiverId,
        'sender': financialModel.sender,
        'sender_id': financialModel.senderId,
        'value': financialModel.value,
        'status': financialModel.status,
        'type': financialModel.type,
        'created_at': financialModel.createdAt,
        'appointment_id': financialModel.appointmentId,
        'guarantee': financialModel.guarantee,
        'payment_intent': financialModel.paymentIntent,
        'subscription_id': financialModel.type == 'subscription' ||
                financialModel.type == 'Assinatura'
            ? financialModel.subscriptionId
            : null,
        'invoice_id': financialModel.invoiceId,
        'updated_at': financialModel.updatedAt,
      };
}

class FinancialGridModel {
  final bool selected;
  final FinancialModel financialModel;
  FinancialGridModel(this.selected, this.financialModel);
}
