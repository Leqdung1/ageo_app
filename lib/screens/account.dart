import 'package:Ageo_solutions/lang/localization.dart';
import 'package:Ageo_solutions/core/api_client.dart';
import 'package:Ageo_solutions/core/helpers.dart';
import 'package:Ageo_solutions/models/user_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
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
  final SecureStorage _ss = const SecureStorage();

  @override
  void initState() {
    super.initState();
    _userDataBuilder = fetchUserData();
    _initializeUserIdAndFetchData();
  }

  Future<int?> _getUserIdFromToken() async {
    final token = await _ss.readSecureData("access_token");
    if (token != null && JwtDecoder.isExpired(token)) {
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
    try {
      final response = await apiClient.getUser(userId!);

      if (response['success']) {
        UserData data = UserData.fromJson(response['data']);
        setState(() {
          _userData = [data];
        });
        return _userData;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
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
      backgroundColor: Theme.of(context).colorScheme.surface,
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
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 18,
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
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color.fromRGBO(237, 146, 39, 1),
                  ),
                );
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
                      // Avatar
                      CachedNetworkImage(
                        imageUrl: userData.imageUrl as String,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Center(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.sizeOf(context).height * 0.02,
                            ),
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
                      ),

                      // Username
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 24,
                          bottom: 5,
                          top: 24,
                        ),
                        child: Text(
                          LocalData.nameInfo.getString(context),
                          style: title,
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 1,
                        margin: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                        ),
                        padding: const EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          border: Border.all(
                            color: const Color.fromRGBO(225, 225, 225, 1),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          userData.name ?? "N/A",
                          style: subTitle,
                        ),
                      ),

                      // Email
                      Padding(
                        padding: const EdgeInsets.only(
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
                        margin: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                        ),
                        padding: const EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          border: Border.all(
                            color: const Color.fromRGBO(225, 225, 225, 1),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          userData.email ?? "N/A",
                          style: subTitle,
                        ),
                      ),

                      // Phonenumber
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 24,
                          bottom: 5,
                          top: 24,
                        ),
                        child: Text(
                          LocalData.phone.getString(context),
                          style: title,
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 1,
                        margin: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                        ),
                        padding: const EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          border: Border.all(
                            color: const Color.fromRGBO(225, 225, 225, 1),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          userData.phoneNumber ?? "N/A",
                          style: subTitle,
                        ),
                      ),

                      // Dob
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 24,
                          bottom: 5,
                          top: 24,
                        ),
                        child: Text(
                          LocalData.dob.getString(context),
                          style: title,
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 1,
                        margin: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                          bottom: 18,
                        ),
                        padding: const EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          border: Border.all(
                            color: const Color.fromRGBO(225, 225, 225, 1),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          DateFormat('dd/MM/yyyy').format(
                            DateTime.parse(userData.dob ?? ''),
                          ),
                          style: subTitle,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color.fromRGBO(237, 146, 39, 1),
                  ),
                );
              }
            }),
      ),
    );
  }
}
