extension CapitalizeExt on String {
  String toCapitalize() => this[0].toUpperCase() + substring(1).toLowerCase();
}
