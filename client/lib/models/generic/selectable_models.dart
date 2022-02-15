import 'package:get/get.dart';

class SelectableItemModel {
  final String text;
  final String? detailedText;
  final dynamic item;
  SelectableItemModel(this.text, this.item, {this.detailedText});
}

class SelectableListModel extends DisposableInterface {
  final String title;
  final List<SelectableItemModel>? items;
  final Rx<SelectableItemModel>? selectedItem;
  final Function(dynamic)? onValueChanged;
  bool get isEmpty => items == null || items!.isEmpty;
  SelectableListModel(this.title,
      {this.items, this.selectedItem, this.onValueChanged});
}
