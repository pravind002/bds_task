class ParkingRecord {
  final int? id;
  final String carNumber;
  final DateTime checkInTime;
  final double checkInLatitude;
  final double checkInLongitude;
  final DateTime? checkOutTime;
  final double? checkOutLatitude;
  final double? checkOutLongitude;

  ParkingRecord({
    this.id,
    required this.carNumber,
    required this.checkInTime,
    required this.checkInLatitude,
    required this.checkInLongitude,
    this.checkOutTime,
    this.checkOutLatitude,
    this.checkOutLongitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'carNumber': carNumber,
      'checkInTime': checkInTime.toIso8601String(),
      'checkInLatitude': checkInLatitude,
      'checkInLongitude': checkInLongitude,
      'checkOutTime': checkOutTime?.toIso8601String(),
      'checkOutLatitude': checkOutLatitude,
      'checkOutLongitude': checkOutLongitude,
    };
  }

  factory ParkingRecord.fromMap(Map<String, dynamic> map) {
    return ParkingRecord(
      id: map['id'],
      carNumber: map['carNumber'],
      checkInTime: DateTime.parse(map['checkInTime']),
      checkInLatitude: map['checkInLatitude'],
      checkInLongitude: map['checkInLongitude'],
      checkOutTime: map['checkOutTime'] != null ? DateTime.parse(map['checkOutTime']) : null,
      checkOutLatitude: map['checkOutLatitude'],
      checkOutLongitude: map['checkOutLongitude'],
    );
  }
}