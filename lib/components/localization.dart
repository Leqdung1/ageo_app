import 'dart:ui';

import 'package:flutter_localization/flutter_localization.dart';

// ignore: non_constant_identifier_names
final List<MapLocale> Local = [
  MapLocale('en', LocalData.EN),
  MapLocale('vi', LocalData.VI),
];

mixin LocalData {
  static String title = 'title';
  static String infoTitle = 'infoTitle';
  static String infoDetails1 = 'infoDetails1';
  static String infoDetails2 = 'infoDetails2';
  static String infoDetails3 = 'infoDetails3';
  static String infoDetails4 = "infoDetails4";
  static String infoDetails5 = "infoDetails5";
  static String infoDetails6 = "infoDetails6";
  static String infoDetails7 = "infoDetails7";
  static String infoDetails8 = "infoDetails8";
  static String infoDetails9 = "infoDetails9";
  static String infoDetails10 = "infoDetails10";
  static String changeLanguage = "titleChangeLanguage";
  static String language1 = "language1";
  static String language2 = "language2";
  static String bottomlabel1 = "bottomLabel1";
  static String bottomlabel2 = "bottomLabel2";
  static String bottomlabel3 = "bottomLabel3";
  static String bottomlabel4 = "bottomLabel4";
  static String bottomlabel5 = "bottomLabel5";
  static String bottomLabel6 = "bottomLabel6";
  static String setting = "setting";
  static String hello = "hello";
  static String accountSetting = "accountSetting";
  static String infomation = "info";
  static String changeLang = "changeLang";
  static String darkMode = "darkMode";
  static String changePassWord = "changePassWord";
  static String logOut = "logOut";
  static String typeNameandNumber = "NameAndNumber";
  static String userName = "userName";
  static String password = "password";
  static String numberMustWrite = "numberMustWrite";
  static String passwordMustWrite = "passwordMustWrite";
  static String logIn = "logIn";
  static String forgotPassword = "forgotPassword";
  static String changeSystem = "changeSystem";
  static String textModal = "textModal";
  static String title1 = "title1";
  static String title2 = "title2";
  static String day = "day";
  static String hours = "hours";
  static String month = "month";
  static String year = "year";
  static String fromDate = "fromDate";
  static String toDate = "toDate";
  static String gnss = "gnss";
  static String loRong = "loRong";
  static String nghiengSau = "nghiengSau";
  static String mua = "mua";
  static String mucNuoc = "mucNuoc";
  static String overView = "overView";
  static String news = "news";

  // ignore: non_constant_identifier_names
  static Map<String, dynamic> EN = {
    "infoTitle": "Informations",
    "infoDetails1": "Slope failure near Khe Sanh, ward 10, DaLat, after a heavy rain",
    "infoDetails2": "Slope failure at Pham Hong Thai str, ward 10, Da Lat",
    "infoDetails3": "Slope failure behind the Hoang Long hotel, Nhat Huy hotel, Thao Quyen hotel, Hoang Lan hotel at Khe Sanh street, ward 10, DaLat, in a sunny day",
    "infoDetails4": "Geometric monitoring the hotel",
    "infoDetails5": "Commencement the rehabilitation project",
    "infoDetails6": "Installation of the GNSS sensors on the hotel",
    "infoDetails7": "Installtion of the rain gauge",
    "infoDetails8": "Installtion of the warning equiptments",
    "infoDetails9": "Completed the installation and monitoring of monitoring equipment on the embankment, the blocks are currently stable.",
    "infoDetails10": "A landslide on an under-construction project at 15/2 Yen The, Ward 10, Da Lat City destroyed the structure on the slope and at the foot of the slope as well as killing two people.",
    "titleChangeLanguage": "Change language",
    "language1": "Vietnamese",
    "language2": "English",
    "bottomLabel1": "Control panel",
    "bottomLabel2": "Map",
    "bottomLabel3": "Camera",
    "bottomLabel4": "Device",
    "bottomLabel5": "Warning",
    "bottomLabel6": "More",
    "setting": "Setting",
    "hello": "Hello,",
    "accountSetting": "Account setting",
    "info": "Infomation",
    "changeLang": "Change language",
    "darkMode": "Dark mode",
    "changePassWord": "Change password",
    "logOut": "Log out",
    "NameAndNumber": "Enter your username & password to access the system",
    "userName": "Username",
    "password": "Password",
    "numberMustWrite": "Username cannot be blank.",
    "passwordMustWrite": "Password can not be blank.",
    "logIn": "Log in",
    "forgotPassword": "Forgot password?",
    "changeSystem": "Change system",
    "textModal": "Done",
    "title1": "Khe Sanh, Ward 10, Da lat City",
    "title2": "Hung Yen Province",
    "hours": "Hours",
    "day": "Day",
    "month": "Month",
    "year": "Year",
    "fromDate": "From date",
    "toDate": "To date",
    "gnss": "GNSS",
    "loRong": "Piezometer",
    "nghiengSau": "Inclinometer",
    "mua": "Rain Gauge",
    "mucNuoc": "Water Level",
    "overView": "Overview",
    "news": "News",
  };

  // ignore: non_constant_identifier_names
  static Map<String, dynamic> VI = {
    infoTitle: 'Thông tin',
    infoDetails1:
        'Sạt lở đất gần Khe Sanh, phường 10, Đà Lạt, sau một trận mưa lớn',
    infoDetails2: 'Sạt lở đất tại đường Phạm Hồng Thái, phường 10, Đà Lạt',
    infoDetails3:
        'Sạt lở đất sau khách sạn Hoàng Long, khách sạn Nhật Huy, khách sạn Thảo Quyên, khách sạn Hoàng Lan tại đường Khe Sanh, phường 10, Đà Lạt, vào một ngày nắng',
    "infoDetails4": "Giám sát hình học khách sạn",
    "infoDetails5": "Khởi công dự án phục hồi",
    "infoDetails6": "Lắp đặt cảm biến GNSS trên khách sạn",
    "infoDetails7": "Lắp đặt máy đo mưa",
    "infoDetails8": "Lắp đặt thiết bị cảnh báo",
    "infoDetails9":
        "Hoàn thành việc lắp đặt và giám sát thiết bị giám sát trên bờ kè, các khối hiện đang ổn định.",
    "infoDetails10":
        "Một vụ lở đất tại dự án đang xây dựng ở 15/2 Yên Thế, Phường 10, Thành phố Đà Lạt đã phá hủy cấu trúc trên sườn dốc và chân dốc cũng như khiến hai người thiệt mạng.",
    "titleChangeLanguage": "Thay đổi ngôn ngữ",
    "language1": "Tiếng việt",
    "language2": "Tiếng anh",
    "bottomLabel1": "Bảng điều khiển",
    "bottomLabel2": "Bản đồ",
    "bottomLabel3": "Camera",
    "bottomLabel4": "Thiết bị",
    "bottomLabel5": "Cảnh báo",
    "bottomLabel6": "Thêm",
    "setting": "Cài đặt",
    "hello": "Xin chào,",
    "accountSetting": "Cài đặt tài khoản",
    "info": "Thông tin cá nhân",
    "changeLang": "Thay đổi ngôn ngữ",
    "darkMode": "Chế độ tối",
    "changePassWord": "Đổi mật khẩu",
    "logOut": "Đăng xuất",
    "NameAndNumber": "Nhập tên đăng nhập & mật khẩu để truy cập hệ thống",
    "userName": "Tên đăng nhập",
    "password": "Mật khẩu",
    "numberMustWrite": "Tên đăng nhập không được để trống.",
    "passwordMustWrite": "Mật khẩu không được để trống.",
    "logIn": "Đăng nhập",
    "forgotPassword": "Quên mật khẩu",
    "changeSystem": "Thay đổi hệ thống",
    "textModal": "Xong",
    "title1": "Khe Sanh, phường 10, TP.Đà Lạt",
    "title2": "Tỉnh Hưng Yên",
    "hours": "Giờ",
    "day": "Ngày",
    "month": "Tháng",
    "year": "Năm",
    "fromDate": "Từ Ngày",
    "toDate": "Đến ngày",
    "gnss": "Quan trắc vệ tinh",
    "loRong": "Áp lực nước lỗ rỗng",
    "nghiengSau": "Đo nghiêng sâu",
    "mua": "Đo mưa",
    "mucNuoc": "Đo mực nước",
    "overView": "Overview",
    "news": "Bản tin",
  };
}
