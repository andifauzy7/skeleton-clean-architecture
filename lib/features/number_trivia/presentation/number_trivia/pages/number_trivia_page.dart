import 'package:flutter/material.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/presentation/number_trivia/widgets/number_trivia_route_body.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
        child: NumberTriviaRouteBody(),
      ),
    );
  }
}
