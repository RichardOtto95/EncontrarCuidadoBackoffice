import 'package:back_office/views/home/home_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'models/post_model.dart';

class PostProvider extends ChangeNotifier {
  int _postPage = 1;

  int get postPage => _postPage;

  incPostPage(postPage) {
    _postPage = postPage;
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

  PostModel _postModel = PostModel();

  PostModel get postModel => _postModel;

  incpostModel(postModel) {
    _postModel = postModel;
    notifyListeners();
  }

  List<PostGridModel> getPostsGridData(QuerySnapshot qs) {
    HomeProvider provider = HomeProvider();
    List<PostGridModel> postsGrid = [];
    //if(kDebugMode) print('qsqsqsqsqsqs: $qs');

    qs.docs.forEach((post) {
      //if(kDebugMode) print('pooooooooooost: ${post.data()}');
      PostModel postModel = PostModel.fromDocument(post.data());
      postModel.status = provider.getPortugueseStatus(postModel.status);
      //if(kDebugMode) print('postModel: $postModel');
      PostGridModel postGridModel = PostGridModel(false, postModel);
      //if(kDebugMode) print('postGridModel: $postGridModel');
      postsGrid.add(postGridModel);
      //if(kDebugMode) print('postsGrid: $postsGrid');
    });
    return postsGrid;
  }

  DataGridRow getDataGridRow(PostGridModel e) {
    HomeProvider homeProvider = HomeProvider();
    return DataGridRow(cells: [
      DataGridCell(columnName: 'id', value: e.postModel.id),
      DataGridCell(columnName: 'doctorId', value: e.postModel.doctorId),
      DataGridCell(
        columnName: 'date',
        value:
            homeProvider.validateTimeStamp(e.postModel.createdAt, 'created_at'),
      ),
      DataGridCell(columnName: 'text', value: e.postModel.text),
      DataGridCell(columnName: 'status', value: e.postModel.status),
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
