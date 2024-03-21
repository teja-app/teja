import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomTitle extends StatelessWidget {
  const CustomTitle({
    Key? key,
    required this.title,
    this.route = '/404',
    this.extend = true,
    this.fontSize = 20.0,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
  }) : super(key: key);

  final String title;
  final String route;
  final bool extend;
  final double fontSize;
  final Map<String, String> pathParameters;
  final Map<String, dynamic> queryParameters;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final GoRouter goRouter = GoRouter.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: textTheme.titleLarge,
        ),
        (extend)
            ? GestureDetector(
                onTap: () {
                  goRouter.pushNamed(
                    route,
                    pathParameters: pathParameters,
                    queryParameters: queryParameters,
                  );
                },
                child: Text(
                  'See More',
                  style: textTheme.titleSmall,
                ),
              )
            : Container(),
      ],
    );
  }
}
