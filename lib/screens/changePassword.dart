import 'package:Ageo_solutions/core/api_client.dart';
import 'package:Ageo_solutions/core/helpers.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ChangePWScreen extends StatefulWidget {
  @override
  _ChangePWScreenState createState() => _ChangePWScreenState();
}

class _ChangePWScreenState extends State<ChangePWScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final apiClient = ApiClient();
  final SecureStorage _ss = SecureStorage();

  int? userId;
  String? displayName;
  String? email;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final token = await _ss.readSecureData("access_token");
    if (token != null && !JwtDecoder.isExpired(token)) {
      final decodedToken = JwtDecoder.decode(token);

      // Extract userId, displayName, and email from the token
      setState(() {
        userId = decodedToken['userid'] != null
            ? int.tryParse(decodedToken['userid'])
            : null;
        displayName = decodedToken['displayName'] ?? 'Unknown';
        email = decodedToken['email'] ?? 'Unknown';
      });
    } else {
      print("Token is either null or expired.");
    }
  }

  Future<void> _handleChangePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Ensure that userId, displayName, and email are not null
      if (userId != null && displayName != null && email != null) {
        Map<String, dynamic> userData = {
          "userId": userId,
          "displayName": displayName,
          "email": email,
          // Add other relevant fields as needed
        };

        String oldPassword = _oldPasswordController.text;
        String newPassword = _newPasswordController.text;

        // Call your changePassword function
        Map<String, dynamic> response =
            await apiClient.changePassWord(userData, oldPassword, newPassword);

        setState(() {
          _isLoading = false;
        });

        // Handle the response (success or failure)
        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Password changed successfully!'),
            backgroundColor: Colors.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Password change failed: ${response['error'] ?? 'Unknown error'}'),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to retrieve user data.'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Old Password',
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your old password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirm New Password'),
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _handleChangePassword,
                      child: Text(
                        'Change Password',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
