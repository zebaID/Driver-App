class RateCardModel {
  int? id;
  String? rateCardHtml;
  String? rateCard;
  int? localBase;
  int? localOvertime;
  int? outstationBase;
  int? outstationOvertime;
  Null? createdBy;
  String? createdDate;
  Null? updatedBy;
  String? updatedDate;
  String? operationCityId;
  String? type;

  RateCardModel({
    this.id,
    this.rateCardHtml,
    this.rateCard,
    this.localBase,
    this.localOvertime,
    this.outstationBase,
    this.outstationOvertime,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.operationCityId,
    this.type,
  });

  RateCardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rateCardHtml = json['rateCardHtml'];
    rateCard = json['rateCard'];
    localBase = json['localBase'];
    localOvertime = json['localOvertime'];
    outstationBase = json['outstationBase'];
    outstationOvertime = json['outstationOvertime'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
    operationCityId = json['operationCityId'];
    type = json['type'];
    operationCityId = json['operation_city_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rateCardHtml'] = this.rateCardHtml;
    data['rateCard'] = this.rateCard;
    data['localBase'] = this.localBase;
    data['localOvertime'] = this.localOvertime;
    data['outstationBase'] = this.outstationBase;
    data['outstationOvertime'] = this.outstationOvertime;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['updatedBy'] = this.updatedBy;
    data['updatedDate'] = this.updatedDate;
    data['operationCityId'] = this.operationCityId;
    data['type'] = this.type;
    data['operation_city_id'] = this.operationCityId;
    return data;
  }
}
