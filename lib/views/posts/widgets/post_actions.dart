import 'package:back_office/views/posts/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../post_provider.dart';

class PostActions extends StatelessWidget {
  final Function onView, onEdit, onDelete;
  final PostModel postModel;

  const PostActions({
    Key key,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.postModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(),
        IconButton(
          onPressed: () {
            Provider.of<PostProvider>(context, listen: false).incPostPage(2);
            Provider.of<PostProvider>(context, listen: false)
                .incpostModel(postModel);
          },
          icon: Icon(Icons.remove_red_eye, size: 22, color: Color(0xff707070)),
        ),
        Spacer(),
        IconButton(
          onPressed: () {
            Provider.of<PostProvider>(context, listen: false).incPostPage(3);
            Provider.of<PostProvider>(context, listen: false)
                .incpostModel(postModel);
          },
          icon: Icon(Icons.edit, size: 22, color: Color(0xff707070)),
        ),
        Spacer(),
        // IconButton(
        //   onPressed: () => showDialog(            useRootNavigator: true,

        //     context: context,
        //     barrierDismissible: true,
        //     builder: (context) {
        //       return DialogWidget(
        //         title: 'Tem certeza que deseja excluir esta postagem?',
        //       );
        //     },
        //   ),
        //   icon: Icon(Icons.delete, size: 22, color: Color(0xff707070)),
        // ),
        // Spacer(),
      ],
    );
  }
}
