// import 'package:attendance_panel/services/auth_services.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class EmployeeDashboard extends StatefulWidget {
//   const EmployeeDashboard({super.key});

//   @override
//   _EmployeeDashboardState createState() => _EmployeeDashboardState();
// }

// class _EmployeeDashboardState extends State<EmployeeDashboard> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   bool _isCheckedIn = false;
//   String _checkInTime = '';
//   String _checkOutTime = '';

//   // void _logout() async {
//   //   await AuthService().signOut();
//   //   Navigator.pushReplacementNamed(context, '/login');
//   // }

//   void _logout() async {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => Center(child: CircularProgressIndicator()),
//     );

//     await AuthService().signOut();

//     if (mounted) {
//       Navigator.pop(context); // Close loading dialog
//       Navigator.pushReplacementNamed(
//           context, '/login'); // Navigate after sign-out
//     }
//   }

//   Future<String> _getAddressFromLatLng(double lat, double lng) async {
//     final String url =
//         "https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng";

//     try {
//       final response = await http.get(Uri.parse(url), headers: {
//         "User-Agent": "AttendanceApp/1.0" // Required for Nominatim API
//       });

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return data['display_name'] ?? "Address not found";
//       } else {
//         return "Failed to fetch address";
//       }
//     } catch (e) {
//       return "Error: $e";
//     }
//   }

//   Future<void> _markAttendance() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     String currentTime = DateTime.now().toIso8601String();
//     User? user = _auth.currentUser;

//     if (user != null) {
//       String formattedAddress =
//           await _getAddressFromLatLng(position.latitude, position.longitude);

//       DocumentReference attendanceRef =
//           _firestore.collection('attendance').doc(user.uid);
//       DocumentSnapshot attendanceSnapshot = await attendanceRef.get();

//       if (!attendanceSnapshot.exists ||
//           (attendanceSnapshot.exists &&
//               attendanceSnapshot['checkOut'] != null)) {
//         // Check-in
//         await attendanceRef.set({
//           'name': user.displayName ?? 'Employee',
//           'checkIn': currentTime,
//           'checkOut': null,
//           'location': {
//             'latitude': position.latitude,
//             'longitude': position.longitude,
//             'address': formattedAddress
//           },
//           'late': DateTime.now().hour > 9,
//         });
//         setState(() {
//           _isCheckedIn = true;
//           _checkInTime = currentTime;
//         });
//       } else {
//         // Check-out
//         await attendanceRef.update({
//           'checkOut': currentTime,
//         });
//         setState(() {
//           _isCheckedIn = false;
//           _checkOutTime = currentTime;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Employee Dashboard'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: _logout,
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(_isCheckedIn
//                 ? 'Checked in at: $_checkInTime'
//                 : 'Check-out at: $_checkOutTime'),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _markAttendance,
//               child: Text(_isCheckedIn ? 'Check Out' : 'Check In'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:attendance_panel/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmployeeDashboard extends StatefulWidget {
  const EmployeeDashboard({super.key});

  @override
  _EmployeeDashboardState createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isCheckedIn = false;
  bool _isCheckedOut = false;
  String _checkInTime = '';
  String _checkOutTime = '';

  @override
  void initState() {
    super.initState();
    _fetchAttendanceStatus();
  }

  Future<void> _fetchAttendanceStatus() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot attendanceSnapshot =
          await _firestore.collection('attendance').doc(user.uid).get();

      if (attendanceSnapshot.exists) {
        String checkIn = attendanceSnapshot['checkIn'] ?? '';
        String checkOut = attendanceSnapshot['checkOut'] ?? '';
        DateTime today = DateTime.now();
        DateTime checkInDate =
            checkIn.isNotEmpty ? DateTime.parse(checkIn) : DateTime(2000);

        if (_isSameDay(today, checkInDate)) {
          setState(() {
            _isCheckedIn = checkIn.isNotEmpty;
            _checkInTime = checkIn;
            _isCheckedOut = checkOut.isNotEmpty;
            _checkOutTime = checkOut;
          });
        }
      }
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> _logout() async {
    await AuthService().signOut(context);
  }

  Future<String> _getAddressFromLatLng(double lat, double lng) async {
    final String url =
        "https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng";

    try {
      final response = await http
          .get(Uri.parse(url), headers: {"User-Agent": "AttendanceApp/1.0"});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['display_name'] ?? "Address not found";
      } else {
        return "Failed to fetch address";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  Future<void> _markAttendance() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String currentTime = DateTime.now().toIso8601String();
    User? user = _auth.currentUser;

    if (user != null) {
      // Fetch user details from 'users' collection
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(user.uid).get();
      String userName = userSnapshot.exists ? userSnapshot['name'] : 'Employee';

      String formattedAddress =
          await _getAddressFromLatLng(position.latitude, position.longitude);

      DocumentReference attendanceRef =
          _firestore.collection('attendance').doc(user.uid);
      DocumentSnapshot attendanceSnapshot = await attendanceRef.get();

      if (!attendanceSnapshot.exists ||
          (attendanceSnapshot.exists &&
              !_isSameDay(DateTime.parse(attendanceSnapshot['checkIn']),
                  DateTime.now()))) {
        // New day - Check-in
        await attendanceRef.set({
          'name': userName,
          'checkIn': currentTime,
          'checkOut': null,
          'location': {
            'latitude': position.latitude,
            'longitude': position.longitude,
            'address': formattedAddress
          },
          'late': DateTime.now().hour > 9,
        });
        setState(() {
          _isCheckedIn = true;
          _isCheckedOut = false;
          _checkInTime = currentTime;
          _checkOutTime = '';
        });
      } else if (!_isCheckedOut) {
        // Check-out
        await attendanceRef.update({
          'checkOut': currentTime,
        });
        setState(() {
          _isCheckedOut = true;
          _checkOutTime = currentTime;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isCheckedIn)
              Text('Checked in at: $_checkInTime',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            if (_isCheckedOut)
              Text('Checked out at: $_checkOutTime',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            if (!_isCheckedIn) // Show Check-in button only if not checked in
              ElevatedButton(
                onPressed: _markAttendance,
                child: Text('Check In'),
              ),
            if (_isCheckedIn && !_isCheckedOut) // Show Check-out button
              ElevatedButton(
                onPressed: _markAttendance,
                child: Text('Check Out'),
              ),
          ],
        ),
      ),
    );
  }
}
