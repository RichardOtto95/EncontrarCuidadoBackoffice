import 'package:back_office/shared/utilities.dart';
import 'package:back_office/views/admins/admins_provider.dart';
import 'package:back_office/views/admins/models/admin_model.dart';
import 'package:back_office/views/admins/widgets/admin_actions.dart';
import 'package:back_office/views/home/home_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter/foundation.dart';

import 'package:syncfusion_flutter_core/theme.dart';

class AdminGrid extends StatefulWidget {
  @override
  _AdminGridState createState() => _AdminGridState();
}

List<AdminGridModel> paginatedDataSource = [];
List<AdminGridModel> _admins = [];
final int rowsPerPage = 1000;

class _AdminGridState extends State<AdminGrid> {
  AdminProvider adminProvider = AdminProvider();
  AdminDataGridSource _adminDataGridSource;
  // InstanceDataGridSource _instanceDataGridSource;
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
    // _instanceDataGridSource = InstanceDataGridSource();
    _adminDataGridSource = AdminDataGridSource();
  }

  // bool open = false;
  // Map<String, String> map = {};

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
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
                      padding: EdgeInsets.fromLTRB(wXD(45, context),
                          hXD(23, context), 0, hXD(20, context)),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Admins',
                            style: TextStyle(
                              fontSize: 28,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Gestão de administradores',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff707070),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder(
                      future:
                          FirebaseFirestore.instance.collection('admins').get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            height: hXD(500, context),
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          QuerySnapshot qs = snapshot.data;

                          // List<AdminGridModel> adminsGrid = [];

                          qs.docs.forEach((admin) {
                            AdminModel adminModel =
                                AdminModel.fromDocument(admin.data());

                            if (kDebugMode) print(admin.data());
                            AdminGridModel adminGridModel =
                                AdminGridModel(false, adminModel);

                            _admins.add(adminGridModel);
                          });
                          if (kDebugMode)
                            print(
                                'qs=========================================: $qs');
                          _admins = adminProvider.getAdmingridData(qs);
                          pageCount =
                              (_admins.length / rowsPerPage).ceilToDouble();
                          if (kDebugMode)
                            print(
                                '_admins tela=========================================: $_admins');
                          if (_admins == null ||
                              _admins.length == 0 ||
                              _admins.length == null) {
                            return Container(
                              height: hXD(500, context),
                              alignment: Alignment.center,
                              child: SelectableText(
                                  'Sem dados no banco para serem apresentados'),
                            );
                          } else {
                            return Column(
                              children: [
                                Center(
                                    child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(32, 35, 32, 0),
                                        height: hXD(540, context),
                                        child: SfDataGrid(
                                            isScrollbarAlwaysShown: true,
                                            controller: _dataGridController,
                                            headerGridLinesVisibility:
                                                GridLinesVisibility.both,
                                            gridLinesVisibility:
                                                GridLinesVisibility.both,
                                            source: _adminDataGridSource,
                                            headerRowHeight: 40,
                                            defaultColumnWidth: 200,
                                            rowHeight: 60,
                                            selectionMode:
                                                SelectionMode.multiple,
                                            columns: [
                                              GridTextColumn(
                                                  width: 200,
                                                  columnName: 'username',
                                                  label: Container(
                                                      padding: EdgeInsets.only(
                                                          left: 15),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                          'Nome de usuário',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xff000000),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          )))),
                                              GridTextColumn(
                                                  width: 200,
                                                  columnName: 'role',
                                                  label: Container(
                                                      height: 60,
                                                      width: 200,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                          'Nivel de acesso',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xff000000),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          )))),
                                              GridTextColumn(
                                                  width: 200,
                                                  columnName: 'phone',
                                                  label: Container(
                                                      height: 60,
                                                      width: 20,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text('Telefone',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xff000000),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          )))),
                                            ]))),
                                Container(
                                  height: 70,
                                  child: SfDataPagerTheme(
                                      data: SfDataPagerThemeData(
                                        backgroundColor: Color(0xfffafafa),
                                        itemBorderRadius: BorderRadius.all(
                                            Radius.circular(6)),
                                        disabledItemColor:
                                            Color(0xff707070).withOpacity(.3),
                                        itemColor: Color(0xfffafafa),
                                        selectedItemColor: Color(0xff707070),
                                        selectedItemTextStyle: TextStyle(
                                            color: Color(0xff000000),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                        itemTextStyle: TextStyle(
                                            color: Color(0xff000000),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      ),
                                      child: SfDataPager(
                                        visibleItemsCount: pageCount.toInt(),
                                        controller: _dataPagerController,
                                        delegate: _adminDataGridSource,
                                        pageCount: pageCount,
                                        direction: Axis.horizontal,
                                        onPageNavigationStart:
                                            (int pageIndex) {},
                                        onPageNavigationEnd: (int pageIndex) {
                                          _dataGridController
                                              .scrollToVerticalOffset(0);
                                        },
                                      )),
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
                right: 70,
                bottom: 40,
                child: Container(
                  width: 190,
                  height: 50,
                  color: Color(0xfffafafa),
                  alignment: Alignment.center,
                  child: Consumer<AdminProvider>(
                    builder: (context, value, child) => Text(value.pageCount ==
                            0
                        ? '${value.pageView + 1} de 1 Páginas'
                        : '${value.pageView + 1} de ${value.pageCount} Páginas'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      alignment: Alignment.topCenter,
    );
  }
}

class AdminDataGridSource extends DataGridSource {
  HomeProvider homeProvider = HomeProvider();
  AdminDataGridSource() {
    paginatedDataSource = [];
    buildDataGridRows();
    if (kDebugMode)
      print('_adminData pos =============================: $_adminData');
  }
  // void initState() {
  //   AdminDataGridSource();
  // }

  List<DataGridRow> _adminData = [];
  List<DataGridRow> get rows => _adminData;
  setRows(adminData) {
    _adminData = adminData;
    if (kDebugMode)
      print(
          '_adminData_adminData_adminData_adminData_adminData ******************************** ROWROW $_adminData');

    notifyListeners();
  }

  refresh() {
    return Future.delayed(Duration(seconds: 1), () {
      notifyListeners();
    });
  }

  // setPaginated() {
  //   paginatedDataSource = _admins;
  // }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    int startIndex = newPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    if (startIndex < _admins.length) {
      if (endIndex > _admins.length) {
        endIndex = _admins.length;
      }
      if (kDebugMode)
        print(
            '_admins  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&: $_admins');

      paginatedDataSource =
          _admins.getRange(startIndex, endIndex).toList(growable: false);
      buildDataGridRows();
    } else {
      paginatedDataSource = [];
    }
    notifyListeners();
    return true;
  }

  void buildDataGridRows() {
    if (kDebugMode)
      print(
          'paginatedDataSource funcfunc *************************8 $paginatedDataSource');

    _adminData = paginatedDataSource
        .map((e) => DataGridRow(cells: [
              DataGridCell(
                  columnName: 'username', value: e.adminModel.username),
              DataGridCell(columnName: 'role', value: e.adminModel.role),
              DataGridCell(columnName: 'phone', value: e.adminModel.phone),
            ]))
        .toList();
    if (kDebugMode)
      print('_adminData funcfunc *************************8 $_adminData');
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      switch (e.columnName) {
        case 'actions':
          return AdminActions(
            adminModel: e.value.adminModel,
            onDelete: () {
              buildDataGridRows();
              notifyListeners();
            },
          );
          break;
        case 'role':
          String value = e.value.toString();
          if (value == 'null') {
            value = '- - -';
          }
          if (value == 'SUPPORT') {
            value = 'Suporte';
          } else if (value == 'ADMIN') {
            value = 'Administrador';
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
          break;
        default:
          String value = e.value.toString();
          if (value == 'null') {
            value = '- - -';
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
