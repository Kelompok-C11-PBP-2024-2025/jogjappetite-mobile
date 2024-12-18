import 'package:flutter/material.dart';
import 'package:jogjappetite_mobile/screens/authentication/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String? userType;
  bool isLoading = true;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    final request = context.read<CookieRequest>();
    try {
      final typeResponse =
          await request.get('http://127.0.0.1:8000/auth/get-user-type/');
      print('User type response: $typeResponse');

      if (typeResponse['user_type'] != null) {
        final dataResponse =
            await request.get('http://127.0.0.1:8000/auth/get-user-data/');
        print('User data response: $dataResponse');
        setState(() {
          userType = typeResponse['user_type'];
          userData =
              dataResponse['user']; // Assuming the data is nested under 'user'
          isLoading = false;
        });
      } else {
        setState(() {
          userType = null;
          userData = null;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error getting user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    final request = context.read<CookieRequest>();
    try {
      final response =
          await request.logout('http://127.0.0.1:8000/auth/logout-flutter/');
      if (response['status'] == 'success') {
        setState(() {
          userType = null;
          userData = null;
        });
      }
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body:
            Center(child: CircularProgressIndicator(color: Color(0xFFDC2626))),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 32),
                if (userType != null && userData != null) ...[
                  // Profile circle with initials
                  Container(
                    width: 96,
                    height: 96,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDC2626),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(userData!['full_name'] ?? ''),
                        style: const TextStyle(
                          color:
                              Colors.white, // Ensuring white color for initials
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // User details
                  _buildDetailItem(
                      'Full Name', userData!['full_name'] ?? 'N/A'),
                  _buildDetailItem('Username', userData!['username'] ?? 'N/A'),
                  _buildDetailItem('Email', userData!['email'] ?? 'N/A'),
                  _buildDetailItem(
                      'Account Type', userType?.toUpperCase() ?? 'N/A'),
                  _buildDetailItem(
                      'User ID', userData!['id']?.toString() ?? 'N/A'),
                  _buildDetailItem(
                      'Date Joined', _formatDate(userData!['date_joined'])),
                  _buildDetailItem(
                      'Last Login', _formatDate(userData!['last_login'])),

                  const SizedBox(height: 32),
                  // Logout button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleLogout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ] else ...[
                  const SizedBox(height: 120),
                  const Icon(
                    Icons.account_circle_outlined,
                    size: 100,
                    color: Color(0xFFDC2626),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Not logged in',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                        if (result == true) {
                          _getUserData();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
    } catch (e) {
      return dateStr;
    }
  }

  String _getInitials(String fullName) {
    if (fullName.isEmpty) return '';
    final nameParts = fullName.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return fullName.substring(0, fullName.length >= 2 ? 2 : 1).toUpperCase();
  }
}
