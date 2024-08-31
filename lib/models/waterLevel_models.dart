class WaterLevelData {
  WaterLevelData(this.logTime, this.w1, this.w2);
  final String logTime;
  final double w1;
  final double w2;

  factory WaterLevelData.fromJson(Map<String, dynamic> json) {
    return WaterLevelData(
      json['logTime'],
      json['w1'],
      json['w2'],
    );
  }

  Map<String, dynamic> toJson() => {
        'logTime': logTime,
        'w1': w1,
        'w2': w2,
      };
}

double getMaxYAxisValue(List<WaterLevelData> dataSource) {
  return dataSource.fold(
    0,
    (max, current) => max > current.w2 ? max : current.w2,
  );
}