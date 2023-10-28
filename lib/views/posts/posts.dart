import 'package:back_office/views/posts/widgets/post_data.dart';
import 'package:back_office/views/posts/widgets/post_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'post_provider.dart';
import 'models/post_data_model.dart';
import 'models/post_model.dart';

class Posts extends StatefulWidget {
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  int postPage = 1;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<PostProvider>(
        builder: (context, value, child) {
          return SingleChildScrollView(
            physics: ScrollPhysics(),
            child: getPostPage(
                postPage: value.postPage, postModel: value.postModel),
          );
        },
      ),
    );
  }

  Widget getPostPage({int postPage, PostModel postModel}) {
    switch (postPage) {
      case 1:
        return PostGrid(filters: getPostFilters());
        break;
      case 2:
        return PostData(
          postModel: postModel,
          dataTestModel: getPostData(
            'Detalhes da postagem',
            PostModel().toJson(postModel),
            false,
          ),
        );
        break;
      case 3:
        return PostData(
            postModel: postModel,
            dataTestModel: getPostData(
              'Editar dados da postagem',
              PostModel().toJson(postModel),
              true,
            ));
        break;
      default:
        return Padding(
          padding: EdgeInsets.only(top: 50),
          child: Text('Algo de errado nessa navegação'),
        );
    }
  }
}
