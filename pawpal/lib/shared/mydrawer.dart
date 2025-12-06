import 'package:flutter/material.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/shared/animated_route.dart';
import 'package:pawpal/views/loginscreen.dart';
import 'package:pawpal/views/mainscreen.dart';
import 'package:pawpal/views/submitpetscreen.dart';

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
            currentAccountPicture: CircleAvatar(
              radius: 15,
              child: Text(
                widget.user.name!.isNotEmpty ? widget.user.name![0] : 'A',
                style: const TextStyle(
                  fontFamily: 'NunitoBold',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
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
            leading: Icon(Icons.home),
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
            leading: Icon(Icons.pets_rounded),
            title: Text(
              'Pet Submission Form',
              style: const TextStyle(fontFamily: 'NunitoBold', fontSize: 17),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                AnimatedRoute.slideFromRight(
                  SubmitPetScreen(user: widget.user),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Settings',
              style: const TextStyle(fontFamily: 'NunitoBold', fontSize: 17),
            ),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => Settings()),
              // );
            },
          ),
          ListTile(
            leading: Icon(Icons.login),
            title: Text(
              'Logout',
              style: const TextStyle(fontFamily: 'NunitoBold', fontSize: 17),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
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
}
