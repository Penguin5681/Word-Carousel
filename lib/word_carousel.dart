import 'package:flutter/material.dart';
import 'dart:async';

/// Controller to manage RotatingText from outside
class WordCarouselController {
  VoidCallback? _nextWord;
  Function(int)? _jumpTo;
  VoidCallback? _reset;

  /// Move to the next word
  void next() {
    if (_nextWord != null) {
      _nextWord!();
    }
  }

  /// Jump to a specific word by index
  void jumpTo(int index) {
    if (_jumpTo != null) {
      _jumpTo!(index);
    }
  }

  /// Reset to the first word
  void reset() {
    if (_reset != null) {
      _reset!();
    }
  }
}

/// A widget that displays rotating text with smooth animations.
///
/// The first part of the text remains fixed, while the second part
/// rotates through a list of words with a smooth bottom-to-top animation.
class WordCarousel extends StatefulWidget {
  /// The fixed text that appears before the rotating text.
  final String fixedText;

  /// List of words that will rotate.
  final List<String> rotatingWords;

  /// Duration to stay on each word before animating to the next.
  final Duration stayDuration;

  /// Duration of the animation between words.
  final Duration animationDuration;

  /// Text style for the fixed text.
  final TextStyle? fixedTextStyle;

  /// Text style for the rotating text.
  final TextStyle? rotatingTextStyle;

  /// Spacing between fixed text and rotating text.
  final double spacing;

  /// Whether the rotation should loop continuously.
  final bool loop;

  /// Whether the animation should start automatically.
  final bool autoStart;

  /// Optional callback when the text changes.
  final Function(int)? onTextChanged;

  /// Optional controller to manage the rotating text externally.
  final WordCarouselController? controller;

  /// Optional color for the container containing the rotating words.
  final Color containerColor;

  const WordCarousel({
    super.key,
    required this.fixedText,
    required this.rotatingWords,
    this.stayDuration = const Duration(milliseconds: 2000),
    this.animationDuration = const Duration(milliseconds: 500),
    this.fixedTextStyle,
    this.rotatingTextStyle,
    this.spacing = 8.0,
    this.loop = true,
    this.autoStart = true,
    this.onTextChanged,
    this.controller,
    this.containerColor = Colors.cyan
  });

  @override
  State<WordCarousel> createState() => _WordCarouselState();
}

class _WordCarouselState extends State<WordCarousel> with TickerProviderStateMixin {
  late int _currentWordIndex;
  late List<List<String>> _wordCharacters;
  late AnimationController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentWordIndex = 0;

    // Split each word into characters
    _wordCharacters = widget.rotatingWords
        .map((word) => word.split(''))
        .toList();

    // Initialize animation controller
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    // Connect controller if provided
    if (widget.controller != null) {
      widget.controller!._nextWord = _nextWord;
      widget.controller!._jumpTo = jumpTo;
      widget.controller!._reset = reset;
    }

    if (widget.autoStart) {
      _startRotation();
    }
  }

  void _startRotation() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.stayDuration, (timer) {
      _nextWord();
    });
  }

  void _nextWord() {
    setState(() {
      _controller.reset();
      if (_currentWordIndex < widget.rotatingWords.length - 1) {
        _currentWordIndex++;
      } else if (widget.loop) {
        _currentWordIndex = 0;
      } else {
        _timer?.cancel();
        return;
      }

      if (widget.onTextChanged != null) {
        widget.onTextChanged!(_currentWordIndex);
      }

      _controller.forward();
    });
  }

  void jumpTo(int index) {
    if (index >= 0 && index < widget.rotatingWords.length && index != _currentWordIndex) {
      setState(() {
        _controller.reset();
        _currentWordIndex = index;
        if (widget.onTextChanged != null) {
          widget.onTextChanged!(_currentWordIndex);
        }
        _controller.forward();
      });
    }
  }

  void reset() {
    jumpTo(0);
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fixed text
        Text(
          widget.fixedText,
          style: widget.fixedTextStyle ?? Theme.of(context).textTheme.headlineMedium,
        ),

        SizedBox(width: widget.spacing),

        // Rotating text container
        _buildRotatingTextContainer(),
      ],
    );
  }

  Widget _buildRotatingTextContainer() {
    final currentWord = _wordCharacters[_currentWordIndex];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: widget.containerColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          currentWord.length,
              (charIndex) => _buildAnimatedCharacter(
            currentWord[charIndex],
            charIndex,
            currentWord.length,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCharacter(String char, int index, int totalChars) {
    // Calculate staggered delay for each character
    final delay = (index / totalChars) * 0.5;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Create staggered animation for each character
        final animation = CurvedAnimation(
          parent: _controller,
          curve: Interval(
            delay, // Start delay (staggered)
            delay + 0.5, // End point
            curve: Curves.easeInOut,
          ),
        );

        return Transform.translate(
          offset: Offset(
            0,
            (1.0 - animation.value) * 20, // Move from bottom to top
          ),
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
      child: Text(
        char,
        style: widget.rotatingTextStyle ??
            Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}