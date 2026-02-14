import 'package:flutter/material.dart';

Container custom_text_field(
  TextEditingController my_controller,
  String hint,
  String place_holder ,
) {
  return Container(
    padding: const EdgeInsets.all(5),
    child: TextField(
      controller: my_controller,

      decoration: InputDecoration(
        labelText: place_holder,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
        ),
      ),
    ),
  );
}
