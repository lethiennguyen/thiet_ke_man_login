import 'package:flutter/cupertino.dart';

enum LoginField { tax_code, user_name, password }

extension AuthUserExtentsion on LoginField {
  String get lable {
    switch (this) {
      case LoginField.tax_code:
        return "Mã số thuế";
      case LoginField.user_name:
        return "Tài khoản";
      case LoginField.password:
        return "Mật khẩu";
    }
  }

  String get hint {
    switch (this) {
      case LoginField.tax_code:
        return "000012";
      case LoginField.user_name:
        return "Tài khoản";
      case LoginField.password:
        return "Mật khẩu";
    }
  }

  TextInputType get keyboardType {
    switch (this) {
      case LoginField.tax_code:
        return TextInputType.number;
      case LoginField.user_name:
      case LoginField.password:
        return TextInputType.text;
    }
  }

  String get fieldValidator {
    switch (this) {
      case LoginField.tax_code:
        return "Mã số thuế phải đúng 10 ký tự";
      case LoginField.user_name:
        return "Tài khoản không được để trống";
      case LoginField.password:
        return "Mật khẩu phải từ 6 đến 50 ký tự";
    }
  }
}
