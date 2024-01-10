import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
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
    final Widget mainBody = ListView(
      padding: const EdgeInsets.all(4.0),
      children: <Widget>[
        _buildCategoryBox(
          'Inspiration',
          'assets/background/inspiration.svg',
          context,
          RootPath.inspiration,
          'Discover quotes, affirmations, and more to inspire and motivate you.',
        ),
        _buildCategoryBox(
          'Journal',
          'assets/background/journal.svg',
          context,
          RootPath.journalTemplateList,
          'Discover a guided journal for a better clarity with the prompts',
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
        actions: [
          IconButton(
            onPressed: () {
              // Add functionality for any actions you want here.
            },
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Discover and explore a world of inspiration and self-improvement.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: mainBody,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBox(String title, String svgPath, BuildContext context, String routeName, String description,
      {bool isComingSoon = false}) {
    final GoRouter goRouter = GoRouter.of(context);
    final brightness = Theme.of(context).colorScheme.brightness;
    return GestureDetector(
      onTap: () {
        if (!isComingSoon) {
          goRouter.pushNamed(routeName);
          HapticFeedback.selectionClick();
        }
      },
      child: BentoBox(
        gridWidth: 4,
        gridHeight: 3,
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
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.black.withOpacity(0.7),
                child: Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
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
