import 'dart:math';
import 'package:cramx_v0_0_1/utils/candidate_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExampleCard extends StatefulWidget {
  final ExampleCandidateModel candidate;

  const ExampleCard(this.candidate, {super.key});

  @override
  State<ExampleCard> createState() => _ExampleCardState();
}

class _ExampleCardState extends State<ExampleCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;
  late List<Color> cardGradient; // Store a fixed gradient for this card

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // Assign a random gradient ONCE when the card is first created
    cardGradient = getRandomGradient();
  }

  void _toggleCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.002)
              ..rotateY(_animation.value * 3.14),
            child: _animation.value < 0.5 ? _buildFrontSide() : _buildBackSide(),
          );
        },
      ),
    );
  }

  Widget _buildFrontSide() {
    return _buildCard(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            widget.candidate.question,
            textAlign: TextAlign.center,
            style: GoogleFonts.patrickHand(fontSize: 50, color:  Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildBackSide() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(3.14),
      child: _buildCard(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.candidate.answer,
              textAlign: TextAlign.center,
              style: GoogleFonts.patrickHand(fontSize: 50, color:  Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: 350,
      height: 600,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: cardGradient, // Now using a fixed gradient
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<List<Color>> gradientOptions = [
    [Colors.blue, Colors.lightBlueAccent],
    [Colors.purple, Colors.deepPurpleAccent],
    [Colors.red, Colors.orangeAccent],
    [Colors.green, Colors.lightGreenAccent],
    [Colors.teal, Colors.cyan],
    [Colors.amber, Colors.orange],
    [Colors.pink, Colors.purpleAccent],
    [Colors.indigo, Colors.blueGrey],
    [Colors.lime, Colors.lightGreen],
  ];

  List<Color> getRandomGradient() {
    final random = Random();
    return gradientOptions[random.nextInt(gradientOptions.length)];
  }
}
