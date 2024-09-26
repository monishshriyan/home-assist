import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homeassist/base/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:homeassist/main.dart';

class ManageAddress extends StatefulWidget {
  const ManageAddress({super.key});

  @override
  State<ManageAddress> createState() => _ManageAddressState();
}

class _ManageAddressState extends State<ManageAddress> {
  String _currentAddress = '';
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCurrentAddress();
  }

  Future<void> _fetchCurrentAddress() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('address')
          .eq('id', userId)
          .single();

      if (response != null) {
        setState(() {
          _currentAddress = response['address'] ?? '';
          _addressController.text = _currentAddress; // Set the fetched address in the TextField
        });
      }
    }
  }

  Future<void> _updateAddress() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      await Supabase.instance.client
          .from('profiles')
          .update({'address': _addressController.text,
          'updated_at': DateTime.now().toIso8601String()})
          .eq('id', userId);
      // Optionally, show a success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Address updated successfully!'),
      ));
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Changes'),
          content: const Text('Are you sure you want to save these changes?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
              //backgroundColor: ColorConstants.navBackground, // Set the button color
              foregroundColor: ColorConstants.deepGreenAccent,
              textStyle: const TextStyle(
              fontSize: 18, // Adjust the font size
              ), // Set the text color
              ),
              child: const Text('Discard'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
              //backgroundColor: ColorConstants.navBackground, // Set the button color
              foregroundColor: ColorConstants.deepGreenAccent,
              textStyle: const TextStyle(
              fontSize: 18, // Adjust the font size
              ), // Set the text color
              ),
              child: const Text('Save Changes'),
              onPressed: () {
                _updateAddress(); // Update the address in the database
                Navigator.of(context).pop();
                navKey.currentState?.updateIndex(3); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Addresses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                hintText: _currentAddress.isNotEmpty ? _currentAddress : 'Current Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.darkSlateGrey,
                      elevation: 0
                    ),
              onPressed: _showConfirmationDialog,
              child: const Text('Save Changes',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}