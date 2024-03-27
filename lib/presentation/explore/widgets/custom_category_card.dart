import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:teja/presentation/explore/datas/category_json.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teja/presentation/pro/pro_sheet.dart';

class CustomCategoryCard extends StatelessWidget {
  const CustomCategoryCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Color primary = colorScheme.primary;
    TextTheme textTheme = Theme.of(context).textTheme;
    final cardTheme = Theme.of(context).cardTheme;
    var size = MediaQuery.of(context).size;
    final GoRouter goRouter = GoRouter.of(context);

    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(HomePageCategoryJson.length, (index) {
          return GestureDetector(
            onTap: () {
              bool isPro = HomePageCategoryJson[index]['pro'];
              String path = HomePageCategoryJson[index]['path'];
              if (isPro) {
                showProBottomSheet(context);
              } else {
                goRouter.pushNamed(path);
              }
              HapticFeedback.selectionClick();
            },
            child: Container(
              height: size.width * .25,
              width: size.width * .25,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: cardTheme.color,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: cardTheme.color!.withOpacity(0.05),
                    blurRadius: 15.0,
                    offset: Offset(0, 7),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Container(
                      child: SvgPicture.asset(
                        HomePageCategoryJson[index]['icon'],
                        width: 30,
                        colorFilter: const ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    HomePageCategoryJson[index]['title'],
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: 0.0),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
