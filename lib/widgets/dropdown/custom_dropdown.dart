import 'package:flutter/material.dart';
import 'package:mh_core/utils/color/custom_color.dart';
import 'package:mh_core/utils/constant.dart';

enum DropdownListType { none, object, json }

class TitleDropdown extends StatelessWidget {
  final String? dwValue;
  final String? title;
  final List<dynamic> dwItems;
  final String? viewKey;
  final String? valueKey;
  final Function onChange;
  final double? height;
  final double? width;
  final double? marginHorizontal;
  final double? marginVertical;
  final double? marginTop;
  final double? marginLeft;
  final double? marginRight;
  final double? marginBottom;
  final double? circularBorderRadius;
  final String? hintText;
  final Color? textColor;
  final Color? rightIconColor;
  final Color? borderColor;
  final Color? bgColor;
  final Color? itemColor;
  final Color? fillColor;
  final Color? rightIconBgColor;
  final TextStyle? hintTextStyle;
  final TextStyle? textStyle;
  final TextStyle? titleStyle;
  final IconData? dropDownIconData;
  final double? horizontalContentPadding;
  final bool isFillColor;
  final bool isBorder;
  final bool isTitle;
  final bool isRightIcon;
  final DropdownListType? type;

  const TitleDropdown({
    super.key,
    required this.dwItems,
    this.title,
    required this.dwValue,
    required this.onChange,
    this.height,
    this.width,
    this.bgColor,
    this.rightIconColor,
    this.borderColor,
    this.hintText,
    this.textColor,
    this.itemColor,
    this.circularBorderRadius,
    this.hintTextStyle,
    this.textStyle,
    this.titleStyle,
    this.horizontalContentPadding,
    this.isFillColor = false,
    this.isBorder = true,
    this.isTitle = true,
    this.isRightIcon = true,
    this.viewKey,
    this.valueKey,
    this.type = DropdownListType.none,
    this.marginHorizontal,
    this.marginVertical,
    this.marginTop,
    this.marginLeft,
    this.marginRight,
    this.marginBottom,
    this.fillColor,
    this.dropDownIconData,
    this.rightIconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: marginHorizontal ?? 16,
        vertical: marginVertical ?? 12,
      ).copyWith(
        left: marginLeft ?? marginHorizontal ?? 16,
        top: marginTop ?? marginVertical ?? 12,
        right: marginRight ?? marginHorizontal ?? 16,
        bottom: marginBottom ?? marginVertical ?? 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isTitle)
            Text(title ?? '',
                style:titleStyle?? const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black,
                )),
          if (isTitle) space2C,
          Container(
            // padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 16),
            width: width ?? double.infinity,
            height: height ?? 44,
            decoration: BoxDecoration(
                color: fillColor ?? const Color(0xffFCFCFA),
                border: isBorder ? Border.all(color: borderColor ?? Colors.black.withOpacity(.14), width: 1) : null,
                borderRadius: BorderRadius.circular(circularBorderRadius ?? 5),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0.0, 4.0), blurRadius: 16, color: const Color(0xff25251C).withOpacity(.05))
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(circularBorderRadius ?? 5),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: const Color(0xffFCFCFA),
                  hint: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: horizontalContentPadding ?? 8),
                    child: Text(
                      hintText ?? '',
                      style: hintTextStyle ??
                          TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.black.withOpacity(.50),
                          ),
                    ),
                  ),
                  icon: Container(
                    margin: EdgeInsets.only(right: horizontalContentPadding ?? 8),
                    height: (height ?? 44) - 8,
                    width: (height ?? 44) - 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: rightIconBgColor ?? CustomColor.kPrimaryColor,
                    ),
                    child: Center(
                      child: Icon(dropDownIconData ?? Icons.keyboard_arrow_down_outlined,
                          color: rightIconColor ?? CustomColor.kTextColor),
                    ),
                  ),
                  isExpanded: true,
                  isDense: true,
                  value: dwValue,
                  onChanged: (newValue) {
                    onChange(newValue);
                  },
                  items: dwItems
                      .map((e) => type == DropdownListType.object ? e.toJson() : e)
                      .toList()
                      .map(
                        (item) => DropdownMenuItem<String>(
                          value: type == DropdownListType.none ? item : item[valueKey],
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: horizontalContentPadding ?? 8),
                              child: Text(
                                type == DropdownListType.none ? item : item[viewKey],
                                style: textStyle ??
                                    const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
