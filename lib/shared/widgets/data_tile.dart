import 'package:back_office/shared/models/time_model.dart';
import 'package:back_office/shared/utilities.dart';
import 'package:back_office/shared/widgets/data_tile_provider.dart';
import 'package:back_office/views/home/home_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

class DataTestTile extends StatefulWidget {
  final String title, type, module, state;
  final List<Map<String, String>> statuses, types, notes;
  final dynamic data;
  final bool edit;
  final Function onChanged;
  DataTestTile({
    Key key,
    this.notes,
    this.title,
    this.data,
    this.type,
    this.edit,
    this.onChanged,
    this.module,
    this.statuses,
    this.types,
    this.state,
  }) : super(key: key);

  @override
  _DataTestTileState createState() => _DataTestTileState();
}

class _DataTestTileState extends State<DataTestTile> {
  FocusNode focusNode = FocusNode();
  OverlayEntry overlayEntry;
  MoneyMaskedTextController moneyMaskedTextController =
      MoneyMaskedTextController();
  TextEditingController textEditingController = TextEditingController();
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    textEditingController = TextEditingController();
    moneyMaskedTextController = MoneyMaskedTextController();
    getData();
    focusNode = FocusNode();
    if (widget.type == 'gender' ||
        widget.type == 'type' ||
        widget.type == 'status' ||
        widget.type == 'speciality_name' ||
        widget.type == 'state' ||
        widget.type == 'city' ||
        widget.type == 'type_of_visit' ||
        (widget.type == 'note' && widget.module == 'financial') ||
        widget.data is bool) {
      addListener();
      // if (widget.type == 'state') {}
    }
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  DateTime _selectedDate;
  String _data;
  MaskTextInputFormatter textInputFormatter;
  bool formatter = false;
  bool _edit = false;
  bool _hasButton = true;
  bool _changeState = false;
  bool _controller = false;
  bool _edited = false;
  bool _typeStatus = false;
  TimeOfDay timeSelected;
  List<TextInputFormatter> formatters = [];

  addListener() {
    focusNode.addListener(() {
      if (kDebugMode) print('focusNode.hasFocus ${focusNode.hasFocus}');
      if (focusNode.hasFocus) {
        overlayEntry = callOverlay();
        Overlay.of(context).insert(overlayEntry);
      } else {
        overlayEntry.remove();
      }
    });
  }

  OverlayEntry callOverlay() {
    if (kDebugMode) print('Calling Overlay');
    List<Map<String, dynamic>> overlayTiles;
    if (widget.data is bool) {
      overlayTiles = [
        {'data': 'Sim', 'data_field': true},
        {'data': 'Não', 'data_field': false},
      ];
    }
    switch (widget.type) {
      case 'type':
        overlayTiles = widget.types;
        break;
      case 'status':
        overlayTiles = widget.statuses;
        break;
      case 'note':
        overlayTiles = widget.notes;
        break;
      case 'gender':
        overlayTiles = [
          {
            'data': 'Masculino',
            'data_field': 'Masculino',
          },
          {
            'data': 'Feminino',
            'data_field': 'Feminino',
          },
          {
            'data': 'Outro',
            'data_field': 'Outro',
          },
        ];
        break;
      case 'type_of_visit':
        overlayTiles = [
          {
            'data': 'Consulta médica',
            'data_field': 'Consulta médica',
          },
          {
            'data': 'Retorno médico',
            'data_field': 'Retorno médico',
          },
          {
            'data': 'Reagendamento',
            'data_field': 'Reagendamento',
          },
          {
            'data': 'Paciente encaixado',
            'data_field': 'Paciente encaixado',
          },
        ];
        break;
      default:
    }
    double getWidth() {
      switch (widget.module) {
        case 'financial':
          return 250;
          break;
        case 'created_at':
          return 150;
          break;
        default:
          return 235;
          break;
      }
    }

    Future<List<DocumentSnapshot>> getStates() async {
      QuerySnapshot _infoQuery =
          await FirebaseFirestore.instance.collection('info').get();
      DocumentSnapshot _infoDoc = _infoQuery.docs.first;
      QuerySnapshot _statesQuery =
          await _infoDoc.reference.collection('states').get();
      return _statesQuery.docs;
    }

    Future<DocumentSnapshot> getCitys() async {
      QuerySnapshot _infoQuery =
          await FirebaseFirestore.instance.collection('info').get();

      DocumentSnapshot _infoDoc = _infoQuery.docs.first;
      if (kDebugMode) print("infoId: ${_infoDoc.id}");
      if (kDebugMode) print("State: ${widget.state}");
      QuerySnapshot _statesQuery = await _infoDoc.reference
          .collection('states')
          .where('name', isEqualTo: widget.state ?? '')
          .get();
      if (kDebugMode) print('_statesQuery: ${_statesQuery.docs}');
      DocumentSnapshot _stateDoc = _statesQuery.docs.first;
      //if(kDebugMode) print('_stateDoc["citys"] ${_stateDoc['citys']}');
      // List<String> citys = _stateDoc['citys'];

      return _stateDoc;
    }

    //if(kDebugMode) print(overlayTiles);
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    // if (widget.data is bool) {}
    switch (widget.type) {
      case 'speciality_name':
        return OverlayEntry(
          maintainState: true,
          builder: (context) => Positioned(
            width: 200,
            height: 200,
            child: CompositedTransformFollower(
              offset: Offset(60, size.height - 7),
              link: this._layerLink,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 3),
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
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('specialties')
                        .snapshots(),
                    builder: (streamcontext, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          padding: EdgeInsets.only(top: 70),
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        List<DocumentSnapshot> specialties = snapshot.data.docs;
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: specialties
                                .map(
                                  (e) => InkWell(
                                    onTap: () {
                                      setState(() {
                                        _data = e['speciality'];
                                      });
                                      if (kDebugMode) print('_data: $_data');
                                      widget.onChanged([e['speciality'], e.id]);
                                      focusNode.unfocus();
                                    },
                                    child: Container(
                                        height: 25,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          e['speciality'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Color(0xff000000),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )),
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        );
        break;
      case 'state':
        Future<List<DocumentSnapshot>> states = getStates();

        return OverlayEntry(
          maintainState: true,
          builder: (context) => Positioned(
            width: 200,
            height: 200,
            child: CompositedTransformFollower(
              offset: Offset(60, size.height - 7),
              link: this._layerLink,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 3),
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
                  child: FutureBuilder(
                    future: states,
                    builder: (futureContext, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          padding: EdgeInsets.only(top: 70),
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        List<DocumentSnapshot> states = snapshot.data;
                        states.sort((a, b) => a['name']
                            .toString()
                            .compareTo(b['name'].toString()));
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                                states.length,
                                (index) => InkWell(
                                      onTap: () {
                                        setState(() {
                                          _data = states[index]['acronyms'];
                                        });
                                        if (kDebugMode) print('_data: $_data');
                                        widget.onChanged(
                                            states[index]['acronyms']);
                                        focusNode.unfocus();
                                      },
                                      child: Container(
                                          height: 25,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            states[index]['name'],
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Color(0xff000000),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )),
                                    )),

                            // snapshot.data
                            //     .map(
                            //       (e) => InkWell(
                            //         onTap: () {
                            //           setState(() {
                            //             _data = e['acronyms'];
                            //           });
                            //          if(kDebugMode) print('_data: $_data');
                            //           widget.onChanged(e['acronyms']);
                            //           focusNode.unfocus();
                            //         },
                            //         child: Container(
                            //             height: 25,
                            //             alignment: Alignment.centerLeft,
                            //             child: Text(
                            //               e['name'],
                            //               style: TextStyle(
                            //                 fontSize: 18,
                            //                 color: Color(0xff000000),
                            //                 fontWeight: FontWeight.w600,
                            //               ),
                            //             )),
                            //       ),
                            //     )
                            //     .toList(),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        );
        break;
      case 'city':
        if (kDebugMode) print('stateeeeeeee: ${widget.state}');
        // return OverlayEntry(
        //   builder: (context) => Positioned(
        //     width: 40,
        //     height: 40,
        //     child: Container(P
        //       color: Colors.blue,
        //     ),
        //   ),
        // );
        Future<DocumentSnapshot> citys = getCitys();
        return OverlayEntry(
          maintainState: true,
          builder: (context) => Positioned(
            width: 200,
            height: 170,
            child: CompositedTransformFollower(
              offset: Offset(60, size.height - 7),
              link: this._layerLink,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 3),
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
                  child: widget.state == null || widget.state == ''
                      ? Text(
                          'Primeiro selecione um estado',
                          overflow: TextOverflow.clip,
                        )
                      : FutureBuilder(
                          future: citys,
                          builder: (streamcontext, snapshot) {
                            if (!snapshot.hasData) {
                              return Container(
                                padding: EdgeInsets.only(top: 50),
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              DocumentSnapshot docState = snapshot.data;
                              //if(kDebugMode) print('docState: ${docState.data()}');
                              // return Container();
                              List citys = docState['citys'];
                              citys.sort();
                              return SingleChildScrollView(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                      citys.length,
                                      (index) => InkWell(
                                        onTap: () {
                                          setState(() {
                                            _data = citys[index];
                                          });
                                          if (kDebugMode)
                                            print('_data: $_data');
                                          widget.onChanged(citys[index]);
                                          focusNode.unfocus();
                                        },
                                        child: Container(
                                            height: 25,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              citys[index],
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )),
                                      ),
                                    )),
                              );
                            }
                          },
                        ),
                ),
              ),
            ),
          ),
        );
        break;
      default:
        return OverlayEntry(
          builder: (context) => Positioned(
            width: getWidth(),
            height: overlayTiles.length < 5
                ? (overlayTiles.length * 25) + 20.toDouble()
                : 160,
            child: CompositedTransformFollower(
              offset: Offset(60, size.height - 7),
              link: this._layerLink,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 3),
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
                      children: overlayTiles
                          .map(
                            (e) => InkWell(
                              onTap: () {
                                setState(() {
                                  _data = e['data'];
                                });
                                widget.onChanged(e['data_field']);
                                focusNode.unfocus();
                              },
                              child: Container(
                                  height: 25,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    e['data'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xff000000),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        break;
    }
  }

  getData() {
    HomeProvider homeProvider = HomeProvider();
    if (widget.edit) {
      switch (widget.type) {
        case 'cpf':
          _edit = true;
          formatter = true;
          textInputFormatter = homeProvider.getMask('cpf');
          _data = textInputFormatter.maskText(widget.data ?? '');
          break;
        case 'cep':
          _edit = true;
          formatter = true;
          textInputFormatter = homeProvider.getMask('cep');
          _data = textInputFormatter.maskText(widget.data ?? '');

          break;
        case 'phone':
          _edit = true;
          formatter = true;
          textInputFormatter = homeProvider.getMask('phone');
          _data = textInputFormatter.maskText(widget.data ?? '');
          break;
        case 'avaliation':
          _edit = true;
          _controller = true;
          textEditingController = TextEditingController(
              text: widget.data.toString().padRight(2, '.0') ?? '');
          formatters = [homeProvider.getMask('avaliation')];
          break;
        case 'price':
          _edit = true;
          _controller = true;
          moneyMaskedTextController = MoneyMaskedTextController(
            initialValue: widget.data ?? 0,
            decimalSeparator: ',',
            thousandSeparator: '.',
            leftSymbol: 'R\$ ',
          );
          break;
        case 'value':
          if (kDebugMode) print('widget.data ${widget.data}');
          _edit = true;
          _controller = true;
          moneyMaskedTextController = MoneyMaskedTextController(
            initialValue: widget.data ?? 0,
            decimalSeparator: ',',
            thousandSeparator: '.',
            leftSymbol: 'R\$ ',
          );
          break;
        case 'id':
          _hasButton = false;
          _edit = false;
          _data = widget.data;
          break;
        case 'patient_id':
          _hasButton = false;
          _edit = false;
          _data = widget.data;
          break;
        case 'doctor_id':
          _hasButton = false;
          _edit = false;
          _data = widget.data;
          break;
        case 'dr_id':
          _hasButton = false;
          _edit = false;
          _data = widget.data;
          break;
        case 'sender_id':
          _hasButton = false;
          _edit = false;
          _data = widget.data;
          break;
        case 'receiver_id':
          _hasButton = false;
          _edit = false;
          _data = widget.data;
          break;
        case 'appointment_id':
          _hasButton = false;
          _edit = false;
          _data = widget.data;
          break;
        case 'responsible_id':
          _hasButton = false;
          _edit = false;
          _data = widget.data;
          break;
        case 'subscription_id':
          _hasButton = false;
          _edit = false;
          _data = widget.data;
          break;
        case 'birthday':
          _typeStatus = true;
          _edit = false;
          _data = homeProvider.validateTimeStamp(widget.data, 'date');
          break;
        case 'date':
          _typeStatus = true;
          _edit = false;
          _data = homeProvider.validateTimeStamp(widget.data, 'date');
          break;
        case 'created_at':
          _hasButton = false;
          _edit = false;
          _data = homeProvider.validateTimeStamp(widget.data, 'date');
          break;
        case 'hour':
          _typeStatus = true;
          _edit = false;
          _data = homeProvider.validateTimeStamp(widget.data, 'hour');
          break;
        case 'start_hour':
          _typeStatus = true;
          _edit = false;
          _data = homeProvider.validateTimeStamp(widget.data, 'hour');
          break;
        case 'end_hour':
          _typeStatus = true;
          _edit = false;
          _data = homeProvider.validateTimeStamp(widget.data, 'hour');
          break;
        case 'type':
          _edit = false;
          _data = widget.data;
          _typeStatus = true;
          break;
        case 'status':
          _edit = false;
          _data = widget.data;
          _typeStatus = true;
          break;
        case 'type_of_visit':
          _edit = false;
          _data = widget.data;
          _typeStatus = true;
          break;
        case 'gender':
          _edit = false;
          _data = widget.data;
          _typeStatus = true;
          break;
        case 'state':
          _changeState = true;
          _edit = false;
          _data = widget.data;
          _typeStatus = true;
          break;
        case 'city':
          _changeState = true;
          _edit = false;
          _data = widget.data;
          _typeStatus = true;
          break;
        case 'speciality_name':
          _edit = false;
          _data = widget.data;
          _typeStatus = true;
          break;
        case 'note':
          _edit = true;
          _data = widget.data == null ? '' : widget.data.toString();
          break;
        case 'email':
          if (kDebugMode) print('###### Emaaaaaaaaail: ${widget.data}');
          _data = widget.data == null || widget.data == 'null'
              ? ''
              : widget.data.toString().toLowerCase();
          _edit = true;
          break;
        case 'return_period':
          _edit = true;
          _data = widget.data == null ? '' : widget.data.toString();
          break;
        default:
          //if(kDebugMode) print('${widget.type} is bool');
          if (kDebugMode) print('${widget.type}: ${widget.data}');
          if (widget.data is bool) {
            _edit = false;
            _typeStatus = true;
            if (widget.data) {
              _data = 'Sim';
            } else {
              _data = 'Não';
            }
          } else {
            _data = widget.data == null ? '' : widget.data.toString();
            _edit = true;
          }
          break;
      }
    } else {
      switch (widget.type) {
        case 'birthday':
          _data = homeProvider.validateTimeStamp(widget.data, 'date');
          break;
        case 'created_at':
          _data = homeProvider.validateTimeStamp(widget.data, 'date');
          break;
        case 'date':
          _data = homeProvider.validateTimeStamp(widget.data, 'date');
          break;
        case 'hour':
          _data = homeProvider.validateTimeStamp(widget.data, 'hour');
          break;
        case 'start_hour':
          _data = homeProvider.validateTimeStamp(widget.data, 'hour');
          break;
        case 'end_hour':
          _data = homeProvider.validateTimeStamp(widget.data, 'hour');
          break;
        case 'cpf':
          _data = homeProvider.getTextMasked(widget.data ?? '', 'cpf');
          break;
        case 'cep':
          _data = homeProvider.getTextMasked(widget.data ?? '', 'cep');
          break;
        case 'phone':
          _data = homeProvider.getTextMasked(widget.data ?? '', 'phone');
          break;
        case 'price':
          //if(kDebugMode) print('widget.type: ${widget.type}  widget.data: ${widget.data}');
          _data = homeProvider.formatedCurrency(widget.data ?? 0);
          // _data = widget.data.toString();
          break;
        case 'value':
          _data = homeProvider.formatedCurrency(widget.data ?? 0);
          break;
        case 'avaliation':
          _data = widget.data == null
              ? ''
              : widget.data.toString().padRight(2, '.0');
          break;
        case 'email':
          if (kDebugMode) print('###### Emaaaaaaaaail: ${widget.data}');
          _data =
              widget.data == null ? '' : widget.data.toString().toLowerCase();
          break;
        default:
          if (widget.data is bool) {
            //if(kDebugMode) print('é boooooooooooooooooool');
            if (widget.data) {
              _data = 'Sim';
            } else {
              _data = 'Não';
            }
          } else {
            _data = widget.data == null ? '' : widget.data.toString();
          }
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider = HomeProvider();

    selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
        initialDatePickerMode: DatePickerMode.year,
        firstDate: DateTime(1950),
        lastDate: DateTime(2025),
        context: context,
        initialDate: DateTime.now(),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: const Color(0xFF41c3b3),
              accentColor: const Color(0xFF21bcce),
              colorScheme: ColorScheme.light(primary: const Color(0xFF41c3b3)),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child,
          );
        },
      );
      if (picked != null && picked != _selectedDate) {
        //if(kDebugMode) print('picked: $picked');
        _selectedDate = picked;
        //if(kDebugMode) print('_selectedDate: $_selectedDate');
        Timestamp timestamp = Timestamp.fromDate(_selectedDate);
        //if(kDebugMode) print('timestamp: $timestamp');
        String dataEscolhida =
            homeProvider.validateTimeStamp(timestamp, 'date');
        //if(kDebugMode) print('dataEscolhida: $dataEscolhida');
        setState(() {
          _data = dataEscolhida;
        });
        //if(kDebugMode) print('_data: $_data');
        widget.onChanged(timestamp);

        // _data =
        //     homeProvider.validateTimeStamp(Timestamp.fromDate(picked), 'date');
        // widget.onChanged();
      }
    }

    pickTime(BuildContext context, Timestamp initialTime) async {
      TimeOfDay timeOfDay = TimeOfDay(
          hour: initialTime.toDate().hour, minute: initialTime.toDate().minute);
      final newTime = await showTimePicker(
        context: context,
        initialTime: timeOfDay,
      );

      if (newTime == null) return;

      timeSelected = newTime;

      DateTime dateTime = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, timeSelected.hour, timeSelected.minute);
      //if(kDebugMode) print('dateTime ${dateTime}');

      Timestamp timestamp = Timestamp.fromDate(dateTime);
      setState(() {
        _data = TimeModel().hour(timestamp);
      });
      widget.onChanged(timestamp);
      //if(kDebugMode) print('timestamp ${timestamp}');
    }

    validateValue(value) {
      if (_edited) {
        if (value.length == 0) {
          return 'Digite um valor válido';
        } else {
          if (kDebugMode) print("valor diferente do que veio");
          if (kDebugMode) print('$value != ${widget.data}');
          switch (widget.type) {
            case 'email':
              bool emailValid = RegExp(
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{3,}))$')
                  .hasMatch(value);

              if (!emailValid) {
                return 'Digite um e-mail válido';
              } else {
                return null;
              }
              break;

            case 'cep':
              if (value.length < 10) {
                return 'Digite o CEP por completo';
              } else {
                return null;
              }
              break;

            case 'cpf':
              if (value.length < 14) {
                return 'Digite o CPF por completo';
              } else {
                return null;
              }
              break;
            case 'phone':
              if (value.length != 20) {
                return 'Digite o número por completo';
              } else {
                return null;
              }
              break;
            case 'avaliation':
              String avaliation = value.toString().padRight(2, '.0');
              String firstKey = avaliation.substring(0, 1);
              String lastKey = avaliation.substring(2, 3);
              //if(kDebugMode) print('firstKey: $firstKey, lastKey: $lastKey');
              if (firstKey == '5' && lastKey != '0') {
                return 'O valor não pode ser maior do que 5.0';
              }
              //if(kDebugMode) print('value $value');
              break;
            default:
              return null;
              break;
          }
        }
      }
    }

    checkEdit(val) {
      if (widget.data == null || widget.data == '') {
        if (val == '' || val == null || val == 'null') {
          _edited = false;
        } else {
          _edited = true;
        }
      } else {
        _edited = true;
      }
    }

    return CompositedTransformTarget(
      link: this._layerLink,
      child: Container(
        width: wXD(983, context),
        height: 60,
        padding: EdgeInsets.fromLTRB(
          wXD(20, context),
          0,
          wXD(10, context),
          0,
        ),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Color(0xff707070).withOpacity(.5)))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: wXD(900, context),
              child: Row(
                children: [
                  SelectableText(
                    '${widget.title}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Flexible(
                      child: _edit
                          ? formatter
                              ? TextFormField(
                                  // autovalidateMode:
                                  //     AutovalidateMode.onUserInteraction,
                                  cursorColor: Color(0xff707070),
                                  inputFormatters: [textInputFormatter],
                                  onChanged: (value) {
                                    checkEdit(value);
                                    if (kDebugMode) print('edited: $_edited');
                                    widget.onChanged(
                                        textInputFormatter.getUnmaskedText());
                                  },
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xff000000),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  focusNode: focusNode,
                                  initialValue: _data == null ? '' : _data,
                                  decoration: InputDecoration.collapsed(
                                      hintText: _data),
                                  validator: (value) => validateValue(value),
                                )
                              : _controller
                                  ? TextFormField(
                                      inputFormatters: formatters,
                                      controller: widget.type == 'price' ||
                                              widget.type == 'value'
                                          ? moneyMaskedTextController
                                          : textEditingController,
                                      cursorColor: Color(0xff707070),
                                      onChanged: (value) {
                                        checkEdit(value);

                                        switch (widget.type) {
                                          case 'price':
                                            widget.onChanged(
                                                moneyMaskedTextController
                                                    .numberValue);
                                            break;
                                          case 'value':
                                            widget.onChanged(
                                                moneyMaskedTextController
                                                    .numberValue);
                                            break;
                                          case 'avaliation':
                                            if (value != '') {
                                              widget.onChanged(double.parse(
                                                  textEditingController.text));
                                            } else {
                                              widget.onChanged(0);
                                            }
                                            break;
                                          default:
                                        }
                                      },
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xff000000),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      focusNode: focusNode,
                                      decoration: InputDecoration.collapsed(
                                          hintText: _data ?? ''),
                                      validator: (value) =>
                                          validateValue(value),
                                    )
                                  : TextFormField(
                                      // autovalidateMode:
                                      //     AutovalidateMode.onUserInteraction,
                                      cursorColor: Color(0xff707070),
                                      onChanged: (value) {
                                        checkEdit(value);
                                        widget.onChanged(value);
                                      },
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xff000000),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      focusNode: focusNode,
                                      initialValue: _data ?? '',
                                      decoration: InputDecoration.collapsed(
                                          hintText: _data),
                                      validator: (value) =>
                                          validateValue(value),
                                    )
                          : _typeStatus
                              ? _changeState
                                  ? Consumer<DataTileProvider>(
                                      builder: (context, value, child) {
                                      return InkWell(
                                        onTap: () {
                                          if (kDebugMode)
                                            print(
                                                'widget.type: ${widget.type} o do request');
                                          if (kDebugMode)
                                            print('state: ${widget.state} ');
                                          focusNode.requestFocus();
                                        },
                                        child: Focus(
                                          focusNode: focusNode,
                                          child: Text(
                                            widget.type == 'state'
                                                ? value.stateSelected ??
                                                    '                  '
                                                : value.citySelected ??
                                                    '                  ',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Color(0xff000000),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                                  : InkWell(
                                      onTap: () {
                                        if (widget.type == 'status' ||
                                            widget.type == 'type' ||
                                            widget.type == 'type_of_visit' ||
                                            widget.type == 'gender' ||
                                            widget.type == 'state' ||
                                            widget.type == 'city' ||
                                            widget.type == 'speciality_name' ||
                                            (widget.type == 'note' &&
                                                widget.module == 'financial') ||
                                            widget.data is bool) {
                                          focusNode.requestFocus();
                                        }
                                        if (widget.type == 'birthday' ||
                                            widget.type == 'date' ||
                                            widget.type == 'created_at') {
                                          selectDate(context);
                                        }
                                        if (widget.type == 'hour' ||
                                            widget.type == 'end_hour') {
                                          pickTime(context, widget.data);
                                        }
                                        // focusNode.requestFocus();
                                      },
                                      child: Focus(
                                        focusNode: focusNode,
                                        child: Text(
                                          _data ?? '                       ',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Color(0xff000000),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    )
                              : SelectableText(
                                  _data ?? '',
                                  maxLines: 1,
                                  cursorColor: Colors.grey,
                                  showCursor: true,
                                  enableInteractiveSelection: true,
                                  toolbarOptions: ToolbarOptions(
                                      copy: true,
                                      selectAll: true,
                                      cut: false,
                                      paste: false),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xff000000),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ))
                ],
              ),
            ),
            Visibility(
              visible: widget.edit && _hasButton,
              child: IconButton(
                icon: Icon(Icons.edit, size: 22, color: Color(0xff000000)),
                onPressed: () {
                  if (widget.type == 'status' ||
                      widget.type == 'type' ||
                      widget.type == 'type_of_visit' ||
                      widget.type == 'gender' ||
                      widget.type == 'state' ||
                      widget.type == 'city' ||
                      widget.type == 'speciality_name' ||
                      (widget.type == 'note' && widget.module == 'financial') ||
                      widget.data is bool) {
                    focusNode.requestFocus();
                  }
                  if (widget.type == 'birthday' ||
                      widget.type == 'date' ||
                      widget.type == 'created_at') {
                    selectDate(context);
                  }
                  if (widget.type == 'hour' || widget.type == 'end_hour') {
                    pickTime(context, widget.data);
                  }

                  focusNode.requestFocus();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DataTile extends StatelessWidget {
  final String title, data, type;
  const DataTile({
    Key key,
    this.title,
    this.data,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case '':
        break;
      default:
    }
    return Container(
      width: wXD(983, context),
      height: 60,
      padding: EdgeInsets.fromLTRB(
        wXD(20, context),
        0,
        wXD(10, context),
        0,
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Color(0xff707070).withOpacity(.5)))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: wXD(900, context),
            child: SelectableText.rich(
              TextSpan(
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(text: '$title '),
                  TextSpan(text: data),
                ],
              ),
              scrollPhysics: AlwaysScrollableScrollPhysics(),
              showCursor: true,
              toolbarOptions: ToolbarOptions(
                  copy: true, cut: true, paste: true, selectAll: true),
              selectionControls: MaterialTextSelectionControls(),
              enableInteractiveSelection: true,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class EditDataTile extends StatelessWidget {
  final String title, data;
  final Function onChanged, onEdit;
  final bool edit, formatter, typeTime;
  final MaskTextInputFormatter textInputFormatter;
  final FocusNode focusNode;

  EditDataTile({
    Key key,
    this.title,
    this.data,
    this.onChanged,
    this.textInputFormatter,
    this.focusNode,
    this.edit = true,
    this.typeTime = false,
    this.onEdit,
    this.formatter = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (title == 'Data de nascimento:') {
      //if(kDebugMode) print("title: $title \ndata: $data\n");
    }
    return Container(
      width: wXD(983, context),
      height: 60,
      padding: EdgeInsets.fromLTRB(
        wXD(20, context),
        0,
        wXD(10, context),
        0,
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Color(0xff707070).withOpacity(.5)))),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: wXD(900, context),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      children: [
                        SelectableText(
                          '$title',
                          cursorColor: Colors.red,
                          showCursor: true,
                          toolbarOptions: ToolbarOptions(
                              copy: true,
                              selectAll: true,
                              cut: false,
                              paste: false),
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Flexible(
                          child: Container(
                            child: formatter
                                ? TextFormField(
                                    enabled: edit,
                                    cursorColor: Color(0xff707070),
                                    inputFormatters: [textInputFormatter],
                                    onChanged: (val) {
                                      onChanged(
                                          textInputFormatter.getUnmaskedText());
                                    },
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xff000000),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    focusNode: focusNode,
                                    initialValue: '$data',
                                    decoration:
                                        InputDecoration.collapsed(hintText: ''),
                                  )
                                : typeTime
                                    ? Text(
                                        '$data',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xff000000),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    : TextFormField(
                                        enableInteractiveSelection: true,
                                        enabled: edit,
                                        cursorColor: Color(0xff707070),
                                        onChanged: onChanged,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xff000000),
                                          fontWeight: FontWeight.w600,
                                        ),
                                        focusNode: focusNode,
                                        initialValue: '$data',
                                        decoration: InputDecoration.collapsed(
                                            hintText: ''),
                                      ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit, size: 22, color: Color(0xff000000)),
                onPressed: () {
                  setState(
                    () {
                      onEdit == null ? focusNode.requestFocus() : onEdit();
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
