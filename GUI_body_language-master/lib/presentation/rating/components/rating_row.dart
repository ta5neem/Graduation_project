import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingRow extends StatelessWidget {
  final String title;
  const RatingRow({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        RatingBar(
          initialRating: 0,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          glowRadius: 1,
          ratingWidget: RatingWidget(
            full: const Icon(Icons.star_rate_rounded, color: Colors.amber),
            half: const Icon(Icons.star_half_rounded,
                color: Colors.amber, textDirection: TextDirection.ltr),
            empty: const Icon(Icons.star_border_rounded, color: Colors.amber),
          ),
          itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
          onRatingUpdate: (rating) {},
        ),
      ],
    );
  }
}
