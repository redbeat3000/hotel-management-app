class AttendanceModel {
  final int? id;
  final int staffId;
  final String checkInTime;
  final String checkOutTime;
  final String duration;
  final String date;

  AttendanceModel({
    this.id,
    required this.staffId,
    required this.checkInTime,
    required this.checkOutTime,
    required this.duration,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'staffId': staffId,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'duration': duration,
      'date': date,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      id: map['id'],
      staffId: map['staffId'],
      checkInTime: map['checkInTime'],
      checkOutTime: map['checkOutTime'],
      duration: map['duration'],
      date: map['date'],
    );
  }
}
