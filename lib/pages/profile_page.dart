import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biomark/pages/login_page.dart';

class ProfilePage extends StatelessWidget {
  final String id;

  const ProfilePage({super.key, required this.id});

  Future<Map<String, dynamic>> _getUserData() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('models')
        .where('accountId', isEqualTo: id)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data();
    } else {
      throw Exception('User not found');
    }
  }

  // Future<void> _unsubscribeUser(BuildContext context) async {
  //   try {
  //     final querySnapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .where('account.email', isEqualTo: email)
  //         .get();

  //     if (querySnapshot.docs.isNotEmpty) {
  //       await querySnapshot.docs.first.reference.delete();

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('You have been unsubscribed.')),
  //       );

  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => const LoginPage()),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('User not found.')),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: $e')),
  //     );
  //   }
  // }

  Future<void> _unsubscribeUser(BuildContext context, String accountId) async {
    try {
      // Step 1: Delete the account document from the 'accounts' collection using the accountId
      final accountDoc = await FirebaseFirestore.instance
          .collection('accounts')
          .doc(accountId)
          .get();

      if (accountDoc.exists) {
        await accountDoc.reference.delete();

        // Step 2: Delete the corresponding 'model' document using the accountId
        final modelSnapshot = await FirebaseFirestore.instance
            .collection('models')
            .where('accountId', isEqualTo: accountId)
            .get();
        if (modelSnapshot.docs.isNotEmpty) {
          await modelSnapshot.docs.first.reference.delete();
        }

        // Step 3: Delete the corresponding 'recovery' document using the accountId
        final recoverySnapshot = await FirebaseFirestore.instance
            .collection('recovery')
            .where('accountId', isEqualTo: accountId)
            .get();
        if (recoverySnapshot.docs.isNotEmpty) {
          await recoverySnapshot.docs.first.reference.delete();
        }

        // Notify the user about successful unsubscription
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You have been unsubscribed.')),
        );

        // Navigate back to the login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        // Handle case where the account is not found
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account not found.')),
        );
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
          final model = userData as Map<String, dynamic>;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to your profile!',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Log Out'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _unsubscribeUser(context, id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Unsubscribe'),
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
