import 'package:go_router/go_router.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:teja/router.dart';
import 'package:teja/theme/padding.dart';
import 'package:flutter/material.dart';

class CustomSearchField extends StatefulWidget {
  const CustomSearchField({
    Key? key,
    required this.hintField,
    this.backgroundColor,
  }) : super(key: key);

  final String hintField;
  final Color? backgroundColor;

  @override
  _CustomSearchFieldState createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final cardTheme = Theme.of(context).cardTheme;
    final textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).pushNamed(RootPath.exploreSearch); // Adapt the route as needed based on your routing setup
      },
      child: Container(
        width: size.width,
        height: spacer,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(color: widget.backgroundColor, borderRadius: BorderRadius.circular(7.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 40.0,
              width: 40.0,
              alignment: Alignment.center,
              child: Container(
                child: const Icon(AntDesign.search1, weight: 15),
              ),
            ),
            Flexible(
              child: Container(
                width: size.width,
                height: 38,
                alignment: Alignment.centerLeft,
                child: Text(widget.hintField, style: textTheme.bodyLarge),
              ),
            ),
            SizedBox(width: 10.0),
            Container(
              height: 40.0,
              width: 40.0,
              alignment: Alignment.center,
              child: Container(
                child: const Icon(AntDesign.filter, weight: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
