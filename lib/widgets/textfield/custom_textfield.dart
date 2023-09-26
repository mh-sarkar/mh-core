import 'package:flutter/material.dart';
import 'package:mh_core/utils/color/custom_color.dart';

import '../../utils/constant.dart';

class CustomTextField extends StatefulWidget {
  final double? height;
  final double? width;
  final double? borderRadius;
  final String? hintText;
  final double? hintSize;
  final Color? hintColor;
  final Color? focusColor;
  final Widget? prefixWidget;
  final Color? enableBorderColor;
  final FontWeight? hintFontWeight;
  final double? textSize;
  final Color? textColor;
  final Color? fillColor;
  final FontWeight? textFontWeight;
  final String? labelText;
  final double? labelSize;
  final Color? labelColor;
  final FontWeight? labelFontWeight;
  final String? errorMessage;
  final int? maxLine;
  final TextEditingController? controller;
  final double? marginHorizontal;
  final double? marginVertical;
  final Function(String)? onSubmitted;
  final bool? isPassword;
  final bool? obscureText;
  final bool? isInvalid;
  final bool isLabelSeparated;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final bool isRequired;
  final bool isEnable;
  final ValueChanged<String>? onChanged;
  final double? marginTop;
  final double? marginLeft;
  final double? marginRight;
  final double? marginBottom;
  final double? borderWidth;
  final Color? suffixIconColor;

  const CustomTextField({
    Key? key,
    this.height,
    this.width,
    this.borderRadius,
    this.hintText,
    this.focusColor,
    this.hintSize,
    this.fillColor,
    this.enableBorderColor,
    this.prefixWidget,
    this.hintColor,
    this.hintFontWeight,
    this.textColor,
    this.textSize,
    this.textFontWeight,
    this.labelText,
    this.labelColor,
    this.labelFontWeight,
    this.labelSize,
    this.errorMessage,
    this.onChanged,
    this.isEnable = true,
    this.maxLine = 1,
    this.controller,
    this.marginHorizontal,
    this.suffixIcon,
    this.marginVertical,
    this.isPassword = false,
    this.isLabelSeparated = true,
    this.obscureText = false,
    this.isInvalid = false,
    this.focusNode,
    this.keyboardType,
    this.isRequired = false,
    this.onSubmitted,
    this.marginTop,
    this.marginLeft,
    this.marginRight,
    this.marginBottom,
    this.borderWidth,
    this.suffixIconColor,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = false;
  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.symmetric(
          horizontal: widget.marginHorizontal ?? 16,
          vertical: widget.marginVertical ?? 12,
        ).copyWith(
          left: widget.marginLeft ?? widget.marginHorizontal ?? 16,
          top: widget.marginTop ?? widget.marginVertical ?? 12,
          right: widget.marginRight ?? widget.marginHorizontal ?? 16,
          bottom: widget.marginBottom ?? widget.marginVertical ?? 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isLabelSeparated && widget.labelText != null)
              Row(
                children: [
                  Text(widget.labelText ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: widget.labelColor ?? Colors.black,
                      )),
                  if (widget.isRequired)
                    Text(
                      ' *',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: widget.labelSize,
                          fontWeight: widget.labelFontWeight),
                    )
                ],
              ),
            if (widget.isLabelSeparated && widget.labelText != null) space2C,
            SizedBox(
              height: widget.maxLine == null &&
                      (widget.maxLine != null && widget.maxLine! > 1)
                  ? null
                  : widget.height ?? 44,
              width: widget.width ?? size.width,
              // margin: EdgeInsets.symmetric(
              //   horizontal: widget.marginHorizontal ?? 16,
              //   vertical: widget.marginVertical ?? 12,
              // ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      enabled: widget.isEnable,
                      focusNode: widget.focusNode,
                      cursorColor: Colors.black,
                      obscureText: _obscureText,
                      controller: widget.controller,
                      maxLines: widget.maxLine,
                      keyboardType: widget.keyboardType,
                      onFieldSubmitted: widget.onSubmitted,
                      style: TextStyle(
                        color: widget.textColor ?? Colors.black,
                        fontSize: widget.textSize ?? 14,
                        fontWeight: widget.textFontWeight ?? FontWeight.w500,
                      ),
                      onChanged: widget.onChanged,
                      decoration: InputDecoration(
                          prefixIcon: widget.prefixWidget,
                          fillColor: widget.fillColor,
                          filled: widget.fillColor != null,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                          hintText: widget.hintText,
                          hintStyle: TextStyle(
                            color: widget.hintColor ??
                                const Color(0xff000000).withOpacity(0.40),
                            fontSize: widget.hintSize ?? 14,
                            fontWeight:
                                widget.hintFontWeight ?? FontWeight.w400,
                          ),
                          labelStyle: TextStyle(
                            color: widget.labelColor ??
                                Colors.black.withOpacity(.7),
                            fontSize: widget.labelSize ?? 12,
                            fontWeight:
                                widget.labelFontWeight ?? FontWeight.w400,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(widget.borderRadius ?? 5),
                            borderSide: BorderSide(
                              color:
                                  widget.focusColor ?? const Color(0xffD9D9D9),
                              width: widget.borderWidth ?? 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(widget.borderRadius ?? 5),
                            borderSide: BorderSide(
                              color: widget.enableBorderColor ??
                                  const Color(0xffD9D9D9),
                              width: widget.borderWidth ?? 1,
                            ),
                          ),
                          labelText:
                              widget.isLabelSeparated ? null : widget.labelText,
                          isDense: true,
                          suffixIcon: widget.isPassword!
                              ? InkWell(
                                  onTap: () {
                                    toogle();
                                  },
                                  child: Icon(
                                      _obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: widget.suffixIconColor ??
                                          const Color(0xff484848)),
                                )
                              : widget.suffixIcon),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.errorMessage != null)
              Column(
                children: [
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.errorMessage!,
                      style: TextStyle(
                        color: CustomColor.kPrimaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ));
  }

  void toogle() {
    _obscureText = !_obscureText;
    setState(() {});
  }
}
