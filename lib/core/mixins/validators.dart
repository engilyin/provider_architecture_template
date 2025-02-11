import 'package:provider_start/core/constant/local_keys.dart';

/// Class of validation functions that the app will use
///   - This class should be used as a mixin using the `with` keyword
class Validators {
  static final phoneNumberRegExp = RegExp(
      r'^([0-9]( |-)?)?(\(?[0-9]{3}\)?|[0-9]{3})( |-)?([0-9]{3}( |-)?[0-9]{4}|[a-zA-Z0-9]{7})$');
  static final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  static final zipCodeRegExp = RegExp(r'^[0-9]{5}(?:-[0-9]{4})?$');

  static String? validateEmail(String value) {
    if (!emailRegExp.hasMatch(value.trim())) {
      return LocalKeys.invalid_email;
    }
    return null;
  }

  static String? validatePhoneNumber(String value) {
    if (!phoneNumberRegExp.hasMatch(value.trim())) {
      return LocalKeys.invalid_phone_number;
    }
    return null;
  }

  static String? validateZip(String value) {
    if (!zipCodeRegExp.hasMatch(value.trim())) {
      return LocalKeys.invalid_zip_code;
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (value.trim().isEmpty) {
      return LocalKeys.password_empty;
    } else if (value.length <= 6) {
      return LocalKeys.password_short;
    }
    return null;
  }
}
