import 'dart:math';

import 'package:flutter/material.dart';
import '../../models/medicine_model.dart';

class Medicine extends StatefulWidget {
  final Meds med;

  Medicine({
    Key? key,
    required this.med,
  }) : super(key: key);

  @override
  State<Medicine> createState() => _MedicineState();
}

class _MedicineState extends State<Medicine>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse(from: 1);
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward(from: 0);
      }
    });
    setRotation(7);
    super.initState();
  }

  void setRotation(int degrees) {
    final angle = degrees * pi / 360;
    animation =
        Tween<double>(begin: 0, end: angle).animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AnimatedBuilder(
        animation: animation,
        builder: (context, child) => Transform.rotate(
          angle: animation.value,
          child: child,
        ),
        child: GestureDetector(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 100, minHeight: 60),
              child: Container(
                color: Colors.white.withOpacity(0.75),
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.med.name),
                        if (widget.med.dosage.toString().isNotEmpty)
                          Text(widget.med.dosage.toString() + " mg")
                      ],
                    ),
                    Row(
                      children: [
                        ...widget.med.doses.map((item) {
                          return tracking(context, item);
                        }).toList()
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          onLongPress: () {
            animationController.forward(from: 0);
          },
          onTap: () {
            animationController.reset();
          },
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.04,
      ),
    ]);
  }

  Widget tracking(BuildContext context, DoseTime item) {
    return Row(
      children: [
        SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
                backgroundColor: item.isTaken == 1
                    ? Color(0xFF50EC5F)
                    : item.isTaken == 0
                        ? Color(0xFFE1EBF1)
                        : Color(0xFFEC5050),
                child: item.isTaken == 1
                    ? Icon(
                        Icons.check_outlined,
                        color: Colors.white,
                      )
                    : item.isTaken == -1
                        ? Icon(
                            Icons.close,
                            color: Colors.white,
                          )
                        : null),
            Text(
              item.time,
              style: TextStyle(color: Color(0xFF1EA3EA)),
            )
          ],
        ),
      ],
    );
  }
}
