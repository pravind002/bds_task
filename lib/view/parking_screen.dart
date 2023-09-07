
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/colors.dart';
import '../helpers/custom_widgets.dart';
import '../helpers/database_helper.dart';
import '../helpers/geo_services.dart';
import '../helpers/helpers.dart';
import 'history_screen.dart';

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key});

  @override
  _ParkingScreenState createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  TextEditingController carNumberController = TextEditingController();

  void _startLocationService() async {
    LocationService().initialize();

    LocationService().getLongitude().then((value) {
      setState(() {
        logitud = value!;
      });

      LocationService().getLatitude().then((value) {
        setState(() {
          latitude = value!;
        });
      });
    });
  }

  String location = '';
  void _getLocation() async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(latitude, logitud);

    setState(() {
      location =
          '${placemark[0].street},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country},';
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    _startLocationService();
    super.initState();
  }

  var latitude = 0.0;
  var logitud = 0.0;

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      
    )) {
      throw Exception('Could not launch $url');
    }
  }

  void _checkIn() async {
   
    final checkInTime = DateTime.now();
    var checkInLatitude = latitude;
    var checkInLongitude = logitud;

    final record = ParkingRecord(
      carNumber: carNumberController.text,
      checkInTime: checkInTime,
      checkInLatitude: checkInLatitude,
      checkInLongitude: checkInLongitude,
    );

    await dbHelper.insertRecord(record);
    setState(() {
      carNumberController.clear();
    });
    _getLocation();
  }

  void _showHistory() {
    Get.to(() => const HistoryScreen());
  }

  void checkOut(ParkingRecord record) async {
    if (record.checkOutTime == null) {
      final checkOutTime = DateTime.now();

      record.checkOutTime = checkOutTime;
      record.checkOutLatitude = latitude;
      record.checkOutLongitude = logitud;

      await dbHelper.updateRecord(record);
      setState(() {});
    }
    _getLocation();
  }

  ParkingRecord record = ParkingRecord(
      checkInTime: DateTime.now(), checkInLatitude: 0.0, checkInLongitude: 0.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appbar('PARKING  HUB'),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: carNumberController,
                style: const TextStyle(color: whiteColor),
               decoration:  InputDecoration(
          label:customText('Car Number',color: whiteColor) ,hintText: 'Enter  Car Number',
          labelStyle: const TextStyle(color: Colors.white), 
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white), 
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
              ),
              const SizedBox(
                height: 50,
              ),
            
              InkWell(
                  onTap: _checkIn,
                  child: button('CHECK IN',
                      width: MediaQuery.of(context).size.width)),
                        const SizedBox(height: 40,),
              Align(alignment: Alignment.centerLeft,
                child: customText('Pending Check Out Lists',color: whiteColor,fontsize: 25),
              ),
              
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
                      if(records!.isEmpty){
                        return customText('No Data Found!!');
                      }else{
                      return ListView.builder(
                        itemCount: records.length,
                        itemBuilder: (context, index) {
                          final record = records[index];
                          return record.checkOutTime == null
                              ? Container(
                                  padding: const EdgeInsets.all(15),
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: whiteColor.withOpacity(.2),
                                  ),
                                  child: ListTile(
                                    title:
                                        customText('Car Number: ${record.carNumber}',color: whiteColor),
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
                                        ? 
                                     
                                         InkWell(
                                            onTap: () => checkOut(record),
                                            child:
                                                button('CHECK OUT', fontsize: 14))
                                        : null,
                                  ),
                                )
                              : Center(child: customText('No List Available'));
                        },
                      );
                    }
                   } },
                ),
              ),
            ],
          ),
        ),
       
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          onPressed: _showHistory,tooltip: 'History',
          backgroundColor: whiteColor.withOpacity(.2),
          child: const Icon(
            Icons.history,
            color: whiteColor,
          ),
        )


        );
  }
}
