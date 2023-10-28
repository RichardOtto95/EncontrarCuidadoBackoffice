import 'package:back_office/views/financial/models/financial_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter/foundation.dart';
import '../financial_provider.dart';

class FinancialActions extends StatelessWidget {
  final Function onView, onEdit, onDelete;
  final FinancialModel financialModel;

  const FinancialActions({
    Key key,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.financialModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) print(financialModel.type);
    if (kDebugMode) print(financialModel.status);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(),
        IconButton(
          onPressed: () {
            Provider.of<FinancialProvider>(context, listen: false)
                .incFinancialPage(2);
            Provider.of<FinancialProvider>(context, listen: false)
                .incfinancialModel(financialModel);
          },
          icon: Icon(Icons.remove_red_eye, size: 22, color: Color(0xff707070)),
        ),
        Spacer(),
        IconButton(
          onPressed: () {
            Provider.of<FinancialProvider>(context, listen: false)
                .incFinancialPage(3);
            Provider.of<FinancialProvider>(context, listen: false)
                .incfinancialModel(financialModel);
          },
          icon: Icon(Icons.edit, size: 22, color: Color(0xff707070)),
        ),
        Spacer(),
      ],
    );
  }
}
