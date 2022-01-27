import 'package:flutter/material.dart';

Container ModalContainerTextBox(
    {TextEditingController? controller,
    String? hintText,
    context,
    void function()?,
    readonly = false}) {
  return Container(
    margin: const EdgeInsets.only(top: 50),
    alignment: Alignment.topCenter,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextFormField(
            readOnly: readonly,
            onTap: function,
            controller: controller,
            decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 2.0,
                ),
              ),
              hintText: hintText,
            ),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}
