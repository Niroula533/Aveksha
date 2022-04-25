import 'package:flutter/material.dart';

class TabComponent extends StatelessWidget {
  final String name;
  bool isActive;
  final double heightRatio, widthRatio;
  TabComponent({Key? key, required this.name, required this.isActive, required this.heightRatio, required this.widthRatio})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(5),
        height: MediaQuery.of(context).size.height * heightRatio,
        width: MediaQuery.of(context).size.width * widthRatio,
        color: isActive ? Color(0xFFFF667E) : Colors.white,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: isActive ? Colors.white : Color(0xFF1EA3EA),
            ),
          ),
        ),
      ),
    );
  }
}
