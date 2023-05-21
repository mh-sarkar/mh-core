import 'package:flutter/material.dart';
import 'package:mh_core/utils/color/custom_color.dart';
import 'package:mh_core/utils/constant.dart';

enum DropdownListType { none, object }

class TitleDropdown extends StatelessWidget {
  final String? dwValue;
  final String? title;
  final List<dynamic> dwItems;
  final String? viewKey;
  final String? valueKey;
  final Function onChange;
  final double? height;
  final double? width;
  final double? circularBorderRadius;
  final String? hintText;
  final Color? textColor;
  final Color? rightIconColor;
  final Color? borderColor;
  final Color? bgColor;
  final Color? itemColor;
  final TextStyle? hintTextStyle;
  final TextStyle? textStyle;
  final double? horizontalPadding;
  bool isFillColor;
  bool isBorder;
  bool isTitle;
  bool isRightIcon;
  final DropdownListType? type;

  TitleDropdown({
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
    this.horizontalPadding,
    this.isFillColor = false,
    this.isBorder = true,
    this.isTitle = true,
    this.isRightIcon = true,
    this.viewKey,
    this.valueKey,
    this.type = DropdownListType.none,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isTitle)
          Text(title ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black,
              )),
        if (isTitle) space4C,
        Container(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 16),
          width: width ?? double.infinity,
          height: height ?? 56,
          decoration: BoxDecoration(
              color: const Color(0xffFCFCFA),
              border: isBorder ? Border.all(color: borderColor ?? Colors.black.withOpacity(.14), width: 1) : null,
              borderRadius: BorderRadius.circular(circularBorderRadius ?? 10),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0.0, 4.0), blurRadius: 16, color: const Color(0xff25251C).withOpacity(.05))
              ]),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: const Color(0xffFCFCFA),
              hint: Container(
                alignment: Alignment.centerLeft,
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
              icon: isRightIcon
                  ? Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: CustomColor.kPrimaryColor,
                      ),
                      child: const Icon(Icons.keyboard_arrow_down_outlined, color: Colors.white),
                    )
                  : Image.asset('images/icon/arrow_down.png', color: rightIconColor),
              isExpanded: true,
              isDense: true,
              value: dwValue,
              onChanged: (newValue) {
                onChange(newValue);
              },
              items: dwItems
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: type == DropdownListType.none ? item : item[valueKey],
                      child: Align(
                        alignment: Alignment.centerLeft,
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
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
