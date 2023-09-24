import 'package:flutter/material.dart';
import 'package:mh_core/utils/color/custom_color.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.primary,
    this.borderColor,
    this.labelColor,
    this.fontSize,
    this.fontWeight,
    this.iconData,
    this.height,
    this.borderWidth,
    this.elevation,
    this.boxShadowColor,
    this.isBorder = false,
    this.width,
    this.borderRadiusAll,
    this.contentPadding,
    this.marginHorizontal,
    this.marginVertical,
    this.contentHorizontalPadding,
    this.contentVerticalPadding,
    this.isDisable = false,
    this.prefixImage,
    this.suffixImage,
    this.suffixImageHeight,
    this.suffixImageWidth,
    this.suffixImageColor,
    this.prefixImageHeight,
    this.prefixImageWidth,
    this.prefixImageColor,
    this.loading = false,
  }) : super(key: key);
  final String label;
  final Function()? onPressed;
  final Color? primary;
  final Color? labelColor;
  final Color? boxShadowColor;
  final Color? borderColor;
  final double? fontSize;
  final double? marginHorizontal;
  final double? marginVertical;
  final double? height;
  final double? elevation;
  final double? contentPadding;
  final double? contentHorizontalPadding;
  final double? contentVerticalPadding;
  final double? width;
  final double? borderWidth;
  final double? borderRadiusAll;
  final FontWeight? fontWeight;
  final String? iconData;
  final bool isDisable;
  final bool isBorder;
  final String? prefixImage;
  final String? suffixImage;
  final double? prefixImageHeight;
  final double? prefixImageWidth;
  final Color? prefixImageColor;
  final double? suffixImageHeight;
  final double? suffixImageWidth;
  final Color? suffixImageColor;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: height ?? 48,
      width: width ?? size.width,
      margin: EdgeInsets.symmetric(
        horizontal: marginHorizontal ?? 16,
        vertical: marginVertical ?? 36,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(0.0, 2.0),
            blurRadius: 12,
            color: boxShadowColor ?? const Color(0xffF37048).withOpacity(.12),
          )
        ],
      ),
      child: ElevatedButton(
        onPressed: isDisable ? () {} : onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: primary ?? CustomColor.kPrimaryColor,
          backgroundColor: primary ?? CustomColor.kPrimaryColor,
          elevation: elevation,
          padding: EdgeInsets.symmetric(
              horizontal: contentHorizontalPadding ?? contentPadding ?? 8,
              vertical: contentVerticalPadding ?? contentPadding ?? 8),
          shape: RoundedRectangleBorder(
            side: isBorder
                ? BorderSide(color: borderColor ?? Colors.black, width: 1)
                : BorderSide.none,
            borderRadius: BorderRadius.circular(borderRadiusAll ?? 4),
          ),
        ),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prefixImage != null)
                    Image.asset(
                      prefixImage!,
                      width: prefixImageWidth,
                      height: prefixImageHeight,
                      color: prefixImageColor,
                    ),
                  if (prefixImage != null) const SizedBox(width: 8),
                  Text(label,
                      style: TextStyle(
                        fontSize: fontSize ?? 14,
                        fontWeight: fontWeight ?? FontWeight.w600,
                        color: labelColor ?? Colors.white,
                      )),
                  if (suffixImage != null) const SizedBox(width: 8),
                  if (suffixImage != null)
                    Image.asset(
                      suffixImage!,
                      color: suffixImageColor,
                      height: suffixImageHeight,
                      width: suffixImageWidth,
                    ),
                ],
              ),
      ),
    );
  }
}
