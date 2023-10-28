import 'package:back_office/shared/models/time_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeProvider extends ChangeNotifier {
  int _page = 1;

  int get page => _page;

  incPage(page) {
    _page = page;
    notifyListeners();
  }

  OverlayEntry overlaySelected;

  OverlayEntry get overlay => overlaySelected;

  setOverlaySelected(OverlayEntry overlayEntry) {
    overlaySelected = overlayEntry;
    notifyListeners();
  }

  bool _estornarView = false;

  bool get estornarView => _estornarView;

  incEstornarPage(estornarView) {
    _estornarView = estornarView;
    notifyListeners();
  }

  String formatedCurrency(var value) {
    //if(kDebugMode) print('Formated Currency: $value');
    var newValue = new NumberFormat("R\$ #,##0.00", "pt_BR");
    return newValue.format(value);
  }

  Future<void> launchInWebViewOrVC(String url) async {
    if (!await launch(
      url,
      forceSafariVC: true,
      forceWebView: true,
      // headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  }

  getMask(String type) {
    MaskTextInputFormatter maskFormatterCpf = new MaskTextInputFormatter(
        mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
    MaskTextInputFormatter maskFormatterCep = new MaskTextInputFormatter(
        mask: '##.###-###', filter: {"#": RegExp(r'[0-9]')});
    MaskTextInputFormatter maskFormatterPhone = new MaskTextInputFormatter(
        mask: '+## (##) # ####-####', filter: {"#": RegExp(r'[0-9]')});
    MaskTextInputFormatter maskFormatterGrade = new MaskTextInputFormatter(
        mask: '%.#', filter: {"#": RegExp(r'[0-9]'), "%": RegExp(r'[0-5]')});
    MaskTextInputFormatter maskFormatterDate = new MaskTextInputFormatter(
        mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
    MaskTextInputFormatter maskFormatterHour =
        new MaskTextInputFormatter(mask: '@#:%#', filter: {
      "@": RegExp(r'[0-2]'),
      "%": RegExp(r'[0-6]'),
      "#": RegExp(r'[0-9]'),
    });
    switch (type) {
      case 'cpf':
        return maskFormatterCpf;
        break;
      case 'cep':
        return maskFormatterCep;
        break;
      case 'phone':
        return maskFormatterPhone;
        break;
      case 'avaliation':
        return maskFormatterGrade;
        break;
      case 'date':
        return maskFormatterDate;
        break;
      case 'hour':
        return maskFormatterHour;
        break;
      default:
    }
  }

  String getTextMasked(String value, String type) {
    if (value != '' && value != null) {
      switch (type) {
        case 'cpf':
          return '${value.substring(0, 3)}.${value.substring(3, 6)}.${value.substring(6, 9)}-${value.substring(9, 11)}';
          break;
        case 'cep':
          return '${value.substring(0, 2)}.${value.substring(2, 5)}-${value.substring(5, 8)}';
          break;
        case 'phone':
          return '${value.substring(0, 3)} (${value.substring(3, 5)}) ${value.substring(5, 10)}-${value.substring(10, 14)}';
        // case 'price':
        // return '${value.substring(0, 3)} (${value.substring(3, 5)}) ${value.substring(5, 10)}-${value.substring(10, 14)}';
        default:
          return '### Tipo da máscara não definido corretamente';
      }
    } else {
      return '- - -';
      // switch (type) {
      //   case 'cpf':
      //     return '   .   .   -  ';
      //     break;
      //   case 'cep':
      //     return '  .   -   ';
      //     break;
      //   case 'phone':
      //     return '    (  )      -    }';
      //   default:
      //     return '### Tipo da máscara não definido corretamente';
      // }
    }
  }

  String validateTimeStamp(Timestamp timestamp, String type) {
    if (type == 'date') {
      if (timestamp == null) {
        return '_ /_ /_';
      } else {
        return TimeModel().date(timestamp);
      }
    } else if (type == 'hour') {
      if (timestamp == null) {
        return 'XX:XX';
      } else {
        return TimeModel().hour(timestamp);
      }
    } else {
      return '##### Tipo não específicado ou não específicado corretamente #####';
    }
  }

  Future selectDate(BuildContext context, DateTime initialValue) async {
    DateTime selectedDate = initialValue;
    final DateTime picked = await showDatePicker(
      initialDatePickerMode: DatePickerMode.year,
      firstDate: DateTime(1900),
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
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
    }
    return selectedDate;
  }

  String getPortugueseType(String type) {
    if (type == null) {
      return 'Não informado';
    } else {
      String lowType = type.toLowerCase();
      switch (lowType) {
        case '':
          return 'Não informado';
          break;
        case 'patient':
          return 'Titular';
          break;
        case 'holder':
          return 'Titular';
          break;
        case 'dependent':
          return 'Dependente';
          break;
        case 'doctor':
          return 'Doutor(a)';
          break;
        case 'secretary':
          return 'Secretário(a)';
          break;
        case 'fit':
          return 'Encaixe';
          break;
        case 'appointment':
          return 'Consulta';
          break;
        case 'return':
          return 'Retorno';
          break;
        case 'secretary':
          return 'Secretário';
          break;
        case 'financial_statement':
          return 'Balanço financeiro';
          break;
        case 'financial_statement_done':
          return 'Balanço financeiro realizado';
          break;
        case 'message':
          return 'Mensagem';
          break;
        case 'alert':
          return 'Alerta';
          break;
        case 'manual':
          return 'Alerta';
          break;
        case 'pending_income':
          return 'Recebimento pendente';
          break;
        case 'income':
          return 'Recebimento';
          break;
        case 'outcome':
          return 'Pagamento';
          break;
        case 'pending_outcome':
          return 'Pagamento pendente';
          break;
        case 'reverted':
          return 'Estornado';
          break;
        case 'revert':
          return 'Estorno solicitado';
          break;
        case 'paid ':
          return 'Pago';
          break;
        case 'monthly_income':
          return 'Pagamento mensal';
          break;
        case 'subscription':
          return 'Assinatura';
          break;
        case 'unsubscription':
          return 'Assinatura cancelada';
          break;
        case 'guarantee':
          return 'Caução';
          break;
        case 'refund_requested_income':
          return 'Estorno solicitado';
          break;
        case 'reverted':
          return 'Estornada';
          break;
        case 'pending_refund':
          return 'A estornar';
          break;
        case 'subscription':
          return 'Assinatura';
          break;
        case 'refund':
          return 'Estornado';
          break;
        case 'refund_pending':
          return 'A estornar';
          break;
        case 'remaining':
          return 'Remanescente';
          break;
        case 'guarantee_refund':
          return 'Reembolso de caução';
          break;
        case 'schedule':
          return 'Consulta';
          break;
        case 'payout':
          return 'Saque';
          break;
        case 'auto':
          return 'Automática';
          break;
        default:
          if (kDebugMode) print('tipo não estabelecido: $lowType');
          return 'Tradução não estabelecida';
          break;
      }
    }
  }

  String getPortugueseStatus(String status, {String module = ''}) {
    if (status == null) {
      return 'Não informado';
    } else {
      String lowStatus = status.toLowerCase();
      switch (lowStatus) {
        case '':
          return 'Não informado';
          break;
        case 'scheduled':
          if (module == 'notification') {
            return 'Programada';
          } else {
            return 'Agendado';
          }
          break;
        case 'waiting':
          if (module == 'financial') {
            return 'Aguardando depósito';
          } else {
            return 'Aguardando atendimento';
          }
          break;
        case 'awaiting':
          if (module == 'financial') {
            return 'Aguardando depósito';
          } else {
            return 'Aguardando atendimento';
          }
          break;
        case 'absent':
          return 'Não compareceu';
          break;
        case 'pending_canceled':
          return 'Cancelamento pendente';
          break;
        case 'canceled':
          return 'Cancelado';
          break;
        case 'concluded':
          return 'Concluído';
          break;
        case 'fit_requested':
          return 'Encaixe solicitado';
          break;
        case 'refused':
          return 'Encaixe recusado';
          break;
        case 'waiting_return':
          return 'Aguardando retorno';
          break;
        case 'awaiting_return':
          return 'Aguardando retorno';
          break;
        case 'reported':
          return 'Reportada';
          break;
        case 'visible':
          return 'Visível';
          break;
        case 'deleted':
          return 'Excluída';
          break;
        case 'deposited':
          return 'Depositada';
          break;
        case 'offline':
          return 'Offline';
          break;
        case 'online':
          return 'Online';
          break;
        case 'rated':
          return 'Avaliado';
          break;
        case 'sended':
          return 'Enviada';
          break;
        case 'done':
          return 'Pago';
          break;
        case 'unsettled':
          return 'Pendente';
          break;
        case 'active':
          return 'Ativo';
          break;
        case 'blocked':
          return 'Bloqueado';
          break;
        case 'expired':
          return 'Expirado';
          break;
        case 'refund_requested_income':
          return 'Estorno solicitado';
          break;
        case 'reverted':
          return 'Estornada';
          break;
        case 'pending_refund':
          return 'A estornar';
          break;
        case 'pending_income':
          return 'Recebimento pendente';
          break;
        case 'subscription':
          return 'Assinatura';
          break;
        case 'refund':
          return 'Estornado';
          break;
        case 'unsubscription':
          return 'Assinatura cancelada';
          break;
        case 'income':
          return 'Recebimento';
          break;
        case 'outcome':
          return 'Pagamento';
          break;
        case 'pending_outcome':
          return 'Pagamento pendente';
          break;
        case 'reverted':
          return 'Estornado';
          break;
        case 'revert':
          return 'Estorno solicitado';
          break;
        case 'paid':
          return 'Pago';
          break;
        case 'monthly_income':
          return 'Pagamento mensal';
          break;
        case 'removed':
          return 'Removido';
          break;
        case 'blocked':
          return 'Bloqueado';
          break;
        case 'remaining_refund':
          return 'Estorno de remanescente';
          break;
        case 'remaining':
          return 'Remanescente';
          break;
        case 'payout':
          return 'Pagamento por fora';
          break;
        case 'inactive':
          if (module == 'patient' ||
              module == 'ratings' ||
              module == "financial") {
            return 'Inativo';
          } else {
            return 'Pendente';
          }
          break;
        default:
          if (kDebugMode) print('status não estabelecido: $lowStatus');
          return 'Tradução não estabelecida';
          break;
      }
    }
  }
}
