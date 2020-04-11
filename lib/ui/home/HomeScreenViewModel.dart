import 'dart:convert' as JSON;

import 'package:flutter/foundation.dart';
import 'package:moodtracker/model/UserLog.dart';
import 'package:moodtracker/ui/home/HomeRepository.dart';

class HomeScreenViewModel extends ChangeNotifier {
  HomeScreenRepository homeScreenRepository;

  HomeScreenViewModel(this.homeScreenRepository) {
    readDataFromOffline();
  }

  List<CapturedEmotion> _listOfUserEmotions = [];

  List<CapturedEmotion> get listOfCapturedEmotions => _listOfUserEmotions;

  void addEmotion(CapturedEmotion capturedEmotion) {
    _listOfUserEmotions.add(capturedEmotion);
    notifyListeners();
  }

  CapturedEmotion getLatestCapturedEmotion() {
    if (_listOfUserEmotions.length > 0) {
      return _listOfUserEmotions[_listOfUserEmotions.length - 1];
    } else {
      return CapturedEmotion(5, "So happy to see you here!",
          DateTime.now().millisecondsSinceEpoch);
    }
  }

  void updateLatestLog(CapturedEmotion newCapturedEmotion) {
    if (_listOfUserEmotions.length > 0) {
      _listOfUserEmotions[_listOfUserEmotions.length - 1] = newCapturedEmotion;
    }
    notifyListeners();
  }

  void saveDataOffline() {
    UserLog capturedEmotionResponse =
        UserLog(listOfUserLogs: listOfCapturedEmotions);

    String encodedString = JSON.jsonEncode(capturedEmotionResponse.toJson());
    print(encodedString);
    homeScreenRepository.saveDataOffline(encodedString);
  }

  void readDataFromOffline() async {
    _listOfUserEmotions = await homeScreenRepository.readDataFromOffline();
    if (_listOfUserEmotions.isEmpty) {
      _listOfUserEmotions.add(CapturedEmotion(
          5, "You joined us", DateTime.now().millisecondsSinceEpoch));
    }
    notifyListeners();
  }

  void updateList(List<CapturedEmotion> updatedList) {
    _listOfUserEmotions = updatedList;
    notifyListeners();
  }

  void deleteLatestLog() {
    _listOfUserEmotions.removeLast();
    notifyListeners();
  }
}
