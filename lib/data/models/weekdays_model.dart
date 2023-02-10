class WeekdaysModel {
  late int value;
  late String label;
  bool selected = false;

  WeekdaysModel(this.value, this.label);

  WeekdaysModel.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['label'] = this.label;

    return data;
  }
}
