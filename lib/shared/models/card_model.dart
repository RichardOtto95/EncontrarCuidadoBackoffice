import 'package:flutter/material.dart';

class CardModel {
  final IconData icon;
  final String title, type;
  final Color primaryColor;
  final Color secondaryColor;
  final int page;

  CardModel(
      {this.icon,
      this.page,
      this.title,
      this.primaryColor,
      this.secondaryColor,
      this.type});
}
