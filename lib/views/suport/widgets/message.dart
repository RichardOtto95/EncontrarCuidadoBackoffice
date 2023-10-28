import 'package:back_office/shared/models/time_model.dart';
import 'package:back_office/shared/utilities.dart';
import 'package:back_office/views/suport/models/chat_model.dart';
import 'package:back_office/views/suport/models/message_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/foundation.dart';

import 'hero_pages.dart';

class Message extends StatefulWidget {
  final MessageModel messageModel;
  final ChatModel chatModel;
  final String userId;
  final String userName;
  final String supportAvatar;
  final String userAvatar;

  const Message(
      {this.messageModel,
      this.userId,
      this.chatModel,
      this.userName,
      this.supportAvatar,
      this.userAvatar});

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    html.AnchorElement anchorElement =
        new html.AnchorElement(href: widget.messageModel.data);

    anchorElement.download = widget.messageModel.data;

    if (widget.messageModel.author == widget.userId) {
      return widget.messageModel.text != null &&
              widget.messageModel.image == null &&
              widget.messageModel.file == null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 300,
                  margin: EdgeInsets.fromLTRB(0, 30, 20, 18),
                  padding: EdgeInsets.fromLTRB(13, 17, 13, 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(5),
                    ),
                    color: Color(0xffEFEFEF),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 7),
                            width: 192,
                            child: SelectableText(
                              'Suporte',
                              enableInteractiveSelection: true,
                              showCursor: true,
                              scrollPhysics: ScrollPhysics(),
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff272D3B),
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            alignment: Alignment.centerRight,
                            width: 40,
                            child: Text(
                              TimeModel().hour(widget.messageModel.createdAt),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff272D3B).withOpacity(.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${widget.messageModel.text}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff272D3B),
                          ),
                          // textAlign: TextAlign.justify
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 15),
                  child: CircleAvatar(
                    radius: 27,
                    backgroundImage: widget.supportAvatar == null ||
                            widget.supportAvatar == ''
                        ? AssetImage('assets/img/defaultUser.png')
                        : NetworkImage(widget.supportAvatar),
                  ),
                ),
              ],
            )
          : widget.messageModel.file != null &&
                  widget.messageModel.text == null &&
                  widget.messageModel.image == null
              ? Container(
                  margin: EdgeInsets.only(
                      // bottom: wXD(16, context),
                      // left: wXD(44, context),
                      // right: wXD(16, context),
                      ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: wXD(180, context),
                        width: 300,
                        margin: EdgeInsets.fromLTRB(0, 30, 20, 20),
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        decoration: BoxDecoration(
                          color: Color(0xffEFEFEF),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                // left: wXD(5, context),
                                // top: wXD(5, context),
                                // right: wXD(5, context),
                                bottom: wXD(1, context),
                              ),
                              child: Container(
                                width: 300,
                                child: Column(
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        if (kDebugMode)
                                          print('haha 1  $anchorElement');
                                        html.window.open(
                                            anchorElement.toString(),
                                            'new tab');
                                        // anchorElement.click();
                                        // OpenFile.open(localPath);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                              topRight: Radius.circular(25)),
                                          color: Color(0xffFFFFFF),
                                        ),
                                        height: 120,
                                        width: 300,
                                        child: Center(
                                          child: Image.asset(
                                            'assets/img/${widget.messageModel.extension.toLowerCase()}.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: wXD(5, context)),
                                    Row(
                                      children: [
                                        Spacer(
                                          flex: 1,
                                        ),
                                        InkWell(
                                            onTap: () async {
                                              if (kDebugMode) print('haha 2');
                                              html.window.open(
                                                  anchorElement.toString(),
                                                  'new tab');
                                              // anchorElement.click();
                                            },
                                            child: Icon(
                                              Icons
                                                  .download_for_offline_outlined,
                                              color: Color(0xff272D3B),
                                              size: wXD(30, context),
                                            )),
                                        Spacer(
                                          flex: 2,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .16,
                                          child: Text(
                                            widget.messageModel.file,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: Color(0xff272D3B),
                                                fontSize: wXD(14, context),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Spacer(
                                          flex: 2,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              margin: EdgeInsets.only(
                                right: wXD(17, context),
                                bottom: wXD(4, context),
                              ),
                              child: Text(
                                TimeModel().hour(widget.messageModel.createdAt),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff272D3B).withOpacity(.5),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   width: wXD(11, context),
                      // ),
                      Container(
                        padding: EdgeInsets.only(right: 15),
                        child: CircleAvatar(
                          radius: 27,
                          backgroundImage: widget.supportAvatar == null ||
                                  widget.supportAvatar == ''
                              ? AssetImage('assets/img/defaultUser.png')
                              : NetworkImage(widget.supportAvatar),
                        ),
                      ),

                      // SizedBox(
                      //   width: wXD(11, context),
                      // ),
                      // CircleAvatar(
                      //   radius: 27,
                      //   backgroundImage: chatModel.usrAvatar == null ||
                      //           chatModel.usrAvatar == ''
                      //       ? AssetImage('assets/img/defaultUser.png')
                      //       : NetworkImage(chatModel.usrAvatar),
                      // ),
                    ],
                  ),
                )
              : Container();
    } else {
      return widget.messageModel.text != null &&
              widget.messageModel.image == null &&
              widget.messageModel.file == null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15),
                  child: CircleAvatar(
                    radius: 27,
                    backgroundImage:
                        widget.userAvatar == null || widget.userAvatar == ''
                            ? AssetImage('assets/img/defaultUser.png')
                            : NetworkImage(widget.userAvatar),
                  ),
                ),
                Container(
                  width: 300,
                  margin: EdgeInsets.fromLTRB(20, 18, 0, 30),
                  padding: EdgeInsets.fromLTRB(13, 14, 13, 17),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    color: Color(0xff00CCF2),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 7),
                            width: 192,
                            child: SelectableText(
                              '${widget.userName}',
                              enableInteractiveSelection: true,
                              showCursor: true,
                              scrollPhysics: ScrollPhysics(),
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xfffafafa),
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            alignment: Alignment.centerRight,
                            width: 40,
                            child: Text(
                              TimeModel().hour(widget.messageModel.createdAt),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Color(0xfffafafa).withOpacity(.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${widget.messageModel.text}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Color(0xfffafafa),
                          ),
                          // textAlign: TextAlign.justify
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          : widget.messageModel.image != null &&
                  widget.messageModel.text == null &&
                  widget.messageModel.file == null
              ? Container(
                  margin: EdgeInsets.only(
                    bottom: wXD(16, context),
                    // left: wXD(44, context),
                    right: wXD(16, context),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        child: CircleAvatar(
                            radius: 27,
                            backgroundImage: widget.userAvatar == null ||
                                    widget.userAvatar == ''
                                ? AssetImage('assets/img/defaultUser.png')
                                : CachedNetworkImageProvider(widget.userAvatar)

                            // Image.network(chatModel.spAvatar)

                            //  NetworkImage(),
                            ),
                      ),
                      SizedBox(
                        width: wXD(11, context),
                      ),
                      Container(
                        // height: wXD(77, context),

                        margin: EdgeInsets.fromLTRB(20, 18, 0, 30),
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),

                        width: 300,
                        decoration: BoxDecoration(
                          color: Color(0xff00CCF2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Stack(
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: wXD(5, context),
                                top: wXD(5, context),
                                right: wXD(5, context),
                                bottom: wXD(5, context),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              HeroImage(
                                                imgLink:
                                                    widget.messageModel.data,
                                              )));
                                },
                                child: Hero(
                                  tag: 'image',
                                  child: Container(
                                    width: 300,
                                    height: wXD(150, context),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                widget.messageModel.data),
                                            fit: BoxFit.cover),
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    // child: Center(
                                    //   child: Image.network(
                                    //     isImage,
                                    //     fit: BoxFit.fitWidth,
                                    //   ),
                                    // ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: wXD(20, context),
                              bottom: wXD(8, context),
                              child: Text(
                                TimeModel().hour(widget.messageModel.createdAt),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xfffafafa).withOpacity(.5),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : widget.messageModel.file != null &&
                      widget.messageModel.text == null &&
                      widget.messageModel.image == null
                  ? Container(
                      margin: EdgeInsets.only(
                        bottom: wXD(16, context),
                        // left: wXD(44, context),
                        right: wXD(16, context),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 15),
                            child: CircleAvatar(
                              radius: 27,
                              backgroundImage: widget.userAvatar == null ||
                                      widget.userAvatar == ''
                                  ? AssetImage('assets/img/defaultUser.png')
                                  : NetworkImage(widget.userAvatar),
                            ),
                          ),
                          SizedBox(
                            width: wXD(11, context),
                          ),
                          Container(
                            height: wXD(180, context),
                            width: 300,
                            margin: EdgeInsets.fromLTRB(20, 18, 0, 30),
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            decoration: BoxDecoration(
                              color: Color(0xff00CCF2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    // left: wXD(5, context),
                                    // top: wXD(5, context),
                                    // right: wXD(5, context),
                                    bottom: wXD(1, context),
                                  ),
                                  child: Container(
                                    width: 300,
                                    child: Column(
                                      children: [
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            if (kDebugMode) print('haha 3');
                                            html.window.open(
                                                anchorElement.toString(),
                                                'new tab');
                                            // anchorElement.click();
                                            // OpenFile.open(localPath);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(25),
                                                  topRight:
                                                      Radius.circular(25)),
                                              color: Color(0xffFFFFFF),
                                            ),
                                            height: 120,
                                            width: 300,
                                            child: Center(
                                              child: Image.asset(
                                                'assets/img/${widget.messageModel.extension.toLowerCase()}.png',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: wXD(5, context)),
                                        Row(
                                          children: [
                                            Spacer(
                                              flex: 1,
                                            ),
                                            InkWell(
                                                onTap: () async {
                                                  if (kDebugMode)
                                                    print('haha 4');
                                                  html.window.open(
                                                      anchorElement.toString(),
                                                      'new tab');
                                                },
                                                child: Icon(
                                                  Icons
                                                      .download_for_offline_outlined,
                                                  color: Color(0xfffafafa),
                                                  size: wXD(30, context),
                                                )),
                                            Spacer(
                                              flex: 2,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .16,
                                              child: Text(
                                                widget.messageModel.file,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Color(0xfffafafa),
                                                    fontSize: wXD(14, context),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Spacer(
                                              flex: 2,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  margin: EdgeInsets.only(
                                    right: wXD(17, context),
                                    bottom: wXD(4, context),
                                  ),
                                  child: Text(
                                    TimeModel()
                                        .hour(widget.messageModel.createdAt),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xfffafafa).withOpacity(.5),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          // SizedBox(
                          //   width: wXD(11, context),
                          // ),
                          // CircleAvatar(
                          //   radius: 27,
                          //   backgroundImage: chatModel.usrAvatar == null ||
                          //           chatModel.usrAvatar == ''
                          //       ? AssetImage('assets/img/defaultUser.png')
                          //       : NetworkImage(chatModel.usrAvatar),
                          // ),
                        ],
                      ),
                    )
                  : Container();
    }
  }
}
