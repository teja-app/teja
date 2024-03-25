import 'package:teja/shared/common/button.dart';
import 'package:teja/theme/padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomPromotionCard extends StatelessWidget {
  const CustomPromotionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final cardTheme = Theme.of(context).cardTheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(left: appPadding, right: appPadding),
      child: Stack(
        alignment: Alignment.topRight,
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size.width,
            height: size.width * .5,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: cardTheme.color,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.width * .3,
                  child: Text(
                    "Free with streak",
                    style: textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 7.0),
                SizedBox(
                  width: size.width * .425,
                  child: Text("Teja Pro", style: textTheme.titleLarge),
                ),
                SizedBox(
                  width: size.width * .3,
                  child: Text(
                    "AI and Teja - Echo",
                    style: textTheme.titleMedium,
                  ),
                ),
                const Button(
                  text: 'Know more',
                  buttonType: ButtonType.primary,
                  // onPressed: () => {},
                ),
              ],
            ),
          ),
          Positioned(
            top: -120,
            right: -20,
            child: SizedBox(
              height: size.height * .4,
              child: SvgPicture.asset(
                'assets/explore/dog_reading_vector.svg',
                height: 250,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
