import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeleton_clean_architecture/core/injection/injection.dart';
import 'package:skeleton_clean_architecture/features/number_trivia/presentation/number_trivia/pages/number_trivia_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Injection().initialize().then(
        (_) => runApp(
          const MyApp(),
        ),
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      primaryColor: Colors.green.shade800,
      primarySwatch: Colors.green,
    );

    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          secondary: Colors.green.shade600,
        ),
      ),
      home: const NumberTriviaPage(),
    );
  }
}
