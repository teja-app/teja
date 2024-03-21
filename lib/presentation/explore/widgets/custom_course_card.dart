import 'package:flutter/material.dart';

class CustomCourseCardExpand extends StatefulWidget {
  const CustomCourseCardExpand({
    Key? key,
    required this.thumbNail,
    required this.videoAmount,
    required this.title,
    required this.userProfile,
    required this.userName,
    required this.price,
  }) : super(key: key);

  final String thumbNail;
  final String videoAmount;
  final String title;
  final String userProfile;
  final String userName;
  final String price;

  @override
  _CustomCourseCardExpandState createState() => _CustomCourseCardExpandState();
}

class _CustomCourseCardExpandState extends State<CustomCourseCardExpand> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final cardTheme = Theme.of(context).cardTheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      width: size.width * .6,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(7.0),
      decoration: BoxDecoration(
        color: cardTheme.color,
        borderRadius: BorderRadius.circular(17.0),
        boxShadow: [
          BoxShadow(
            color: cardTheme.color!.withOpacity(0.1),
            blurRadius: 10.0,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Container(
                height: size.width * .6,
                width: size.width * .6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    widget.thumbNail,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 7.0,
                left: 7.0,
                child: Container(
                  width: 90.0,
                  height: 30.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: cardTheme.color!.withOpacity(0.75), borderRadius: BorderRadius.circular(100.0)),
                  child: Text(
                    '${widget.videoAmount} Videos',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.0),
          Container(
            padding: const EdgeInsets.only(
              left: 7.0,
              right: 7.0,
            ),
            child: Text(
              widget.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleMedium,
            ),
          ),
          SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.only(
              left: 7.0,
              right: 7.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 30.0,
                  width: 30.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Image.network(
                      widget.userProfile,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: Container(
                    width: size.width,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.userName,
                      style: textTheme.titleSmall,
                    ),
                  ),
                ),
                Text(
                  '\$${widget.price}',
                  style: textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}

class CustomCourseCardShrink extends StatefulWidget {
  const CustomCourseCardShrink({
    Key? key,
    required this.thumbNail,
    required this.title,
    required this.userName,
    required this.price,
  }) : super(key: key);

  final String thumbNail;
  final String title;
  final String userName;
  final String price;

  @override
  _CustomCourseCardShrinkState createState() => _CustomCourseCardShrinkState();
}

class _CustomCourseCardShrinkState extends State<CustomCourseCardShrink> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Color primary = colorScheme.primary;
    TextTheme textTheme = Theme.of(context).textTheme;
    final cardTheme = Theme.of(context).cardTheme;
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.width * .2,
      padding: const EdgeInsets.all(15.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: cardTheme.color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Container(
            height: size.width * .125,
            width: size.width * .125,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                widget.thumbNail,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 15.0),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: textTheme.bodyLarge),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Instructor: ' + widget.userName,
                      style: textTheme.titleMedium,
                    ),
                    Text(
                      '\$' + widget.price,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
