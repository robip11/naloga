import 'item.dart';

List<Item> _checkedItemsList = [];
List<Item> _uncheckedItemsList = [];
List<Item> _itemsList = [];

List<Item> get checkedItemsList => _checkedItemsList;
List<Item> get uncheckedItemsList => _uncheckedItemsList;
List<Item> get itemsList => _itemsList;

set checkedItemsList(List<Item> list) {
  _checkedItemsList = list;
}

set uncheckedItemsList(List<Item> list) {
  _uncheckedItemsList = list;
}

set itemsList(List<Item> list) {
  _itemsList = list;
}