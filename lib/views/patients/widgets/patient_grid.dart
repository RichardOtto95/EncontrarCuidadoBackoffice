import 'package:back_office/shared/grid_scroll_behavior.dart';
import 'package:back_office/shared/widgets/filter_field.dart';
import 'package:back_office/shared/widgets/title_bar.dart';
import 'package:back_office/views/home/home_provider.dart';
import 'package:back_office/views/patients/models/patient_model.dart';
import 'package:back_office/shared/utilities.dart';
import 'package:back_office/shared/widgets/filter.dart';
import 'package:back_office/views/patients/patient_provider.dart';
import 'package:back_office/views/patients/widgets/patient_actions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class PatientGrid extends StatefulWidget {
  final List<List> filters;

  PatientGrid({Key key, this.filters}) : super(key: key);
  @override
  _PatientGridState createState() => _PatientGridState();
}

List<PatientGridModel> _paginatedDataSource = [];
List<PatientGridModel> _patients = [];
List<PatientGridModel> _instance = [];
final int rowsPerPage = 20;

class _PatientGridState extends State<PatientGrid> {
  final String collection = 'patients';
  PatientProvider patientProvider = PatientProvider();
  PatientDataGridSource _patientDataSource;
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
    _patientDataSource = PatientDataGridSource();
  }

  int pacientPage = 1;

  bool filtering = false;
  Map<String, String> map = {};

  setVal(String type, String val) {
    if (kDebugMode) print('type: $type val: "$val"');
    if (val != '') {
      if (kDebugMode) print('adicionando ao campo');
      map[type] = val;
    } else {
      if (kDebugMode) print('removendo type');
      map.remove(type);
    }
  }

  double cellWidth = 128;

  @override
  Widget build(BuildContext context) {
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
              TitleBar(
                  title: 'Pacientes',
                  subTitle: 'Gestão de pacientes, titulares e dependentes'),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(collection)
                    .orderBy('created_at', descending: true)
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
                    _patients = patientProvider.getPatientsGridData(qs);
                    pageCount = filtering
                        ? (_instance.length / rowsPerPage).ceilToDouble()
                        : (_patients.length / rowsPerPage).ceilToDouble();
                    if (_patients == null ||
                        _patients.length == 0 ||
                        _patients.length == null) {
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
                        child: SelectableText('Sem pacientes com esses dados'),
                      );
                    } else {
                      return Stack(children: [
                        Column(
                          children: [
                            Center(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(32, 35, 32, 0),
                                height: hXD(540, context),
                                alignment: Alignment.center,
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
                                        ? _patientDataSource
                                        : _instanceDataSource,
                                    headerRowHeight: 60,
                                    defaultColumnWidth: 114,
                                    rowHeight: 74,
                                    selectionMode: SelectionMode.multiple,
                                    columns: [
                                      GridColumn(
                                          width: cellWidth,
                                          columnName: 'id',
                                          label: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'ID',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )),
                                      GridColumn(
                                          width: cellWidth,
                                          columnName: 'username',
                                          label: Container(
                                            padding: EdgeInsets.only(left: 15),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Nome de usuário',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )),
                                      GridColumn(
                                          width: cellWidth,
                                          columnName: 'fullname',
                                          label: Container(
                                            height: 74,
                                            width: cellWidth,
                                            padding: EdgeInsets.only(left: 15),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Nome completo',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )),
                                      GridColumn(
                                          width: cellWidth,
                                          columnName: 'birthday',
                                          label: Container(
                                            height: 74,
                                            width: cellWidth,
                                            padding: EdgeInsets.only(left: 15),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Data de nascimento',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )),
                                      GridColumn(
                                          width: cellWidth,
                                          columnName: 'cpf',
                                          label: Container(
                                            height: 74,
                                            width: cellWidth,
                                            alignment: Alignment.center,
                                            child: Text(
                                              'CPF',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )),
                                      GridColumn(
                                          width: cellWidth,
                                          columnName: 'gender',
                                          label: Container(
                                            height: 74,
                                            width: cellWidth,
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Gênero',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )),
                                      GridColumn(
                                          width: cellWidth,
                                          columnName: 'email',
                                          label: Container(
                                            height: 74,
                                            width: cellWidth,
                                            alignment: Alignment.center,
                                            child: Text(
                                              'E-mail',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )),
                                      GridColumn(
                                          width: cellWidth,
                                          columnName: 'phone',
                                          label: Container(
                                            height: 74,
                                            width: cellWidth,
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Telefone',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )),
                                      GridColumn(
                                          width: cellWidth,
                                          columnName: 'statue',
                                          label: Container(
                                            height: 74,
                                            width: cellWidth,
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Status',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )),
                                      GridColumn(
                                          width: cellWidth,
                                          columnName: 'type',
                                          label: Container(
                                            height: 74,
                                            width: cellWidth,
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Tipo',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )),
                                      GridColumn(
                                        width: cellWidth,
                                        columnName: 'actions',
                                        label: Container(
                                          height: 74,
                                          width: cellWidth,
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Ações',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Color(0xff000000),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
                                      ? _patientDataSource
                                      : _instanceDataSource,
                                  pageCount:
                                      !filtering ? pageCount : searchPageCount,
                                  direction: Axis.horizontal,
                                  onPageNavigationStart: (int pageIndex) {
                                    Provider.of<PatientProvider>(context,
                                            listen: false)
                                        .incPageView(pageIndex);
                                  },
                                  onPageNavigationEnd: (int pageIndex) {
                                    Provider.of<PatientProvider>(context,
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
                            child: Consumer<PatientProvider>(
                              builder: (context, value, child) => Text(
                                  '${value.pageView + 1} de $pageCount Páginas'),
                            ),
                          ),
                        ),
                      ]);
                    }
                  }
                },
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          child: Consumer<PatientProvider>(
            builder: (context, value, child) => Filter(
              onFilter: () {
                if (map.isEmpty) {
                  _instance.clear();
                  _instanceDataSource.rows.clear();
                  searchPageCount = 0;
                  filtering = false;
                } else {
                  _instance.clear();
                  _patients.forEach((patientGridModel) {
                    Map<String, dynamic> patientMap =
                        PatientModel().toJson(patientGridModel.patientModel);
                    //if(kDebugMode) print('patientMap: $patientMap');
                    bool aunContienes = true;
                    map.forEach((key, value) {
                      //if(kDebugMode) print('key: $key: $value');
                      if (patientMap[key] != null) {
                        //if(kDebugMode) print('2º key: $key: $value\n ');

                        if (key == 'date' ||
                            key == 'birthday' ||
                            key == 'created_at') {
                          Timestamp date = patientMap[key];
                          String dateString =
                              '${date.toDate().day.toString().padLeft(2, '0')}${date.toDate().month.toString().padLeft(2, '0')}${date.toDate().year}';
                          patientMap[key] = dateString;
                        }
                        if (kDebugMode)
                          print(
                              'patientMap:  ${patientMap[key].toString().toLowerCase()} == value: ${value.toLowerCase()} ??? ${patientMap[key].toString().toLowerCase().contains(value.toLowerCase())}');
                        if (aunContienes) {
                          if (patientMap[key]
                              .toString()
                              .toLowerCase()
                              .contains(value.toLowerCase())) {
                            //if(kDebugMode) print('######## contaaaaaaaaaaains ##########\n \n ');
                            if (!_instance.contains(patientGridModel)) {
                              //if(kDebugMode) print(
                              //     '######## ainda naaaaaaaaao contaaaaaaaaaaains ##########\n \n \n \n ');
                              _instance.add(patientGridModel);
                            }
                          } else {
                            aunContienes = false;
                            if (_instance.contains(patientGridModel)) {
                              _instance.remove(patientGridModel);
                            }
                          }
                        } else {
                          aunContienes = false;
                          if (_instance.contains(patientGridModel)) {
                            _instance.remove(patientGridModel);
                          }
                        }
                      } else {
                        aunContienes = false;
                        if (_instance.contains(patientGridModel)) {
                          _instance.remove(patientGridModel);
                        }
                      }
                    });
                  });
                  //if(kDebugMode) print('_instance.length: ${_instance.length}');
                  filtering = true;
                  if (_instance.isEmpty) {
                    searchPageCount = 1;
                  } else {
                    searchPageCount =
                        (_instance.length / rowsPerPage).ceilToDouble();
                  }
                  _instanceDataSource.setRows(
                    _instance
                        .map((e) => patientProvider.getDataGridRow(e))
                        .toList(),
                  );
                  //if(kDebugMode) print(
                  //     '_instanceDataSource.rows.length: ${_instanceDataSource.rows.length}');
                  //if(kDebugMode) print('searchPageCount: $searchPageCount');
                }
                _instance.forEach((element) {
                  //if(kDebugMode) print(
                  //     'elemento: ${PatientModel().toJson(element.patientModel)}');
                });
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
                  statuses: ['Ativo', "Removido", "Bloqueado"],
                  types: ['Titular', 'Dependente'],
                  title: title,
                  collection: collection,
                  field: field,
                  onChanged: (val) => setVal(valChange, val),
                );
              }),
              // [
              // FilterField(
              //   title: 'Id',
              //   collection: collection,
              //   field: 'id',
              //   onChanged: (val) => setVal('id', val),
              // ),
              //   FilterField(
              //     title: 'ID do responsável',
              //     collection: collection,
              //     field: 'responsible_id',
              //     onChanged: (val) => setVal('responsible_id', val),
              //   ),
              //   FilterField(
              //     title: 'Data de criação',
              //     collection: collection,
              //     field: 'created_at',
              //     onChanged: (val) => setVal('created_at', val),
              //   ),
              //   FilterField(
              //     title: 'Notificação ativada',
              //     collection: collection,
              //     field: 'notification_enabled',
              //     onChanged: (val) => setVal('notification_enabled', val),
              //   ),
              //   FilterField(
              //     title: 'Nome do usuário',
              //     collection: collection,
              //     field: 'username',
              //     onChanged: (val) => setVal('username', val),
              //   ),
              //   FilterField(
              //     title: 'Nome completo',
              //     collection: collection,
              //     field: 'fullname',
              //     onChanged: (val) => setVal('fullname', val),
              //   ),
              //   FilterField(
              //     title: 'Data de nascimento',
              //     collection: collection,
              //     field: 'birthday',
              //     onChanged: (val) => setVal('birthday', val),
              //     mask: homeProvider.getMask('date'),
              //   ),
              //   FilterField(
              //     title: 'CPF',
              //     collection: collection,
              //     field: 'cpf',
              //     onChanged: (val) => setVal('cpf', val),
              //     mask: homeProvider.getMask('cpf'),
              //   ),
              //   FilterField(
              //     title: 'Gênero',
              //     collection: collection,
              //     field: 'gender',
              //     onChanged: (val) => setVal('gender', val),
              //   ),
              //   FilterField(
              //     title: 'E-mail',
              //     collection: collection,
              //     field: 'email',
              //     onChanged: (val) => setVal('email', val),
              //   ),
              //   FilterField(
              //     title: 'Telefone',
              //     collection: collection,
              //     field: 'phone',
              //     onChanged: (val) => setVal('phone', val),
              //     mask: homeProvider.getMask('phone'),
              //   ),
              //   FilterField(
              //     title: 'Status',
              //     collection: collection,
              //     field: 'status',
              //     overlayData: ['Ativo', 'Inativo', 'Bloqueado'],
              //     onChanged: (val) => setVal('status', val),
              //   ),
              //   FilterField(
              //     title: 'Tipo',
              //     collection: collection,
              //     field: 'type',
              //     overlayData: ['Titular', 'Dependente'],
              //     onChanged: (val) => setVal('type', val),
              //   ),
              // ],
            ),
          ),
        ),
      ],
      alignment: Alignment.topCenter,
    );
  }
}

class PatientDataGridSource extends DataGridSource {
  HomeProvider homeProvider = HomeProvider();
  PatientDataGridSource() {
    _paginatedDataSource = [];
    buildDataGridRows();
  }

  List<DataGridRow> _patientData = [];
  @override
  List<DataGridRow> get rows => _patientData;

  setRows(patientData) {
    _patientData = patientData;
    notifyListeners();
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    //if(kDebugMode) print('oldPageIndex: $oldPageIndex, newPageIndex: $newPageIndex');
    int startIndex = newPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    if (startIndex < _patients.length) {
      //if(kDebugMode) print('startIndex < _patients.length');
      if (endIndex > _patients.length) {
        //if(kDebugMode) print('endIndex > _patients.length');
        endIndex = _patients.length;
      }
      //if(kDebugMode) print('Handle _patients.length: ${_patients.length}');
      _paginatedDataSource =
          _patients.getRange(startIndex, endIndex).toList(growable: false);
      buildDataGridRows();
    } else {
      //if(kDebugMode) print('else');
      _paginatedDataSource = [];
    }
    notifyListeners();
    return true;
  }

  @override
  Future<void> handleRefresh() {
    return Future.delayed(Duration(seconds: 2), () {
      buildDataGridRows();
      notifyListeners();
    });
  }

  void buildDataGridRows() {
    _patientData = _paginatedDataSource
        .map((e) => DataGridRow(cells: [
              DataGridCell(columnName: 'id', value: e.patientModel.id),
              DataGridCell(
                  columnName: 'username', value: e.patientModel.username),
              DataGridCell(
                  columnName: 'fullname', value: e.patientModel.fullname),
              DataGridCell(
                  columnName: 'birthday',
                  value: homeProvider.validateTimeStamp(
                      e.patientModel.birthday, 'date')),
              DataGridCell(
                  columnName: 'cpf',
                  value: homeProvider.getTextMasked(e.patientModel.cpf, 'cpf')),
              DataGridCell(columnName: 'gender', value: e.patientModel.gender),
              DataGridCell(columnName: 'email', value: e.patientModel.email),
              DataGridCell(
                  columnName: 'phone',
                  value: homeProvider.getTextMasked(
                      e.patientModel.phone, 'phone')),
              DataGridCell(columnName: 'status', value: e.patientModel.status),
              DataGridCell(columnName: 'type', value: e.patientModel.type),
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
          return PatientActions(
            patientModel: e.value.patientModel,
            onDelete: () {
              buildDataGridRows();
              notifyListeners();
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

class InstanceDataGridSource extends DataGridSource {
  HomeProvider homeProvider = HomeProvider();
  InstanceDataGridSource() {
    _paginatedDataSource = [];
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
    _paginatedDataSource =
        _instance.getRange(0, maxRange).toList(growable: false);
    buildDataGridRows();
    // _instanceData = instanceData;
    notifyListeners();
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    //if(kDebugMode) print('oldPageIndex: $oldPageIndex, newPageIndex: $newPageIndex');
    int startIndex = newPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    if (startIndex < _instance.length) {
      //if(kDebugMode) print('startIndex < _instance.length');
      if (endIndex > _instance.length) {
        //if(kDebugMode) print('endIndex > _instance.length');

        endIndex = _instance.length;
      }
      //if(kDebugMode) print('Handle _instance.length: ${_instance.length}');
      _paginatedDataSource =
          _instance.getRange(startIndex, endIndex).toList(growable: false);
      buildDataGridRows();
    } else {
      //if(kDebugMode) print('else');
      _paginatedDataSource = [];
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

  void getSearch(String type, String value) {}

  void buildDataGridRows() {
    _instanceData = _paginatedDataSource
        .map((e) => DataGridRow(cells: [
              DataGridCell(columnName: 'id', value: e.patientModel.id),
              DataGridCell(
                  columnName: 'username', value: e.patientModel.username),
              DataGridCell(
                  columnName: 'fullname', value: e.patientModel.fullname),
              DataGridCell(
                  columnName: 'birthday',
                  value: homeProvider.validateTimeStamp(
                      e.patientModel.birthday, 'date')),
              DataGridCell(
                  columnName: 'cpf',
                  value: homeProvider.getTextMasked(e.patientModel.cpf, 'cpf')),
              DataGridCell(columnName: 'gender', value: e.patientModel.gender),
              DataGridCell(columnName: 'email', value: e.patientModel.email),
              DataGridCell(
                  columnName: 'phone',
                  value: homeProvider.getTextMasked(
                      e.patientModel.phone, 'phone')),
              DataGridCell(columnName: 'status', value: e.patientModel.status),
              DataGridCell(columnName: 'type', value: e.patientModel.type),
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
          return PatientActions(
            patientModel: e.value.patientModel,
            onDelete: () {
              buildDataGridRows();
              notifyListeners();
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
