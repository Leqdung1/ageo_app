class warnData {
  final int status;
  final String code;
  final String title;
  final double lat;
  final double lng;
  final double v1;
  final double v2;
  final double v3;
  final DateTime time;

  warnData({
    required this.status,
    required this.code,
    required this.title,
    required this.lat,
    required this.lng,
    required this.v1,
    required this.v2,
    required this.v3,
    required this.time,
  });

  factory warnData.fromJson(Map<String, dynamic> json) => warnData(
        status: json["status"] ?? 0,
        code: json["deviceCode"] ?? '',
        title: json["deviceTitle"] ?? '',
        lat: (json["lat"] as num?)?.toDouble() ?? 0.0,
        lng: (json["lng"] as num?)?.toDouble() ?? 0.0,
        v1: (json["v1"] as num?)?.toDouble() ?? 0.0,
        v2: (json["v2"] as num?)?.toDouble() ?? 0.0,
        v3: (json["v3"] as num?)?.toDouble() ?? 0.0,
        time: json["logTime"] != null
            ? DateTime.parse(json["logTime"])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "deviceCode": code,
        "deviceTitle": title,
        "lat": lat,
        "lng": lng,
        "v1": v1,
        "v2": v2,
        "v3": v3,
        "logTime": time.toIso8601String(),
      };
}
