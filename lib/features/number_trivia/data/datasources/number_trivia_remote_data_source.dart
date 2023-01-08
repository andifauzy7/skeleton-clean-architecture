import 'dart:convert';

import 'package:http/http.dart';
import 'package:skeleton_clean_architecture/core/error/exception.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';

const HOST_NUMBERS_API = 'http://numbersapi.com';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) =>
      _getTriviaFromUrl('$HOST_NUMBERS_API/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      _getTriviaFromUrl('$HOST_NUMBERS_API/random');

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final uri = Uri.parse(url);

    final headers = {
      'Content-Type': 'application/json',
    };

    final response = await client.get(uri, headers: headers);
    final responseBody = response.body;
    final responseCode = response.statusCode;

    if (responseCode == 200) {
      final jsonResponse = json.decode(responseBody);
      final numberTriviaModel = NumberTriviaModel.fromJson(jsonResponse);

      return numberTriviaModel;
    } else {
      throw ServerException();
    }
  }
}
