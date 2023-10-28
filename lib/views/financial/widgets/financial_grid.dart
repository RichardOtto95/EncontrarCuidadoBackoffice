import 'package:back_office/shared/grid_scroll_behavior.dart';
import 'package:back_office/shared/utilities.dart';
import 'package:back_office/shared/widgets/filter.dart';
import 'package:back_office/shared/widgets/filter_field.dart';
import 'package:back_office/shared/widgets/title_bar.dart';
import 'package:back_office/views/financial/financial_provider.dart';
import 'package:back_office/views/financial/models/financial_model.dart';
import 'package:back_office/views/home/home_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'package:flutter/foundation.dart';
import 'financial_actions.dart';

class FinancialGrid extends StatefulWidget {
  final List<List> filters;

  const FinancialGrid({Key key, this.filters}) : super(key: key);
  @override
  _FinancialGridState createState() => _FinancialGridState();
}

List<FinancialGridModel> paginatedDataSource = [];
List<FinancialGridModel> _instance = [];
List<FinancialGridModel> _financials = [];
final int rowsPerPage = 20;

class _FinancialGridState extends State<FinancialGrid> {
  final String collection = 'transactions';
  FinancialProvider financialProvider = FinancialProvider();
  FinancialDataSource _financialDataSource;

  InstanceDataGridSource _instanceDataSource;
  DataGridController _dataGridController;
  DataPagerController _dataPagerController;

  double pageCount = 0;
  double searchPageCount = 0;

  @override
  void initState() {
    super.initState();

    _dataGridController = DataGridController();
    _dataPagerController = DataPagerController();
    _instanceDataSource = InstanceDataGridSource();
    _financialDataSource = FinancialDataSource();
  }

  bool filtering = false;
  Map<String, String> map = {};

  setVal(String type, String val) {
    if (val != '') {
      map[type] = val;
    } else {
      map.remove(type);
    }
  }

  bool open = false;
  @override
  Widget build(BuildContext context) {
    double columnWidth = 156.72;
    return Stack(
      children: [
        Container(
          width: wXD(983, context),
          margin: EdgeInsets.symmetric(
            horizontal: wXD(48, context),
            vertical: hXD(32, context),
          ),
          decoration: BoxDecoration(
            color: Color(0xfffafafa),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TitleBar(
                title: 'Financeiro',
                subTitle: 'Gestão das finanças',
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('transactions')
                    .orderBy('created_at', descending: true)
                    .snapshots(),
                builder: (context, transactionsSnap) {
                  if (!transactionsSnap.hasData) {
                    return Container(
                      height: hXD(500, context),
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    QuerySnapshot qs = transactionsSnap.data;
                    _financials = financialProvider.getFinancialsGridData(qs);
                    pageCount =
                        (_financials.length / rowsPerPage).ceilToDouble();
                    if (_financials == null ||
                        _financials.length == 0 ||
                        _financials.length == null) {
                      return Container(
                        height: hXD(500, context),
                        alignment: Alignment.center,
                        child: SelectableText(
                            'Sem dados no banco para serem apresentados'),
                      );
                    } else if (map.isNotEmpty &&
                        _instance.isEmpty &&
                        filtering) {
                      return Container(
                        height: hXD(500, context),
                        alignment: Alignment.center,
                        child: SelectableText('Sem transações com esses dados'),
                      );
                    } else {
                      return Column(
                        children: [
                          Center(
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 39,
                                  ),
                                  height: hXD(540, context),
                                  child: ScrollConfiguration(
                                    behavior: GridScrollBehavior(),
                                    child: SfDataGrid(
                                        isScrollbarAlwaysShown: true,
                                        controller: _dataGridController,
                                        allowPullToRefresh: true,
                                        headerGridLinesVisibility:
                                            GridLinesVisibility.both,
                                        gridLinesVisibility:
                                            GridLinesVisibility.both,
                                        source: !filtering
                                            ? _financialDataSource
                                            : _instanceDataSource,
                                        headerRowHeight: 60,
                                        defaultColumnWidth: 114,
                                        rowHeight: 74,
                                        selectionMode: SelectionMode.multiple,
                                        columns: [
                                          GridTextColumn(
                                              width: columnWidth,
                                              columnName: 'id',
                                              label: Container(
                                                  alignment: Alignment.center,
                                                  child: Text('ID',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            Color(0xff000000),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      )))),
                                          GridTextColumn(
                                              width: columnWidth,
                                              columnName: 'sender',
                                              label: Container(
                                                  alignment: Alignment.center,
                                                  child: Text('Remetente',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            Color(0xff000000),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      )))),
                                          GridTextColumn(
                                              width: columnWidth,
                                              columnName: 'receiver',
                                              label: Container(
                                                  height: 74,
                                                  width: columnWidth,
                                                  alignment: Alignment.center,
                                                  child: Text('Destinatário',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            Color(0xff000000),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      )))),
                                          GridTextColumn(
                                              width: columnWidth,
                                              columnName: 'appointment_id',
                                              label: Container(
                                                  height: 74,
                                                  width: columnWidth,
                                                  alignment: Alignment.center,
                                                  child: Text('ID da consulta',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            Color(0xff000000),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      )))),
                                          GridTextColumn(
                                              width: columnWidth,
                                              columnName: 'value',
                                              label: Container(
                                                  height: 74,
                                                  width: columnWidth,
                                                  alignment: Alignment.center,
                                                  child: Text('Valor',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            Color(0xff000000),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      )))),
                                          GridTextColumn(
                                              width: columnWidth,
                                              columnName: 'date',
                                              label: Container(
                                                  height: 74,
                                                  width: columnWidth,
                                                  alignment: Alignment.center,
                                                  child: Text('Data',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            Color(0xff000000),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      )))),
                                          GridTextColumn(
                                              width: columnWidth,
                                              columnName: 'note',
                                              label: Container(
                                                  height: 74,
                                                  width: columnWidth,
                                                  alignment: Alignment.center,
                                                  child: Text('Justificativa',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            Color(0xff000000),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      )))),
                                          GridTextColumn(
                                              width: columnWidth,
                                              columnName: 'status',
                                              label: Container(
                                                  height: 74,
                                                  width: columnWidth,
                                                  alignment: Alignment.center,
                                                  child: Text('Status',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            Color(0xff000000),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      )))),
                                          GridTextColumn(
                                              width: columnWidth,
                                              columnName: 'type',
                                              label: Container(
                                                  height: 74,
                                                  width: columnWidth,
                                                  alignment: Alignment.center,
                                                  child: Text('Tipo',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            Color(0xff000000),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      )))),
                                          GridTextColumn(
                                              width: columnWidth,
                                              columnName: 'actions',
                                              label: Container(
                                                  height: 74,
                                                  width: columnWidth,
                                                  alignment: Alignment.center,
                                                  child: Text('Ações',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            Color(0xff000000),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ))))
                                        ]),
                                  ))),
                          Container(
                            height: 70,
                            child: SfDataPagerTheme(
                              data: SfDataPagerThemeData(
                                backgroundColor: Color(0xfffafafa),
                                itemBorderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                disabledItemColor:
                                    Color(0xff707070).withOpacity(.3),
                                itemColor: Color(0xfffafafa),
                                selectedItemColor: Color(0xff707070),
                                selectedItemTextStyle: TextStyle(
                                    color: Color(0xff000000),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                                itemTextStyle: TextStyle(
                                    color: Color(0xff000000),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                              ),
                              child: SfDataPager(
                                visibleItemsCount: !filtering
                                    ? pageCount.toInt()
                                    : searchPageCount.toInt(),
                                controller: _dataPagerController,
                                delegate: !filtering
                                    ? _financialDataSource
                                    : _instanceDataSource,
                                pageCount:
                                    !filtering ? pageCount : searchPageCount,
                                direction: Axis.horizontal,
                                onPageNavigationStart: (int pageIndex) {
                                  Provider.of<FinancialProvider>(context,
                                          listen: false)
                                      .incPageView(pageIndex);
                                },
                                onPageNavigationEnd: (int pageIndex) {
                                  Provider.of<FinancialProvider>(context,
                                          listen: false)
                                      .incPageView(pageIndex);
                                  _dataGridController.scrollToVerticalOffset(0);
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
        Positioned(
          right: 80,
          bottom: 40,
          child: Container(
            width: 150,
            height: 70,
            color: Color(0xfffafafa),
            alignment: Alignment.center,
            child: Consumer<FinancialProvider>(
              builder: (context, value, child) => Text(value.pageCount == 0
                  ? '${value.pageView + 1} de 1 Páginas'
                  : '${value.pageView + 1} de ${value.pageCount} Páginas'),
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: Consumer<FinancialProvider>(builder: (context, value, child) {
            return Filter(
              open: value.open,
              onFilter: () async {
                if (kDebugMode) print('maaaaaaap: $map');
                if (map.isEmpty) {
                  _instance.clear();
                  _instanceDataSource.rows.clear();
                  searchPageCount = 0;
                  filtering = false;
                } else {
                  _instance.clear();
                  _financials.forEach(
                    (financialGridModel) {
                      Map<String, dynamic> financialMap = FinancialModel()
                          .toJson(financialGridModel.financialModel);
                      //if(kDebugMode) print('financialMap: $financialMap');
                      bool aunContienes = true;
                      map.forEach((key, value) {
                        //if(kDebugMode) print('key: $key: $value');
                        //if(kDebugMode) print("financialMap[key]: ${financialMap[key]}");
                        if (financialMap[key] != null) {
                          if (kDebugMode) print('2º key: $key: $value\n ');

                          if (key == 'date' ||
                              key == 'birthday' ||
                              key == 'updated_at' ||
                              key == 'created_at') {
                            Timestamp date = financialMap[key];
                            String dateString =
                                '${date.toDate().day.toString().padLeft(2, '0')}${date.toDate().month.toString().padLeft(2, '0')}${date.toDate().year}';
                            financialMap[key] = dateString;
                          }
                          if (key == 'hour') {
                            Timestamp hour = financialMap[key];
                            String hourString = hour
                                    .toDate()
                                    .hour
                                    .toString()
                                    .padLeft(2, '0') +
                                hour.toDate().minute.toString().padLeft(2, '0');
                            financialMap[key] = hourString;
                          }
                          if (kDebugMode)
                            print(
                                'financialMap[$key]: ${financialMap[key].toString().toLowerCase()} ==  value: ${value.toLowerCase()} ??? ${financialMap[key].toString().toLowerCase().contains(value.toString().toLowerCase())}');
                          if (aunContienes) {
                            if (financialMap[key]
                                .toString()
                                .toLowerCase()
                                .contains(value.toString().toLowerCase())) {
                              //if(kDebugMode) print('######## contaaaaaaaaaaains ##########\n \n ');
                              if (!_instance.contains(financialGridModel)) {
                                //if(kDebugMode) print(
                                //     '######## ainda naaaaaaaaao contaaaaaaaaaaains ##########\n \n \n \n ');
                                _instance.add(financialGridModel);
                              }
                            } else {
                              aunContienes = false;
                              if (_instance.contains(financialGridModel)) {
                                _instance.remove(financialGridModel);
                              }
                            }
                          } else {
                            aunContienes = false;
                            if (_instance.contains(financialGridModel)) {
                              _instance.remove(financialGridModel);
                            }
                          }
                        } else {
                          aunContienes = false;
                          if (_instance.contains(financialGridModel)) {
                            _instance.remove(financialGridModel);
                          }
                        }
                      });
                    },
                  );
                  filtering = true;

                  //if(kDebugMode) print('_instance.length: ${_instance.length}');
                  if (_instance.isEmpty) {
                    searchPageCount = 1;
                  } else {
                    searchPageCount =
                        (_instance.length / rowsPerPage).ceilToDouble();
                  }
                  //if(kDebugMode) print('searchPageCount: $searchPageCount');
                  _instanceDataSource.setRows(
                    _instance
                        .map(
                          (e) => financialProvider.getDataGridRow(e),
                        )
                        .toList(),
                  );
                  //if(kDebugMode) print(
                  //     '_instanceDataSource.rows.length: ${_instanceDataSource.rows.length}');
                  //if(kDebugMode) print('searchPageCount: $searchPageCount');
                }
                // _instance.forEach((element) {
                //  if(kDebugMode) print(
                //       'elemento: ${FinancialModel().toJson(element.financialModel)}');
                // });
                _dataPagerController.firstPage();
                value.setOpen(false);
              },
              onView: () {
                value.setOpen(!value.open);
              },
              children: List.generate(
                widget.filters.length,
                (index) {
                  String title = widget.filters[index].first;
                  String valChange = widget.filters[index][1];
                  String collection = widget.filters[index][2];
                  String field = widget.filters[index].last;
                  return FilterField(
                    statuses: [
                      'Estornado',
                      'Estorno solicitado',
                      'Pagamento',
                      // 'Pagamento mensal',
                      'Aguardando'
                    ],
                    types: [
                      "Assinatura",
                      "Caução",
                      "Reembolso de Caução",
                      "Remanescente",
                      "Saque",
                    ],
                    title: title,
                    collection: collection,
                    field: field,
                    onChanged: (val) => setVal(valChange, val),
                  );
                },
              ),
              // [
              //   FilterField(
              //     title: 'Id',
              //     collection: collection,
              //     field: 'id',
              //     onChanged: (val) => setVal('id', val),
              //   ),
              //   FilterField(
              //     title: 'Remetente',
              //     collection: collection,
              //     field: 'sender',
              //     onChanged: (val) => setVal('sender', val),
              //   ),
              //   FilterField(
              //     title: 'Destinatário',
              //     collection: collection,
              //     field: 'receiver',
              //     onChanged: (val) => setVal('receiver', val),
              //   ),
              //   FilterField(
              //     title: 'Valor',
              //     collection: collection,
              //     field: 'value',
              //     onChanged: (val) => setVal('value', val),
              //   ),
              //   FilterField(
              //     title: 'Data',
              //     collection: collection,
              //     field: 'date',
              //     onChanged: (val) => setVal('date', val),
              //     // mask: homeProvider.getMask('date'),
              //   ),
              //   FilterField(
              //     title: 'Observação',
              //     collection: collection,
              //     field: 'note',
              //     onChanged: (val) => setVal('note', val),
              //   ),
              //   FilterField(
              //     title: 'Status',
              //     collection: collection,
              //     field: 'status',
              //     // overlayData: ['Aguardando depósito', 'Depositada', 'Pago'],
              //     onChanged: (val) => setVal('status', val),
              //   ),
              //   FilterField(
              //     title: 'Tipo',
              //     collection: collection,
              //     field: 'type',
              //     // overlayData: [
              //     //   'Balanço financeiro',
              //     //   'Balanço financeiro realizado'
              //     // ],
              //     onChanged: (val) => setVal('type', val),
              //   ),
              // ],
            );
          }),
        ),
      ],
      alignment: Alignment.topCenter,
    );
  }
}

class FinancialDataSource extends DataGridSource {
  HomeProvider homeProvider = HomeProvider();
  FinancialDataSource() {
    paginatedDataSource = [];
    buildDataGridRows();
  }

  List<DataGridRow> _financialData = [];
  @override
  List<DataGridRow> get rows => _financialData;
  setRows(financialData) {
    _financialData = financialData;
    notifyListeners();
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    // await Future.delayed(const Duration(seconds: 3));
    int startIndex = newPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    if (startIndex < _financials.length) {
      if (endIndex > _financials.length) {
        endIndex = _financials.length;
      }
      paginatedDataSource =
          _financials.getRange(startIndex, endIndex).toList(growable: false);
      buildDataGridRows();
    } else {
      paginatedDataSource = [];
    }
    notifyListeners();
    return true;
  }

  @override
  Future<void> handleRefresh() {
    if (kDebugMode) print("financialData: $_financialData");
    if (kDebugMode) print('');
    return Future.delayed(Duration(seconds: 3), () {
      buildDataGridRows();
      notifyListeners();
    });
  }

  void buildDataGridRows() {
    _financialData = paginatedDataSource
        .map((e) => DataGridRow(cells: [
              DataGridCell(columnName: 'id', value: e.financialModel.id),
              DataGridCell(
                  columnName: 'sender', value: e.financialModel.sender),
              DataGridCell(
                  columnName: 'receiver', value: e.financialModel.receiver),
              DataGridCell(
                  columnName: 'appointment_id',
                  value: e.financialModel.appointmentId),
              DataGridCell(
                  columnName: 'value',
                  value: homeProvider.formatedCurrency(e.financialModel.value)),
              DataGridCell(
                  columnName: 'date',
                  value: homeProvider.validateTimeStamp(
                      e.financialModel.createdAt, 'date')),
              DataGridCell(columnName: 'note', value: e.financialModel.note),
              DataGridCell(
                  columnName: 'status', value: e.financialModel.status),
              DataGridCell(columnName: 'type', value: e.financialModel.type),
              DataGridCell(columnName: 'actions', value: e),
            ]))
        .toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      switch (e.columnName) {
        case 'actions':
          return FinancialActions(financialModel: e.value.financialModel);
          break;
        default:
          String value;
          if (e.value == null) {
            value = '- - -';
          } else {
            value = e.value.toString();
          }
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: SelectableText(
              value.toString(),
              enableInteractiveSelection: true,
              toolbarOptions: ToolbarOptions(selectAll: true),
              scrollPhysics: ClampingScrollPhysics(),
              maxLines: 1,
            ),
          );
      }
    }).toList());
  }
}

class InstanceDataGridSource extends DataGridSource {
  HomeProvider homeProvider = HomeProvider();
  InstanceDataGridSource() {
    paginatedDataSource = [];
    buildDataGridRows();
  }

  List<DataGridRow> _instanceData = [];

  @override
  List<DataGridRow> get rows => _instanceData;

  setRows(financialData) {
    int maxRange = rowsPerPage;
    if (_instance.length < rowsPerPage) {
      maxRange = _instance.length;
    }
    paginatedDataSource =
        _instance.getRange(0, maxRange).toList(growable: false);
    buildDataGridRows();
    // _instanceData = financialData;
    notifyListeners();
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    // await Future.delayed(const Duration(seconds: 3));
    int startIndex = newPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    if (startIndex < _instance.length) {
      if (endIndex > _instance.length) {
        endIndex = _instance.length;
      }
      paginatedDataSource =
          _instance.getRange(startIndex, endIndex).toList(growable: false);
      buildDataGridRows();
    } else {
      paginatedDataSource = [];
    }
    notifyListeners();
    return true;
  }

  @override
  Future<void> handleRefresh() {
    return Future.delayed(Duration(seconds: 3), () {
      buildDataGridRows();
      notifyListeners();
    });
  }

  void buildDataGridRows() {
    _instanceData = paginatedDataSource
        .map((e) => DataGridRow(cells: [
              DataGridCell(columnName: 'id', value: e.financialModel.id),
              DataGridCell(
                  columnName: 'sender', value: e.financialModel.sender),
              DataGridCell(
                  columnName: 'receiver', value: e.financialModel.receiver),
              DataGridCell(
                  columnName: 'appointment_id',
                  value: e.financialModel.appointmentId),
              DataGridCell(
                  columnName: 'value',
                  value: homeProvider.formatedCurrency(e.financialModel.value)),
              DataGridCell(
                  columnName: 'date',
                  value: homeProvider.validateTimeStamp(
                      e.financialModel.createdAt, 'date')),
              DataGridCell(columnName: 'note', value: e.financialModel.note),
              DataGridCell(
                  columnName: 'status', value: e.financialModel.status),
              DataGridCell(columnName: 'type', value: e.financialModel.type),
              DataGridCell(columnName: 'actions', value: e),
            ]))
        .toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      switch (e.columnName) {
        case 'actions':
          return FinancialActions(
            financialModel: e.value.financialModel,
            onDelete: () {
              notifyListeners();
              buildDataGridRows();
            },
          );
          break;
        default:
          String value;
          if (e.value == null) {
            value = '- - -';
          } else {
            value = e.value.toString();
          }
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: SelectableText(
              value,
              enableInteractiveSelection: true,
              toolbarOptions: ToolbarOptions(selectAll: true),
              scrollPhysics: ClampingScrollPhysics(),
              maxLines: 1,
            ),
          );
      }
    }).toList());
  }
}
