import 'package:back_office/shared/grid_scroll_behavior.dart';
import 'package:back_office/shared/models/time_model.dart';
import 'package:back_office/shared/utilities.dart';
import 'package:back_office/shared/widgets/filter.dart';
import 'package:back_office/shared/widgets/filter_field.dart';
import 'package:back_office/shared/widgets/title_bar.dart';
import 'package:back_office/views/ratings/rating_provider.dart';
import 'package:back_office/views/ratings/models/rating_model.dart';
import 'package:back_office/views/home/home_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'package:flutter/foundation.dart';
import 'rating_actions.dart';

class RatingGrid extends StatefulWidget {
  final List<List> filters;

  const RatingGrid({Key key, this.filters}) : super(key: key);
  @override
  _RatingGridState createState() => _RatingGridState();
}

List<RatingGridModel> paginatedDataSource = [];
List<RatingGridModel> _ratings = [];
List<RatingGridModel> _instance = [];
final int rowsPerPage = 20;

class _RatingGridState extends State<RatingGrid> {
  final String collection = 'ratings';
  RatingProvider ratingProvider = RatingProvider();
  RatingDataSource _ratingDataSource;
  InstanceDataGridSource _instanceDataSource;
  DataGridController _dataGridController;
  DataPagerController _dataPagerController;
  HomeProvider homeProvider = HomeProvider();

  double pageCount = 0;
  double searchPageCount = 0;

  @override
  void initState() {
    super.initState();
    _dataGridController = DataGridController();
    _dataPagerController = DataPagerController();
    _instanceDataSource = InstanceDataGridSource();
    _ratingDataSource = RatingDataSource();
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

  @override
  Widget build(BuildContext context) {
    double columnWidth = 176;
    return Stack(
      children: [
        Container(
          width: wXD(983, context),
          margin: EdgeInsets.fromLTRB(
            wXD(48, context),
            hXD(32, context),
            wXD(48, context),
            hXD(32, context),
          ),
          decoration: BoxDecoration(
            color: Color(0xfffafafa),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TitleBar(title: 'Avaliações', subTitle: 'Gestão de avaliações'),
              StreamBuilder<Object>(
                  stream: FirebaseFirestore.instance
                      .collection(collection)
                      .orderBy('created_at', descending: true)
                      .snapshots(),
                  builder: (context, ratingSnap) {
                    if (!ratingSnap.hasData) {
                      return Container(
                        height: hXD(500, context),
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      QuerySnapshot qs = ratingSnap.data;
                      _ratings = ratingProvider.getRatingsGridData(qs);
                      pageCount = filtering
                          ? (_instance.length / rowsPerPage).ceilToDouble()
                          : (_ratings.length / rowsPerPage).ceilToDouble();
                      if (_ratings == null ||
                          _ratings.length == 0 ||
                          _ratings.length == null) {
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
                          child:
                              SelectableText('Sem avaliações com esses dados'),
                        );
                      } else {
                        return Stack(
                          children: [
                            Column(
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
                                                  ? _ratingDataSource
                                                  : _instanceDataSource,
                                              headerRowHeight: 60,
                                              defaultColumnWidth: 114,
                                              rowHeight: 74,
                                              selectionMode:
                                                  SelectionMode.multiple,
                                              columns: [
                                                GridTextColumn(
                                                    width: columnWidth,
                                                    columnName: 'id',
                                                    label: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text('ID',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color: Color(
                                                                  0xff000000),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            )))),
                                                GridTextColumn(
                                                    width: columnWidth,
                                                    columnName: 'doctorId',
                                                    label: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            'Id do  médico',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color: Color(
                                                                  0xff000000),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            )))),
                                                GridTextColumn(
                                                    width: columnWidth,
                                                    columnName: 'patientId',
                                                    label: Container(
                                                        height: 74,
                                                        width: columnWidth,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            'Id do paciente',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color: Color(
                                                                  0xff000000),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            )))),
                                                GridTextColumn(
                                                    width: columnWidth,
                                                    columnName: 'username',
                                                    label: Container(
                                                        height: 74,
                                                        width: columnWidth,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            'Nome do paciente',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color: Color(
                                                                  0xff000000),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            )))),
                                                GridTextColumn(
                                                    width: columnWidth,
                                                    columnName: 'date',
                                                    label: Container(
                                                        height: 74,
                                                        width: columnWidth,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text('Data',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color: Color(
                                                                  0xff000000),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            )))),
                                                GridTextColumn(
                                                    width: columnWidth,
                                                    columnName: 'avaliation',
                                                    label: Container(
                                                        height: 74,
                                                        width: columnWidth,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text('Nota',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color: Color(
                                                                  0xff000000),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            )))),
                                                GridTextColumn(
                                                    width: columnWidth,
                                                    columnName: 'status',
                                                    label: Container(
                                                        height: 74,
                                                        width: columnWidth,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text('Status',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color: Color(
                                                                  0xff000000),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            )))),
                                                GridTextColumn(
                                                    width: columnWidth,
                                                    columnName: 'actions',
                                                    label: Container(
                                                        height: 74,
                                                        width: columnWidth,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text('Ações',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color: Color(
                                                                  0xff000000),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
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
                                          ? _ratingDataSource
                                          : _instanceDataSource,
                                      pageCount: !filtering
                                          ? pageCount
                                          : searchPageCount,
                                      direction: Axis.horizontal,
                                      onPageNavigationStart: (int pageIndex) {
                                        Provider.of<RatingProvider>(context,
                                                listen: false)
                                            .incPageView(pageIndex);
                                      },
                                      onPageNavigationEnd: (int pageIndex) {
                                        Provider.of<RatingProvider>(context,
                                                listen: false)
                                            .incPageView(pageIndex);
                                        _dataGridController
                                            .scrollToVerticalOffset(0);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              right: 10,
                              bottom: 10,
                              child: Container(
                                width: 190,
                                height: 50,
                                color: Color(0xfffafafa),
                                alignment: Alignment.center,
                                child: Consumer<RatingProvider>(
                                  builder: (context, value, child) => Text(
                                      '${value.pageView + 1} de $pageCount Páginas'),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }),
            ],
          ),
        ),
        Positioned(
          top: 0,
          child: Consumer<RatingProvider>(builder: (context, value, child) {
            return Filter(
              onFilter: () {
                if (map.isEmpty) {
                  _instance.clear();
                  _instanceDataSource.rows.clear();
                  searchPageCount = 0;
                  filtering = false;
                } else {
                  _instance.clear();
                  _ratings.forEach((ratingGridModel) {
                    Map<String, dynamic> ratingMap =
                        RatingModel().toJson(ratingGridModel.ratingModel);
                    //if(kDebugMode) print(' ratingMap: $ratingMap');
                    //if(kDebugMode) print(' map: $map');
                    bool aunContienes = true;
                    map.forEach((key, value) {
                      //if(kDebugMode) print('key: $key: $value');
                      if (ratingMap[key] != null) {
                        //if(kDebugMode) print('2º key: $key: $value\n ');

                        if (key == 'date' ||
                            key == 'birthday' ||
                            key == 'created_at') {
                          Timestamp date = ratingMap[key];
                          String dateString =
                              '${date.toDate().day.toString().padLeft(2, '0')}${date.toDate().month.toString().padLeft(2, '0')}${date.toDate().year}';
                          ratingMap[key] = dateString;
                        }
                        if (key == 'hour') {
                          Timestamp hour = ratingMap[key];
                          String hourString = hour
                                  .toDate()
                                  .hour
                                  .toString()
                                  .padLeft(2, '0') +
                              hour.toDate().minute.toString().padLeft(2, '0');
                          ratingMap[key] = hourString;
                        }
                        if (key == 'avaliation') {
                          if (kDebugMode)
                            print('graaaaaaade ${ratingMap[key]}');
                          ratingMap[key] =
                              ratingMap[key].toString().padRight(2, '.0');
                          if (kDebugMode)
                            print('graaaaaaade222 ${ratingMap[key]}');
                          String stringGrade =
                              ratingMap[key].toString().substring(0, 1) +
                                  ratingMap[key].toString().substring(2);
                          ratingMap[key] = stringGrade;
                        }

                        if (aunContienes) {
                          if (kDebugMode)
                            print(
                                ' ratingMap[key]: ${ratingMap[key].toString().toLowerCase()} ==  value: ${value.toString().toLowerCase()} ??? ${ratingMap[key].toString().toLowerCase().contains(value.toString().toLowerCase())}');
                          if (ratingMap[key]
                              .toString()
                              .toLowerCase()
                              .contains(value.toString().toLowerCase())) {
                            //if(kDebugMode) print('######## contaaaaaaaaaaains ##########\n \n ');
                            if (!_instance.contains(ratingGridModel)) {
                              //if(kDebugMode) print(
                              //     '######## ainda naaaaaaaaao contaaaaaaaaaaains ##########\n \n \n \n ');
                              _instance.add(ratingGridModel);
                            }
                          } else {
                            aunContienes = false;
                            if (_instance.contains(ratingGridModel)) {
                              _instance.remove(ratingGridModel);
                            }
                          }
                        } else {
                          aunContienes = false;
                          if (_instance.contains(ratingGridModel)) {
                            _instance.remove(ratingGridModel);
                          }
                        }
                      } else {
                        aunContienes = false;
                        if (_instance.contains(ratingGridModel)) {
                          _instance.remove(ratingGridModel);
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
                  _instanceDataSource.setRows(
                    _instance
                        .map(
                          (e) => ratingProvider.getDataGridRow(e),
                        )
                        .toList(),
                  );
                  //if(kDebugMode) print(
                  //     '_instanceDataSource.rows.length: ${_instanceDataSource.rows.length}');
                  //if(kDebugMode) print('searchPageCount: $searchPageCount');
                }
                // _instance.forEach((element) {
                //  if(kDebugMode) print(
                //       'elemento: ${AppointmentModel().toJson(element. ratingModel)}');
                // });
                if (kDebugMode) print('map is empty? ${map.isEmpty}');
                if (kDebugMode) print('instance.length? ${_instance.length}');
                _dataPagerController.firstPage();
                value.setOpen(false);
              },
              onView: () {
                value.setOpen(!value.open);
              },
              open: value.open,
              children: List.generate(widget.filters.length, (index) {
                String title = widget.filters[index].first;
                String valChange = widget.filters[index][1];
                String collection = widget.filters[index][2];
                String field = widget.filters[index].last;
                return FilterField(
                  statuses: ['Visível', 'Reportada', 'Inativo'],
                  title: title,
                  collection: collection,
                  field: field,
                  onChanged: (val) => setVal(valChange, val),
                );
              }),
              // children: [
              //   FilterField(
              //     title: 'Id',
              //     collection: collection,
              //     field: 'id',
              //     onChanged: (val) => setVal('id', val),
              //   ),
              //   FilterField(
              //     title: 'Id do  médico',
              //     collection: 'doctors',
              //     field: 'id',
              //     onChanged: (val) => setVal('doctor_id', val),
              //   ),
              //   FilterField(
              //     title: 'Id do paciente',
              //     collection: 'patients',
              //     field: 'id',
              //     onChanged: (val) => setVal('patient_id', val),
              //   ),
              //   FilterField(
              //     title: 'Data',
              //     collection: collection,
              //     field: 'date',
              //     onChanged: (val) => setVal('date', val),
              //     // mask: homeProvider.getMask('date'),
              //   ),
              //   FilterField(
              //     title: 'Nota',
              //     collection: collection,
              //     field: 'avaliation',
              //     onChanged: (val) => setVal('avaliation', val),
              //     // mask: homeProvider.getMask('avaliation'),
              //   ),
              //   FilterField(
              //     title: 'Texto',
              //     collection: collection,
              //     field: 'text',
              //     onChanged: (val) => setVal('text', val),
              //   ),
              //   FilterField(
              //     title: 'Status',
              //     collection: collection,
              //     field: 'status',
              //     overlayData: ['Avaliada', 'Reportada', 'Inativada'],
              //     onChanged: (val) => setVal('status', val),
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

class RatingDataSource extends DataGridSource {
  RatingDataSource() {
    paginatedDataSource = [];
    buildDataGridRows();
  }

  List<DataGridRow> _ratingData = [];
  @override
  List<DataGridRow> get rows => _ratingData;
  setRows(ratingData) {
    _ratingData = ratingData;
    notifyListeners();
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    // await Future.delayed(const Duration(seconds: 3));
    int startIndex = newPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    if (startIndex < _ratings.length) {
      if (endIndex > _ratings.length) {
        endIndex = _ratings.length;
      }
      paginatedDataSource =
          _ratings.getRange(startIndex, endIndex).toList(growable: false);
      buildDataGridRows();
    } else {
      paginatedDataSource = [];
    }
    notifyListeners();
    return true;
  }

  void buildDataGridRows() {
    _ratingData = paginatedDataSource
        .map((e) => DataGridRow(cells: [
              DataGridCell(columnName: 'id', value: e.ratingModel.id),
              DataGridCell(
                  columnName: 'doctorId', value: e.ratingModel.doctorId),
              DataGridCell(
                  columnName: 'patientId', value: e.ratingModel.patientId),
              DataGridCell(
                  columnName: 'username', value: e.ratingModel.username),
              DataGridCell(
                  columnName: 'date', value: validate(e.ratingModel.createdAt)),
              DataGridCell(
                  columnName: 'avaliation',
                  value: e.ratingModel.avaliation.toString().padRight(2, '.0')),
              DataGridCell(columnName: 'status', value: e.ratingModel.status),
              DataGridCell(columnName: 'actions', value: e),
            ]))
        .toList();
  }

  validate(Timestamp e) {
    //if(kDebugMode) print('e.patientModel.birthday ${e}');
    if (e == null) {
      return 'null';
    } else {
      return e;
    }
  }

  @override
  Future<void> handleRefresh() {
    return Future.delayed(Duration(seconds: 3), () {
      buildDataGridRows();
      notifyListeners();
    });
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      switch (e.columnName) {
        case 'date':
          Timestamp timestamp = e.value;
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: SelectableText(
              TimeModel().date(timestamp),
              enableInteractiveSelection: true,
              toolbarOptions: ToolbarOptions(selectAll: true),
              scrollPhysics: ClampingScrollPhysics(),
              maxLines: 1,
            ),
          );
          break;
        case 'actions':
          return RatingActions(ratingModel: e.value.ratingModel);
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

class InstanceDataGridSource extends DataGridSource {
  InstanceDataGridSource() {
    paginatedDataSource = [];
    buildDataGridRows();
  }

  List<DataGridRow> _instanceData = [];
  @override
  List<DataGridRow> get rows => _instanceData;

  setRows(ratingData) {
    int maxRange = rowsPerPage;
    if (_instance.length < rowsPerPage) {
      maxRange = _instance.length;
    }
    paginatedDataSource =
        _instance.getRange(0, maxRange).toList(growable: false);
    buildDataGridRows();
    // _instanceData = ratingData;
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

  void buildDataGridRows() {
    _instanceData = paginatedDataSource
        .map((e) => DataGridRow(cells: [
              DataGridCell(columnName: 'id', value: e.ratingModel.id),
              DataGridCell(
                  columnName: 'doctorId', value: e.ratingModel.doctorId),
              DataGridCell(
                  columnName: 'patientId', value: e.ratingModel.patientId),
              DataGridCell(
                  columnName: 'username', value: e.ratingModel.username),
              DataGridCell(
                  columnName: 'date',
                  value: HomeProvider()
                      .validateTimeStamp(e.ratingModel.createdAt, 'date')),
              DataGridCell(
                  columnName: 'avaliation',
                  value: e.ratingModel.avaliation.toString().padRight(2, '.0')),
              DataGridCell(columnName: 'status', value: e.ratingModel.status),
              DataGridCell(columnName: 'actions', value: e),
            ]))
        .toList();
  }

  @override
  Future<void> handleRefresh() {
    return Future.delayed(Duration(seconds: 3), () {
      buildDataGridRows();
      notifyListeners();
    });
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      switch (e.columnName) {
        case 'actions':
          return RatingActions(ratingModel: e.value.ratingModel);
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
