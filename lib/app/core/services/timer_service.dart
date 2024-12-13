import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../../features/Appointment/views/client_appointment_details_view.dart';

class TimerService extends ChangeNotifier {
  Timer? _timer;
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

  int _totalTime = 0;

  int get totalTime => _totalTime;

  void setTotalTime(int totalTime) {
    _totalTime = totalTime;
    notifyListeners();
  }

  void setElapsedSeconds(int elapsedSeconds) {
    _elapsedSeconds = elapsedSeconds;
    notifyListeners();
  }

  // String isTimerClient() {
  //   print(" is timer clinet $currentTimerClientEmail");
  //   return currentTimerClientEmail;
  // }

  void start() {
    _startTime = DateTime.now();
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      var currentTime = DateTime.now();
      _elapsedSeconds = currentTime.difference(_startTime).inSeconds;
      if (_elapsedSeconds >= kTimerDurationInSeconds) {
        stop();
      }
      notifyListeners();
    });
  }

  void stop() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resetTimer(String clientEmail) {
    currentTimerClientEmail = clientEmail;
    _elapsedSeconds = 0;
    _totalTime = 0;
    _isRunning = false;
  }

  String getFormattedTime(int timeInSeconds) {
    int hours = (timeInSeconds ~/ 3600).toInt();
    int minutes = ((timeInSeconds % 3600) ~/ 60).toInt();
    int seconds = (timeInSeconds % 60).toInt();
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
