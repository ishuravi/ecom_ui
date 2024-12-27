import 'package:flutter/material.dart';

import '../constants.dart';

class Description extends StatelessWidget {
  final String description;
  final bool isDescriptionSelected;
  final bool isReviewSelected;
  final VoidCallback onDescriptionTap;
  final VoidCallback onReviewsTap;

  Description({
    super.key,
    required this.description,
    required this.isDescriptionSelected,
    required this.isReviewSelected,
    required this.onDescriptionTap,
    required this.onReviewsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onDescriptionTap,
              child: Container(
                width: 120,
                height: 40,
                decoration: BoxDecoration(
                  color: isDescriptionSelected ? kprimaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: kprimaryColor),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Description",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDescriptionSelected ? Colors.white : kprimaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: onReviewsTap,
              child: Container(
                width: 120,
                height: 40,
                decoration: BoxDecoration(
                  color: isReviewSelected ? kprimaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: kprimaryColor),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Reviews",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isReviewSelected ? Colors.white : kprimaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (isDescriptionSelected)
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          )
        else
          const Text(
            "No reviews yet!",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
      ],
    );
  }
}
