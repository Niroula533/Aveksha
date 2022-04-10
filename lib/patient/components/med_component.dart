import 'package:flutter/material.dart';

class Medicine extends StatelessWidget {
  final String name;
  var dosage;
  final List<int> taken;
  final List<int> hours;
  final int minute;

  Medicine(
      {Key? key,
      required this.name,
      this.dosage,
      required this.taken,
      required this.hours,
      required this.minute})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 100, minHeight: 60),
          child: Container(
            // height: MediaQuery.of(context).size.height,
            color: Colors.white.withOpacity(0.75),
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(name), Text(dosage.toString() + " mg")],
                ),
                Row(
                  children: [
                    ...taken.map((isTaken) {
                      // return Column(
                      //   children: [
                      return tracking(context, isTaken);

                      // ],
                      // );
                    }).toList()
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.04,
      ),
    ]);
  }

  Widget tracking(BuildContext context, int isTaken) {
    return Row(
      children: [
        SizedBox(width: 10),
        CircleAvatar(
            backgroundColor: isTaken == 1
                ? Color(0xFF50EC5F)
                : isTaken == 0
                    ? Color(0xFFE1EBF1)
                    : Color(0xFFEC5050),
            child: isTaken == 1
                ? Icon(
                    Icons.check_outlined,
                    color: Colors.white,
                  )
                : isTaken == -1
                    ? Icon(
                        Icons.close,
                        color: Colors.white,
                      )
                    : null),
      ],
    );
  }
}
