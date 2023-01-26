class Address {
  String street;
  String? number;
  String? complement;
  String district;
  String zipCode;
  String city;
  String state;

  double latitude;
  double longitude;

  Address({
    required this.street,
    required this.number,
    required this.complement,
    required this.district,
    required this.zipCode,
    required this.city,
    required this.state,
    required this.latitude,
    required this.longitude,
  });

  Address.empty({
    this.street = '',
    this.number = '',
    this.complement = '',
    this.district = '',
    this.zipCode = '',
    this.city = '',
    this.state = '',
    this.latitude = 0,
    this.longitude = 0,
  });

  Address.fromMap(Map<String, dynamic> map)
      : street = map['street'] as String,
        number = map['number'] as String,
        complement = map['complement'] as String,
        district = map['district'] as String,
        zipCode = map['zipCode'] as String,
        city = map['city'] as String,
        state = map['state'] as String,
        latitude = map['latitude'] as double,
        longitude = map['longitude'] as double;

  Map<String, dynamic> toMap() => {
        'street': street,
        'number': number,
        'complement': complement,
        'district': district,
        'zipCode': zipCode,
        'city': city,
        'state': state,
        'latitude': latitude,
        'longitude': longitude,
      };
}
