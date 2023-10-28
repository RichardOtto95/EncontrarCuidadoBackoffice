import 'package:back_office/views/ratings/widgets/rating_data.dart';
import 'package:back_office/views/ratings/widgets/rating_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'rating_provider.dart';
import 'models/rating_data_model.dart';
import 'models/rating_model.dart';

class Ratings extends StatefulWidget {
  @override
  _RatingsState createState() => _RatingsState();
}

class _RatingsState extends State<Ratings> {
  int ratingPage = 1;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<RatingProvider>(
        builder: (context, value, child) {
          return SingleChildScrollView(
            physics: ScrollPhysics(),
            child: getRatingPage(
                ratingPage: value.ratingPage, ratingModel: value.ratingModel),
          );
        },
      ),
    );
  }

  Widget getRatingPage({int ratingPage, RatingModel ratingModel}) {
    switch (ratingPage) {
      case 1:
        return RatingGrid(filters: getRatingFilters());
        break;
      case 2:
        return RatingData(
          ratingModel: ratingModel,
          dataTestModel: getRatingData(
            'Detalhes da avaliação',
            RatingModel().toJson(ratingModel),
            false,
          ),
        );
        break;
      case 3:
        return RatingData(
          ratingModel: ratingModel,
          dataTestModel: getRatingData(
            'Detalhes da avaliação',
            RatingModel().toJson(ratingModel),
            true,
          ),
        );
        break;
      default:
        return Padding(
          padding: EdgeInsets.only(top: 50),
          child: Text('Algo de errado nessa navegação'),
        );
    }
  }
}
