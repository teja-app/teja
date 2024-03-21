import 'package:teja/presentation/explore/datas/promotion.dart';
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
    print("Promotion['image'].toString()${Promotion['image'].toString()}");
    return Padding(
      padding: const EdgeInsets.only(left: appPadding, right: appPadding),
      child: Stack(
        alignment: Alignment.topRight,
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size.width,
            height: size.width * .450,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: cardTheme.color,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Promotion['title'].toString(),
                  style: textTheme.titleMedium,
                ),
                SizedBox(height: 7.0),
                Container(
                  width: size.width * .425,
                  child: Text(Promotion['subTitle'].toString(), style: textTheme.titleLarge),
                ),
                Container(
                  child: const Button(
                    text: 'Try 7 Days Free',
                    buttonType: ButtonType.primary,
                  ),
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
                Promotion['image'].toString(),
                height: 250,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
