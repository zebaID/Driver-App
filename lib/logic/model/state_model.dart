class StatesModel {
  late int id;
  late String stateName;
  late String rtoCode;

  StatesModel(this.id, this.stateName, this.rtoCode);

  StatesModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        stateName = json['stateName'],
        rtoCode = json['rtoCode'];

  Map<String, dynamic> toJson() =>
      {'id': id, 'stateName': stateName, 'rtoCode': rtoCode};

  static List<StatesModel> fromJsonList(List list) {
    return list.map((item) => StatesModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '${this.stateName}';
  }

  @override
  String toString() => stateName;
}
