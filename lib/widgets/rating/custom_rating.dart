import 'package:flutter/material.dart';
import 'package:mh_core/utils/constant.dart';
import 'package:mh_core/utils/global.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final bool showRatingValue;
  final double? fontSize;
  final double? ratingIconSize;
  final Color? color;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;

  const RatingWidget({
    super.key,
    required this.rating,
    this.showRatingValue = true,
    this.fontSize,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center, this.color = const Color(0xffFFA873), this.ratingIconSize = 14,
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
            style:  TextStyle(color: color, fontSize: fontSize?? 16, fontWeight: FontWeight.w600),
          ),
        if (showRatingValue) space1R,
        Icon(rating > 0 && rating < 1 ? Icons.star_half : Icons.star,
            color: rating > 0 ?  color : const Color(0xff8C8FA5), size: ratingIconSize),
        Icon(rating > 1 && rating < 2 ? Icons.star_half : Icons.star,
            color: rating > 1 ?  color : const Color(0xff8C8FA5), size: ratingIconSize),
        Icon(rating > 2 && rating < 3 ? Icons.star_half : Icons.star,
            color: rating > 2 ?  color : const Color(0xff8C8FA5), size: ratingIconSize),
        Icon(rating > 3 && rating < 4 ? Icons.star_half : Icons.star,
            color: rating > 3 ?  color : const Color(0xff8C8FA5), size: ratingIconSize),
        Icon(rating > 4 && rating < 5 ? Icons.star_half : Icons.star,
            color: rating > 4 ?  color : const Color(0xff8C8FA5), size: ratingIconSize),
      ],
    );
  }
}

class GiveARatingWidget extends StatefulWidget {
  const GiveARatingWidget({super.key, this.rating = 0, this.onRating, this.enabled = true});
  final int? rating;
  final bool enabled;
  final Function(int)? onRating;
  @override
  State<GiveARatingWidget> createState() => _GiveARatingWidgetState();
}

class _GiveARatingWidgetState extends State<GiveARatingWidget> {
  int _selectedIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    _selectedIndex = widget.rating! <= 0 ? 0 : widget.rating! - 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(
          5,
          (index) {
            return GestureDetector(
              onTap: widget.enabled
                  ? () {
                      globalLogger.d(index);
                      _selectedIndex = index;
                      setState(() {});
                      if (widget.onRating != null) widget.onRating!(index + 1);
                    }
                  : null,
              child: Icon(Icons.star, color: _selectedIndex >= index ? const Color(0xffFFA873) : Colors.grey, size: 16),
            );
          },
        ),
      ],
    );
  }
}
