import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/address.dart';

class Store {
  String name;
  String image;
  String phone;
  Address address;
  Map<String, Map?> opening;

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
        );
}
