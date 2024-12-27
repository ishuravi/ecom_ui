import 'package:flutter/material.dart';

class MyImageSlider extends StatelessWidget {
  final String image;
  final ValueChanged<int> onChange;

  const MyImageSlider({
    super.key,
    required this.image,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.network(
        image,
        width: 300, // Adjust size as needed
        height: 300,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const CircularProgressIndicator();
        },
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      ),
    );
  }
}
