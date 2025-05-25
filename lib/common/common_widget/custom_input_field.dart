import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

typedef ValidatorFunction = String? Function(String?);

class CustomInputField extends StatefulWidget {
  final IconData? icon;
  final String label;
  final TextEditingController controller;
  final bool isSecure;
  final List<ValidatorFunction>? validators;

  const CustomInputField({
    super.key,
    this.icon,
    required this.label,
    required this.controller,
    this.isSecure = false,
    this.validators,
  });

  @override
  _CustomInputField createState() => _CustomInputField();
}

class _CustomInputField extends State<CustomInputField> {
  late bool obscureText;

  @override
  void initState() {
    super.initState();
    obscureText = widget.isSecure;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: TextFormField(
          controller: widget.controller,
          obscureText: obscureText,
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.black87),
          decoration: InputDecoration(
            errorMaxLines: 2,
            labelText: widget.label,
            suffixIcon: widget.isSecure
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText; // Toggle visibility
                      });
                    },
                  )
                : null,
            prefixIcon: widget.icon != null
                ? Icon(widget.icon, color: Colors.blue.shade900)
                : null,
            filled: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            fillColor: const Color.fromARGB(255, 247, 246, 252),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your ${widget.label.toLowerCase()}';
            }

            // Run additional validators if provided
            if (widget.validators != null) {
              for (var validator in widget.validators!) {
                final result = validator(value);
                if (result != null) return result;
              }
            }

            return null;
          }),
    );
  }
}
