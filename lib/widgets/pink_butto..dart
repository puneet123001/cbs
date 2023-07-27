import 'package:flutter/material.dart';

class PinkButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final double width;
  const PinkButton({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * width,
        height: 45,
        decoration: BoxDecoration(
            color: Colors.pink.shade400,
            borderRadius: BorderRadius.circular(12)),
        child: MaterialButton(
          onPressed: onPressed,
          child: Text(
            label,
            style: const TextStyle(color: Colors.yellow),
          ),
        ));
  }
}
