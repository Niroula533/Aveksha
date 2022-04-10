import 'package:flutter/material.dart';

class TabComponent extends StatelessWidget {
  final String name;
  const TabComponent({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(5),
        height: MediaQuery.of(context).size.height * 0.06,
        width: MediaQuery.of(context).size.width * 0.25,
        color: Color(0xFFFF667E),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              // color: Colors.white,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 0.8
                ..color = Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
