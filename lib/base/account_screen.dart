import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homeassist/base/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _username = '';
  String _avatarUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await _fetchUsername(); // Load Username
    await _fetchAvatarUrl(); // Load Avatar URL
  }

  String? _getCurrentUserId() {
    final user = Supabase.instance.client.auth.currentUser;
    return user?.id;
  }

  Future<void> _fetchUsername() async {
    final userId = _getCurrentUserId();
    if (userId != null) {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('username')
          .eq('id', userId)
          .single();
    }
  }

  Future<void> _fetchAvatarUrl() async {
    final userId = _getCurrentUserId();
    if (userId != null) {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('avatar_url')
          .eq('id', userId)
          .single();
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
          SnackBar(
              content: Text('Unexpected error occurred'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  static const double _sizedBoxHeight = 25;
  static const double _sizedBoxWidth = 10;
  static const double _iconSize = 32;
  static const double _fontSize = 26;
  static const double _listGap = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // This will remove the back button
          title: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              'Account',
              style:
                  TextStyle(color: ColorConstants.textDarkGreen, fontSize: 32),
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: IconButton(
                icon: const Icon(
                  Icons.mode_edit_outlined,
                  size: 32,
                ), // This will add an edit icon on the right side
                onPressed: () {
                  // You can add a callback here to handle the edit button press
                },
              ),
            ),
          ],
        ),
        backgroundColor: ColorConstants.backgroundWhite,
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: _sizedBoxHeight,
                ),
                //Profile Info
                Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 46,
                            backgroundImage: _avatarUrl.isNotEmpty
                                ? NetworkImage(_avatarUrl)
                                : null,
                            child: _avatarUrl.isEmpty
                                ? Icon(Icons.person, size: 46)
                                : null,
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          Transform.translate(
                            offset: const Offset(0, -10),
                            child: Column(
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
                                    "+91 7206942069",
                                    style: TextStyle(
                                        color: ColorConstants.textLightGrey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  const SizedBox(height: 18),
                                  TextButton(
                                    onPressed: _signOut,
                                    child: const Text('Sign Out'),
                                  ),
                                ]),
                          ),
                        ])),

                const Divider(
                  thickness: 15,
                  height: 60,
                  color: Color.fromARGB(147, 227, 227, 227),
                ),

                ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: ValueConstants.containerMargin),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.wallet,
                                    size: _iconSize,
                                  ),
                                  SizedBox(
                                    width: _sizedBoxWidth,
                                  ),
                                  Text(
                                    'Wallet',
                                    style: TextStyle(fontSize: _fontSize),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.chevron_right),
                                ],
                              ),
                            ],
                          )),

                      const SizedBox(
                        height: _listGap,
                      ),
                      //second row
                      Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: ValueConstants.containerMargin),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.home_filled,
                                    size: _iconSize,
                                  ),
                                  SizedBox(
                                    width: _sizedBoxWidth,
                                  ),
                                  Text(
                                    'Address',
                                    style: TextStyle(fontSize: _fontSize),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.chevron_right),
                                ],
                              ),
                            ],
                          )),

                      const SizedBox(
                        height: _listGap,
                      ),
                      //third row
                      Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: ValueConstants.containerMargin),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_pin,
                                    size: _iconSize,
                                  ),
                                  SizedBox(
                                    width: _sizedBoxWidth,
                                  ),
                                  Text(
                                    'Location',
                                    style: TextStyle(fontSize: _fontSize),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.chevron_right),
                                ],
                              ),
                            ],
                          ))
                    ])
              ],
            ),
          ),
        )));
  }
}
