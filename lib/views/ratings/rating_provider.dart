import 'package:back_office/views/home/home_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'models/rating_model.dart';

class RatingProvider extends ChangeNotifier {
  int _ratingPage = 1;

  int get ratingPage => _ratingPage;

  incRatingPage(ratingPage) {
    _ratingPage = ratingPage;
    notifyListeners();
  }

  int _pageView = 0;

  int get pageView => _pageView;

  incPageView(pageView) {
    _pageView = pageView;
    notifyListeners();
  }

  int _pageCount = 0;

  int get pageCount => _pageCount;

  incPageCount(pageCount) {
    _pageCount = pageCount;
    notifyListeners();
  }

  RatingModel _ratingModel = RatingModel();

  RatingModel get ratingModel => _ratingModel;

  incratingModel(ratingModel) {
    _ratingModel = ratingModel;
    notifyListeners();
  }

  List<RatingGridModel> getRatingsGridData(QuerySnapshot qs) {
    HomeProvider provider = HomeProvider();
    List<RatingGridModel> ratingsGrid = [];
    //if(kDebugMode) print('qsqsqsqsqsqs: $qs');

    qs.docs.forEach((rating) {
      //if(kDebugMode) print('paaaaaatient: $rating');
      RatingModel ratingModel = RatingModel.fromDocument(rating);
      ratingModel.status =
          provider.getPortugueseStatus(ratingModel.status, module: 'ratings');
      //if(kDebugMode) print('ratingModel: $ratingModel');
      RatingGridModel ratingGridModel = RatingGridModel(false, ratingModel);
      //if(kDebugMode) print('ratingGridModel: $ratingGridModel');
      ratingsGrid.add(ratingGridModel);
      //if(kDebugMode) print('ratingsGrid: $ratingsGrid');
    });
    return ratingsGrid;
  }

  DataGridRow getDataGridRow(RatingGridModel e) {
    HomeProvider homeProvider = HomeProvider();
    return DataGridRow(cells: [
      DataGridCell(columnName: 'id', value: e.ratingModel.id),
      DataGridCell(columnName: 'doctorId', value: e.ratingModel.doctorId),
      DataGridCell(columnName: 'patientId', value: e.ratingModel.patientId),
      DataGridCell(
        columnName: 'date',
        value: homeProvider.validateTimeStamp(
            e.ratingModel.createdAt, 'created_at'),
      ),
      DataGridCell(columnName: 'avaliation', value: e.ratingModel.avaliation),
      DataGridCell(columnName: 'text', value: e.ratingModel.text),
      DataGridCell(columnName: 'status', value: e.ratingModel.status),
      DataGridCell(columnName: 'actions', value: e),
    ]);
  }

  bool _open = false;
  bool get open => _open;
  setOpen(open) {
    _open = open;
    notifyListeners();
  }
}
