import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia? useCase;
  MockNumberTriviaRepository? mockNumberTriviaRepository;

  const testNumber = 1;
  const testNumberTrivia = NumberTrivia(number: 1, text: 'test');

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    useCase = GetConcreteNumberTrivia(mockNumberTriviaRepository!);
  });

  test('should get trivia for the number from the repository', () async {
    // "On the fly" implementation of the Repository using the Mockito package.
    // When getConcreteNumberTrivia is called with any argument, always answer with
    // the Right "side" of Either containing a test NumberTrivia object.
    when(() => mockNumberTriviaRepository!.getConcreteNumberTrivia(any()))
        .thenAnswer((_) async => const Right(testNumberTrivia));
    // The "act" phase of the test. Call the not-yet-existent method.
    final result = await useCase!(const Params(number: testNumber));
    // UseCase should simply return whatever was returned from the Repository
    expect(result, equals(const Right(testNumberTrivia)));
    // Verify that the method has been called on the Repository
    verify(
        () => mockNumberTriviaRepository!.getConcreteNumberTrivia(testNumber));
    // Only the above method should be called and nothing more.
    verifyNoMoreInteractions(
      mockNumberTriviaRepository,
    );
  });
}
