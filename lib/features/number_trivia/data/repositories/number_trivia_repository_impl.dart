import 'package:skeleton_clean_architecture/core/error/exception.dart';
import 'package:skeleton_clean_architecture/core/network/network_info.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:skeleton_clean_architecture/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';

typedef _ConcreteOrRandomChooser = Future<NumberTriviaModel> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
          int number) async =>
      await _getTrivia(
        () => remoteDataSource.getConcreteNumberTrivia(number),
      );

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async =>
      await _getTrivia(
        () => remoteDataSource.getRandomNumberTrivia(),
      );

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _ConcreteOrRandomChooser getConcreteOrRandom) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final numberTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(numberTrivia);
        return Right(numberTrivia);
      } on ServerException {
        final failure = ServerFailure();
        return Left(failure);
      }
    } else {
      try {
        final numberTrivia = await localDataSource.getLastNumberTrivia();
        return Right(numberTrivia);
      } on CacheException {
        final failure = CacheFailure();
        return Left(failure);
      }
    }
  }
}
