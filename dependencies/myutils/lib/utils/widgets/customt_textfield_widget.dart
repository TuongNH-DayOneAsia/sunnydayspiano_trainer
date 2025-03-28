import 'package:flutter/material.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';

class CustomTextField extends StatefulWidget {
  final Function(String) onChanged;
  final String? labelText, hintText;
  final bool isPassword;
  final Widget? prefixIcon;
  final Function(String)? validateInput;
  final TextInputType keyboardType;
  final double? maxLines;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final bool enabled;
  final bool filled;
  final Function(bool)? onFocusChange;
  final bool? inputBorderNone;

  const CustomTextField({
    super.key,
    required this.onChanged,
    this.labelText,
    this.isPassword = false,
    this.validateInput,
    this.prefixIcon,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.textStyle,
    this.hintStyle,
    this.enabled = true,
    this.filled = false,
    this.onFocusChange,
    this.inputBorderNone,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  String _errorText = '';
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (widget.onFocusChange != null) {
        widget.onFocusChange!(_focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      obscureText: widget.isPassword && _obscureText,
      onChanged: (value) {
        widget.onChanged(value);
        if (widget.validateInput != null) {
          setState(() {
            _errorText = widget.validateInput!(value);
          });
        }
      },
      keyboardType: widget.keyboardType,
      cursorColor: MyColors.lightGrayColor,
      maxLines: widget.maxLines?.toInt(),
      style: widget.textStyle,
      enabled: widget.enabled,
      decoration: InputDecoration(
        filled: widget.filled,
        fillColor: Colors.white,
        prefixIcon: widget.prefixIcon,
        isDense: widget.inputBorderNone == true,
        contentPadding: widget.inputBorderNone == true
            ? const EdgeInsets.symmetric(
                vertical: 0,
              )
            : null,
        border: widget.inputBorderNone == true ? InputBorder.none : const OutlineInputBorder(),
        focusedBorder: widget.inputBorderNone == true ? InputBorder.none : null,
        enabledBorder: widget.inputBorderNone == true ? InputBorder.none : null,
        errorBorder: widget.inputBorderNone == true ? InputBorder.none : null,
        disabledBorder: widget.inputBorderNone == true ? InputBorder.none : null,
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        floatingLabelStyle: TextStyle(color: MyColors.mainColor),
        errorText: _errorText.isEmpty ? null : _errorText,
        errorStyle: TextStyle(color: widget.filled ? MyColors.lightGrayColor : Colors.red),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: MyAppIcon.iconNamedCommon(
                    iconName: 'visible.svg', color: _obscureText ? MyColors.lightGrayColor : MyColors.mainColor),
                onPressed: _togglePasswordVisibility,
              )
            : null,
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
