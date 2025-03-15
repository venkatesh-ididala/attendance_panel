import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> markAttendance(String userId, DateTime checkInTime) async {
    await _firestore.collection('attendance').add({
      'userId': userId,
      'checkIn': checkInTime.toIso8601String(),
    });
  }
}
