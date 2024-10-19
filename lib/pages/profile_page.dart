import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biomark/pages/login_page.dart';

class ProfilePage extends StatelessWidget {
  final String email; // Pass the user's email to identify the correct user in Firestore.

  const ProfilePage({super.key, required this.email});

  Future<Map<String, dynamic>> _getUserData() async {
    // Fetch the user's document from Firestore based on their email
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('account.email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data();
    } else {
      throw Exception('User not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data found'));
          }

          final userData = snapshot.data!;
          final model = userData['model'] as Map<String, dynamic>;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to your profile!',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                // Displaying user's model data
                _buildProfileItem('Email', userData['account']['email']),
                _buildProfileItem('Blood Group', model['bloodGroup']),
                _buildProfileItem('Date of Birth', model['dateOfBirth']),
                _buildProfileItem('Ethnicity', model['ethnicity']),
                _buildProfileItem('Eye Color', model['eyeColor']),
                _buildProfileItem('Height', model['height']),
                _buildProfileItem('Sex', model['sex']),
                _buildProfileItem('Location of Birth', model['locationOfBirth']),
                _buildProfileItem('Time of Birth', model['timeOfBirth']),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Text('Log Out'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}
