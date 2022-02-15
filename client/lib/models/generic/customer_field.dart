import 'customer_field_ui_group.dart';

class CustomerField {
  String? name;
  String? defaultText;
  String? type;
  String? title;
  bool? isNative;
  bool? isRequired;
  int? displayOrder;
  CustomerFieldUIGroup? uIGroup;
  List<String?>? possibleValues;
  CustomerFieldType get fieldType {
    var result = CustomerFieldType.Text;
    CustomerFieldType.values.forEach((fieldType) {
      if (fieldType.isParsed(type!)) {
        result = fieldType;
      }
    });
    return result;
  }

  bool get hasText =>
      fieldType == CustomerFieldType.Text ||
      fieldType == CustomerFieldType.Complex ||
      fieldType == CustomerFieldType.Email ||
      fieldType == CustomerFieldType.PhoneNumber;

  CustomerField(
      {this.name,
      this.type,
      this.title,
      this.isNative,
      this.isRequired,
      this.displayOrder,
      this.uIGroup,
      this.possibleValues});

  CustomerField.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    type = json['Type'];
    title = json['Title'];
    isNative = json['IsNative'];
    isRequired = json['IsRequired'] ?? false;
    displayOrder = json['DisplayOrder'];
    uIGroup = json['UIGroup'] != null
        ? new CustomerFieldUIGroup.fromJson(json['UIGroup'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Type'] = this.type;
    data['Title'] = this.title;
    data['IsNative'] = this.isNative;
    data['IsRequired'] = this.isRequired;
    data['DisplayOrder'] = this.displayOrder;
    if (this.uIGroup != null) {
      data['UIGroup'] = this.uIGroup!.toJson();
    }
    return data;
  }
}

enum CustomerFieldType {
  Text,
  CheckBox,
  ComboBox,
  Radio,
  CheckboxGroup,
  Complex,
  Date,
  PhoneNumber,
  GDPR,
  Address,
  City,
  Country,
  Email,
  Town,
  District,
  ZipCode
}

extension CustomerFieldTypeParser on CustomerFieldType {
  bool isParsed(String val) {
    return equalsIgnoreCase(this.toString().split('.').elementAt(1), val);
  }
}

bool equalsIgnoreCase(String string1, String string2) {
  return string1.toLowerCase() == string2.toLowerCase();
}
