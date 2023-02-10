class CustomerDetailsModel {
  int? id;
  int? conuserId;
  String? createdBy;
  String? createdDate;
  String? updatedBy;
  String? updatedDate;
  String? customerType;
  String? remark;
  Null? company2CustomerId;
  String? requirementStatus;
  ConUsers? conUsers;

  CustomerDetailsModel(
      {this.id,
      this.conuserId,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.customerType,
      this.remark,
      this.company2CustomerId,
      this.requirementStatus,
      this.conUsers});

  CustomerDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    conuserId = json['conuserId'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
    customerType = json['customerType'];
    remark = json['remark'];
    company2CustomerId = json['company2CustomerId'];
    requirementStatus = json['requirementStatus'];
    conUsers = json['conUsers'] != null
        ? new ConUsers.fromJson(json['conUsers'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['conuserId'] = this.conuserId;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['updatedBy'] = this.updatedBy;
    data['updatedDate'] = this.updatedDate;
    data['customerType'] = this.customerType;
    data['remark'] = this.remark;
    data['company2CustomerId'] = this.company2CustomerId;
    data['requirementStatus'] = this.requirementStatus;
    if (this.conUsers != null) {
      data['conUsers'] = this.conUsers!.toJson();
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
