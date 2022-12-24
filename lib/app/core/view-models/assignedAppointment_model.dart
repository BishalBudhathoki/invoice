class AssignedClientAppointment {
  late final String userEmail;
  late final String clientEmail;
  late final List dateList;
  late final List startTimeList;
  late final List endTimeList;
  late final List breakList;


  AssignedClientAppointment({
    required this.userEmail,
    required this.clientEmail,
    required this.dateList,
    required this.startTimeList,
    required this.endTimeList,
    required this.breakList,
  });

  factory AssignedClientAppointment.fromJson(Map<String, dynamic> json) {
    return AssignedClientAppointment(
      userEmail: json['userEmail'],
      clientEmail: json['clientEmail'],
      dateList: json['dateList'],
      startTimeList: json['startTimeList'],
      endTimeList: json['endTimeList'],
      breakList: json['breakList'],
    );
  }
}
