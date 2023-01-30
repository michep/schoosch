import 'package:schoosch/generated/l10n.dart';

enum ModelStatus {
  inactive,
  active;

  static const _inactive = 0;
  static const _active = 1;

  static ModelStatus parse(int value) {
    switch (value) {
      case _inactive:
        return ModelStatus.inactive;
      case _active:
        return ModelStatus.active;
      default:
        throw 'unkown type';
    }
  }

  int get nameInt {
    switch (this) {
      case ModelStatus.inactive:
        return _inactive;
      case ModelStatus.active:
        return _active;
    }
  }

  String localizedName(S S) {
    switch (this) {
      case ModelStatus.inactive:
        return S.statusInactive;
      case ModelStatus.active:
        return S.statusActive;
    }
  }
}
