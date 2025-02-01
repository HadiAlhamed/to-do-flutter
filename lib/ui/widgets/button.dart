import 'package:flutter/material.dart';
import 'package:to_do_app/ui/themes.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function() onTap;
  const MyButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      width: 100,
      height: 50,

      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: primaryClr,
        
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
