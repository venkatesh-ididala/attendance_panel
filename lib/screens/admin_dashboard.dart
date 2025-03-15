// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
// import '../services/auth_services.dart';

// class AdminDashboard extends StatefulWidget {
//   const AdminDashboard({super.key});

//   @override
//   _AdminDashboardState createState() => _AdminDashboardState();
// }

// class _AdminDashboardState extends State<AdminDashboard> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Future<void> _logout() async {
//   //   try {
//   //     await AuthService().signOut();
//   //     if (mounted) {
//   //       Navigator.pushReplacementNamed(context, '/login');
//   //     }
//   //   } catch (e) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text("Logout failed. Please try again.")),
//   //     );
//   //   }
//   // }

//   Future<void> _logout() async {
//     await AuthService().signOut(context);
//   }

//   double calculateSalaryDeduction(DateTime checkInTime) {
//     int lateMinutes = checkInTime.hour > 9
//         ? (checkInTime.hour - 9) * 60 + checkInTime.minute
//         : 0;
//     return (lateMinutes > 0) ? (lateMinutes / 60.0) * 10.0 : 0.0;
//   }

//   String formatTime(String? dateTimeString) {
//     if (dateTimeString == null || dateTimeString.isEmpty) return 'Pending';
//     DateTime dateTime = DateTime.parse(dateTimeString);
//     return DateFormat('hh:mm a').format(dateTime); // 12-hour format
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin Dashboard'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: _logout,
//           ),
//         ],
//       ),
//       body: StreamBuilder(
//         stream: _firestore.collection('attendance').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }

//           var attendanceData = snapshot.data!.docs;

//           return SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Container(
//               margin: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey.shade400),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: DataTable(
//                 columnSpacing: 20,
//                 border: TableBorder.all(
//                   color: Colors.grey.shade400,
//                   width: 1,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 columns: [
//                   DataColumn(
//                       label: Text('Name',
//                           style: TextStyle(fontWeight: FontWeight.bold))),
//                   DataColumn(
//                       label: Text('Check-In',
//                           style: TextStyle(fontWeight: FontWeight.bold))),
//                   DataColumn(
//                       label: Text('Check-Out',
//                           style: TextStyle(fontWeight: FontWeight.bold))),
//                   DataColumn(
//                       label: Text('Location',
//                           style: TextStyle(fontWeight: FontWeight.bold))),
//                   DataColumn(
//                       label: Text('Salary Deduction',
//                           style: TextStyle(fontWeight: FontWeight.bold))),
//                   DataColumn(
//                       label: Text('Late',
//                           style: TextStyle(fontWeight: FontWeight.bold))),
//                 ],
//                 rows: attendanceData.map((record) {
//                   DateTime checkInTime = DateTime.parse(record['checkIn']);
//                   double salaryDeduction =
//                       calculateSalaryDeduction(checkInTime);
//                   String formattedAddress =
//                       record['location']?['address'] ?? 'Address not available';

//                   return DataRow(cells: [
//                     DataCell(Text(record['name'])),
//                     DataCell(Text(formatTime(record['checkIn']))),
//                     DataCell(Text(formatTime(record['checkOut'] ?? ''))),
//                     DataCell(Text(formattedAddress,
//                         overflow: TextOverflow.ellipsis, maxLines: 2)),
//                     DataCell(Text('\$${salaryDeduction.toStringAsFixed(2)}')),
//                     DataCell(
//                       record['late']
//                           ? Icon(Icons.warning, color: Colors.red)
//                           : Icon(Icons.check, color: Colors.green),
//                     ),
//                   ]);
//                 }).toList(),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../services/auth_services.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _logout() async {
    await AuthService().signOut(context);
  }

  double calculateSalaryDeduction(DateTime checkInTime) {
    int lateMinutes = checkInTime.hour > 9
        ? (checkInTime.hour - 9) * 60 + checkInTime.minute
        : 0;
    return (lateMinutes > 0) ? (lateMinutes / 60.0) * 10.0 : 0.0;
  }

  String formatTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return 'Pending';
    DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat('hh:mm a').format(dateTime); // 12-hour format
  }

  String formatDate(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return 'N/A';
    DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat('yyyy-MM-dd').format(dateTime); // Date format
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _firestore
            .collection('attendance')
            .orderBy('checkIn',
                descending: true) // Sorting by date & time in descending order
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var attendanceData = snapshot.data!.docs;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DataTable(
                columnSpacing: 20,
                border: TableBorder.all(
                  color: Colors.grey.shade400,
                  width: 1,
                  borderRadius: BorderRadius.circular(8),
                ),
                columns: [
                  DataColumn(
                      label: Text('Name',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Date',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Check-In',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Check-Out',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Location',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Salary Deduction',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Late',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: attendanceData.map((record) {
                  DateTime checkInTime = DateTime.parse(record['checkIn']);
                  double salaryDeduction =
                      calculateSalaryDeduction(checkInTime);
                  String formattedAddress =
                      record['location']?['address'] ?? 'Address not available';

                  return DataRow(cells: [
                    DataCell(Text(record['name'])),
                    DataCell(
                        Text(formatDate(record['checkIn']))), // New Date Column
                    DataCell(Text(formatTime(record['checkIn']))),
                    DataCell(Text(formatTime(record['checkOut'] ?? ''))),
                    DataCell(Text(formattedAddress,
                        overflow: TextOverflow.ellipsis, maxLines: 2)),
                    DataCell(Text('\$${salaryDeduction.toStringAsFixed(2)}')),
                    DataCell(
                      record['late']
                          ? Icon(Icons.warning, color: Colors.red)
                          : Icon(Icons.check, color: Colors.green),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
