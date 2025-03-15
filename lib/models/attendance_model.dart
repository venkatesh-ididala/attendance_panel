class AttendanceModel {
  String userId;
  DateTime checkIn;
  DateTime? checkOut;

  AttendanceModel({required this.userId, required this.checkIn, this.checkOut});
}
