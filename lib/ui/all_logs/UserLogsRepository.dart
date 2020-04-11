import 'package:moodtracker/model/UserLog.dart';
import 'package:moodtracker/repo/offline_cache/OfflineCacheRepo.dart';

class UserLogsRepository {
  OfflineCacheRepo offlineCacheRepo;

  UserLogsRepository(this.offlineCacheRepo);

  Future<List<CapturedEmotion>> readDataFromOffline() async {
    return await offlineCacheRepo.getCachedListOfEmotions();
  }
}

const String LIST_OF_EMOTIONS_FILE_NAME = "file1.txt";
