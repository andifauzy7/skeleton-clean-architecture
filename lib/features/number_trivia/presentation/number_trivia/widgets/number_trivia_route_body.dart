import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeleton_clean_architecture/core/service_locator/service_locator.dart';
import 'package:skeleton_clean_architecture/core/viewstate/view_state.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/presentation/number_trivia/controller/number_trivia_controller.dart';
import 'widgets.dart';

class NumberTriviaRouteBody extends StatelessWidget {
  NumberTriviaRouteBody({
    Key? key,
  }) : super(key: key);

  final controller = Get.put(
    NumberTriviaController(
      getConcreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Obx(() {
            if (controller.viewState.value.status == Status.INITIAL) {
              return const MessageDisplay(
                message: 'Start searching!',
              );
            } else if (controller.viewState.value.status == Status.LOADING) {
              return const LoadingWidget();
            } else if (controller.viewState.value.status == Status.COMPLETED) {
              return TriviaDisplay(
                numberTrivia: controller.viewState.value.data,
              );
            } else {
              return MessageDisplay(
                message: controller.viewState.value.message,
              );
            }
          }),
          const SizedBox(
            height: 20,
          ),
          const TriviaControl(),
        ],
      ),
    );
  }
}
