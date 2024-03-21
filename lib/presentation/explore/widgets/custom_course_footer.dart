import 'package:teja/theme/padding.dart';
import 'package:flutter/material.dart';

import 'custom_button_box.dart';

class CustomCourseFooter extends StatelessWidget {
  const CustomCourseFooter({
    Key? key,
    this.coursePrice = '',
    this.enrolled = false,
  }) : super(key: key);

  final String coursePrice;
  final bool enrolled;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final cardTheme = Theme.of(context).cardTheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return (enrolled)
        ? Container(
            width: size.width,
            height: 100.0,
            padding: const EdgeInsets.all(appPadding),
            decoration: BoxDecoration(
              color: cardTheme.color,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: CustomButtonBox(title: 'Continue Class'),
          )
        : Container(
            width: size.width,
            height: 100.0,
            padding: const EdgeInsets.only(
              left: appPadding,
              right: appPadding,
              top: appPadding,
            ),
            decoration: BoxDecoration(
              color: cardTheme.color,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Course Price',
                        style: textTheme.bodyMedium,
                      ),
                      SizedBox(height: 5),
                      Text(
                        coursePrice,
                        style: textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: miniSpacer + 5),
                Flexible(child: CustomButtonBox(title: 'Enroll Now')),
              ],
            ),
          );
  }
}
