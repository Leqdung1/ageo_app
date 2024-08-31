class PiezometerData {
  PiezometerData(this.logTime, this.pz1, this.pz2, this.pz3, this.pz4, this.pz5,
      this.pz6, this.pz7, this.pz8);
  final String logTime;
  final double pz1;
  final double pz2;
  final double pz3;
  final double pz4;
  final double pz5;
  final double pz6;
  final double pz7;
  final double pz8;

  factory PiezometerData.fromJson(Map<String, dynamic> json) => PiezometerData(
        json["logTime"],
        json["pz1"],
        json["pz2"],
        json["pz3"],
        json["pz4"],
        json["pz5"],
        json["pz6"],
        json["pz7"],
        json["pz8"],
      );

  Map<String, dynamic> toJson() => {
        "logTime": logTime,
        "pz1": pz1,
        "pz2": pz2,
        "pz3": pz3,
        "pz4": pz4,
        "pz5": pz5,
        "pz6": pz6,
        "pz7": pz7,
        "pz8": pz8,
      };
}
