import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordInput extends StatefulWidget {
  final String? Function(String?)? validator;
  final String labelText;
  final TextEditingController? controller;
  final String? validatorText;
  const ChangePasswordInput({
    super.key,
    required this.labelText,
    required this.controller,
    required this.validator,
    this.validatorText,
  });

  @override
  State<ChangePasswordInput> createState() => _PasswordTextInputState();
}

class _PasswordTextInputState extends State<ChangePasswordInput> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      cursorColor: Colors.grey,
      controller: widget.controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        focusColor: Colors.white,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              obscureText = !obscureText;
              print(obscureText);
            });
          },

          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
        ),
        labelText: widget.labelText,
        labelStyle: GoogleFonts.beVietnamPro(color: Colors.grey),
      ),
      validator: widget.validator,
      /*(value) {
        if (value == null || value.isEmpty) {
          return "Input field cannot be empty";
        } else if (value.length < 8) {
          return "Password length cannot be less than 8";
        }
        if (value != widget.controller!.text) {
          return widget.validatorText;
        }
        return null;
      }*/
    );
  }
}
