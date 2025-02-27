![output.gif](https://i.postimg.cc/FK1dzRfw/output.gif)

# Word Carousel

A smooth, animated text carousel widget for Flutter that displays rotating text with beautiful transitions. Perfect for creating engaging user interfaces with dynamic text animations.

## Features

- 🎭 Smooth bottom-to-top character animations
- 🎯 Fixed text with rotating words
- ⚙️ Highly customizable appearance and timing
- 🎮 External controller support
- 🔄 Automatic or manual text rotation
- 📏 Adjustable spacing and styling
- 🎨 Customizable container color
- 🔁 Optional looping functionality

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  word_carousel: ^0.0.1
```

## Usage

```dart
import 'package:word_carousel/word_carousel.dart';

// Basic usage
WordCarousel(
  fixedText: "I am a",
  rotatingWords: ["Developer", "Designer", "Creator"],
);

// Advanced usage with controller
final controller = WordCarouselController();

WordCarousel(
  fixedText: "I love",
  rotatingWords: ["Flutter", "Coding", "Animation"],
  stayDuration: Duration(milliseconds: 2000),
  animationDuration: Duration(milliseconds: 500),
  fixedTextStyle: TextStyle(fontSize: 24),
  rotatingTextStyle: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
  spacing: 8.0,
  loop: true,
  autoStart: true,
  containerColor: Colors.cyan,
  controller: controller,
  onTextChanged: (index) {
    print('Text changed to: ${rotatingWords[index]}');
  },
);

// Control the carousel externally
controller.next();      // Move to next word
controller.reset();     // Reset to first word
controller.jumpTo(2);   // Jump to specific index
```

## Properties

| Property            | Type                    | Description                                     | Default       |
|---------------------|-------------------------|-------------------------------------------------|---------------|
| `fixedText`         | String                  | The static text displayed before rotating words | Required      |
| `rotatingWords`     | List<String>            | List of words to rotate through                 | Required      |
| `stayDuration`      | Duration                | Time to display each word                       | 2000ms        |
| `animationDuration` | Duration                | Duration of transition animation                | 500ms         |
| `fixedTextStyle`    | TextStyle?              | Style for fixed text                            | Theme default |
| `rotatingTextStyle` | TextStyle?              | Style for rotating text                         | Theme default |
| `spacing`           | double                  | Space between fixed and rotating text           | 8.0           |
| `loop`              | bool                    | Whether to loop through words continuously      | true          |
| `autoStart`         | bool                    | Whether to start rotation automatically         | true          |
| `containerColor`    | Color                   | Background color of rotating text container     | Colors.cyan   |
| `controller`        | WordCarouselController? | External controller for the carousel            | null          |
| `onTextChanged`     | Function(int)?          | Callback when text changes                      | null          |
