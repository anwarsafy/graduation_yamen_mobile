class QRData {
  final String doctorName;
  final String subjectName; // "اسم المادة"
  final String levelName;
  final String location; // current location in "lat,long" format
  final String userId;
  final String email;
  final String qrID;

  QRData({
    required this.doctorName,
    required this.subjectName,
    required this.levelName,
    required this.location,
    required this.userId,
    required this.email,
    required this.qrID,
  });

  // Convert to a map for Firebase storage
  Map<String, dynamic> toMap() {
    return {
      'doctorName': doctorName,
      'subjectName': subjectName,
      'levelName': levelName,
      'location': location,
      'userId': userId,
      'email': email,
      'qrID': qrID,
    };
  }

  // Create a QRData object from Firebase data
  factory QRData.fromMap(Map<String, dynamic> map) {
    return QRData(
      doctorName: map['doctorName'] ?? '',
      subjectName: map['subjectName'] ?? '',
      levelName: map['levelName'] ?? '',
      location: map['location'] ?? '',
      userId: map['userId'] ?? '',
      email: map['email'] ?? '',
      qrID: map['qrID'] ?? '',
    );
  }
}
