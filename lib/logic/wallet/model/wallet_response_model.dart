class WalletResponseModel {
  int? id;
  String? accountId;
  String? description;
  double? amount;
  String? createdBy;
  String? createdDate;
  String? updatedBy;
  String? updatedDate;
  String? transactionStatus;
  String? rechargeTransactionId;
  String? orderId;
  double? balance;

  WalletResponseModel(
      {this.id,
      this.accountId,
      this.description,
      this.amount,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.transactionStatus,
      this.rechargeTransactionId,
      this.orderId,
      this.balance});

  WalletResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accountId = json['accountId'];
    description = json['description'];
    amount = json['amount'].runtimeType == int
        ? double.parse(json['amount'].toString())
        : json['amount'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
    transactionStatus = json['transactionStatus'];
    rechargeTransactionId = json['rechargeTransactionId'];
    orderId = json['orderId'];
    balance = json['Balance'].runtimeType == int
        ? double.parse(json['Balance'].toString())
        : json['Balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['accountId'] = this.accountId;
    data['description'] = this.description;
    data['amount'] = this.amount;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['updatedBy'] = this.updatedBy;
    data['updatedDate'] = this.updatedDate;
    data['transactionStatus'] = this.transactionStatus;
    data['rechargeTransactionId'] = this.rechargeTransactionId;
    data['orderId'] = this.orderId;
    data['Balance'] = this.balance;
    return data;
  }
}
