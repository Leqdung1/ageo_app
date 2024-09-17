class UserData {
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? imageUrl;

  UserData({
    this.name,
    this.email,
    this.phoneNumber,
    this.imageUrl,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json["displayName"] ?? 'Không có dữ liệu',
      email: json['email'] ?? 'Không có dữ liệu',
      phoneNumber: json["phoneNumber"] ?? 'Không có dữ liệu',
      imageUrl: json["avatar"] ?? '',
    );
  }
}
