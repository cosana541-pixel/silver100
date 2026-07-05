import 'package:flutter/foundation.dart';

enum AppTextSize { normal, large, veryLarge }

class AppSettingsStore extends ChangeNotifier {
  AppTextSize _textSize = AppTextSize.normal;
  bool _easyExplanation = true;

  AppTextSize get textSize => _textSize;
  bool get easyExplanation => _easyExplanation;

  double get textScale {
    switch (_textSize) {
      case AppTextSize.normal:
        return 1;
      case AppTextSize.large:
        return 1.12;
      case AppTextSize.veryLarge:
        return 1.24;
    }
  }

  String get textSizeLabel {
    switch (_textSize) {
      case AppTextSize.normal:
        return '기본';
      case AppTextSize.large:
        return '크게';
      case AppTextSize.veryLarge:
        return '아주 크게';
    }
  }

  void setTextSize(AppTextSize value) {
    if (_textSize == value) return;
    _textSize = value;
    notifyListeners();
  }

  void setEasyExplanation(bool value) {
    if (_easyExplanation == value) return;
    _easyExplanation = value;
    notifyListeners();
  }
}

final appSettingsStore = AppSettingsStore();
