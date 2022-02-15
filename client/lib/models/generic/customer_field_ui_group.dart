class CustomerFieldUIGroup {
  String? name;
  String? title;
  int? displayOrder;

  CustomerFieldUIGroup({this.name, this.title, this.displayOrder});

  CustomerFieldUIGroup.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    title = json['Title'];
    displayOrder = json['DisplayOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Title'] = this.title;
    data['DisplayOrder'] = this.displayOrder;
    return data;
  }
}
