import 'package:flutter/material.dart';
import 'package:word_carousel/word_carousel.dart';

/// The main entry point of the application.
void main() {
  runApp(const MyApp());
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  /// Creates an instance of [MyApp].
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}
/// The home page of the application.
class MyHomePage extends StatefulWidget {
  /// Creates an instance of [MyHomePage].
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Create a controller for the rotating text
  final controller = WordCarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: WordCarousel(
          controller: controller,
          fixedText: 'Creative',
          rotatingWords: const [
            'Coding',
            'Thinking',
            'Design',
            'Solutions',
            'Components',
          ],
          fixedTextStyle: const TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          rotatingTextStyle: const TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          stayDuration: const Duration(milliseconds: 2000),
          animationDuration: const Duration(milliseconds: 800),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Manually trigger the next word using controller
          controller.next();
        },
        child: const Icon(Icons.skip_next),
      ),
    );
  }
}