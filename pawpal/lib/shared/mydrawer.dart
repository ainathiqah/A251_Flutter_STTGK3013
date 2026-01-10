import 'package:flutter/material.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/shared/animated_route.dart';
import 'package:pawpal/views/adoptionRecords.dart';
import 'package:pawpal/views/donationHistory.dart';
import 'package:pawpal/views/loginScreen.dart';
import 'package:pawpal/views/mainscreen.dart';
import 'package:pawpal/views/myPetScreen.dart';
import 'package:pawpal/views/profilescreen.dart';

class MyDrawer extends StatefulWidget {
  final User user;
  const MyDrawer({super.key, required this.user});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late double screenHeight;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    return Drawer(
      backgroundColor: Colors.pink.shade50,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.pinkAccent[100]),
            currentAccountPicture: _buildProfileImage(),
            accountName: Text(
              'Hello, ${widget.user.name ?? ''}',
              style: const TextStyle(
                fontFamily: 'NunitoBold',
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            accountEmail: Text(
              widget.user.email ?? '',
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),

          ListTile(
            leading: Icon(Icons.home, color: Colors.pink.shade700),
            title: Text(
              'Home',
              style: const TextStyle(fontFamily: 'NunitoBold', fontSize: 17),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                AnimatedRoute.slideFromRight(MainScreen(user: widget.user)),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.pets_rounded, color: Colors.pink.shade700),
            title: Text(
              'My Pets',
              style: const TextStyle(fontFamily: 'NunitoBold', fontSize: 17),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                AnimatedRoute.slideFromRight(MyPetsScreen(user: widget.user)),
              );
            },
          ),

          // Update your MyDrawer.dart file:
          ListTile(
            leading: Icon(
              Icons.history_rounded, 
              color: Colors.pink.shade700,
            ),
            title: Text(
              'Adoption Records',
              style: const TextStyle(fontFamily: 'NunitoBold', fontSize: 17),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                AnimatedRoute.slideFromRight(
                  AcceptAdoption(
                    user: widget.user,
                    petData:
                        null, // Pass null since you're viewing all adoption records
                  ),
                ),
              );
            },
          ),

          ListTile(
            leading: Icon(
              Icons.attach_money_rounded,
              color: Colors.pink.shade700,
            ),
            title: Text(
              'Donation History',
              style: const TextStyle(fontFamily: 'NunitoBold', fontSize: 17),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DonationHistory(user: widget.user),
                ),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.person_rounded, color: Colors.pink.shade700),
            title: Text(
              'Profile',
              style: const TextStyle(fontFamily: 'NunitoBold', fontSize: 17),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(user: widget.user),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.pink.shade700,
            ), // Changed to logout icon
            title: Text(
              'Logout',
              style: const TextStyle(fontFamily: 'NunitoBold', fontSize: 17),
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false, // This condition removes all previous routes
              );
            },
          ),

          SizedBox(
            height: screenHeight / 3.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text("@2025 PawPal", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    if (widget.user.image != null && widget.user.image!.isNotEmpty) {
      return CircleAvatar(
        backgroundColor: Colors.white,
        child: ClipOval(
          child: Image.network(
            '${MyConfig.baseUrl}/pawpal/assets/profileImage/${widget.user.image}',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildInitialsAvatar();
            },
          ),
        ),
      );
    }

    return _buildInitialsAvatar();
  }

  Widget _buildInitialsAvatar() {
    return CircleAvatar(
      backgroundColor: Colors.pink.shade200,
      child: Text(
        widget.user.name?.isNotEmpty == true
            ? widget.user.name![0].toUpperCase()
            : 'U',
        style: const TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
