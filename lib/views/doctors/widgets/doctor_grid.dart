import 'package:back_office/shared/grid_scroll_behavior.dart';
import 'package:back_office/shared/utilities.dart';
import 'package:back_office/shared/widgets/filter.dart';
import 'package:back_office/shared/widgets/filter_field.dart';
import 'package:back_office/views/doctors/doctors_provider.dart';
import 'package:back_office/views/doctors/models/doctor_model.dart';
import 'package:back_office/views/home/home_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'doctor_actions.dart';

class DoctorGrid extends StatefulWidget {
  final List<List> filters;

  const DoctorGrid({Key key, this.filters}) : super(key: key);
  @override
  _DoctorGridState createState() => _DoctorGridState();
}

List<DoctorGridModel> paginatedDataSource = [];
List<DoctorGridModel> _doctors = [];
List<DoctorGridModel> _instance = [];
final int rowsPerPage = 20;

class _DoctorGridState extends State<DoctorGrid> {
  final String collection = 'doctors';
  DoctorProvider doctorProvider = DoctorProvider();
  DoctorDataGridSource _doctorDataSource;
  InstanceDataGridSource _instanceDataSource;
  DataGridController _dataGridController;
  DataPagerController _dataPagerController;
  bool showLoadingIndicator = true;
  double pageCount = 0;
  double searchPageCount = 0;

  @override
  void initState() {
    super.initState();
    _dataGridController = DataGridController();
    _dataPagerController = DataPagerController();
    _instanceDataSource = InstanceDataGridSource();
    _doctorDataSource = DoctorDataGridSource();
  }

  bool open = false;
  int pacientPage = 1;

  bool filtering = false;
  Map<String, String> map = {};

  @override
  Widget build(BuildContext context) {
    setVal(String type, String val) {
      if (val != '') {
        map[type] = val;
      } else {
        map.remove(type);
      }
    }

    //if(kDebugMode) print('mapmapmapampmap $map');
    //if(kDebugMode) print('pageCount $pageCount');

    return SingleChildScrollView(
      child: Stack(
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
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Color(0xff707070).withOpacity(.3)))),
                  padding: EdgeInsets.fromLTRB(
                      wXD(45, context), hXD(23, context), 0, hXD(20, context)),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Médicos',
                        style: TextStyle(
                          fontSize: 28,
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Gestão de médicos e secretários',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff707070),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
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
                      // Stream stream = FirebaseFirestore.instance
                      //     .collection(collection)
                      //     .snapshots(includeMetadataChanges: true);

                      // stream.listen((event) {
                      //   QuerySnapshot qs = event;
                      //  if(kDebugMode) print('event: ${qs.metadata.runtimeType}');
                      //   if (qs.metadata.runtimeType != SnapshotMetadata) {
                      //     _doctorDataSource.refresh();
                      //   }
                      // });
                      QuerySnapshot qs = snapshot.data;
                      _doctors = doctorProvider.getDoctorsGridData(qs);
                      pageCount = filtering
                          ? (_instance.length / rowsPerPage).ceilToDouble()
                          : (_doctors.length / rowsPerPage).ceilToDouble();

                      if (_doctors == null ||
                          _doctors.length == 0 ||
                          _doctors.length == null) {
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
                          child: SelectableText('Sem doutores com esses dados'),
                        );
                      } else {
                        return Stack(children: [
                          Column(
                            children: [
                              Center(
                                  child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(32, 35, 32, 0),
                                      height: hXD(540, context),
                                      child: ScrollConfiguration(
                                        behavior: GridScrollBehavior(),
                                        child: SfDataGrid(
                                            isScrollbarAlwaysShown: true,
                                            allowPullToRefresh: true,
                                            controller: _dataGridController,
                                            headerGridLinesVisibility:
                                                GridLinesVisibility.both,
                                            gridLinesVisibility:
                                                GridLinesVisibility.both,
                                            source: !filtering
                                                ? _doctorDataSource
                                                : _instanceDataSource,
                                            headerRowHeight: 60,
                                            defaultColumnWidth: 114,
                                            rowHeight: 74,
                                            selectionMode:
                                                SelectionMode.multiple,
                                            columns: [
                                              GridTextColumn(
                                                  width: 121,
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
                                                                FontWeight.w600,
                                                          )))),
                                              GridTextColumn(
                                                  width: 121,
                                                  columnName: 'username',
                                                  label: Container(
                                                      padding: EdgeInsets.only(
                                                          left: 15),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                          'Nome de usuário',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Color(
                                                                0xff000000),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          )))),
                                              GridTextColumn(
                                                  width: 121,
                                                  columnName: 'fullname',
                                                  label: Container(
                                                      height: 74,
                                                      width: 121,
                                                      padding: EdgeInsets.only(
                                                          left: 15),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                          'Nome completo',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Color(
                                                                0xff000000),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          )))),
                                              GridTextColumn(
                                                  width: 121,
                                                  columnName: 'born',
                                                  label: Container(
                                                      height: 74,
                                                      width: 121,
                                                      padding: EdgeInsets.only(
                                                          left: 15),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                          'Data de nascimento',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Color(
                                                                0xff000000),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          )))),
                                              GridTextColumn(
                                                  width: 121,
                                                  columnName: 'cpf',
                                                  label: Container(
                                                      height: 74,
                                                      width: 121,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text('CPF',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Color(
                                                                0xff000000),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          )))),
                                              GridTextColumn(
                                                  width: 121,
                                                  columnName: 'gender',
                                                  label: Container(
                                                      height: 74,
                                                      width: 121,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text('Gênero',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Color(
                                                                0xff000000),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          )))),
                                              GridTextColumn(
                                                  width: 121,
                                                  columnName: 'crm',
                                                  label: Container(
                                                      height: 74,
                                                      width: 121,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text('CRM',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Color(
                                                                0xff000000),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          )))),
                                              GridTextColumn(
                                                  width: 121,
                                                  columnName: 'rqe',
                                                  label: Container(
                                                      height: 74,
                                                      width: 121,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text('RQE',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Color(
                                                                0xff000000),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          )))),
                                              GridTextColumn(
                                                  width: 121,
                                                  columnName: 'speciality',
                                                  label: Container(
                                                      height: 74,
                                                      width: 121,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                          'Especialidade',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Color(
                                                                0xff000000),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          )))),
                                              GridTextColumn(
                                                  width: 121,
                                                  columnName: 'return_period',
                                                  label: Container(
                                                      height: 74,
                                                      width: 121,
                                                      alignment:
                                                          Alignment.center,
                                                      padding: EdgeInsets.only(
                                                          left: 15),
                                                      child: Text(
                                                          'Dias para retorno',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Color(
                                                                0xff000000),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          )))),
                                              GridTextColumn(
                                                  width: 121,
                                                  columnName: 'email',
                                                  label: Container(
                                                      height: 74,
                                                      width: 121,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text('E-mail',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Color(
                                                                0xff000000),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          )))),
                                              GridTextColumn(
                                                  width: 121,
                                                  columnName: 'phone',
                                                  label: Container(
                                                      height: 74,
                                                      width: 121,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text('Telefone',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Color(
                                                                0xff000000),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          )))),
                                              GridTextColumn(
                                                  width: 121,
                                                  columnName: 'status',
                                                  label: Container(
                                                      height: 74,
                                                      width: 121,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text('Status',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Color(
                                                                0xff000000),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          )))),
                                              GridTextColumn(
                                                  width: 121,
                                                  columnName: 'type',
                                                  label: Container(
                                                      height: 74,
                                                      width: 121,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text('Tipo',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Color(
                                                                0xff000000),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          )))),
                                              GridTextColumn(
                                                  width: 161,
                                                  columnName: 'actions',
                                                  label: Container(
                                                      height: 74,
                                                      width: 121,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text('Ações',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Color(
                                                                0xff000000),
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
                                          ? _doctorDataSource
                                          : _instanceDataSource,
                                      pageCount: !filtering
                                          ? pageCount
                                          : searchPageCount,
                                      direction: Axis.horizontal,
                                      onPageNavigationStart: (int pageIndex) {
                                        Provider.of<DoctorProvider>(context,
                                                listen: false)
                                            .incPageView(pageIndex);
                                      },
                                      onPageNavigationEnd: (int pageIndex) {
                                        Provider.of<DoctorProvider>(context,
                                                listen: false)
                                            .incPageView(pageIndex);
                                        _dataGridController
                                            .scrollToVerticalOffset(0);
                                      },
                                    )),
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
                              child: Consumer<DoctorProvider>(
                                builder: (context, value, child) => Text(
                                    '${value.pageView + 1} de $pageCount Páginas'),
                              ),
                            ),
                          ),
                        ]);
                      }
                    }
                  },
                )
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Consumer<DoctorProvider>(builder: (context, value, child) {
              return Filter(
                onFilter: () async {
                  if (map.isEmpty) {
                    _instance.clear();
                    _instanceDataSource.rows.clear();

                    await _doctorDataSource.handlePageChange(0, 0);
                    filtering = false;
                    searchPageCount = 0;
                  } else {
                    _instance.clear();
                    _doctors.forEach((doctorGridModel) {
                      Map<String, dynamic> doctorMap =
                          DoctorModel().toJson(doctorGridModel.doctorModel);
                      //if(kDebugMode) print('doctorMap: $doctorMap');
                      bool aunContienes = true;
                      map.forEach((key, value) {
                        //if(kDebugMode) print('key: $key: $value');
                        if (doctorMap[key] != null) {
                          //if(kDebugMode) print('2º key: $key: $value\n ');

                          if (key == 'date' ||
                              key == 'birthday' ||
                              key == 'created_at') {
                            Timestamp date = doctorMap[key];
                            String dateString =
                                '${date.toDate().day.toString().padLeft(2, '0')}${date.toDate().month.toString().padLeft(2, '0')}${date.toDate().year}';
                            doctorMap[key] = dateString;
                          }

                          //if(kDebugMode) print(
                          //     '######## contaaaaaaaaaaains ${doctorMap[key].toString().toLowerCase()} == ${value.toLowerCase()} ##########\n \n ');
                          if (aunContienes) {
                            if (doctorMap[key]
                                .toString()
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                              if (!_instance.contains(doctorGridModel)) {
                                //if(kDebugMode) print(
                                //     '######## ainda naaaaaaaaao contaaaaaaaaaaains ##########\n \n \n \n ');
                                _instance.add(doctorGridModel);
                              }
                            } else {
                              aunContienes = false;
                              if (_instance.contains(doctorGridModel)) {
                                _instance.remove(doctorGridModel);
                              }
                            }
                          } else {
                            aunContienes = false;
                            if (_instance.contains(doctorGridModel)) {
                              _instance.remove(doctorGridModel);
                            }
                          }
                        } else {
                          aunContienes = false;
                          if (_instance.contains(doctorGridModel)) {
                            _instance.remove(doctorGridModel);
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
                            (e) => doctorProvider.getDataGridRow(e),
                          )
                          .toList(),
                    );
                    await _instanceDataSource.handlePageChange(0, 0);

                    //if(kDebugMode) print(
                    //     '_instanceDataSource.rows.length: ${_instanceDataSource.rows.length}');
                    //if(kDebugMode) print('searchPageCount: $searchPageCount');
                  }
                  // _instance.forEach((element) {
                  //if(kDebugMode) print(
                  //     'elemento: ${DoctorModel().toJson(element.doctorModel)}');
                  // });
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
                    statuses: [
                      'Ativo',
                      'Bloqueado',
                      /*'Inativo',  'Expirado'*/
                      'Removido'
                    ],
                    types: ['Doutor(a)', 'Secretário(a)'],
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
                //     // mask: homeProvider.getMask('date'),
                //   ),
                //   FilterField(
                //     title: 'CPF',
                //     collection: collection,
                //     field: 'cpf',
                //     onChanged: (val) => setVal('cpf', val),
                //     // mask: homeProvider.getMask('cpf'),
                //   ),
                //   FilterField(
                //     title: 'Gênero',
                //     collection: collection,
                //     field: 'gender',
                //     onChanged: (val) => setVal('gender', val),
                //   ),
                //   FilterField(
                //     title: 'CRM',
                //     collection: collection,
                //     field: 'crm',
                //     onChanged: (val) => setVal('crm', val),
                //   ),
                //   FilterField(
                //     title: 'RQE',
                //     collection: collection,
                //     field: 'rqe',
                //     onChanged: (val) => setVal('rqe', val),
                //   ),
                //   FilterField(
                //     title: 'Especialidade',
                //     collection: 'specialties',
                //     field: 'speciality',
                //     onChanged: (val) => setVal('speciality_name', val),
                //   ),
                //   FilterField(
                //     title: 'Período de retorno',
                //     collection: collection,
                //     field: 'return_period',
                //     onChanged: (val) => setVal('return_period', val),
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
                //     // mask: homeProvider.getMask('phone'),
                //   ),
                //   FilterField(
                //     title: 'Status',
                //     collection: collection,
                //     field: 'status',
                //     overlayData: ['Ativo', 'Inativo', 'Bloqueado', 'Expirado'],
                //     onChanged: (val) => setVal('status', val),
                //   ),
                //   FilterField(
                //     title: 'Tipo',
                //     collection: collection,
                //     field: 'type',
                //     overlayData: ['Doutor(a)', 'Secretário(a)'],
                //     onChanged: (val) => setVal('type', val),
                //   ),
                // ],
              );
            }),
          ),
        ],
        alignment: Alignment.topCenter,
      ),
    );
  }
}

class DoctorDataGridSource extends DataGridSource {
  HomeProvider homeProvider = HomeProvider();
  DoctorDataGridSource() {
    paginatedDataSource = [];
    buildDataGridRows();
  }

  List<DataGridRow> _doctorData = [];
  @override
  List<DataGridRow> get rows => _doctorData;

  setRows(doctorData) {
    _doctorData = doctorData;
    notifyListeners();
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    // await Future.delayed(const Duration(seconds: 3));
    int startIndex = newPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    if (startIndex < _doctors.length) {
      if (endIndex > _doctors.length) {
        endIndex = _doctors.length;
      }
      paginatedDataSource =
          _doctors.getRange(startIndex, endIndex).toList(growable: false);
      buildDataGridRows();
    } else {
      paginatedDataSource = [];
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
    _doctorData = paginatedDataSource
        .map((e) => DataGridRow(cells: [
              DataGridCell(columnName: 'id', value: e.doctorModel.id),
              DataGridCell(
                  columnName: 'username', value: e.doctorModel.username),
              DataGridCell(
                  columnName: 'fullname', value: e.doctorModel.fullname),
              DataGridCell(
                  columnName: 'birthday',
                  value: homeProvider.validateTimeStamp(
                      e.doctorModel.birthday, 'date')),
              DataGridCell(
                  columnName: 'cpf',
                  value: homeProvider.getTextMasked(e.doctorModel.cpf, 'cpf')),
              DataGridCell(columnName: 'gender', value: e.doctorModel.gender),
              DataGridCell(columnName: 'crm', value: e.doctorModel.crm),
              DataGridCell(columnName: 'rqe', value: e.doctorModel.rqe),
              DataGridCell(
                  columnName: 'speciality', value: e.doctorModel.speciality),
              DataGridCell(
                  columnName: 'return_period',
                  value: e.doctorModel.returnPeriod.toString()),
              DataGridCell(columnName: 'email', value: e.doctorModel.email),
              DataGridCell(
                  columnName: 'phone',
                  value:
                      homeProvider.getTextMasked(e.doctorModel.phone, 'phone')),
              DataGridCell(columnName: 'status', value: e.doctorModel.status),
              DataGridCell(columnName: 'type', value: e.doctorModel.type),
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
          return DoctorActions(
            doctorModel: e.value.doctorModel,
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
            value = e.value;
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
    paginatedDataSource = [];
    buildDataGridRows();
  }

  List<DataGridRow> _instanceData = [];

  @override
  List<DataGridRow> get rows => _instanceData;

  setRows(instanceData) {
    _instanceData = instanceData;
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
      paginatedDataSource =
          _instance.getRange(startIndex, endIndex).toList(growable: false);
      buildDataGridRows();
    } else {
      //if(kDebugMode) print('else');
      paginatedDataSource = [];
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

  refresh() {
    return Future.delayed(Duration(seconds: 1), () {
      buildDataGridRows();
      notifyListeners();
    });
  }

  void buildDataGridRows() {
    _instanceData = paginatedDataSource
        .map((e) => DataGridRow(cells: [
              DataGridCell(columnName: 'id', value: e.doctorModel.id),
              DataGridCell(
                  columnName: 'username', value: e.doctorModel.username),
              DataGridCell(
                  columnName: 'fullname', value: e.doctorModel.fullname),
              DataGridCell(
                  columnName: 'birthday',
                  value: homeProvider.validateTimeStamp(
                      e.doctorModel.birthday, 'date')),
              DataGridCell(
                  columnName: 'cpf',
                  value: homeProvider.getTextMasked(e.doctorModel.cpf, 'cpf')),
              DataGridCell(columnName: 'gender', value: e.doctorModel.gender),
              DataGridCell(columnName: 'crm', value: e.doctorModel.crm),
              DataGridCell(columnName: 'rqe', value: e.doctorModel.rqe),
              DataGridCell(
                  columnName: 'speciality', value: e.doctorModel.speciality),
              DataGridCell(
                  columnName: 'return_period',
                  value: e.doctorModel.returnPeriod.toString()),
              DataGridCell(columnName: 'email', value: e.doctorModel.email),
              DataGridCell(
                  columnName: 'phone',
                  value:
                      homeProvider.getTextMasked(e.doctorModel.phone, 'phone')),
              DataGridCell(columnName: 'status', value: e.doctorModel.status),
              DataGridCell(columnName: 'type', value: e.doctorModel.type),
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
          return DoctorActions(
            doctorModel: e.value.doctorModel,
            onDelete: () {
              buildDataGridRows();
              notifyListeners();
            },
          );
          break;

        default:
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: SelectableText(
              e.value ?? '- - -',
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
