import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:moodtracker/model/UserLog.dart';
import 'package:moodtracker/ui/all_logs/UserLogsRepository.dart';

class UserLogsScreenViewModel extends ChangeNotifier {
  UserLogsRepository userLogsRepository;

  List<CapturedEmotion> _listOfUserEmotions = [];

  UserLogsScreenViewModel(this._listOfUserEmotions, this.userLogsRepository);

  List<CapturedEmotion> get listOfUserLogs => _listOfUserEmotions;

  void deleteWidget(int index) {
    _listOfUserEmotions.removeAt(index);
    notifyListeners();
  }
}
