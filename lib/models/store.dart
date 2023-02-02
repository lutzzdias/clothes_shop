import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/helpers/extensions.dart';
import 'package:loja_virtual/models/address.dart';

enum StoreStatus {
  closed,
  open,
  closing,
}

class Store {
  String name;
  String image;
  String phone;
  Address address;
  Map<String, Map<String, TimeOfDay>?> opening;
  late StoreStatus status;

  Store.fromDocument(DocumentSnapshot doc)
      : name = doc.get('name') as String,
        image = doc.get('image'),
        phone = doc.get('phone'),
        address = Address.fromMap(doc.get('address') as Map<String, dynamic>),
        opening = (doc.get('opening') as Map<String, dynamic>).map(
          (key, value) {
            final timeString = value;
            if (timeString != null && timeString.isNotEmpty) {
              final splitted = timeString.split(RegExp(r'[:-]'));
              return MapEntry(
                key,
                {
                  'from': TimeOfDay(
                    hour: int.parse(splitted[0]),
                    minute: int.parse(splitted[1]),
                  ),
                  'to': TimeOfDay(
                    hour: int.parse(splitted[2]),
                    minute: int.parse(splitted[3]),
                  ),
                },
              );
            } else {
              return MapEntry(key, null);
            }
          },
        ) {
    updateStatus();
  }

  String get addressText =>
      '${address.street}, ${address.number}${address.complement != null && address.complement!.isNotEmpty ? ' - ${address.complement}' : ''} - '
      '${address.district}, ${address.city}/${address.state}';

  String get openingText => 'Seg-Sex: ${formattedPeriod(opening['weekday'])}\n'
      'Sab: ${formattedPeriod(opening['saturday'])}\n'
      'Dom: ${formattedPeriod(opening['sunday'])}\n';

  String get statusText {
    switch (status) {
      case StoreStatus.open:
        return 'Aberta';
      case StoreStatus.closing:
        return 'Fechando';
      case StoreStatus.closed:
        return 'Fechada';
      default:
        return '';
    }
  }

  String get cleanPhone => phone.replaceAll(RegExp(r'[^\d]'), '');

  String formattedPeriod(Map<String, TimeOfDay>? period) {
    if (period == null) return 'Fechado';
    return '${period['from']!.formatted()} - ${period['to']!.formatted()}';
  }

  void updateStatus() {
    final weekDay = DateTime.now().weekday;
    Map<String, TimeOfDay>? period;
    if (weekDay >= 1 && weekDay <= 5)
      period = opening['weekday'];
    else if (weekDay == 6)
      period = opening['saturday'];
    else
      period = opening['sunday'];

    final now = TimeOfDay.now();

    if (period == null)
      status = StoreStatus.closed;
    else if (period['from']!.toMinutes() < now.toMinutes() &&
        period['to']!.toMinutes() - 15 > now.toMinutes())
      status = StoreStatus.open;
    else if (period['from']!.toMinutes() < now.toMinutes() &&
        period['to']!.toMinutes() > now.toMinutes())
      status = StoreStatus.closing;
    else
      status = StoreStatus.closed;
  }
}
