import 'package:flutter/material.dart';
import 'package:mh_core/utils/constant.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final bool showRatingValue;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;

  const RatingWidget({
    super.key,
    required this.rating,
    this.showRatingValue = true,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment!,
      crossAxisAlignment: crossAxisAlignment!,
      children: [
        if (showRatingValue)
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(color: Color(0xffFFA873), fontSize: 16, fontWeight: FontWeight.w600),
          ),
        if (showRatingValue) space1R,
        Icon(rating > 0 && rating < 1 ? Icons.star_half : Icons.star,
            color: rating > 0 ? const Color(0xffFFA873) : const Color(0xff8C8FA5), size: 14),
        Icon(rating > 1 && rating < 2 ? Icons.star_half : Icons.star,
            color: rating > 1 ? const Color(0xffFFA873) : const Color(0xff8C8FA5), size: 14),
        Icon(rating > 2 && rating < 3 ? Icons.star_half : Icons.star,
            color: rating > 2 ? const Color(0xffFFA873) : const Color(0xff8C8FA5), size: 14),
        Icon(rating > 3 && rating < 4 ? Icons.star_half : Icons.star,
            color: rating > 3 ? const Color(0xffFFA873) : const Color(0xff8C8FA5), size: 14),
        Icon(rating > 4 && rating < 5 ? Icons.star_half : Icons.star,
            color: rating > 4 ? const Color(0xffFFA873) : const Color(0xff8C8FA5), size: 14),
      ],
    );
  }
}
