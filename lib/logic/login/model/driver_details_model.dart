class DriverDetailsModel {
  int? id;
  int? conuserId;
  String? isLuxury;
  String? permanentAddress;
  String? bankName;
  String? accountNumber;
  String? ifscCode;
  String? micrCode;
  bool? pv;
  bool? cpv;
  String? emergencyNumber;
  String? trDate;
  String? ntDate;
  String? driverBatch;
  String? freeAddress;
  String? driverCode;
  String? remark;
  String? createdBy;
  String? createdDate;
  String? updatedBy;
  String? updatedDate;
  String? bDate;
  double? experience;
  String? jobStatus;
  String? pvExpiryDate;
  String? cpvDate;
  String? licenseDate;
  String? vehicle;
  bool? driverTraining;
  String? driverStatus;
  String? testScore;
  String? interviewStatus;
  bool? fitnessCertificate;
  String? dOF;
  String? interviewLink;
  String? interview;
  ConUsers? conUsers;
  List<DriverAccount>? driverAccount;

  DriverDetailsModel(
      {this.id,
      this.conuserId,
      this.isLuxury,
      this.permanentAddress,
      this.bankName,
      this.accountNumber,
      this.ifscCode,
      this.micrCode,
      this.pv,
      this.cpv,
      this.emergencyNumber,
      this.trDate,
      this.ntDate,
      this.driverBatch,
      this.freeAddress,
      this.driverCode,
      this.remark,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.bDate,
      this.experience,
      this.jobStatus,
      this.pvExpiryDate,
      this.cpvDate,
      this.licenseDate,
      this.vehicle,
      this.driverTraining,
      this.driverStatus,
      this.testScore,
      this.interviewStatus,
      this.fitnessCertificate,
      this.dOF,
      this.interviewLink,
      this.interview,
      this.conUsers,
      this.driverAccount});

  DriverDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    conuserId = json['conuserId'];
    isLuxury = json['isLuxury'];
    permanentAddress = json['permanentAddress'];
    bankName = json['bankName'];
    accountNumber = json['accountNumber'];
    ifscCode = json['ifscCode'];
    micrCode = json['micrCode'];
    pv = json['pv'];
    cpv = json['cpv'];
    emergencyNumber = json['emergencyNumber'];
    trDate = json['trDate'];
    ntDate = json['ntDate'];
    driverBatch = json['driverBatch'];
    freeAddress = json['freeAddress'];
    driverCode = json['driverCode'];
    remark = json['remark'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
    bDate = json['BDate'];
    experience = json['Experience'];
    jobStatus = json['jobStatus'];
    pvExpiryDate = json['pvExpiryDate'];
    cpvDate = json['cpvDate'];
    licenseDate = json['licenseDate'];
    vehicle = json['vehicle'];
    driverTraining = json['driverTraining'];
    driverStatus = json['driverStatus'];
    testScore = json['testScore'];
    interviewStatus = json['InterviewStatus'];
    fitnessCertificate = json['fitnessCertificate'];
    dOF = json['DOF'];
    interviewLink = json['InterviewLink'];
    interview = json['Interview'];
    conUsers = json['conUsers'] != null
        ? new ConUsers.fromJson(json['conUsers'])
        : null;
    if (json['driverAccount'] != null) {
      driverAccount = <DriverAccount>[];
      json['driverAccount'].forEach((v) {
        driverAccount!.add(new DriverAccount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['conuserId'] = this.conuserId;
    data['isLuxury'] = this.isLuxury;
    data['permanentAddress'] = this.permanentAddress;
    data['bankName'] = this.bankName;
    data['accountNumber'] = this.accountNumber;
    data['ifscCode'] = this.ifscCode;
    data['micrCode'] = this.micrCode;
    data['pv'] = this.pv;
    data['cpv'] = this.cpv;
    data['emergencyNumber'] = this.emergencyNumber;
    data['trDate'] = this.trDate;
    data['ntDate'] = this.ntDate;
    data['driverBatch'] = this.driverBatch;
    data['freeAddress'] = this.freeAddress;
    data['driverCode'] = this.driverCode;
    data['remark'] = this.remark;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['updatedBy'] = this.updatedBy;
    data['updatedDate'] = this.updatedDate;
    data['BDate'] = this.bDate;
    data['Experience'] = this.experience;
    data['jobStatus'] = this.jobStatus;
    data['pvExpiryDate'] = this.pvExpiryDate;
    data['cpvDate'] = this.cpvDate;
    data['licenseDate'] = this.licenseDate;
    data['vehicle'] = this.vehicle;
    data['driverTraining'] = this.driverTraining;
    data['driverStatus'] = this.driverStatus;
    data['testScore'] = this.testScore;
    data['InterviewStatus'] = this.interviewStatus;
    data['fitnessCertificate'] = this.fitnessCertificate;
    data['DOF'] = this.dOF;
    data['InterviewLink'] = this.interviewLink;
    data['Interview'] = this.interview;
    if (this.conUsers != null) {
      data['conUsers'] = this.conUsers!.toJson();
    }
    if (this.driverAccount != null) {
      data['driverAccount'] =
          this.driverAccount!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ConUsers {
  int? id;
  String? firstName;
  String? middleName;
  String? lastName;
  String? email;
  String? username;
  bool? isActive;
  String? otp;
  String? mobileNumber;
  String? address;
  String? addressLine2;
  String? userDevice;
  double? addressLat;
  double? addressLong;
  String? varificationToken;
  String? createdBy;
  String? createdDate;
  String? updatedBy;
  String? updatedDate;
  String? operationCity;
  String? realm;
  String? credentials;
  String? challenges;
  bool? emailVerified;
  String? verificationToken;
  String? status;
  String? created;
  String? lastUpdated;

  ConUsers(
      {this.id,
      this.firstName,
      this.middleName,
      this.lastName,
      this.email,
      this.username,
      this.isActive,
      this.otp,
      this.mobileNumber,
      this.address,
      this.addressLine2,
      this.userDevice,
      this.addressLat,
      this.addressLong,
      this.varificationToken,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.operationCity,
      this.realm,
      this.credentials,
      this.challenges,
      this.emailVerified,
      this.verificationToken,
      this.status,
      this.created,
      this.lastUpdated});

  ConUsers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    email = json['email'];
    username = json['username'];
    isActive = json['isActive'];
    otp = json['otp'];
    mobileNumber = json['mobileNumber'];
    address = json['address'];
    addressLine2 = json['addressLine2'];
    userDevice = json['userDevice'];
    addressLat = json['addressLat'].runtimeType == int
        ? double.parse(json['addressLat'].toString())
        : json['addressLat'];
    addressLong = json['addressLong'].runtimeType == int
        ? double.parse(json['addressLong'].toString())
        : json['addressLong'];
    varificationToken = json['varificationToken'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
    operationCity = json['operationCity'];
    realm = json['realm'];
    credentials = json['credentials'];
    challenges = json['challenges'];
    emailVerified = json['emailVerified'];
    verificationToken = json['verificationToken'];
    status = json['status'];
    created = json['created'];
    lastUpdated = json['lastUpdated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['middleName'] = this.middleName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['username'] = this.username;
    data['isActive'] = this.isActive;
    data['otp'] = this.otp;
    data['mobileNumber'] = this.mobileNumber;
    data['address'] = this.address;
    data['addressLine2'] = this.addressLine2;
    data['userDevice'] = this.userDevice;
    data['addressLat'] = this.addressLat;
    data['addressLong'] = this.addressLong;
    data['varificationToken'] = this.varificationToken;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['updatedBy'] = this.updatedBy;
    data['updatedDate'] = this.updatedDate;
    data['operationCity'] = this.operationCity;
    data['realm'] = this.realm;
    data['credentials'] = this.credentials;
    data['challenges'] = this.challenges;
    data['emailVerified'] = this.emailVerified;
    data['verificationToken'] = this.verificationToken;
    data['status'] = this.status;
    data['created'] = this.created;
    data['lastUpdated'] = this.lastUpdated;
    return data;
  }
}

class DriverAccount {
  int? id;
  String? driverId;
  double? balance;
  String? createdBy;
  String? createdDate;
  String? updatedBy;
  String? updatedDate;

  DriverAccount(
      {this.id,
      this.driverId,
      this.balance,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate});

  DriverAccount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverId = json['driverId'];
    balance = json['balance'].runtimeType == int
        ? double.parse(json['balance'].toString())
        : json['balance'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['driverId'] = this.driverId;
    data['balance'] = this.balance;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['updatedBy'] = this.updatedBy;
    data['updatedDate'] = this.updatedDate;
    return data;
  }
}
