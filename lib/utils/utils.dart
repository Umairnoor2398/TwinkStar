import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomizedLoginSignupButton extends StatelessWidget {
  final String? buttonText;
  final Color? buttonColor;
  final VoidCallback? onPressed;
  final Color? textColor;
  const CustomizedLoginSignupButton(
      {Key? key,
      this.buttonText,
      this.buttonColor,
      this.onPressed,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: buttonColor,
            border: Border.all(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(buttonText!,
                style: TextStyle(color: textColor, fontSize: 30)),
          ),
        ),
      ),
    );
  }
}

class CustomizedTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? errorText;
  final bool isPassword;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  const CustomizedTextField(
      {Key? key,
      this.controller,
      this.hintText,
      required this.isPassword,
      this.keyboardType,
      this.errorText,
      this.onChanged})
      : super(key: key);

  @override
  State<CustomizedTextField> createState() => _CustomizedTextFieldState();
}

class _CustomizedTextFieldState extends State<CustomizedTextField> {
  bool secureText = false;
  Icon suffixIcon = const Icon(Icons.remove_red_eye);

  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        keyboardType: widget.keyboardType,
        enableSuggestions: !widget.isPassword,
        autocorrect: !widget.isPassword,
        obscureText: secureText,
        controller: widget.controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffe8ecf4), width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffe8ecf4), width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          fillColor: const Color(0xffe8ecf4),
          filled: true,
          hintText: widget.hintText,
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () {
                    if (pressed) {
                      suffixIcon = const Icon(Icons.remove_red_eye);
                      pressed = false;
                    } else {
                      suffixIcon = const Icon(Icons.remove_red_eye_outlined);
                      pressed = true;
                    }
                    setState(() {
                      secureText = !secureText;
                    });
                  },
                  icon: suffixIcon,
                  color: Colors.grey,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final TextInputAction? inputAction;
  final TextEditingController? controller;
  final String? hintText;
  final String? errorText;
  final bool isPassword;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  const CustomTextField(
      {Key? key,
      this.controller,
      this.hintText,
      required this.isPassword,
      this.keyboardType,
      this.errorText,
      this.onChanged,
      this.inputAction})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool secureText = false;
  Icon suffixIcon = const Icon(Icons.remove_red_eye);

  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        maxLines: null,
        style: const TextStyle(
          fontSize: 18,
        ),
        textInputAction: widget.inputAction,
        keyboardType: widget.keyboardType,
        enableSuggestions: !widget.isPassword,
        autocorrect: !widget.isPassword,
        obscureText: secureText,
        controller: widget.controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffe8ecf4), width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffe8ecf4), width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          fillColor: const Color(0xffe8ecf4),
          filled: true,
          hintText: widget.hintText,
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () {
                    if (pressed) {
                      suffixIcon = const Icon(Icons.remove_red_eye);
                      pressed = false;
                    } else {
                      suffixIcon = const Icon(Icons.remove_red_eye_outlined);
                      pressed = true;
                    }
                    setState(() {
                      secureText = !secureText;
                    });
                  },
                  icon: suffixIcon,
                  color: Colors.grey,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}

class Toast {
  static void showToast(String message, Color bgColor) {
    Fluttertoast.showToast(
        msg: message,
        // toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: bgColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
