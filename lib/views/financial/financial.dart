import 'package:back_office/views/financial/widgets/financial_data.dart';
import 'package:back_office/views/financial/widgets/financial_grid.dart';
import 'package:back_office/views/financial/widgets/register_deposit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'financial_provider.dart';
import 'models/financial_data_model.dart';
import 'models/financial_model.dart';

class Financial extends StatefulWidget {
  final bool reverse;
  final Function onReverseClick;

  const Financial({
    Key key,
    this.reverse,
    this.onReverseClick,
  }) : super(key: key);

  @override
  _FinancialState createState() => _FinancialState();
}

class _FinancialState extends State<Financial> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<FinancialProvider>(
        builder: (context, value, child) {
          return SingleChildScrollView(
            physics: ScrollPhysics(),
            child: getFinancialPage(
                financialPage: value.financialPage,
                financialModel: value.financialModel),
          );
        },
      ),
    );
  }

  Widget getFinancialPage({int financialPage, FinancialModel financialModel}) {
    switch (financialPage) {
      case 1:
        return FinancialGrid(filters: getFinancialFilters());
        break;
      case 2:
        return FinancialData(
          financialModel: financialModel,
          dataTestModel: getFinancialData(
            'Detalhes da finança',
            FinancialModel().toJson(financialModel),
            false,
          ),
        );
        break;
      case 3:
        return FinancialData(
            financialModel: financialModel,
            dataTestModel: getFinancialData(
              'Editar dados da finança ',
              FinancialModel().toJson(financialModel),
              true,
            ));
        break;
      case 4:
        return RegisterDeposit(
          financialModel: financialModel,
        );
        break;
      default:
        return Padding(
          padding: EdgeInsets.only(top: 50),
          child: Text('Algo de errado nessa navegação'),
        );
    }
  }
}
