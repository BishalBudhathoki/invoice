class Patient {
  late final String clientFirstName;
  late final String clientLastName;
  late final String clientEmail;
  late final String clientPhone;
  late final String clientAddress;
  late final String clientCity;
  late final String clientState;
  late final String clientZip;

  Patient({
    required this.clientFirstName,
    required this.clientLastName,
    required this.clientEmail,
    required this.clientPhone,
    required this.clientAddress,
    required this.clientCity,
    required this.clientState,
    required this.clientZip,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      clientFirstName: json['clientFirstName'],
      clientLastName: json['clientLastName'],
      clientEmail: json['clientEmail'],
      clientPhone: json['clientPhone'],
      clientAddress: json['clientAddress'],
      clientCity: json['clientCity'],
      clientState: json['clientState'],
      clientZip: json['clientZip'],
    );
  }
}
