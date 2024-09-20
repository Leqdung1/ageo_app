class CommonData {
  CommonData(
    this.logTime,
    this.v1,
    this.v2,
    this.v3,
    this.v4,
    this.v5,
    this.v6,
    this.v7,
    this.v8,
    this.v9,
    this.v10,
    this.v11,
    this.v12,
  );
  final String logTime;
  final double v1;
  final double v2;
  final double v3;
  final double v4;
  final double v5;
  final double v6;
  final double v7;
  final double v8;
  final double v9;
  final double v10;
  final double v11;
  final double v12;

  factory CommonData.fromJson(Map<String, dynamic> json) => CommonData(
        json["logTime"],
        json["v1"]?.toDouble() ?? 0.0,
        json["v2"]?.toDouble() ?? 0.0,
        json["v3"]?.toDouble() ?? 0.0,
        json["v4"]?.toDouble() ?? 0.0,
        json["v5"]?.toDouble() ?? 0.0,
        json["v6"]?.toDouble() ?? 0.0,
        json["v7"]?.toDouble() ?? 0.0,
        json["v8"]?.toDouble() ?? 0.0,
        json["v9"]?.toDouble() ?? 0.0,
        json["v10"]?.toDouble() ?? 0.0,
        json["v11"]?.toDouble() ?? 0.0,
        json["v12"]?.toDouble() ?? 0.0,
      );
}
