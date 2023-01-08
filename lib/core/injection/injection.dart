import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:skeleton_clean_architecture/core/network/network_info.dart';
import 'package:skeleton_clean_architecture/core/service_locator/service_locator.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/di/number_trivia_dependencies.dart';

class Injection {
  Future<void> initialize() async {
    await _registerCoreDependencies();
    _registerDependencies();
  }

  void _registerDependencies() {
    NumberTriviaDependencies();
  }

  Future<void> _registerCoreDependencies() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton(() => http.Client());
    sl.registerLazySingleton(() => InternetConnectionChecker());
    sl.registerLazySingleton(() => sharedPreferences);
    sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(
        connectionChecker: sl(),
      ),
    );
  }
}
