import 'package:flutter/widgets.dart';
import 'package:whatsapp/core/theme/style.dart';

Widget attachWindowItem({
  IconData? icon,
  Color? color,
  String? title,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: color,
          ),
          child: Center(child: Icon(icon, size: 20)),
        ),
        const SizedBox(height: 5),
        Text("$title", style: const TextStyle(color: greyColor, fontSize: 9)),
      ],
    ),
  );
}
