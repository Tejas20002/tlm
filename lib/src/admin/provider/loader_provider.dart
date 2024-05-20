import 'package:flutter/material.dart';

class LoaderProvider extends ChangeNotifier {
  int _currentPdf = 0;
  int _totalPdf = 0;
  int _totalPages = 0;
  int _currentPages = 0;
  bool isLoading = false;

  void setCurrentPdf(int value) {
    _currentPdf = value;
    notifyListeners();
  }

  void setTotalPdf(int value) {
    _totalPdf = value;
    notifyListeners();
  }

  void setCurrentPages(int value) {
    _currentPages = value;
    notifyListeners();
  }

  void setTotalPages(int value) {
    _totalPages = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  int get currentPdf => _currentPdf;

  int get totalPdf
  => _totalPdf;

  int get currentPages => _currentPages;

  int get totalPages => _totalPages;
}
