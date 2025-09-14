extension EnumToString on Enum {
  /// get string value from enum
  String get value => toString().split('.').last;
}
