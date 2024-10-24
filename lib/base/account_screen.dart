import 'package:flutter/material.dart';
import 'package:homeassist/base/constants.dart';
import 'package:homeassist/base/pages/account_page.dart';
import 'package:homeassist/base/pages/booking_history.dart';
import 'package:homeassist/base/pages/manage_address.dart';
import 'package:homeassist/base/pages/settings_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _username = '';
  String _avatarUrl = '';
  String _phoneNumber = '';
 

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

void _reloadScreen1() {
  _loadUserData();
}
  Future<void> _loadUserData() async {
    final user = Supabase.instance.client.auth.currentUser; // Fetch the current user
  if (user != null) {
    final userId = user.id;
    try{
      final response = await Supabase.instance.client
          .from('profiles')
          .select('*')
          .eq('id', userId)
          .single();

      if (response != null) {
        setState(() {
          _username = response['username'] ?? 'Unknown User';
          _avatarUrl = response['avatar_url'] ?? '';
          _phoneNumber = response['phone_number'] ?? 'No Phone Number Provided';
        });
      }
    }
    catch (e) {
  print('Error fetching user data: $e');
  }
  }
  }

  Future<void> _signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } on AuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message), backgroundColor: Colors.red),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Unexpected error occurred'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to Logout?'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: ColorConstants.deepGreenAccent,
              textStyle: const TextStyle(
              fontSize: 18, 
              ),
              ),
            child: const Text('Discard'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: ColorConstants.deepGreenAccent,
              textStyle: const TextStyle(
              fontSize: 18, 
              ),
              ),
            child: const Text('Logout'),
            onPressed: () {
              Navigator.pop(context);
              _signOut();
            },
          ),
        ],
      ),
    );
  }


  static const double _sizedBoxWidth = 10;
  static const double _iconSize = 30;
  static const double _fontSize = 24;
  static const double _listGap = 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false, // This will remove the back button
          title: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              'Account',
              style:
                  TextStyle(color: ColorConstants.textDarkGreen, fontSize: 26),
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: IconButton(
                icon: const Icon(
                  Icons.mode_edit_outlined,
                  size: 30,
                ), // This will add an edit icon on the right side
                onPressed: () async {
                   final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AccountPage()),
                    );
                    if (result == true) {
                      setState(() {
                        _reloadScreen1(); 
                      });
                    }
                },
              ),
            ),
          ],
        ),
        //backgroundColor: ColorConstants.backgroundWhite,
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  //height: _sizedBoxHeight,
                  height: 10,                
                ),
                //Profile Info
                Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _avatarUrl != null
                              ? CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(_avatarUrl),
                                )
                              : CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(_avatarUrl),
                                ),
                          const SizedBox(
                            width: 18,
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _username,
                                  style: TextStyle(
                                      color: ColorConstants.textDarkGreen,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w900),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '+91 $_phoneNumber',
                                  style: TextStyle(
                                      color: ColorConstants.textLightGrey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900),
                                ),
                                const SizedBox(height: 18),
                                
                              ]),
                        ])),

                const Divider(
                  thickness: 15,
                  height: 60,
                  color: Color.fromARGB(43, 184, 229, 233),
                ),

                ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ManageAddress()),
                        );
                        },
                        child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: ValueConstants.containerMargin),
                            padding: const EdgeInsets.only(top: 5), // Add padding to make the area bigger
                              decoration: const BoxDecoration(
                              color: Colors.transparent, // Set a transparent background to cover the entire area
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: _iconSize,
                                    ),
                                    SizedBox(
                                      width: _sizedBoxWidth,
                                    ),
                                    Text(
                                      'Manage addresses',
                                      style: TextStyle(fontSize: _fontSize),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.chevron_right,
                                    size: 28),
                                  ],
                                ),
                              ],
                            )),
                      ),

                      const SizedBox(
                        height: _listGap,
                      ),
                      //second row
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BookingHistory()),
                        );
                        },
                        child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: ValueConstants.containerMargin),
                              decoration: const BoxDecoration(
                              color: Colors.transparent, // Set a transparent background to cover the entire area
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.event_available_rounded,
                                      size: _iconSize,
                                    ),
                                    SizedBox(
                                      width: _sizedBoxWidth,
                                    ),
                                    Text(
                                      'Booking history',
                                      style: TextStyle(fontSize: _fontSize),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.chevron_right,
                                    size: 28),
                                  ],
                                ),
                              ],
                            )),
                      ),

                      const SizedBox(
                        height: _listGap,
                      ),
                      //third row
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsScreen()),
                        );
                        },
                        child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: ValueConstants.containerMargin),
                            decoration: const BoxDecoration(
                              color: Colors.transparent, // Set a transparent background to cover the entire area
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.settings,
                                      size: _iconSize,
                                    ),
                                    SizedBox(
                                      width: _sizedBoxWidth,
                                    ),
                                    Text(
                                      'Settings',
                                      style: TextStyle(fontSize: _fontSize),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.chevron_right,
                                    size: 28,),
                                  ],
                                ),
                              ],
                            )),
                      ),
                          const SizedBox(
                        height: _listGap,
                      ),
                      //fourth row
                      Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: ValueConstants.containerMargin),
                          decoration: const BoxDecoration(
                              color: Colors.transparent, // Set a transparent background to cover the entire area
                            ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.headset_mic,
                                    size: _iconSize,
                                  ),
                                  SizedBox(
                                    width: _sizedBoxWidth,
                                  ),
                                  Text(
                                    'Support',
                                    style: TextStyle(fontSize: _fontSize),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.chevron_right,
                                  size: 28,),
                                ],
                              ),
                            ],
                          )),
                          const SizedBox(
                        height: _listGap,
                      ),
                      //fifth row
                      GestureDetector(
                        onTap: () {
                          _showLogoutConfirmation();
                        },
                        child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: ValueConstants.containerMargin),
                            decoration: const BoxDecoration(
                              color: Colors.transparent, // Set a transparent background to cover the entire area
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.logout_rounded,
                                      size: _iconSize,
                                    ),
                                    SizedBox(
                                      width: _sizedBoxWidth,
                                    ),
                                    Text(
                                      'Logout',
                                      style: TextStyle(fontSize: _fontSize),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.chevron_right,
                                    size: 28,),
                                  ],
                                ),
                              ],
                            )),
                      )
                    ])
              ],
            ),
          ),
        )));
  }
}
