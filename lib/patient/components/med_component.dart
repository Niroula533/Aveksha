import 'dart:math';

import 'package:aveksha/apis/getNdeleteReminders.dart';
import 'package:aveksha/controllers/reminderControl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/medicine_model.dart';

class Medicine extends StatefulWidget {
  final Meds med;
  final id;
  Medicine({
    Key? key,
    required this.med,
    required this.id,
  }) : super(key: key);

  @override
  State<Medicine> createState() => MedicineState();
}

class MedicineState extends State<Medicine>
    with SingleTickerProviderStateMixin {
  GlobalKey<MedicineState> medicineKey = GlobalKey<MedicineState>();
  late AnimationController animationController;
  late Animation<double> animation;
  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed &&
          Get.find<AllReminders>().play) {
        animationController.reverse(from: 1);
      } else if (status == AnimationStatus.dismissed &&
          Get.find<AllReminders>().play) {
        animationController.forward(from: 0);
      } else if (!Get.find<AllReminders>().play) {
        animationController.reset();
      }
    });
    setRotation(2);
    super.initState();
  }

  void setRotation(int degrees) {
    final angle = degrees * pi / 360;
    animation =
        Tween<double>(begin: 0, end: angle).animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(key: medicineKey, children: [
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
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white.withOpacity(0.75),
                      padding: EdgeInsets.all(10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(widget.med.name),
                                if (widget.med.dosage.toString().isNotEmpty &&
                                    widget.med.dosage != null)
                                  Text(widget.med.dosage.toString() + " mg")
                              ],
                            ),
                            GetX<AllReminders>(builder: (controller) {
                              int reminderIndex = controller.allMedicine
                                  .indexWhere(
                                      (element) => element.id == widget.id);
                              // return Row(
                              //   children: [
                              //     ...controller
                              //         .allMedicine[reminderIndex].med.doses
                              //         .map((item) {
                              //       return tracking(item);
                              //     }).toList()
                              //   ],
                              // );
                              return Container(
                                width: MediaQuery.of(context).size.width *0.4,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                    itemCount: controller
                                        .allMedicine[reminderIndex]
                                        .med
                                        .doses
                                        .length,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children: [
                                          SizedBox(width: 10),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                  backgroundColor: controller
                                                              .allMedicine[
                                                                  reminderIndex]
                                                              .med
                                                              .doses[index]
                                                              .isTaken ==
                                                          1
                                                      ? Color(0xFF50EC5F)
                                                      : controller
                                                                  .allMedicine[
                                                                      reminderIndex]
                                                                  .med
                                                                  .doses[index]
                                                                  .isTaken ==
                                                              0
                                                          ? Color(0xFFE1EBF1)
                                                          : Color(0xFFEC5050),
                                                  child: controller
                                                              .allMedicine[
                                                                  reminderIndex]
                                                              .med
                                                              .doses[index]
                                                              .isTaken ==
                                                          1
                                                      ? Icon(
                                                          Icons.check_outlined,
                                                          color: Colors.white,
                                                        )
                                                      : controller
                                                                  .allMedicine[
                                                                      reminderIndex]
                                                                  .med
                                                                  .doses[index]
                                                                  .isTaken ==
                                                              -1
                                                          ? Icon(
                                                              Icons.close,
                                                              color: Colors.white,
                                                            )
                                                          : null),
                                              Text(
                                                controller
                                                    .allMedicine[reminderIndex]
                                                    .med
                                                    .doses[index]
                                                    .time,
                                                style: TextStyle(
                                                    color: Color(0xFF1EA3EA)),
                                              )
                                            ],
                                          ),
                                        ],
                                      );
                                    }),
                              );
                            }),
                          ]),
                    ),
                    // if (Get.find<AllReminders>().play) Get only when long pressed!
                    Positioned(
                      left: width * 0.85,
                      child: GestureDetector(
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red[400],
                            child: Icon(
                              Icons.delete_forever_sharp,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          onTap: () async {
                            // widget.delReminder(widget.id);
                            await Get.find<AllReminders>().delReminder(
                                id: widget.id,
                                context: medicineKey.currentContext);
                          }),
                    )
                  ],
                ),
              ),
            ),
            onLongPress: () {
              // widget.setPlay(true);
              Get.find<AllReminders>().play = true;
              animationController.forward(from: 0);
            }),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.04,
      ),
    ]);
  }

  Widget tracking(DoseTime item) {
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
