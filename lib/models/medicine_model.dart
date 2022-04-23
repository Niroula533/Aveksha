class Meds {
  final String name;
  final dosage;
  List<DoseTime> doses;
  Meds(
    this.name,
    this.dosage,
    this.doses,
  );
  Map toJson() {
    List<Map> doseList = doses.map((e) => e.toJson()).toList();
    return {'name': name, 'dosage': dosage, 'doseTime': doseList};
  }
}

class DoseTime {
  int isTaken;
  String time;
  DoseTime(this.isTaken, this.time);
  Map toJson() => {'isTaken': isTaken, 'time': time};
}
