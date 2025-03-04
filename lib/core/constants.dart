import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Colors.blueAccent;
  static const Color secondaryColor = Colors.green;
  static const Color errorColor = Colors.red;
}

class DefaultLocation {
  static const double latitude = 37.7749;
  static const double longitude = -122.4194;
  static const int distanceFilter = 100;
}

class ErrorMessages {
  static const String internetErrorTitle = "İnternete Bağlanılamıyor";
  static const String internetErrorMessage =
      "İnternet bağlantınız yok. Lütfen bağlantınızı kontrol edin.";
  static const String locationErrorTitle = "Konum bilgisi alınamadı.";
  static const String locationErrorMessage =
      "Uygulamanın konum takibi yapabilmesi için izin vermelisiniz.";
}

class TextItems {
  static const String addressDialogTitle = "İşaret Adresi";
  static const String appbarTitle = "Konum Takip Uygulaması";
  static const String locationError = "Konum bilgisi alınamadı.";
}
