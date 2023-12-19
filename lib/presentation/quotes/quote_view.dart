import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class QuoteStyle {
  final TextStyle textStyle;
  final double spacing;

  QuoteStyle({
    required this.textStyle,
    this.spacing = 10.0,
  });
}

class QuoteView extends StatelessWidget {
  final String quoteText;
  final String? quoteAuthor;
  final QuoteStyle style;
  final ImageProvider background;
  final Alignment alignment;
  final bool isLogoAtTop;

  const QuoteView({
    Key? key,
    required this.quoteText,
    this.quoteAuthor,
    required this.style,
    required this.background,
    this.alignment = Alignment.center,
    this.isLogoAtTop = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: background,
          fit: BoxFit.cover,
        ),
      ),
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLogoAtTop) SvgPicture.asset("assets/logo/ColorVertical.svg", width: 60),
            SizedBox(height: style.spacing),
            Text(
              quoteText,
              style: style.textStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: style.spacing),
            if (quoteAuthor != null)
              Text(
                "- ${quoteAuthor!}",
                style: style.textStyle.copyWith(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
            if (!isLogoAtTop) SvgPicture.asset("assets/logo/ColorVertical.svg", width: 60),
          ],
        ),
      ),
    );
  }
}
