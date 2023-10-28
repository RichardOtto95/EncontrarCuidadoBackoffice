import 'package:back_office/views/ratings/models/rating_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../rating_provider.dart';

class RatingActions extends StatelessWidget {
  final Function onView, onEdit, onDelete;
  final RatingModel ratingModel;

  const RatingActions({
    Key key,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.ratingModel,
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
            Provider.of<RatingProvider>(context, listen: false)
                .incRatingPage(2);
            Provider.of<RatingProvider>(context, listen: false)
                .incratingModel(ratingModel);
          },
          icon: Icon(Icons.remove_red_eye, size: 22, color: Color(0xff707070)),
        ),
        Spacer(),
        IconButton(
          onPressed: () {
            Provider.of<RatingProvider>(context, listen: false)
                .incRatingPage(3);
            Provider.of<RatingProvider>(context, listen: false)
                .incratingModel(ratingModel);
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
        //         title: 'Tem certeza que deseja excluir esta avaliação?',
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
