import 'package:back_office/views/home/home_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/foundation.dart';

class FilterField extends StatefulWidget {
  final String title, collection, field;
  final List<String> statuses, types, typeOfVisit;
  final Function onChanged;

  FilterField({
    this.title,
    this.collection,
    this.field,
    Key key,
    this.onChanged,
    this.statuses,
    this.types,
    this.typeOfVisit,
  }) : super(key: key);

  @override
  _FilterFieldState createState() => _FilterFieldState();
}

class _FilterFieldState extends State<FilterField> {
  final HomeProvider homeProvider = HomeProvider();
  final FocusNode focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  MaskTextInputFormatter mask;
  OverlayEntry overlayEntry;

  TextEditingController textController = TextEditingController();

  String text = '';
  bool _defaultOverlay = false;
  bool _enable = true;
  bool _isBool = false;
  List<String> bools = [
    'notification_disabled',
    'connected',
    'first_appointment',
    'greed_simptoms',
    'rated',
    'viewed',
    'guarantee',
    'first_visit',
    'covid_symptoms',
  ];
  List<String> genders = ['Masculino', 'Feminino', 'Outro'];
  List<String> overlayTiles = [];
  List<String> searchList = [];

  initState() {
    textController = TextEditingController();
    _defaultOverlay = widget.field == 'status' ||
        widget.field == 'type' ||
        widget.field == 'gender' ||
        widget.field == 'type_of_visit' ||
        bools.contains(widget.field);

    if (widget.field != 'birthday' &&
        widget.field != 'date' &&
        widget.field != 'start_hour' &&
        widget.field != 'end_hour' &&
        widget.field != 'avaliation' &&
        widget.field != 'hour') {
      addListener();
    }
    if (bools.contains(widget.field) || _defaultOverlay) {
      _enable = false;
    }

    getMask();
    setLists();
    super.initState();
  }

  dispose() {
    textController.dispose();
    focusNode.removeListener(() {});
    super.dispose();
  }

  getMask() {
    switch (widget.field) {
      case 'cpf':
        mask = homeProvider.getMask('cpf');
        break;
      case 'cep':
        mask = homeProvider.getMask('cep');
        break;
      case 'phone':
        mask = homeProvider.getMask('phone');
        break;
      case 'contact':
        mask = homeProvider.getMask('phone');
        break;
      case 'avaliation':
        mask = homeProvider.getMask('avaliation');
        break;
      case 'date':
        mask = homeProvider.getMask('date');
        break;
      case 'birthday':
        mask = homeProvider.getMask('date');
        break;
      case 'created_at':
        mask = homeProvider.getMask('date');
        break;
      case 'updated_at':
        mask = homeProvider.getMask('date');
        break;
      case 'dispatched_at':
        mask = homeProvider.getMask('date');
        break;
      case 'hour':
        mask = homeProvider.getMask('hour');
        break;
      case 'start_hour':
        mask = homeProvider.getMask('hour');
        break;
      case 'end_hour':
        mask = homeProvider.getMask('hour');
        break;
      default:
    }
  }

  setLists() {
    switch (widget.field) {
      case 'status':
        overlayTiles = widget.statuses;
        break;
      case 'type':
        overlayTiles = widget.types;
        break;
      case 'type_of_visit':
        overlayTiles = widget.typeOfVisit;
        break;
      default:
        if (bools.contains(widget.field)) {
          //if(kDebugMode) print('é boooooooool');
          _isBool = true;
        } else {
          overlayTiles = genders;
        }
        break;
    }
  }

  addListener() {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        if (kDebugMode) print('criando overlay ${widget.field}');
        overlayEntry = callOverlayEntry();
        Overlay.of(context).insert(overlayEntry);
      } else {
        if (kDebugMode) print('removendo overlay ${widget.field}');
        overlayEntry.remove();
      }
    });
  }

  // search(String _text) {
  //  if(kDebugMode) print('seaching');
  //  if(kDebugMode) print(searchList);
  //  if(kDebugMode) print(overlayTiles);
  //   // overlayTiles.clear();
  //   List<String> _lista = [];

  //   if (widget.field == 'gender') {
  //     genders.forEach((babu) {
  //       //if(kDebugMode) print(
  //       //     'babu: $babu text: $_text?? ${babu.toLowerCase().contains(_text.toLowerCase())}');
  //       if (babu.toLowerCase().contains(_text.toLowerCase())) {
  //         _lista.add(babu);
  //       }
  //     });
  //   } else {
  //     widget.overlayData.forEach((babu) {
  //       //if(kDebugMode) print(
  //       //     'babu: $babu text: $_text?? ${babu.toLowerCase().contains(_text.toLowerCase())}');
  //       if (babu.toLowerCase().contains(_text.toLowerCase())) {
  //         _lista.add(babu);
  //       }
  //     });
  //   }

  //   overlayTiles = _lista;
  // }

  OverlayEntry callOverlayEntry() {
    double getWidth() {
      switch (widget.field) {
        case 'id':
          return 330;
          break;
        case 'type':
          if (widget.types.contains('Balanço financeiro')) {
            return 270;
          } else if (widget.types.contains('Recebimento pendente')) {
            return 210;
          } else {
            return 200;
          }
          break;
        default:
          return 200;
          break;
      }
    }

    getDateString(Timestamp time, {bool mask = true}) {
      DateTime _date = time.toDate();
      String day = _date.day.toString().padLeft(2, '0');
      String month = _date.month.toString().padLeft(2, '0');
      String year = _date.year.toString();
      String _dateString = '$day/$month/$year';
      String _dateWithout = '$day$month$year';
      if (mask) {
        //if(kDebugMode) print('_dataString = $_dateString');
        return _dateString;
      } else {
        //if(kDebugMode) print('_dateWithout = $_dateWithout');
        return _dateWithout;
      }
    }

    // RenderBox box = context.findRenderObject();
    // Size size = box.size;
    if (kDebugMode) print('is boooooooooooooool????? $_isBool');
    if (kDebugMode) print('_defaultOverlay????? $_defaultOverlay');
    return OverlayEntry(
      builder: (context) => _defaultOverlay
          ? Positioned(
              width: getWidth(),
              height:
                  _isBool ? 64 : ((overlayTiles.length * 25).toDouble() + 14),
              child: CompositedTransformFollower(
                offset: Offset(-10, 33),
                link: this._layerLink,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 7, 10, 7),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
                            color: Color(0x30000000),
                            offset: Offset(0, 3),
                          )
                        ],
                        color: Color(0xffffffff)),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _isBool
                            ? [
                                InkWell(
                                  onTap: () {
                                    widget.onChanged('true');
                                    textController.text = 'Sim';
                                    focusNode.unfocus();
                                  },
                                  child: Container(
                                    height: 25,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Sim',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xff000000),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    widget.onChanged('false');
                                    textController.text = 'Não';
                                    focusNode.unfocus();
                                  },
                                  child: Container(
                                    height: 25,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Não',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xff000000),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                            : List.generate(
                                overlayTiles.length,
                                (index) => InkWell(
                                  onTap: () {
                                    widget.onChanged(overlayTiles[index]);
                                    textController.text = overlayTiles[index];
                                    focusNode.unfocus();
                                  },
                                  child: Container(
                                    height: 25,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      overlayTiles[index],
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xff000000),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(widget.collection)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else {
                  List<Map<String, dynamic>> _stringData = [];
                  QuerySnapshot qs = snapshot.data;

                  qs.docs.forEach((DocumentSnapshot doc) {
                    if (doc[widget.field] is bool) {
                      _stringData = [
                        {
                          'view': 'Sim',
                          'data': 'true',
                        },
                        {
                          'view': 'Não',
                          'data': 'false',
                        }
                      ];
                    } else {
                      //if(kDebugMode) print(
                      //     'doc[widget.field] is Timestamp ?? ${doc[widget.field] is Timestamp}');
                      String _field = doc[widget.field] is Timestamp
                          ? getDateString(doc[widget.field], mask: false)
                          : doc[widget.field].toString().toLowerCase();
                      String _text = text.toLowerCase();
                      //if(kDebugMode) print('_text: $_text  _field: $_field');
                      //if(kDebugMode) print(
                      //     '_stringData.contains(doc[widget.field].toString()): ${_stringData.contains(doc[widget.field].toString())}');

                      String fieldAdd = doc[widget.field] is Timestamp
                          ? getDateString(doc[widget.field])
                          : doc[widget.field].toString();
                      bool containsField() {
                        bool contains = false;
                        if (_stringData.isNotEmpty) {
                          for (var i = 0; i <= _stringData.length - 1; i++) {
                            bool hasView = _stringData[i]['view'] == fieldAdd;
                            bool hasData = _stringData[i]['data'] == _field;
                            if (hasView && hasData) {
                              contains = true;
                              break;
                            }
                          }
                        }
                        return contains;
                      }

                      if (_field != null &&
                          _field.contains(_text) &&
                          !containsField()) {
                        _stringData.add({'view': fieldAdd, 'data': _field});
                      }
                    }
                  });

                  //if(kDebugMode) print('\n   ####&&&&%%%%%%%%&&&&####   \n ');
                  return text == ''
                      ? Container()
                      : Positioned(
                          width: _stringData.length == 0
                              ? 250
                              : text == ''
                                  ? 0
                                  : getWidth(),
                          height: _stringData.length == 0
                              ? 49
                              : _stringData.length > 10
                                  ? 264
                                  : (_stringData.length * 25).toDouble() + 14,
                          child: CompositedTransformFollower(
                            offset: Offset(-10, 33),
                            link: this._layerLink,
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10, 7, 10, 7),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 3,
                                        color: Color(0x30000000),
                                        offset: Offset(0, 3),
                                      )
                                    ],
                                    color: Color(0xffffffff)),
                                child: SingleChildScrollView(
                                  child: _stringData.isEmpty
                                      ? Container(
                                          padding: EdgeInsets.only(top: 10),
                                          alignment: Alignment.bottomCenter,
                                          child: Text(
                                              'Sem documentos com esses dados'))
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: _stringData.map((e) {
                                            String overlayText;
                                            switch (widget.field) {
                                              case 'phone':
                                                overlayText =
                                                    homeProvider.getTextMasked(
                                                        e['view'], 'phone');
                                                break;
                                              case 'cpf':
                                                overlayText =
                                                    homeProvider.getTextMasked(
                                                        e['view'], 'cpf');
                                                break;
                                              case 'cep':
                                                overlayText =
                                                    homeProvider.getTextMasked(
                                                        e['view'], 'cep');
                                                break;
                                              // case 'value':
                                              //   overlayText = homeProvider
                                              //       .formatedCurrency(
                                              //           double.parse(
                                              //               e['view']));
                                              //   break;
                                              // case 'price':
                                              //   overlayText = homeProvider
                                              //       .formatedCurrency(
                                              //           double.parse(
                                              //               e['view']));
                                              //   break;
                                              case 'avaliation':
                                                overlayText = e['view']
                                                    .toString()
                                                    .padRight(2, '.0');
                                                break;
                                              default:
                                                if (e['view'] == 'true' ||
                                                    e['view'] == 'false') {
                                                  overlayText =
                                                      e['view'] == 'true'
                                                          ? 'Sim'
                                                          : 'Não';
                                                } else if (e['view'] ==
                                                    'null') {
                                                  e['view'] = 'Nulo';
                                                }
                                                {
                                                  overlayText =
                                                      e['view'].toString();
                                                }
                                                break;
                                            }

                                            return InkWell(
                                              onTap: () {
                                                if (kDebugMode)
                                                  print(
                                                      'overlayText: $overlayText');
                                                widget.onChanged(e['data']);
                                                textController.text =
                                                    overlayText;
                                                focusNode.unfocus();
                                              },
                                              child: Container(
                                                  height: 25,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    overlayText,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Color(0xff000000),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  )),
                                            );
                                          }).toList(),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        );
                }
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 30),
        width: 405,
        height: 33,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 218,
              child: SelectableText(
                '${widget.title}',
                maxLines: 1,
                scrollPhysics: AlwaysScrollableScrollPhysics(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Stack(
              children: [
                Container(
                    height: 33,
                    width: 187,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(13)),
                        border: Border.all(
                            color: Color(0xff707070).withOpacity(.5))),
                    alignment: Alignment.center,
                    child: CompositedTransformTarget(
                      link: _layerLink,
                      child: !_enable
                          ? InkWell(
                              onDoubleTap: () {
                                textController.clear();
                                widget.onChanged('');
                              },
                              onTap: () {
                                focusNode.requestFocus();
                              },
                              child: Focus(
                                focusNode: focusNode,
                                child: Container(
                                  height: 33,
                                  width: 187,
                                  alignment: Alignment.centerLeft,
                                  child: TextFormField(
                                    enabled: false,
                                    controller: textController,
                                    // onChanged: (val) {
                                    //   text = val;
                                    //  if(kDebugMode) print(widget.field);
                                    //  if(kDebugMode) print(
                                    //       '_defaultOverlay: $_defaultOverlay');
                                    //   if (_defaultOverlay) {
                                    //     widget.onChanged(val);
                                    //     search(val);
                                    //   } else {
                                    //     widget.onChanged(val);
                                    //   }
                                    //  if(kDebugMode) print('text: $text \n');
                                    // },
                                    decoration: InputDecoration.collapsed(
                                        hintText: '', border: InputBorder.none),
                                  ),
                                ),
                              ),
                            )
                          : mask == null
                              ? TextFormField(
                                  focusNode: focusNode,
                                  controller: textController,
                                  onChanged: (val) {
                                    text = val;
                                    //if(kDebugMode) print(widget.field);
                                    //if(kDebugMode) print('_defaultOverlay: $_defaultOverlay');
                                    widget.onChanged(val);
                                    //if(kDebugMode) print('text: $text \n');
                                  },
                                  decoration: InputDecoration.collapsed(
                                      hintText: '', border: InputBorder.none),
                                )
                              : TextFormField(
                                  focusNode: focusNode,
                                  controller: textController,
                                  onChanged: (val) {
                                    text = mask.getUnmaskedText();
                                    //if(kDebugMode) print(widget.field);
                                    //if(kDebugMode) print('_defaultOverlay: $_defaultOverlay');
                                    widget.onChanged(mask.getUnmaskedText());
                                    //if(kDebugMode) print('text: $text \n');
                                  },
                                  inputFormatters: [mask],
                                  decoration: InputDecoration.collapsed(
                                      hintText: '', border: InputBorder.none),
                                ),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
