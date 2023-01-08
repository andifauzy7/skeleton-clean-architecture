import 'package:skeleton_clean_architecture/core/service_locator/service_locator.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

class NumberTriviaDependencies {
  NumberTriviaDependencies() {
    _registerUseCase();
    _registerRepository();
    _registerDataSource();
  }

  void _registerUseCase() {
    sl.registerLazySingleton<GetConcreteNumberTrivia>(
      () => GetConcreteNumberTrivia(
        sl(),
      ),
    );
    sl.registerLazySingleton<GetRandomNumberTrivia>(
      () => GetRandomNumberTrivia(
        sl(),
      ),
    );
  }

  void _registerRepository() {
    sl.registerLazySingleton<NumberTriviaRepository>(
      () => NumberTriviaRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        networkInfo: sl(),
      ),
    );
  }

  void _registerDataSource() {
    sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(
        client: sl(),
      ),
    );
    sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(
        sharedPreferences: sl(),
      ),
    );
  }
}
