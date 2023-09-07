
import 'package:flutter/material.dart';

import '../helpers/colors.dart';
import '../helpers/custom_widgets.dart';
import '../helpers/database_helper.dart';
import '../helpers/helpers.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();

  void _clearOldRecords() async {
    await dbHelper.clearOldRecords();
    setState(() {});
  }

  void _checkOut(ParkingRecord record) async {
    if (record.checkOutTime == null) {
      final checkOutTime = DateTime.now();
      const checkOutLatitude = 0.0;
      const checkOutLongitude = 0.0;

      record.checkOutTime = checkOutTime;
      record.checkOutLatitude = checkOutLatitude;
      record.checkOutLongitude = checkOutLongitude;

      await dbHelper.updateRecord(record);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar('HISTORY'),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<ParkingRecord>>(
              future: dbHelper.getAllRecords(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No records found.'));
                } else {
                  final records = snapshot.data;
                  return ListView.builder(
                    itemCount: records!.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return record.checkOutTime != null
                          ? Container(
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: whiteColor.withOpacity(.2),),
                            child: ListTile(
                              title:
                                  customText('Car Number: ${record.carNumber}',color: whiteColor,fontsize: 20),
                              subtitle: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  customText(
                                      'Check-In Time: ${record.checkInTime}'),
                                  customText(
                                      'Check-Out Time: ${record.checkOutTime ?? 'N/A'}'),
                                  customText(
                                      'Check-In GPS: ${record.checkInLatitude}, ${record.checkInLongitude}'),
                                  customText(
                                      'Check-Out GPS: ${record.checkOutLatitude ?? 'N/A'}, ${record.checkOutLongitude ?? 'N/A'}'),
                                ],
                              ),
                              trailing: record.checkOutTime == null
                                  ? ElevatedButton(
                                      onPressed: () => _checkOut(record),
                                      child: const Text('Check-Out'),
                                    )
                                  : null,
                            ),
                          )
                          : Container();
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
