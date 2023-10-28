import 'package:back_office/shared/grid_scroll_behavior.dart';
import 'package:back_office/shared/utilities.dart';
import 'package:back_office/shared/widgets/filter.dart';
import 'package:back_office/shared/widgets/filter_field.dart';
import 'package:back_office/shared/widgets/title_bar.dart';
import 'package:back_office/views/home/home_provider.dart';
import 'package:back_office/views/notifications/models/notification_model.dart';
import 'package:back_office/views/notifications/notification_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'notification_actions.dart';

class NotificationGrid extends StatefulWidget {
  final List<List> filters;

  const NotificationGrid({Key key, this.filters}) : super(key: key);
  @override
  _NotificationGridState createState() => _NotificationGridState();
}

List<NotificationGridModel> paginatedDataSource = [];
List<NotificationGridModel> _instance = [];
List<NotificationGridModel> _notifications = [];
final int rowsPerPage = 20;

class _NotificationGridState extends State<NotificationGrid> {
  final String collection = 'notifications';
  NotificationProvider notificationProvider = NotificationProvider();
  NotificationDataSource _notificationDataSource;

  InstanceDataGridSource _instanceDataSource;
  DataGridController _notificationGridController = DataGridController();
  DataPagerController _dataPagerController;

  double pageCount = 0;
  double searchPageCount = 0;

  @override
  void initState() {
    super.initState();
    _dataPagerController = DataPagerController();
    _instanceDataSource = InstanceDataGridSource();
    _notificationDataSource = NotificationDataSource();
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
    double gridWidth = 200;
    return Stack(
      children: [
        Container(
          width: wXD(976, context),
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
                title: 'Notificações',
                subTitle: 'Gestão de Notificações',
                button: Padding(
                  padding: EdgeInsets.only(right: wXD(50, context)),
                  child: InkWell(
                    onTap: () {
                      Provider.of<NotificationProvider>(context, listen: false)
                          .incNotificationPage(4);
                    },
                    child: Container(
                      height: 32,
                      width: 149,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xff41C3B3),
                                Color(0xff21BCCE),
                              ])),
                      alignment: Alignment.center,
                      child: Text(
                        'Nova',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Color(0xfffafafa),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('notifications')
                    .orderBy('created_at', descending: true)
                    // .where('type', isEqualTo: "alert")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      height: hXD(500, context),
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    QuerySnapshot qs = snapshot.data;
                    //if(kDebugMode) print('qs.docs.length: ${qs.docs.length}');
                    if (qs.docs.length == 0) {
                      return Container(
                        height: hXD(500, context),
                        alignment: Alignment.center,
                        child: Text(
                          'Sem notificações para serem listadas',
                          style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 22,
                              fontWeight: FontWeight.w400),
                        ),
                      );
                    } else {
                      if (kDebugMode) print("Grid notification");
                      _notifications =
                          notificationProvider.getNotificationsGridData(qs);
                      pageCount = filtering
                          ? (_instance.length / rowsPerPage).ceilToDouble()
                          : (_notifications.length / rowsPerPage)
                              .ceilToDouble();
                      if (kDebugMode) print("Grid notification 2");

                      // WidgetsBinding.instance.addPostFrameCallback((_) {
                      //   Provider.of<NotificationProvider>(context,
                      //           listen: false)
                      //       .incPageCount(pageCount);
                      // });
                      if (_notifications == null ||
                          _notifications.length == 0 ||
                          _notifications.length == null) {
                        return Container(
                          height: hXD(500, context),
                          alignment: Alignment.center,
                          child: SelectableText(
                            'Sem dados no banco para serem apresentados',
                          ),
                        );
                      } else if (map.isNotEmpty &&
                          _instance.isEmpty &&
                          filtering) {
                        return Container(
                          height: hXD(500, context),
                          alignment: Alignment.center,
                          child: SelectableText(
                              'Sem notificações com esses dados'),
                        );
                      } else {
                        if (kDebugMode) print("Grid notification 3");
                        return Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 39,
                              ),
                              height: hXD(540, context),
                              // width: wXD(800, context),
                              child: ScrollConfiguration(
                                behavior: GridScrollBehavior(),
                                child: SfDataGrid(
                                  isScrollbarAlwaysShown: true,
                                  // scroll
                                  // horizontalScrollController: ,
                                  // verticalScrollPhysics:
                                  //     AlwaysScrollableScrollPhysics(),
                                  // horizontalScrollPhysics:
                                  //     AlwaysScrollableScrollPhysics(),
                                  controller: _notificationGridController,
                                  allowPullToRefresh: true,
                                  headerGridLinesVisibility:
                                      GridLinesVisibility.both,
                                  gridLinesVisibility: GridLinesVisibility.both,
                                  source: !filtering
                                      ? _notificationDataSource
                                      : _instanceDataSource,
                                  headerRowHeight: 60,
                                  defaultColumnWidth: 114,
                                  rowHeight: 90,
                                  selectionMode: SelectionMode.multiple,
                                  columns: [
                                    GridTextColumn(
                                        width: gridWidth,
                                        columnName: 'id',
                                        label: Container(
                                            alignment: Alignment.center,
                                            child: Text('ID',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xff000000),
                                                  fontWeight: FontWeight.w600,
                                                )))),
                                    GridTextColumn(
                                        width: gridWidth,
                                        columnName: 'receiver',
                                        label: Container(
                                            padding: EdgeInsets.only(left: 15),
                                            alignment: Alignment.center,
                                            child: Text('Id do destinatário',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xff000000),
                                                  fontWeight: FontWeight.w600,
                                                )))),
                                    GridTextColumn(
                                        width: gridWidth,
                                        columnName: 'text',
                                        label: Container(
                                            height: 74,
                                            width: gridWidth,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15),
                                            alignment: Alignment.center,
                                            child: Text('Texto',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xff000000),
                                                  fontWeight: FontWeight.w600,
                                                )))),
                                    GridTextColumn(
                                        width: gridWidth,
                                        columnName: 'date',
                                        label: Container(
                                            height: 74,
                                            width: gridWidth,
                                            alignment: Alignment.center,
                                            child: Text('Data',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xff000000),
                                                  fontWeight: FontWeight.w600,
                                                )))),
                                    GridTextColumn(
                                        width: gridWidth,
                                        columnName: 'status',
                                        label: Container(
                                            height: 74,
                                            width: gridWidth,
                                            alignment: Alignment.center,
                                            child: Text('Status',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xff000000),
                                                  fontWeight: FontWeight.w600,
                                                )))),
                                    GridTextColumn(
                                        width: gridWidth,
                                        columnName: 'type',
                                        label: Container(
                                            height: 74,
                                            width: gridWidth,
                                            alignment: Alignment.center,
                                            child: Text('Tipo',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xff000000),
                                                  fontWeight: FontWeight.w600,
                                                )))),
                                    GridTextColumn(
                                        width: gridWidth,
                                        columnName: 'viewed',
                                        label: Container(
                                            height: 74,
                                            width: gridWidth,
                                            alignment: Alignment.center,
                                            child: Text('Visualizada',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xff000000),
                                                  fontWeight: FontWeight.w600,
                                                )))),
                                    GridTextColumn(
                                        width: gridWidth,
                                        columnName: 'actions',
                                        label: Container(
                                            height: 74,
                                            width: gridWidth,
                                            alignment: Alignment.center,
                                            child: Text('Ações',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xff000000),
                                                  fontWeight: FontWeight.w600,
                                                ))))
                                  ],
                                ),
                              ),
                            ),
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
                                      ? _notificationDataSource
                                      : _instanceDataSource,
                                  pageCount:
                                      !filtering ? pageCount : searchPageCount,
                                  direction: Axis.horizontal,
                                  onPageNavigationStart: (int pageIndex) {
                                    //if(kDebugMode) print('page index: $pageIndex');;
                                    Provider.of<NotificationProvider>(context,
                                            listen: false)
                                        .incPageView(pageIndex);
                                  },
                                  onPageNavigationEnd: (int pageIndex) {
                                    //if(kDebugMode) print('page index: $pageIndex');
                                    Provider.of<NotificationProvider>(context,
                                            listen: false)
                                        .incPageView(pageIndex);
                                    _notificationGridController
                                        .scrollToVerticalOffset(0);
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                },
              )
            ],
          ),
        ),
        Positioned(
          right: 70,
          bottom: 40,
          child: Container(
            width: 190,
            height: 70,
            color: Color(0xfffafafa),
            alignment: Alignment.center,
            child: Consumer<NotificationProvider>(
              builder: (context, value, child) =>
                  Text('${value.pageView + 1} de $pageCount Páginas'),
            ),
          ),
        ),
        Positioned(
          top: 0,
          child:
              Consumer<NotificationProvider>(builder: (context, value, child) {
            return Filter(
              open: value.open,
              onFilter: () async {
                if (map.isEmpty) {
                  _instance.clear();
                  _instanceDataSource.rows.clear();
                  searchPageCount = 0;
                  filtering = false;
                } else {
                  _instance.clear();
                  _notifications.forEach((notificationGridModel) {
                    Map<String, dynamic> notificationMap = NotificationModel()
                        .toJson(notificationGridModel.notificationModel);
                    //if(kDebugMode) print('notificationMap: $notificationMap');
                    bool aunContienes = true;
                    map.forEach((key, value) {
                      //if(kDebugMode) print('key: $key: $value');
                      if (notificationMap[key] != null) {
                        //if(kDebugMode) print('2º key: $key: $value\n ');

                        if (key == 'date' ||
                            key == 'birthday' ||
                            key == 'dispatched_at' ||
                            key == 'created_at') {
                          Timestamp date = notificationMap[key];
                          String dateString =
                              '${date.toDate().day.toString().padLeft(2, '0')}${date.toDate().month.toString().padLeft(2, '0')}${date.toDate().year}';
                          notificationMap[key] = dateString;
                        }
                        if (key == 'hour') {
                          Timestamp hour = notificationMap[key];
                          String hourString = hour
                                  .toDate()
                                  .hour
                                  .toString()
                                  .padLeft(2, '0') +
                              hour.toDate().minute.toString().padLeft(2, '0');
                          notificationMap[key] = hourString;
                        }
                        if (aunContienes) {
                          //if(kDebugMode) print(
                          //     'notificationMap[key]: ${notificationMap[key].toString().toLowerCase()} ==  value: ${value.toLowerCase()} ???');
                          if (notificationMap[key]
                              .toString()
                              .toLowerCase()
                              .contains(value.toString().toLowerCase())) {
                            //if(kDebugMode) print('######## contaaaaaaaaaaains ##########\n \n ');
                            if (!_instance.contains(notificationGridModel)) {
                              //if(kDebugMode) print(
                              //     '######## ainda naaaaaaaaao contaaaaaaaaaaains ##########\n \n \n \n ');
                              _instance.add(notificationGridModel);
                            }
                          } else {
                            aunContienes = false;
                            if (_instance.contains(notificationGridModel)) {
                              _instance.remove(notificationGridModel);
                            }
                          }
                        } else {
                          aunContienes = false;
                          if (_instance.contains(notificationGridModel)) {
                            _instance.remove(notificationGridModel);
                          }
                        }
                      } else {
                        aunContienes = false;
                        if (_instance.contains(notificationGridModel)) {
                          _instance.remove(notificationGridModel);
                        }
                      }
                    });
                  });
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
                          (e) => notificationProvider.getDataGridRow(e),
                        )
                        .toList(),
                  );
                  //if(kDebugMode) print(
                  //     '_instanceDataSource.rows.length: ${_instanceDataSource.rows.length}');
                  //if(kDebugMode) print('searchPageCount: $searchPageCount');
                }
                // _instance.forEach((element) {
                //  if(kDebugMode) print(
                //       'elemento: ${NotificationModel().toJson(element.notificationModel)}');
                // });
                _dataPagerController.firstPage();
                value.setOpen(false);
              },
              onView: () {
                value.setOpen(!value.open);
              },
              children: List.generate(widget.filters.length, (index) {
                String title = widget.filters[index].first;
                String valChange = widget.filters[index][1];
                String collection = widget.filters[index][2];
                String field = widget.filters[index].last;
                return FilterField(
                  statuses: ['Programada', 'Enviada'],
                  types: ['Mensagem', 'Alerta'],
                  title: title,
                  collection: collection,
                  field: field,
                  onChanged: (val) => setVal(valChange, val),
                );
              }),
              // [
              //   FilterField(
              //     title: 'Id',
              //     collection: collection,
              //     field: 'id',
              //     onChanged: (val) => setVal('id', val),
              //   ),
              //   FilterField(
              //     title: 'Destinatário',
              //     collection: collection,
              //     field: 'receiver',
              //     onChanged: (val) => setVal('receiver', val),
              //   ),
              //   FilterField(
              //     title: 'Texto',
              //     collection: collection,
              //     field: 'text',
              //     onChanged: (val) => setVal('text', val),
              //   ),
              //   FilterField(
              //     title: 'Data',
              //     collection: collection,
              //     field: 'date',
              //     onChanged: (val) => setVal('date', val),
              //     // mask: homeProvider.getMask('date'),
              //   ),
              //   FilterField(
              //     title: 'Status',
              //     collection: collection,
              //     field: 'status',
              //     // overlayData: ['Agendada', 'Enviada'],
              //     onChanged: (val) => setVal('status', val),
              //   ),
              //   FilterField(
              //     title: 'Tipo',
              //     collection: collection,
              //     field: 'type',
              //     // overlayData: ['Mensagem', 'Alerta'],
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

class NotificationDataSource extends DataGridSource {
  NotificationDataSource() {
    paginatedDataSource = [];
    buildDataGridRows();
  }

  List<DataGridRow> _notificationData = [];
  @override
  List<DataGridRow> get rows => _notificationData;
  setRows(notificationData) {
    _notificationData = notificationData;
    if (kDebugMode) print("setRows: ${paginatedDataSource.length}");
    notifyListeners();
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    // await Future.delayed(const Duration(seconds: 3));
    int startIndex = newPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    if (startIndex < _notifications.length) {
      if (endIndex > _notifications.length) {
        endIndex = _notifications.length;
      }
      if (kDebugMode) print("startIndex: $startIndex , endIndex: $endIndex , ");
      paginatedDataSource =
          _notifications.getRange(startIndex, endIndex).toList(growable: false);
      if (kDebugMode) print("handlePageChange: ${paginatedDataSource.length}");
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
    _notificationData = paginatedDataSource
        .map((e) => DataGridRow(cells: [
              DataGridCell(columnName: 'id', value: e.notificationModel.id),
              DataGridCell(
                  columnName: 'receiver',
                  value: e.notificationModel.receiverId),
              DataGridCell(columnName: 'text', value: e.notificationModel.text),
              DataGridCell(
                  columnName: 'date',
                  value: HomeProvider().validateTimeStamp(
                      e.notificationModel.dispatchedAt, 'date')),
              DataGridCell(
                  columnName: 'status', value: e.notificationModel.status),
              DataGridCell(columnName: 'type', value: e.notificationModel.type),
              DataGridCell(
                  columnName: 'viewed', value: e.notificationModel.viewed),
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
          return NotificationActions(
            notificationModel: e.value.notificationModel,
            onDelete: () {
              buildDataGridRows();
              notifyListeners();
            },
          );
          break;

        default:
          String value = e.value.toString();
          if (value == 'null') {
            value = '- - -';
          } else if (value == 'true') {
            value = 'Sim';
          } else if (value == 'false') {
            value = 'Não';
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

class InstanceDataGridSource extends DataGridSource {
  InstanceDataGridSource() {
    paginatedDataSource = [];
    buildDataGridRows();
  }

  List<DataGridRow> _instanceData = [];
  @override
  List<DataGridRow> get rows => _instanceData;
  setRows(instanceData) {
    int maxRange = rowsPerPage;
    if (_instance.length < rowsPerPage) {
      maxRange = _instance.length;
    }
    paginatedDataSource =
        _instance.getRange(0, maxRange).toList(growable: false);
    buildDataGridRows();
    // _instanceData = instanceData;
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
              DataGridCell(columnName: 'id', value: e.notificationModel.id),
              DataGridCell(
                  columnName: 'receiver',
                  value: e.notificationModel.receiverId),
              DataGridCell(columnName: 'text', value: e.notificationModel.text),
              DataGridCell(
                  columnName: 'date',
                  value: HomeProvider().validateTimeStamp(
                      e.notificationModel.dispatchedAt, 'date')),
              DataGridCell(
                  columnName: 'status', value: e.notificationModel.status),
              DataGridCell(columnName: 'type', value: e.notificationModel.type),
              DataGridCell(
                  columnName: 'viewed', value: e.notificationModel.viewed),
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
          return NotificationActions(
            notificationModel: e.value.notificationModel,
            onDelete: () {
              buildDataGridRows();
              notifyListeners();
            },
          );
          break;

        default:
          String value = e.value.toString();
          if (value == 'null') {
            value = '- - -';
          } else if (value == 'true') {
            value = 'Sim';
          } else if (value == 'false') {
            value = 'Não';
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
