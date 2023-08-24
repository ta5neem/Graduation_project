import 'package:gui/core/utils/color_manager.dart';
import 'package:flutter/material.dart';


typedef TextFieldChangedCallback = void Function(String value);
class EditTextField extends StatelessWidget {
   TextFieldChangedCallback? onChanged;
  late String label;
  late String hint;
  int? maxLength;
  TextEditingController controller;
  double width;
  String? errorText;
  var type;
  bool obscure;
  VoidCallback? onIconPressed;

  EditTextField({required this.label,
    required this.hint,
    required this.controller,
    required this.type,
    required this.width,
    this.onIconPressed,
    this.maxLength,
    this.obscure = false,
    this.errorText,
    this.onChanged,
    Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
            child: Text(label, style: Theme
                .of(context)
                .textTheme
                .titleLarge),
          ),
          TextField(
            onChanged: onChanged,
            keyboardType: type,
            // style: Theme.of(context).textTheme.bodyLarge,
            obscureText: obscure,
            controller: controller,
            maxLength: maxLength,
            autofocus: false,
            decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(15),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: ColorsManager.lightTeal),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: ColorsManager.lightTeal),
                  borderRadius: BorderRadius.circular(15),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: controller.text.isEmpty ? Colors.black12 : Colors.redAccent),
                  borderRadius: BorderRadius.circular(15),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black12),
                  borderRadius: BorderRadius.circular(15),
                ),
                suffixIcon: label == 'password'

                    ?
                // Icon( Icons.remove_red_eye, color: my_colors.myRed,)
                IconButton(
                  icon: Icon(
                      obscure == false ? Icons.remove_red_eye : Icons.visibility_off,
                      color: ColorsManager.darkTeal),
                  onPressed: onIconPressed,
                )
                    : null,
                fillColor: Colors.white,
                filled: true,
                hintText: hint,
                hintStyle: Theme
                    .of(context)
                    .textTheme
                    .labelLarge,
                errorText: errorText,
                errorStyle: const TextStyle(fontSize: 12, color: ColorsManager.red),
                errorMaxLines: 1),
          ),
        ],
      ),
    );
  }

}
