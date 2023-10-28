import 'package:back_office/shared/utilities.dart';
import 'package:back_office/shared/widgets/blue_button.dart';
import 'package:back_office/shared/widgets/central_container.dart';
import 'package:back_office/shared/widgets/data_tile.dart';
import 'package:back_office/shared/widgets/dialog_widget.dart';
import 'package:back_office/views/financial/financial_provider.dart';
import 'package:back_office/views/financial/models/financial_model.dart';
import 'package:back_office/views/home/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class RegisterDeposit extends StatefulWidget {
  final FinancialModel financialModel;

  const RegisterDeposit({Key key, this.financialModel}) : super(key: key);

  @override
  _RegisterDepositState createState() => _RegisterDepositState();
}

class _RegisterDepositState extends State<RegisterDeposit> {
  Future future;
  DateTime dateTime = DateTime.now();
  FinancialProvider financialProvider = FinancialProvider();

  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider = HomeProvider();

    return CentralContainer(
      paddingBottom: 0,
      child: FutureBuilder(
          future: financialProvider.getRegisterDataModel(widget.financialModel),
          builder: (context, dataModel) {
            if (!dataModel.hasData) {
              return Container(
                height: 600,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            } else {
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
                          onTap: () => Provider.of<FinancialProvider>(context,
                                  listen: false)
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
                  Column(
                    children: List.generate(
                      dataModel.data.tiles.length,
                      (index) => DataTestTile(
                        type: dataModel.data.tiles[index].type,
                        edit: dataModel.data.edit,
                        data: dataModel.data.tiles[index].data,
                        title: dataModel.data.tiles[index].title,
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(height: 60),
                        SelectableText(
                          'Saldo disponível:   ${homeProvider.formatedCurrency(widget.financialModel.value)}',
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
                        SizedBox(height: 170)
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
                            Provider.of<FinancialProvider>(context,
                                    listen: false)
                                .incFinancialPage(1);
                          },
                          child: Text(
                            '< Voltar',
                            style: TextStyle(
                                color: Color(0xff0000DA),
                                fontSize: hXD(20, context)),
                          ),
                        ),
                        BlueButton(
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
                                    Map<String, dynamic> _doctor =
                                        financialProvider.doctorDoc;
                                    financialProvider.financialStatement(
                                      context: context,
                                      dateTime: dateTime,
                                      doctor: _doctor,
                                      financialModel: widget.financialModel,
                                    );
                                  },
                                  title:
                                      'Tem certeza que deseja registrar este depósito?',
                                );
                              },
                            );
                          },
                        )
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
