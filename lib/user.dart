// user_model.dart

class User {
  final String memId;
  final String memName;
  final String memMobileNo;
  final String? fName;
  final String? mName;
  final String? preAddr;
  final String? prePhone;
  final String? preEmail;
  final String? perAddr;
  final String? perPhone;
  final String? perEmail;
  final String? officeName;
  final String? offAddr;
  final String? offPhone;
  final String? offEmail;
  final String? dob;
  final String? designation;
  final String? memPhoto;
  final String? collRollNo;
  final String? yrOfPass;

  User({
    required this.memId,
    required this.memName,
    required this.memMobileNo,
    this.fName,
    this.mName,
    this.preAddr,
    this.prePhone,
    this.preEmail,
    this.perAddr,
    this.perPhone,
    this.perEmail,
    this.officeName,
    this.offAddr,
    this.offPhone,
    this.offEmail,
    this.dob,
    this.designation,
    this.memPhoto,
    this.collRollNo,
    this.yrOfPass,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      memId: json['MEM_ID'] ?? '',
      memName: json['MEM_NAME'] ?? '',
      memMobileNo: json['MEM_MOBILE_NO'] ?? '',
      fName: json['F_NAME'],
      mName: json['M_NAME'],
      preAddr: json['PRE_ADDR'],
      prePhone: json['PRE_PHONE'],
      preEmail: json['PRE_EMAIL'],
      perAddr: json['PER_ADDR'],
      perPhone: json['PER_PHONE'],
      perEmail: json['PER_EMAIL'],
      officeName: json['OFFICE_NAME'],
      offAddr: json['OFF_ADDR'],
      offPhone: json['OFF_PHONE'],
      offEmail: json['OFF_EMAIL'],
      dob: json['DOB'],
      designation: json['DESIGNATION'],
      memPhoto: json['MEM_PHOTO']?.toString(),
      collRollNo: json['COLL_ROLL_NO'],
      yrOfPass: json['YR_OF_PASS'],
    );
  }
}
