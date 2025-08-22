import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:factor/src/config.dart';

class TextView extends StatelessWidget {
  ///Creates a display widget for local strings.
  const TextView({
    required this.text,
    super.key,
    this.textOverflow = TextOverflow.ellipsis,
    this.textAlign = TextAlign.left,
    this.onTap,
    this.textStyle,
    this.color,
    this.fontSize,
    this.fontFamily,
    this.fontWeight,
    this.maxLines,
    this.decoration,
    this.wordSpacing,
    this.letterSpacing,
    this.lineHeight,
    this.softWrap,
  });

  final String text;
  final TextOverflow? textOverflow;
  final TextAlign? textAlign;
  final VoidCallback? onTap;
  final int? maxLines;
  final double? fontSize;
  final TextStyle? textStyle;
  final Color? color;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final TextDecoration? decoration;
  final double? wordSpacing;
  final double? letterSpacing;
  final double? lineHeight;
  final bool? softWrap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        key: key,
        softWrap: softWrap,
        style:
            textStyle ??
            TextStyle(
              fontFamily: fontFamily ?? FactorStrings.inter,
              fontSize: fontSize != null ? fontSize! : 16,
              fontWeight: fontWeight ?? FontWeight.w400,
              color: color ?? FactorColorsDark.kSoftWhite,
              decoration: decoration,
              wordSpacing: wordSpacing,
              height: lineHeight,
              letterSpacing: letterSpacing,
            ),
        textAlign: textAlign,
        overflow: textOverflow,
        maxLines: maxLines,
      ),
    );
  }
}