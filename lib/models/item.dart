class Item {
  String _name;
  bool _isChecked;

  Item(this._name, this._isChecked);

  String get name => _name;
  bool get isChecked => _isChecked;

  set name(String value) {
    _name = value;
  }

  set isChecked(bool value) {
    _isChecked = value;
  }
}
