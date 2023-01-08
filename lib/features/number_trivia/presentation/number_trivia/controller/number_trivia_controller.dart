import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:skeleton_clean_architecture/core/error/failures.dart';
import 'package:skeleton_clean_architecture/core/usecase/usecase.dart';
import 'package:skeleton_clean_architecture/core/viewstate/view_state.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

class NumberTriviaController extends GetxController {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;

  Rx<ViewState> viewState = ViewState.initial().obs;

  NumberTriviaController({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
  });

  Future<void> fetchConcreteNumber(int number) async {
    viewState(
      ViewState.loading(),
    );
    Either<Failure, NumberTrivia> result = await getConcreteNumberTrivia.call(
      Params(number: number),
    );

    result.fold((l) {
      viewState(
        ViewState.error(
          l.toString(),
        ),
      );
    }, (r) {
      viewState(
        ViewState.completed(r),
      );
    });
  }

  Future<void> fetchRandomNumber() async {
    viewState(
      ViewState.loading(),
    );
    Either<Failure, NumberTrivia> result = await getRandomNumberTrivia.call(
      NoParams(),
    );

    result.fold((l) {
      viewState(
        ViewState.error(
          l.toString(),
        ),
      );
    }, (r) {
      viewState(
        ViewState.completed(r),
      );
    });
  }
}
