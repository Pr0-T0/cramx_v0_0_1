import 'package:flutter/material.dart';

class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    required this.flex,
    required this.widthFactor,
  });

  final int flex;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15.0)
          ),          
        ),
      ),
    );
  }
}

class ShimmerView extends StatelessWidget {
  const ShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerBox(flex: 6, widthFactor: 1),
        SizedBox(height: 10.0),
        ShimmerBox(flex: 6, widthFactor: 1),
        SizedBox(height: 10.0),
        ShimmerBox(flex: 6, widthFactor: 1),
        SizedBox(height: 10.0),
        ShimmerBox(flex: 6, widthFactor: 1),
        SizedBox(height: 10.0),
        ShimmerBox(flex: 6, widthFactor: 1),
        SizedBox(height: 10.0),
      ],  
    );
  }
}