import 'package:back_office/shared/grid_scroll_behavior.dart';
import 'package:back_office/shared/utilities.dart';
import 'package:back_office/shared/widgets/filter.dart';
import 'package:back_office/shared/widgets/filter_field.dart';
import 'package:back_office/views/home/home_provider.dart';
import 'package:back_office/views/appointments/models/appointment_model.dart';
import 'package:back_office/views/appointments/appointments_provider.dart';
import 'package:back_office/views/appointments/widgets/appointment_actions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/foundation.dart';

class AppointmentGrid extends StatefulWidget {
  final List<List> filters;

  const AppointmentGrid({Key key, this.filters}) : super(key: key);
  @override
  _AppointmentGridState createState() => _AppointmentGridState();
}

List<AppointmentGridModel> paginatedDataSource = [];
List<AppointmentGridModel> _appointments = [];
List<AppointmentGridModel> _instance = [];
final int rowsPerPage = 20;

class _AppointmentGridState extends State<AppointmentGrid> {
  final String collection = 'appointments';
  AppointmentProvider appointmentProvider = AppointmentProvider();
  AppointmentDataSource _appointmentDataSource;
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
    _appointmentDataSource = AppointmentDataSource();
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
    double columnWidth = 156.5;
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
                      'Agendamentos',
                      style: TextStyle(
                        fontSize: 28,
                        color: Color(0xff000000),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Gestão de agendamentos e retornos',
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
                    .collection('appointments')
                    .orderBy('created_at', descending: true)
                    .snapshots(),
                builder: (context, appointmentsnap) {
                  if (!appointmentsnap.hasData) {
                    return Container(
                      height: hXD(500, context),
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    QuerySnapshot qs = appointmentsnap.data;
                    _appointments =
                        appointmentProvider.getAppointmentsGridData(qs);
                    pageCount = filtering
                        ? (_instance.length / rowsPerPage).ceilToDouble()
                        : (_appointments.length / rowsPerPage).ceilToDouble();
                    if (_appointments == null ||
                        _appointments.length == 0 ||
                        _appointments.length == null) {
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
                        child:
                            SelectableText('Sem agendamentos com esses dados'),
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
                                          ? _appointmentDataSource
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
                                              child: Text(
                                                'ID',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xff000000),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )),
                                        GridTextColumn(
                                            width: columnWidth,
                                            columnName: 'doctorId',
                                            label: Container(
                                              // padding: EdgeInsets.only(left: 15),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Id do  médico',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xff000000),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )),
                                        GridTextColumn(
                                            width: columnWidth,
                                            columnName: 'appointmentId',
                                            label: Container(
                                              height: 74,
                                              width: 121,
                                              // padding: EdgeInsets.only(left: 15),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Id do paciente',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xff000000),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )),
                                        GridTextColumn(
                                            width: columnWidth,
                                            columnName: 'patient_name',
                                            label: Container(
                                              padding:
                                                  EdgeInsets.only(left: 15),
                                              height: 74,
                                              width: 121,
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Nome do paciente',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xff000000),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )),
                                        GridTextColumn(
                                            width: columnWidth,
                                            columnName: 'date',
                                            label: Container(
                                              height: 74,
                                              width: 121,
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Data',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xff000000),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )),
                                        GridTextColumn(
                                            width: columnWidth,
                                            columnName: 'hour',
                                            label: Container(
                                              padding:
                                                  EdgeInsets.only(left: 15),
                                              height: 74,
                                              width: 121,
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Horário ou período',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xff000000),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )),
                                        GridTextColumn(
                                            width: columnWidth,
                                            columnName: 'price',
                                            label: Container(
                                              height: 74,
                                              width: 121,
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Preço',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xff000000),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )),
                                        GridTextColumn(
                                            width: columnWidth,
                                            columnName: 'status',
                                            label: Container(
                                              height: 74,
                                              width: 121,
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
                                        GridTextColumn(
                                            width: columnWidth,
                                            columnName: 'type',
                                            label: Container(
                                              height: 74,
                                              width: 121,
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
                                        GridTextColumn(
                                          width: columnWidth,
                                          columnName: 'actions',
                                          label: Container(
                                            height: 74,
                                            width: 121,
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
                                        ? _appointmentDataSource
                                        : _instanceDataSource,
                                    pageCount: !filtering
                                        ? pageCount
                                        : searchPageCount,
                                    direction: Axis.horizontal,
                                    onPageNavigationStart: (int pageIndex) {
                                      Provider.of<AppointmentProvider>(context,
                                              listen: false)
                                          .incPageView(pageIndex);
                                    },
                                    onPageNavigationEnd: (int pageIndex) {
                                      Provider.of<AppointmentProvider>(context,
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
                              child: Consumer<AppointmentProvider>(
                                builder: (context, value, child) => Text(
                                    '${value.pageView + 1} de $pageCount Páginas'),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }
                },
              )
            ],
          ),
        ),
        Positioned(
          top: 0,
          child:
              Consumer<AppointmentProvider>(builder: (context, value, child) {
            return Filter(
              open: value.open,
              onFilter: () {
                if (map.isEmpty) {
                  _instance.clear();
                  _instanceDataSource.rows.clear();
                  searchPageCount = 0;
                  filtering = false;
                } else {
                  _instance.clear();
                  _appointments.forEach((appointmentGridModel) {
                    Map<String, dynamic> appointmentMap = AppointmentModel()
                        .toJson(appointmentGridModel.appointmentModel);
                    //if(kDebugMode) print('appointmentMap: $appointmentMap');
                    bool aunContienes = true;
                    map.forEach((key, value) {
                      if (kDebugMode) print('key: $key: $value');
                      if (appointmentMap[key] != null) {
                        if (kDebugMode) print('2º key: $key: $value\n ');

                        if (key == 'date' ||
                            key == 'birthday' ||
                            key == 'created_at') {
                          Timestamp date = appointmentMap[key];
                          String dateString =
                              '${date.toDate().day.toString().padLeft(2, '0')}${date.toDate().month.toString().padLeft(2, '0')}${date.toDate().year}';
                          appointmentMap[key] = dateString;
                        }
                        if (key == 'hour' || key == 'end_hour') {
                          Timestamp hour = appointmentMap[key];
                          String hourString = hour
                                  .toDate()
                                  .hour
                                  .toString()
                                  .padLeft(2, '0') +
                              hour.toDate().minute.toString().padLeft(2, '0');
                          appointmentMap[key] = hourString;
                        }
                        if (kDebugMode)
                          print(
                              'appointmentMap[key]: ${appointmentMap[key].toString().toLowerCase()} ==  value: ${value.toLowerCase()} ???');
                        if (aunContienes) {
                          if (appointmentMap[key]
                              .toString()
                              .toLowerCase()
                              .contains(value.toString().toLowerCase())) {
                            //if(kDebugMode) print('######## contaaaaaaaaaaains ##########\n \n ');
                            if (!_instance.contains(appointmentGridModel)) {
                              //if(kDebugMode) print(
                              //     '######## ainda naaaaaaaaao contaaaaaaaaaaains ##########\n \n \n \n ');
                              _instance.add(appointmentGridModel);
                            }
                          } else {
                            aunContienes = false;
                            if (_instance.contains(appointmentGridModel)) {
                              _instance.remove(appointmentGridModel);
                            }
                          }
                        } else if (_instance.contains(appointmentGridModel)) {
                          _instance.remove(appointmentGridModel);
                        }
                      } else if (_instance.contains(appointmentGridModel)) {
                        _instance.remove(appointmentGridModel);
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
                        .map(
                          (e) => appointmentProvider.getDataGridRow(e),
                        )
                        .toList(),
                  );
                  //if(kDebugMode) print(
                  //     '_instanceDataSource.rows.length: ${_instanceDataSource.rows.length}');
                  //if(kDebugMode) print('searchPageCount: $searchPageCount');
                }
                // _instance.forEach((element) {
                //  if(kDebugMode) print(
                //       'elemento: ${AppointmentModel().toJson(element.appointmentModel)}');
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
                  typeOfVisit: [
                    'Consulta médica',
                    'Retorno médico',
                    'Reagendamento',
                    'Paciente encaixado',
                  ],
                  statuses: [
                    'Agendado',
                    'Aguardando atendimento',
                    'Não compareceu',
                    'Cancelado',
                    'Concluído',
                    'Encaixe solicitado',
                    'Encaixe recusado',
                    'Aguardando retorno'
                  ],
                  types: ['Consulta', 'Retorno', 'Encaixe'],
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
              //     title: 'Horário ou Período',
              //     collection: collection,
              //     field: 'hour',
              //     onChanged: (val) => setVal('hour', val),
              //     // mask: homeProvider.getMask('hour'),
              //   ),
              //   FilterField(
              //     title: 'Preço',
              //     collection: collection,
              //     field: 'price',
              //     onChanged: (val) => setVal('price', val),
              //   ),
              //   FilterField(
              //     title: 'Status',
              //     collection: collection,
              //     field: 'status',
              //     overlayData: [
              //       'Agendado',
              //       'Aguardando atendimento',
              //       'Não compareceu',
              //       'Cancelado',
              //       'Concluído',
              //       'Encaixe solicitado',
              //       'Encaixe recusado',
              //       'Aguardando retorno'
              //     ],
              //     onChanged: (val) => setVal('status', val),
              //   ),
              //   FilterField(
              //     title: 'Tipo',
              //     collection: collection,
              //     field: 'type',
              //     overlayData: ['Consulta', 'Retorno', 'Encaixe'],
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

class AppointmentDataSource extends DataGridSource {
  HomeProvider homeProvider = HomeProvider();
  AppointmentDataSource() {
    paginatedDataSource = [];
    buildDataGridRows();
  }

  List<DataGridRow> _appointmentData = [];
  @override
  List<DataGridRow> get rows => _appointmentData;

  setRows(appointmentData) {
    _appointmentData = appointmentData;
    notifyListeners();
  }

  refresh() {
    return Future.delayed(Duration(seconds: 1), () {
      buildDataGridRows();
      notifyListeners();
    });
  }

  @override
  Future<void> handleRefresh() {
    return Future.delayed(Duration(seconds: 3), () {
      buildDataGridRows();
      notifyListeners();
    });
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    // await Future.delayed(const Duration(seconds: 3));
    int startIndex = newPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    if (startIndex < _appointments.length) {
      if (endIndex > _appointments.length) {
        endIndex = _appointments.length;
      }
      paginatedDataSource =
          _appointments.getRange(startIndex, endIndex).toList(growable: false);
      buildDataGridRows();
    } else {
      paginatedDataSource = [];
    }
    notifyListeners();
    return true;
  }

  void buildDataGridRows() {
    _appointmentData = paginatedDataSource
        .map((e) => DataGridRow(cells: [
              DataGridCell(columnName: 'id', value: e.appointmentModel.id),
              DataGridCell(
                  columnName: 'doctorId', value: e.appointmentModel.doctorId),
              DataGridCell(
                  columnName: 'appointmentId',
                  value: e.appointmentModel.patientId),
              DataGridCell(
                  columnName: 'patient_name',
                  value: e.appointmentModel.patientName),
              DataGridCell(
                columnName: 'date',
                value: homeProvider.validateTimeStamp(
                    e.appointmentModel.date, 'date'),
              ),
              DataGridCell(
                columnName: 'hour',
                value: e.appointmentModel,
                // homeProvider.validateTimeStamp(
                //     e.appointmentModel.hour, 'hour'),
              ),
              DataGridCell(
                  columnName: 'price',
                  value:
                      homeProvider.formatedCurrency(e.appointmentModel.price)),
              DataGridCell(
                  columnName: 'status', value: e.appointmentModel.status),
              DataGridCell(columnName: 'type', value: e.appointmentModel.type),
              DataGridCell(columnName: 'actions', value: e),
            ]))
        .toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    HomeProvider homeProvider = HomeProvider();
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      switch (e.columnName) {
        case 'actions':
          return AppointmentActions(
            appointmentModel: e.value.appointmentModel,
            onDelete: () {
              buildDataGridRows();
              notifyListeners();
            },
          );
          break;
        case 'hour':
          AppointmentModel appointment = e.value;
          String hour =
              homeProvider.validateTimeStamp(appointment.hour, 'hour');
          String endHour =
              homeProvider.validateTimeStamp(appointment.endHour, 'hour');
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: SelectableText(
              '$hour às $endHour',
              enableInteractiveSelection: true,
              toolbarOptions: ToolbarOptions(selectAll: true),
              scrollPhysics: ClampingScrollPhysics(),
              maxLines: 1,
            ),
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
    paginatedDataSource = [];
    buildDataGridRows();
  }

  List<DataGridRow> _instanceData = [];
  @override
  List<DataGridRow> get rows => _instanceData;

  setRows(appointmentData) {
    int maxRange = rowsPerPage;
    if (_instance.length < rowsPerPage) {
      maxRange = _instance.length;
    }
    paginatedDataSource =
        _instance.getRange(0, maxRange).toList(growable: false);
    buildDataGridRows();
    // _instanceData = appointmentData;
    notifyListeners();
  }

  refresh() {
    return Future.delayed(Duration(seconds: 1), () {
      buildDataGridRows();
      notifyListeners();
    });
  }

  @override
  Future<void> handleRefresh() {
    return Future.delayed(Duration(seconds: 3), () {
      buildDataGridRows();
      notifyListeners();
    });
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
              DataGridCell(columnName: 'id', value: e.appointmentModel.id),
              DataGridCell(
                  columnName: 'doctorId', value: e.appointmentModel.doctorId),
              DataGridCell(
                  columnName: 'appointmentId',
                  value: e.appointmentModel.patientId),
              DataGridCell(
                  columnName: 'patient_name',
                  value: e.appointmentModel.patientName),
              DataGridCell(
                columnName: 'date',
                value: homeProvider.validateTimeStamp(
                    e.appointmentModel.date, 'date'),
              ),
              DataGridCell(
                columnName: 'hour',
                value: e.appointmentModel,
                // homeProvider.validateTimeStamp(
                //     e.appointmentModel.hour, 'hour'),
              ),
              DataGridCell(
                  columnName: 'price',
                  value:
                      homeProvider.formatedCurrency(e.appointmentModel.price)),
              DataGridCell(
                  columnName: 'status', value: e.appointmentModel.status),
              DataGridCell(columnName: 'type', value: e.appointmentModel.type),
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
          return AppointmentActions(
            appointmentModel: e.value.appointmentModel,
            onDelete: () {
              buildDataGridRows();
              notifyListeners();
            },
          );
          break;
        case 'hour':
          AppointmentModel appointment = e.value;
          String hour =
              homeProvider.validateTimeStamp(appointment.hour, 'hour');
          String endHour =
              homeProvider.validateTimeStamp(appointment.endHour, 'hour');
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: SelectableText(
              '$hour às $endHour',
              enableInteractiveSelection: true,
              toolbarOptions: ToolbarOptions(selectAll: true),
              scrollPhysics: ClampingScrollPhysics(),
              maxLines: 1,
            ),
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
