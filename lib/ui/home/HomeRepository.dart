import 'package:moodtracker/model/UserLog.dart';
import 'package:moodtracker/repo/offline_cache/OfflineCacheRepo.dart';

class HomeScreenRepository {
  OfflineCacheRepo offlineCacheRepo;

  HomeScreenRepository(this.offlineCacheRepo);

  saveDataOffline(String encodedString) async {
    await offlineCacheRepo.writeDataToCache(
        LIST_OF_EMOTIONS_FILE_NAME, encodedString);
  }

  Future<List<CapturedEmotion>> readDataFromOffline() async {
    try {
      return await offlineCacheRepo.getCachedListOfEmotions();
    } catch (error) {
      return [];
    }
  }
}

const String LIST_OF_EMOTIONS_FILE_NAME = "file1.txt";
