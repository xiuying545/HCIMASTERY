import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fyp1/main.dart';
import 'package:go_router/go_router.dart';

class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool _isError = false;

  bool get isLoading => _isLoading;
  bool get isError => _isError;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(bool value) {
    _isError = value;
    notifyListeners();
  }

  Future<T?> tryFunction<T>(Future<T> Function() action) async {
    setLoading(true);
    try {
      return await action();
    } catch (e, stackTrace) {
      _handleError(e, stackTrace);
      return null;
    } finally {
      setLoading(false);
    }
  }

  void _handleError(dynamic error, StackTrace stackTrace) {
    setError(true);
    print("Error: $error");
        final currentContext = navigatorKey.currentContext;
    if (currentContext != null) {
      Future.microtask(() => GoRouter.of(currentContext).go('/error'));
    }
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }
}
