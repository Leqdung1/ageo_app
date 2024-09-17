import 'package:Ageo_solutions/components/localization.dart';
import 'package:Ageo_solutions/core/api_client.dart';
import 'package:Ageo_solutions/core/helpers.dart';
import 'package:Ageo_solutions/models/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final apiClient = ApiClient();
  int? userId;
  Future<List<UserData>>? _userDataBuilder;
  late List<UserData> _userData = [];
  final SecureStorage _ss = SecureStorage();

  @override
  void initState() {
    super.initState();
    _userDataBuilder = fetchUserData();
    _initializeUserIdAndFetchData();
  }

  Future<int?> _getUserIdFromToken() async {
    final token = await _ss
        .readSecureData("access_token"); // Read the token from secure storage
    if (token != null && JwtDecoder.isExpired(token)) {
      print("Token is expired");
      return null;
    }
    if (token != null) {
      final decodedToken = JwtDecoder.decode(token);
      final userIdString = decodedToken['userid'];
      return int.tryParse(userIdString);
    }
    return null;
  }

  Future<void> _initializeUserIdAndFetchData() async {
    userId = await _getUserIdFromToken();
    if (userId != null) {
      _userDataBuilder = fetchUserData();
      setState(() {});
    } else {
      print('Error: userId is still null after loading');
    }
  }

  Future<List<UserData>> fetchUserData() async {
    if (userId == null) {
      print('Error: userId is null');
      return [];
    }

    try {
      final response = await apiClient.getUser(userId!);
      print(response);

      if (response['success']) {
        UserData data = UserData.fromJson(response['data']);

        print('UserData: $data');
        print('Updated UserId: $userId');

        setState(() {
          _userData = [data];
        });
        return _userData;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load UserData');
    }
  }

  @override
  Widget build(BuildContext context) {
    var title = TextStyle(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).textTheme.bodyLarge?.color,
      fontSize: 15,
    );
    var subTitle = TextStyle(
      fontWeight: FontWeight.normal,
      color: Theme.of(context).textTheme.bodyLarge?.color,
      fontSize: 15,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).iconTheme.color,
            size: 15,
          ),
        ),
        title: Text(
          LocalData.info.getString(context),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 15,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: FutureBuilder<List<UserData>>(
            future: _userDataBuilder,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                _userData = snapshot.data!;

                var userData = _userData[0];
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // if (userData.imageUrl != null)
                      //   Container(
                      //     width: 120,
                      //     height: 120,
                      //     decoration: BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       image: DecorationImage(
                      //         fit: BoxFit.cover,
                      //         image: NetworkImage(
                      //           userData.imageUrl ?? '',
                      //         ),
                      //       ),
                      //     ),
                      //   )
                      // else
                      //   Container(
                      //     width: 120,
                      //     height: 120,
                      //     decoration: const BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       color: Colors.grey,
                      //     ),
                      //     child: const Icon(
                      //       Icons.person,
                      //       size: 80,
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 24,
                          bottom: 5,
                          top: 24,
                        ),
                        child: Text(
                          'Name',
                          style: title,
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 1,
                        margin: EdgeInsets.only(
                          left: 24,
                          right: 24,
                        ),
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 15,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                Color.fromRGBO(84, 76, 76, 1).withOpacity(0.14),
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          userData.name ?? "N/A",
                          style: subTitle,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 24,
                          bottom: 5,
                          top: 24,
                        ),
                        child: Text(
                          'Email',
                          style: title,
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 1,
                        margin: EdgeInsets.only(
                          left: 24,
                          right: 24,
                        ),
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 15,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                Color.fromRGBO(84, 76, 76, 1).withOpacity(0.14),
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          userData.email ?? "N/A",
                          style: subTitle,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 24,
                          bottom: 5,
                          top: 24,
                        ),
                        child: Text(
                          'Phone',
                          style: title,
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 1,
                        margin: EdgeInsets.only(
                          left: 24,
                          right: 24,
                          bottom: 18,
                        ),
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 15,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                Color.fromRGBO(84, 76, 76, 1).withOpacity(0.14),
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          userData.phoneNumber ?? "N/A",
                          style: subTitle,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: Text('No data available'));
              }
            }),
      ),
    );
  }
}
