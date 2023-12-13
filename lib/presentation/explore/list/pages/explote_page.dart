import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:teja/presentation/navigation/buildDesktopDrawer.dart';
import 'package:teja/presentation/navigation/buildMobileNavigationBar.dart';
import 'package:teja/presentation/navigation/isDesktop.dart';
import 'package:teja/presentation/navigation/leadingContainer.dart';
import 'package:teja/router.dart';
import 'package:teja/shared/common/bento_box.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget mainBody = GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.0,
      padding: const EdgeInsets.all(4.0),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      children: <Widget>[
        _buildCategoryBox(
          'Guides',
          'assets/background/guide.svg',
          context,
          RootPath.habit,
          isComingSoon: true,
        ),
        _buildCategoryBox(
          'Goals & Habits',
          'assets/background/goal.svg',
          context,
          RootPath.habit,
          isComingSoon: true,
        ),
        _buildCategoryBox(
          'Journal',
          'assets/background/journal.svg',
          context,
          RootPath.habit,
          isComingSoon: true,
        ),
        _buildCategoryBox(
          'Inspiration',
          'assets/background/inspiration.svg',
          context,
          RootPath.inspiration,
        ),
      ],
    );
    return Scaffold(
      bottomNavigationBar: isDesktop(context) ? null : buildMobileNavigationBar(context),
      appBar: AppBar(
        title: const Text('Explore'),
        forceMaterialTransparency: true,
        leading: leadingNavBar(context),
        leadingWidth: 72,
      ),
      body: isDesktop(context)
          ? Row(
              children: [
                buildDesktopNavigationBar(
                  context,
                ),
                Expanded(
                  child: mainBody,
                ),
              ],
            )
          : mainBody,
    );
  }

  Widget _buildCategoryBox(String title, String svgPath, BuildContext context, String routeName,
      {bool isComingSoon = false}) {
    final GoRouter goRouter = GoRouter.of(context);
    final brightness = Theme.of(context).colorScheme.brightness;
    return BentoBox(
      gridWidth: 1,
      gridHeight: 1,
      child: GestureDetector(
        onTap: () {
          if (!isComingSoon) {
            goRouter.pushNamed(routeName);
            HapticFeedback.selectionClick();
          }
        },
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    svgPath,
                    height: 100, // Adjust the height as needed
                    colorFilter: ColorFilter.mode(
                      brightness == Brightness.light ? Colors.black : Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  Text(title),
                ],
              ),
            ),
            if (isComingSoon)
              Positioned.fill(
                child: Container(
                  color: Colors.black45,
                  child: const Center(
                    child: Text(
                      'Coming Soon',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
