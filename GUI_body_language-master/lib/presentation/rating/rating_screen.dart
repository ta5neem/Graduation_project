import 'package:gui/core/utils/app_strings.dart';
import 'package:gui/core/utils/color_manager.dart';
import 'package:gui/core/utils/constants.dart';
import 'package:gui/presentation/rating/components/rating_row.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../core/utils/app_assets.dart';
import '../dashboard/components/tip_row.dart';

class RatingScreen extends StatelessWidget {
  RatingScreen({Key? key}) : super(key: key);

  final List<String> tips = [
    "tip 1: This is a test tip, This is a test tip",
    "tip 2: This is a very very big test tip, This is a very long test tip,please reead it.bla bla bla, This is a very long test tip",
    "tip 3: This is a small test tip",
    "tip 4: use high quality microphone",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          AppStrings.rating,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: ColorsManager.darkTeal),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.bodyLanguageRating,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (_, index) => RatingRow(title: "Mistake ${index+1}"),
                ),
                Constants.verticalSpaceMedium(),
                RatingRow(title: AppStrings.totalRating),
                Constants.verticalSpaceLarge(),
                const Divider(
                  color: ColorsManager.darkTeal,
                  thickness: 2,
                  indent: 12,
                  endIndent: 12,
                ),
                Constants.verticalSpaceMedium(),
                CarouselSlider(
                  options: CarouselOptions(
                    // height: MediaQuery.of(context).size.height / 4,
                      aspectRatio: 19 / 6,
                      clipBehavior: Clip.antiAlias,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.vertical,
                      viewportFraction: 0.75,
                      autoPlay: true,
                      disableCenter: true),
                  items: tips
                      .map((e) => TipRow(title: e, icon: AppAssets.tipIcon))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
