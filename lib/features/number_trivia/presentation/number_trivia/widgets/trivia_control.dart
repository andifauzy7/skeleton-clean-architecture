import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/presentation/number_trivia/controller/number_trivia_controller.dart';

class TriviaControl extends StatefulWidget {
  const TriviaControl({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControl> createState() => _TriviaControlState();
}

class _TriviaControlState extends State<TriviaControl> {
  final textController = TextEditingController();
  String input = '';

  final controller = Get.find<NumberTriviaController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: textController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
          onChanged: (value) {
            input = value;
          },
          onSubmitted: (value) {
            input = value;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: dispatchConcrete,
                child: const Text('Search'),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: dispatchRandom,
                child: const Text('Get random trivia'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void dispatchConcrete() => controller.fetchConcreteNumber(
        int.parse(input),
      );

  void dispatchRandom() => controller.fetchRandomNumber();
}
