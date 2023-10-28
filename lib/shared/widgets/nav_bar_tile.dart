import 'package:back_office/shared/utilities.dart';
import 'package:back_office/views/home/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavBarTile extends StatelessWidget {
  final int page;
  final String title;
  final IconData icon;

  const NavBarTile({
    Key key,
    this.page,
    this.title,
    this.icon,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xff212122),
      child: InkWell(
        hoverColor: Color(0xff131212),
        onTap: () {
          Provider.of<HomeProvider>(context, listen: false).incPage(page);
        },
        child: Consumer<HomeProvider>(
          builder: (context, value, child) {
            bool inPage = value.page == page;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: wXD(22, context)),
              height: hXD(43, context),
              color: inPage ? Color(0xff131212) : Colors.transparent,
              alignment: Alignment.center,
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 25,
                    color: Color(0xff707070),
                  ),
                  SizedBox(
                    width: wXD(11, context),
                  ),
                  Text(
                    '$title',
                    style: TextStyle(
                      color: Color(0xffaeaeae),
                      fontSize: hXD(12, context),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.keyboard_arrow_right_rounded,
                    size: wXD(13, context),
                    color: Color(0xff707070),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class BackTile extends StatelessWidget {
  final Function onTap;
  final String title;
  final IconData icon;
  final bool inPage;

  const BackTile({
    Key key,
    this.onTap,
    this.title,
    this.icon,
    this.inPage = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xff212122),
      child: InkWell(
        hoverColor: Color(0xff131212),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: wXD(22, context)),
          height: hXD(43, context),
          color: inPage ? Color(0xff131212) : Colors.transparent,
          alignment: Alignment.center,
          child: Row(
            children: [
              Icon(
                icon,
                size: wXD(18, context),
                color: Color(0xff707070),
              ),
              SizedBox(
                width: wXD(11, context),
              ),
              Text(
                '$title',
                style: TextStyle(
                  color: Color(0xffaeaeae),
                  fontSize: hXD(12, context),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              Icon(
                Icons.keyboard_arrow_right_rounded,
                size: wXD(13, context),
                color: Color(0xff707070),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
