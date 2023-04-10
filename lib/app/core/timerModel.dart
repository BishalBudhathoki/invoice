import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../ui/views/client_and_appointment_details_view.dart';

class TimerModel extends ChangeNotifier {
  late Timer _timer;
  int _elapsedSeconds = 0;
  bool _isRunning = false;
  late DateTime _startTime;
  String currentTimerClientEmail = "";

  int get elapsedSeconds => _elapsedSeconds;
  bool get isRunning => _isRunning;

  void setTimerClientEmail(String clientEmail) {
    currentTimerClientEmail = clientEmail;
    print("Set timer Client: $currentTimerClientEmail");
  }

  String getTimerClientEmail() {
    print("Get timer Client: $currentTimerClientEmail");
    return currentTimerClientEmail;
  }

  // String isTimerClient() {
  //   print(" is timer clinet $currentTimerClientEmail");
  //   return currentTimerClientEmail;
  // }

  void start() {
    _startTime = DateTime.now();
    _isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      var currentTime = DateTime.now();
      _elapsedSeconds = currentTime.difference(_startTime).inSeconds;
      if (_elapsedSeconds >= kTimerDurationInSeconds) {
        stop();
      }
      notifyListeners();
    });
  }

  bool stop() {
    _timer.cancel();
    _isRunning = false;
    notifyListeners();
    return _isRunning;
  }

  void resetTimer(String clientEmail) {
    currentTimerClientEmail = clientEmail;
    _elapsedSeconds = 0;
    _isRunning = false;
  }

  String getFormattedTime(int timeInSeconds) {
    int hours = timeInSeconds ~/ 3600;
    int minutes = (timeInSeconds % 3600) ~/ 60;
    int seconds = timeInSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
