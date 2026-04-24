import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

enum ConnectivityStatus { online, offline }

class ConnectivityService extends ChangeNotifier {
  ConnectivityStatus _status = ConnectivityStatus.online;
  late StreamSubscription _subscription;

  ConnectivityStatus get status => _status;

  ConnectivityService() {
    _subscription = InternetConnection().onStatusChange.listen((status) {
      _updateStatus(status);
    });
  }

  void _updateStatus(InternetStatus status) {
    if (status == InternetStatus.connected) {
      _status = ConnectivityStatus.online;
    } else {
      _status = ConnectivityStatus.offline;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    // TODO: implement dispose
    super.dispose();
  }
}