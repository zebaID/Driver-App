class NewsModel {
  int? id;
  String? newsHtml;
  String? news;
  String? operationCityId;
  String? createdBy;
  String? createdDate;
  String? updatedBy;
  String? updatedDate;

  NewsModel({
    this.id,
    this.newsHtml,
    this.news,
    this.operationCityId,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
  });

  NewsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    newsHtml = json['NewsHtml'];
    news = json['News'];
    operationCityId = json['operationCityId'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    updatedBy = json['updatedBy'];
    updatedDate = json['updatedDate'];
    operationCityId = json['operation_city_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['NewsHtml'] = this.newsHtml;
    data['News'] = this.news;
    data['operationCityId'] = this.operationCityId;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['updatedBy'] = this.updatedBy;
    data['updatedDate'] = this.updatedDate;
    data['operation_city_id'] = this.operationCityId;
    return data;
  }
}
