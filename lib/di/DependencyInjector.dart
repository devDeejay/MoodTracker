import 'package:get_it/get_it.dart';
import 'package:moodtracker/repo/offline_cache/OfflineCacheRepo.dart';
import 'package:moodtracker/ui/home/HomeRepository.dart';
import 'package:moodtracker/ui/all_logs/UserLogsRepository.dart';

GetIt dependencyInjector = GetIt();

void setupDI() {
  OfflineCacheRepo offlineCacheRepo = OfflineCacheRepo();

  dependencyInjector.registerSingleton(HomeScreenRepository(offlineCacheRepo));
  dependencyInjector.registerSingleton(UserLogsRepository(offlineCacheRepo));
}
