import 'package:back_office/shared/grid_scroll_behavior.dart';
import 'package:back_office/shared/utilities.dart';
import 'package:back_office/shared/widgets/filter.dart';
import 'package:back_office/shared/widgets/filter_field.dart';
import 'package:back_office/views/home/home_provider.dart';
import 'package:back_office/views/posts/models/post_model.dart';
import 'package:back_office/views/posts/post_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/foundation.dart';

import 'post_actions.dart';

class PostGrid extends StatefulWidget {
  final List<List> filters;

  const PostGrid({Key key, this.filters}) : super(key: key);
  @override
  _PostGridState createState() => _PostGridState();
}

List<PostGridModel> paginatedDataSource = [];
List<PostGridModel> _instance = [];
List<PostGridModel> _posts = [];
final int rowsPerPage = 20;

class _PostGridState extends State<PostGrid> {
  final String collection = 'posts';
  PostProvider postProvider = PostProvider();
  PostDataSource _postDataSource;
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
    _postDataSource = PostDataSource();
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
    //if(kDebugMode) print('instance.length: ${_instance.length}');

    double gridWidth = 235.083;
    return Stack(
      children: [
        Container(
          width: wXD(983, context),
          margin: EdgeInsets.symmetric(
              horizontal: wXD(48, context), vertical: hXD(32, context)),
          decoration: BoxDecoration(
              color: Color(0xfffafafa),
              borderRadius: BorderRadius.all(Radius.circular(8))),
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
                      'Postagens',
                      style: TextStyle(
                        fontSize: 28,
                        color: Color(0xff000000),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Gestão de postagens',
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
                    .collection('posts')
                    .orderBy('created_at', descending: true)
                    .snapshots(),
                builder: (context, postsSnap) {
                  if (!postsSnap.hasData) {
                    return Container(
                      height: hXD(500, context),
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    QuerySnapshot qs = postsSnap.data;
                    _posts = postProvider.getPostsGridData(qs);
                    pageCount = filtering
                        ? (_instance.length / rowsPerPage).ceilToDouble()
                        : (_posts.length / rowsPerPage).ceilToDouble();
                    if (kDebugMode) print("pageCount: $pageCount");
                    if (_posts == null ||
                        _posts.length == 0 ||
                        _posts.length == null) {
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
                        child: SelectableText('Sem postagens com esses dados'),
                      );
                    } else {
                      return Stack(
                        children: [
                          Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 39,
                                  ),
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
                                            ? _postDataSource
                                            : _instanceDataSource,
                                        headerRowHeight: 60,
                                        defaultColumnWidth: 114,
                                        rowHeight: 74,
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
                                                        color:
                                                            Color(0xff000000),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      )))),
                                          GridTextColumn(
                                              width: gridWidth,
                                              columnName: 'doctorId',
                                              label: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15),
                                                  alignment: Alignment.center,
                                                  child: Text('Id do  médico',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            Color(0xff000000),
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                                        color:
                                                            Color(0xff000000),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      )))),
                                          GridTextColumn(
                                              width: gridWidth,
                                              columnName: 'likes',
                                              label: Container(
                                                  height: 74,
                                                  width: gridWidth,
                                                  alignment: Alignment.center,
                                                  child: Text('Curtidas',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            Color(0xff000000),
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                                        color:
                                                            Color(0xff000000),
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                                        color:
                                                            Color(0xff000000),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ))))
                                        ]),
                                  )),
                              Container(
                                height: 50,
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
                                        ? _postDataSource
                                        : _instanceDataSource,
                                    pageCount: !filtering
                                        ? pageCount
                                        : searchPageCount,
                                    direction: Axis.horizontal,
                                    onPageNavigationStart: (int pageIndex) {
                                      Provider.of<PostProvider>(context,
                                              listen: false)
                                          .incPageView(pageIndex);
                                    },
                                    onPageNavigationEnd: (int pageIndex) {
                                      Provider.of<PostProvider>(context,
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
                                  child: Consumer<PostProvider>(
                                    builder: (context, value, child) => Text(
                                        '${value.pageView + 1} de $pageCount Páginas'),
                                  ))),
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
          top: 0,
          child: Consumer<PostProvider>(builder: (context, value, child) {
            return Filter(
              open: value.open,
              onFilter: () async {
                if (map.isEmpty) {
                  _instance.clear();
                  _instanceDataSource.rows.clear();
                  searchPageCount = 0;
                  filtering = false;
                } else {
                  _dataPagerController.firstPage();
                  _instance.clear();
                  _posts.forEach((postGridModel) {
                    Map<String, dynamic> postMap =
                        PostModel().toJson(postGridModel.postModel);
                    //if(kDebugMode) print('postMap: $postMap');
                    bool aunContienes = true;
                    map.forEach((key, value) {
                      //if(kDebugMode) print('key: $key: $value');
                      if (postMap[key] != null) {
                        //if(kDebugMode) print('2º key: $key: $value\n ');

                        if (key == 'date' ||
                            key == 'birthday' ||
                            key == 'created_at') {
                          Timestamp date = postMap[key];
                          String dateString =
                              '${date.toDate().day.toString().padLeft(2, '0')}${date.toDate().month.toString().padLeft(2, '0')}${date.toDate().year}';
                          postMap[key] = dateString;
                        }
                        if (key == 'hour') {
                          Timestamp hour = postMap[key];
                          String hourString = hour
                                  .toDate()
                                  .hour
                                  .toString()
                                  .padLeft(2, '0') +
                              hour.toDate().minute.toString().padLeft(2, '0');
                          postMap[key] = hourString;
                        }
                        if (aunContienes) {
                          if (kDebugMode)
                            print(
                                'postMap[key]: ${postMap[key].toString().toLowerCase()} ==  value: ${value.toLowerCase()} ??? ${postMap[key].toString().toLowerCase().contains(value.toString().toLowerCase())}');
                          if (postMap[key]
                              .toString()
                              .toLowerCase()
                              .contains(value.toString().toLowerCase())) {
                            //if(kDebugMode) print('######## contaaaaaaaaaaains ##########\n \n ');
                            if (!_instance.contains(postGridModel)) {
                              //if(kDebugMode) print(
                              //     '######## ainda naaaaaaaaao contaaaaaaaaaaains ##########\n \n \n \n ');
                              _instance.add(postGridModel);
                            }
                          } else {
                            aunContienes = false;
                            if (_instance.contains(postGridModel)) {
                              _instance.remove(postGridModel);
                            }
                          }
                        } else {
                          aunContienes = false;
                          if (_instance.contains(postGridModel)) {
                            _instance.remove(postGridModel);
                          }
                        }
                      } else {
                        aunContienes = false;
                        if (_instance.contains(postGridModel)) {
                          _instance.remove(postGridModel);
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
                    //if(kDebugMode) print('_instance.length ${_instance.length}');
                    //if(kDebugMode) print('map.isEmpty ${map.isEmpty}');
                    //if(kDebugMode) print('searchpagecount $searchPageCount');
                  }
                  //if(kDebugMode) print('searchPageCount: $searchPageCount');
                  _instanceDataSource.setRows(
                    _instance
                        .map(
                          (e) => postProvider.getDataGridRow(e),
                        )
                        .toList(),
                  );
                  // await _instanceDataSource.handlePageChange(0, 0);
                  //if(kDebugMode) print(
                  //     '_instanceDataSource.rows.length: ${_instanceDataSource.rows.length}');
                  //if(kDebugMode) print('searchPageCount: $searchPageCount');
                }
                // _instance.forEach((element) {
                //  if(kDebugMode) print(
                //       'elemento: ${PostModel().toJson(element.postModel)}');
                // });

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
                  statuses: ['Visível', 'Reportada', 'Inativo'],
                  title: title,
                  collection: collection,
                  field: field,
                  onChanged: (val) => setVal(valChange, val),
                );
              }),
              //  [
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
              //     onChanged: (val) => setVal('dr_id', val),
              //   ),
              //   FilterField(
              //     title: 'Data',
              //     collection: collection,
              //     field: 'date',
              //     onChanged: (val) => setVal('date', val),
              //     // mask: homeProvider.getMask('date'),
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
              //     // overlayData: ['Reportada', 'Visível', 'Excluída'],
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

class PostDataSource extends DataGridSource {
  HomeProvider homeProvider = HomeProvider();
  PostDataSource() {
    paginatedDataSource = [];
    buildDataGridRows();
  }

  List<DataGridRow> _postData = [];
  @override
  List<DataGridRow> get rows => _postData;
  setRows(postData) {
    _postData = postData;
    notifyListeners();
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    int startIndex = newPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    if (startIndex < _posts.length) {
      if (endIndex > _posts.length) {
        endIndex = _posts.length;
      }
      paginatedDataSource =
          _posts.getRange(startIndex, endIndex).toList(growable: false);
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
    _postData = paginatedDataSource
        .map((e) => DataGridRow(cells: [
              DataGridCell(columnName: 'id', value: e.postModel.id),
              DataGridCell(columnName: 'doctorId', value: e.postModel.doctorId),
              DataGridCell(
                columnName: 'date',
                value: homeProvider.validateTimeStamp(
                    e.postModel.createdAt, 'date'),
              ),
              DataGridCell(columnName: 'likes', value: e.postModel.likeCount),
              DataGridCell(columnName: 'status', value: e.postModel.status),
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
          return PostActions(postModel: e.value.postModel);
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

  setRows(postData) {
    int maxRange = rowsPerPage;
    if (_instance.length < rowsPerPage) {
      maxRange = _instance.length;
    }
    paginatedDataSource =
        _instance.getRange(0, maxRange).toList(growable: false);
    buildDataGridRows();
    // _instanceData = postData;
    notifyListeners();
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    if (kDebugMode)
      print('oldPageIndex: $oldPageIndex newPageIndex :$newPageIndex');
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
              DataGridCell(columnName: 'id', value: e.postModel.id),
              DataGridCell(columnName: 'doctorId', value: e.postModel.doctorId),
              DataGridCell(
                columnName: 'date',
                value: homeProvider.validateTimeStamp(
                    e.postModel.createdAt, 'date'),
              ),
              DataGridCell(columnName: 'likes', value: e.postModel.likeCount),
              DataGridCell(columnName: 'status', value: e.postModel.status),
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
          return PostActions(postModel: e.value.postModel);
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
