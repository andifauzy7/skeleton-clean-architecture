import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton_clean_architecture/core/error/exception.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl? dataSource;
  MockSharedPreferences? mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences!,
    );
  });

  group('getLastNumberTrivia', () {
    final testNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
      'should return number trivia model from SharedPreferences when there is one in the cache',
      () async {
        // Arrange
        when(() => mockSharedPreferences!.getString(any()))
            .thenReturn(fixture('trivia_cached.json'));

        // Act
        final result = await dataSource!.getLastNumberTrivia();

        // Assert
        verify(() => mockSharedPreferences!.getString(CACHED_NUMBER_TRIVIA));
        expect(result, equals(testNumberTriviaModel));
      },
    );

    test(
      'should throw a cache exception when there is not a cached value',
      () async {
        // Arrange
        when(() => mockSharedPreferences!.getString(any())).thenReturn(null);

        // Act
        final call = dataSource!.getLastNumberTrivia;

        // Assert
        expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    const testNumberTriviaModel = NumberTriviaModel(
      number: 1,
      text: 'test trivia',
    );

    test('should call shared preferences to cache the data', () {
      // Arrange
      when(() => mockSharedPreferences!.setString(any(), any()))
          .thenAnswer((_) async => true);

      // Act
      dataSource!.cacheNumberTrivia(testNumberTriviaModel);

      // Assert
      final expectedJsonString = json.encode(testNumberTriviaModel.toJson());

      verify(() => mockSharedPreferences!.setString(
            CACHED_NUMBER_TRIVIA,
            expectedJsonString,
          ));
    });
  });
}
