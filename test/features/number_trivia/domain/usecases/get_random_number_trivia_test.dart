import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skeleton_clean_architecture/core/usecase/usecase.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTrivia? useCase;
  MockNumberTriviaRepository? mockNumberTriviaRepository;
  const tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    useCase = GetRandomNumberTrivia(mockNumberTriviaRepository!);
  });

  test('should get trivia from the repository', () async {
    // arrange
    when(() => mockNumberTriviaRepository!.getRandomNumberTrivia())
        .thenAnswer((_) async => const Right(tNumberTrivia));
    // act
    // Since random number doesn't require any parameters, we pass in NoParams.
    final result = await useCase!(NoParams());
    // assert
    expect(result, const Right(tNumberTrivia));
    verify(() => mockNumberTriviaRepository!.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
