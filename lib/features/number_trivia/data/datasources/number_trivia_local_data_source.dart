import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton_clean_architecture/core/error/exception.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final numberTriviaString =
        sharedPreferences.getString(CACHED_NUMBER_TRIVIA);

    if (numberTriviaString == null) {
      throw CacheException();
    } else {
      final numberTriviaJson = json.decode(numberTriviaString);
      final numberTriviaModel = NumberTriviaModel.fromJson(numberTriviaJson);
      final numberTriviaFuture = Future.value(numberTriviaModel);

      return numberTriviaFuture;
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) async {
    final triviaMap = triviaToCache.toJson();
    final triviaJson = json.encode(triviaMap);

    sharedPreferences.setString(CACHED_NUMBER_TRIVIA, triviaJson);
  }
}
