import 'package:flutter/material.dart';

class TabComponent extends StatelessWidget {
  final String name;
  bool isActive;
  TabComponent({Key? key, required this.name, required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(5),
        height: MediaQuery.of(context).size.height * 0.06,
        width: MediaQuery.of(context).size.width * 0.25,
        color: isActive? Color(0xFFFF667E): Colors.white,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: isActive?Colors.white : Color(0xFF1EA3EA),
            ),
          ),
        ),
      ),
    );
  }
}
