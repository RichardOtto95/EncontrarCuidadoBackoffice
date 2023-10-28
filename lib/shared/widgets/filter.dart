import 'package:back_office/shared/utilities.dart';
import 'package:flutter/material.dart';

import 'blue_button.dart';
import 'data_button.dart';

class Filter extends StatelessWidget {
  final Function onView, onFilter;
  final bool open;
  final List<Widget> children;

  const Filter({
    Key key,
    this.onView,
    this.open = false,
    this.children,
    this.onFilter,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (a) =>
          FocusScope.of(context).requestFocus(new FocusNode()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            children: [
              AnimatedContainer(
                padding: EdgeInsets.only(bottom: 25),
                duration: Duration(milliseconds: 300),
                curve: Curves.ease,
                height: open ? hXD(600, context) : 0,
                width: wXD(1072, context),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color(0xff707070).withOpacity(.4),
                    ),
                  ),
                  color: Color(0xfffafafa),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 3,
                      offset: Offset(0, 3),
                      color: Color(0x30000000),
                    ),
                  ],
                ),
                child: FilterFields(children: children),
              ),
              Positioned(
                bottom: 30,
                right: 50,
                child: BlueButton(
                  text: 'Filtrar',
                  onTap: onFilter,
                ),
              ),
              // Positioned(
              //   bottom: 30,
              //   left: 50,
              //   child: BlueButton(
              //     text: 'Limpar',
              //     onTap: onClean,
              //   ),
              // ),
            ],
          ),
          DataButton(
            onTap: onView,
            open: open,
          ),
        ],
      ),
    );
  }
}

class FilterFields extends StatelessWidget {
  final List<Widget> children;

  const FilterFields({
    Key key,
    this.children,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 14,
          child: SingleChildScrollView(
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }
}
