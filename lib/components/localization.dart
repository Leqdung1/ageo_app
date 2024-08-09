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
  static String realtime = "realtime";
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
  static String nameProject = "nP";
  static String nameProject1 = "nP1";
  static String namePackage = "nPa";
  static String namePackage1 = "nPa1";
  static String location = "location";
  static String location1 = "location1";
  static String content = "content";
  static String content1 = "content1";
  static String waterLevel1 = "wL1";
  static String waterLevel2 = "wL2";
  static String gnss1 = "gnss1";
  static String gnss2 = "gnss2";
  static String gnss3 = "gnss3";
  static String warn1 = "warn1";
  static String warn2 = "warn2";
  static String piez1 = "piez1";
  static String piez2 = "piez2";
  static String piez3 = "piez3";
  static String inclino1 = "inclino1";
  static String inclino2 = "inclino2";
  static String inclino3 = "inclino3";

  // ignore: non_constant_identifier_names
  static Map<String, dynamic> EN = {
    "infoTitle": "Informations",
    "infoDetails1":
        "Slope failure near Khe Sanh, ward 10, DaLat, after a heavy rain",
    "infoDetails2": "Slope failure at Pham Hong Thai str, ward 10, Da Lat",
    "infoDetails3":
        "Slope failure behind the Hoang Long hotel, Nhat Huy hotel, Thao Quyen hotel, Hoang Lan hotel at Khe Sanh street, ward 10, DaLat, in a sunny day",
    "infoDetails4": "Geometric monitoring the hotel",
    "infoDetails5": "Commencement the rehabilitation project",
    "infoDetails6": "Installation of the GNSS sensors on the hotel",
    "infoDetails7": "Installtion of the rain gauge",
    "infoDetails8": "Installtion of the warning equiptments",
    "infoDetails9":
        "Completed the installation and monitoring of monitoring equipment on the embankment, the blocks are currently stable.",
    "infoDetails10":
        "A landslide on an under-construction project at 15/2 Yen The, Ward 10, Da Lat City destroyed the structure on the slope and at the foot of the slope as well as killing two people.",
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
    "nP": "Project name",
    "nP1":
        "Component project I (phase 2) builds a section through Hung Yen province from Km0Km24+930.9 (NH.39 intersection) under the project to build a road connecting Hanoi - Hai Phong highway Room with Cau Gie - Ninh Binh highway.",
    "nPa": "Packaging name",
    "nPa1": "Third package: Construction of buildings",
    "location": "Construction investment location",
    "location1":
        "Khoai Chau district, An Thi district, Kim Dong district, Tien Lu district, Hung Yen city, Hung Yen province.",
    "content": "Content and scale of investment scope of line section",
    "content1":
        "Planning and design scale: according to the secondary road standard of plain (according to TCVN 4054-2005), the simulated design speed is V = 80 km/h. The cross section includes 4 mechanical lanes and 2 original lanes.",
    "gnss1": "GNSS1",
    "gnss2": "GNSS2",
    "gnss3": "GNSS3",
    "warn1": "Warning sensor 01",
    "warn2": "Warning sensor 02",
    "piez1": "Piezometer 01",
    "piez2": "Piezometer 02",
    "piez3": "Piezometer 03",
    "inclino1": "Inclinometer 01",
    "inclino2": "Inclinometer 02",
    "inclino3": "Inclinometer 03",
    "wL1": "Water level 01",
    "wL2": "Water level 02",
    "realtime": "Realtime",
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
    "overView": "Tổng quan",
    "news": "Bản tin",
    "nP": "Tên dự án",
    "nP1":
        "Dự án thành phần I (giai đoạn 2) xây dựng đoạn qua địa phận tỉnh Hưng Yên từ Km0Km24+930,9 (nút giao QL.39) thuộc Dự án xây dựng tuyến đường bộ nối đường cao tốc Hà Nội - Hải Phòng với đường cao tốc Cầu Giẽ - Ninh Bình.",
    "nPa": "Tên gói thầu",
    "nPa1": "Gói thầu số 3: Thi công xây dựng công trình",
    "location": "Địa điểm đầu tư xây dựng",
    "location1":
        "Huyện Khoái Châu, huyện Ân Thi, huyện Kim Động, huyện Tiên Lữ, TP Hưng Yên, tỉnh Hưng Yên.",
    "content": "Nội dung và quy mô đầu tư phạm vi đoạn tuyến",
    "content1":
        "Quy mô thiết kế theo quy hoạch: tiêu chuẩn đường cấp II đồng bằng (theo TCVN 4054-2005), tốc độ thiết kế châm chước V=80 Km/h. Mặt cắt ngang bao gồm 4 làn xe cơ giới, 2 làn xe thô sơ.",
    "gnss1": "Quan trắc vệ tinh 01",
    "gnss2": "Quan trắc vệ tinh 02",
    "gnss3": "Quan trắc vệ tinh 03",
    "warn1": "Cảm biến cảnh báo 01",
    "warn2": "Cảm biến cảnh báo 02",
    "piez1": "Áp lực nước lỗ rỗng 01",
    "piez2": "Áp lực nước lỗ rỗng 02",
    "piez3": "Áp lực nước lỗ rỗng 03",
    "inclino1": "Đo nghiêng sâu 01",
    "inclino2": "Đo nghiêng sâu 02",
    "inclino3": "Đo nghiêng sâu 03",
    "wL1": "Đo mưa 01",
    "wL2": "Đo mưa 02",
    "realtime": "Thời gian thực"
  };
}
