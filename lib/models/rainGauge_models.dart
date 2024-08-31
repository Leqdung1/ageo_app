
class RainData {
  RainData(this.logTime, this.rainAmount);

  final String logTime;
  final double rainAmount;

  factory RainData.fromJson(Map<String, dynamic> json) => RainData(
        json["logTime"],
        (json["rain_mm_Tot"] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'logTime': logTime,
        'rain_mm_Tot': rainAmount,
      };
}