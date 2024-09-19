class Gnss02Data {
  Gnss02Data(this.logTime, this.dX, this.dY, this.dH);
  final String logTime;
  final double dX;
  final double dY;
  final double dH;

  factory Gnss02Data.fromJson(Map<String, dynamic> json) => Gnss02Data(
        json["logTime"],
        (json["dX"] ?? 0.0).toDouble(),
        (json["dY"] ?? 0.0).toDouble(),
        (json["dH"] ?? 0.0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "logTime": logTime,
        "dX": dX,
        "dY": dY,
        "dH": dH,
      };
}
