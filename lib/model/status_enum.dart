import 'package:schoosch/generated/l10n.dart';

enum StatusModel {
  inactive,
  active;

  static const _inactive = 0;
  static const _active = 1;

  static StatusModel parse(int value) {
    switch (value) {
      case _inactive:
        return StatusModel.inactive;
      case _active:
        return StatusModel.active;
      default:
        throw 'unkown type';
    }
  }

  int get nameInt {
    switch (this) {
      case StatusModel.inactive:
        return _inactive;
      case StatusModel.active:
        return _active;
    }
  }

  String localizedName(S S) {
    switch (this) {
      case StatusModel.inactive:
        return S.statusInactive;
      case StatusModel.active:
        return S.statusActive;
    }
  }
}
