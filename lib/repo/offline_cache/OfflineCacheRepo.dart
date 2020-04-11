import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:moodtracker/model/UserLog.dart';
import 'package:moodtracker/ui/home/HomeRepository.dart';
import 'package:path_provider/path_provider.dart';

class OfflineCacheRepo {
  Future<List<CapturedEmotion>> getCachedListOfEmotions() async {
    String responseString =
        await _readCachedResponseFor(LIST_OF_EMOTIONS_FILE_NAME);
    UserLog capturedEmotions = UserLog.fromJson(json.decode(responseString));
    return capturedEmotions.listOfUserLogs;
  }

  Future<String> _readCachedResponseFor(String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      String text = await file.readAsString();
      return text;
    } catch (e) {
      return "";
    }
  }

  writeDataToCache(String fileName, String fileData) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(fileData);
  }
}
