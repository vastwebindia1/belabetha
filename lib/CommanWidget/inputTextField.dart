import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/ThemeColor/Color.dart';

class InputTextField extends StatefulWidget {
  final String hint,errorText;
  final String label;
  final TextInputType keyBordType;
  final IconData icon;
  final Widget iButton;
  final obscureText;
  final FormFieldValidator validator;
  final TextEditingController controller;
  final BorderSide borderSide;
  final String preText;
  final onSaved;
   final TextStyle labelStyle;
   final TextStyle hintStyle;
  final ValueChanged<String> onChange;
  final int maxLength;
  final bool checkenable;
  final List<TextInputFormatter> inputFormatter;

  const InputTextField({
    Key key,
    this.maxLength,
    this.hint,
    this.label,
    this.keyBordType,
    this.icon,
    this.iButton,
    this.obscureText,
    this.borderSide,
    this.controller,
    this.validator,
    // ignore: deprecated_member_use
    FlatButton suffixIcon,
    TextStyle suffixStyle,
    this.onSaved,
    this.labelStyle,
    this.hintStyle,
    this.preText,
    this.onChange,
    this.checkenable,
    this.inputFormatter, this.errorText, EdgeInsets contentPadding,
  }) : super(key: key);

  @override
  _InputTextFieldState createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  // ignore: non_constant_identifier_names
  void InputTap() {
    setState(() {
      InputDecoration(
        labelStyle: TextStyle(color: PrimaryColor),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 0,
            color: PrimaryColor,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
      ),
      child: TextFormField(
        inputFormatters: widget.inputFormatter,
        style: TextStyle(fontSize: 18, color: PrimaryColor),
        onChanged: widget.onChange,
        controller: widget.controller,
        validator: widget.validator,
        obscureText: widget.obscureText,
        keyboardType: widget.keyBordType,
        maxLength: widget.maxLength,
        enabled: widget.checkenable,
        onTap: InputTap,
        buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
        decoration: InputDecoration(
          errorText:widget.errorText,
          contentPadding: EdgeInsets.only(top: 18,bottom: 18,left: 10),
          labelStyle: widget.labelStyle,
          labelText: widget.label,
          suffixIcon: widget.iButton,
          prefixText: widget.preText,
          hintText: widget.hint,
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(1)),
          ),
          hintStyle: TextStyle(color: PrimaryColor),
        ),
        cursorColor: PrimaryColor,
        cursorHeight: 20,
      ),
    );
  }
}
