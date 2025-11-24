import 'package:flutter/material.dart';

class PasswordTextInput extends StatefulWidget {
  final String? Function(String?)? validator;
  final String labelText;
  final TextEditingController? controller;
  final String? validatorText;
  const PasswordTextInput({
    super.key,
    required this.labelText,
    required this.controller,
    required this.validator,
    this.validatorText,
  });

  @override
  State<PasswordTextInput> createState() => _PasswordTextInputState();
}

class _PasswordTextInputState extends State<PasswordTextInput> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      cursorColor: Colors.grey,
      controller: widget.controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
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
        labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 161, 161, 161),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: const Color.fromARGB(255, 61, 61, 61)),
        ),
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
