import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:skeleton_clean_architecture/core/error/exception.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late NumberTriviaRemoteDataSourceImpl? dataSource;
  late MockHttpClient? mockHttpClient;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockHttpClient = MockHttpClient();

    dataSource = NumberTriviaRemoteDataSourceImpl(
      client: mockHttpClient!,
    );
  });

  void setUpMockHttpClientSuccess200() {
    final trivia = fixture('trivia.json');
    const responseCode = 200;
    final response = http.Response(trivia, responseCode);

    when(() => mockHttpClient!.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => response);
  }

  void setUpMockHttpClientFailure404() {
    const responseBody = 'Something went wrong';
    const statusCode = 404;
    final response = http.Response(responseBody, statusCode);

    when(() => mockHttpClient!.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => response);
  }

  group('getConcreteNumberTrivia', () {
    const testNumber = 1;

    final testNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      '''should perform a GET request on a URL with number being the endpoint
    and with application/json header''',
      () {
        // Arrange
        setUpMockHttpClientSuccess200();

        // Act
        dataSource!.getConcreteNumberTrivia(testNumber);

        // Assert
        final uri = Uri.parse('http://numbersapi.com/$testNumber');

        final headers = {
          'Content-Type': 'application/json',
        };

        verify(() => mockHttpClient!.get(uri, headers: headers));
      },
    );

    test(
      'should return NumberTriviaModel when the response code is 200 (success)',
      () async {
        // Arrange
        setUpMockHttpClientSuccess200();

        // Act
        final result = await dataSource!.getConcreteNumberTrivia(testNumber);

        // Assert
        expect(result, equals(testNumberTriviaModel));
      },
    );

    test(
      'should throw a server exception when the response code is 404 or any other failure code',
      () {
        // Arrange
        setUpMockHttpClientFailure404();

        // Act
        final call = dataSource!.getConcreteNumberTrivia;

        // Assert
        expect(() => call(testNumber),
            throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final testNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      '''should perform a GET request on a URL with number being the endpoint
    and with application/json header''',
      () {
        // Arrange
        setUpMockHttpClientSuccess200();

        // Act
        dataSource!.getRandomNumberTrivia();

        // Assert
        final uri = Uri.parse('http://numbersapi.com/random');

        final headers = {
          'Content-Type': 'application/json',
        };

        verify(() => mockHttpClient!.get(uri, headers: headers));
      },
    );

    test(
      'should return NumberTriviaModel when the response code is 200 (success)',
      () async {
        // Arrange
        setUpMockHttpClientSuccess200();

        // Act
        final result = await dataSource!.getRandomNumberTrivia();

        // Assert
        expect(result, equals(testNumberTriviaModel));
      },
    );

    test(
      'should throw a server exception when the response code is 404 or any other failure code',
      () {
        // Arrange
        setUpMockHttpClientFailure404();

        // Act
        final call = dataSource!.getRandomNumberTrivia;

        // Assert
        expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });
}
