import 'package:flutter/material.dart';
import 'package:law_education_app/conts.dart';

class SeeMoreTextCustom extends StatefulWidget {
  final String text;
  final int trimLines;
  final TextStyle? style;
  final String trimCollapsedText;
  final String trimExpandedText;
  final Color? colorClickableText;
  final TextStyle? clickableTextStyle;

  const SeeMoreTextCustom({
    Key? key,
    required this.text,
    this.trimLines = 2,
    this.style,
    this.trimCollapsedText = 'See More',
    this.trimExpandedText = 'See Less',
    this.colorClickableText = primaryColor,
    this.clickableTextStyle,
  }) : super(key: key);

  @override
  _SeeMoreTextCustomState createState() => _SeeMoreTextCustomState();
}

class _SeeMoreTextCustomState extends State<SeeMoreTextCustom> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textSpan = TextSpan(
      text: widget.text,
      style: widget.style ?? const TextStyle(fontSize: 14),
    );

    final textPainter = TextPainter(
      text: textSpan,
      maxLines: widget.trimLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width);

    final isTextTooLong = textPainter.didExceedMaxLines;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: isExpanded || !isTextTooLong
                    ? widget.text
                    : widget.text.substring(0, textPainter.getPositionForOffset(Offset(
                  MediaQuery.of(context).size.width,
                  textPainter.size.height,
                )).offset) + '...',
                style: widget.style ?? const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        if (isTextTooLong)
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              isExpanded ? widget.trimExpandedText : widget.trimCollapsedText,
              style: widget.clickableTextStyle ?? TextStyle(
                color: widget.colorClickableText,
                fontSize: 12, // Custom size for "See More" and "See Less"
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
