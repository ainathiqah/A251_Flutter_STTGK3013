import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  User user;
  ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  
  // Image
  File? profileImage;
  ImagePicker picker = ImagePicker();
  
  bool isLoading = false;
  
  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() {
    nameController.text = widget.user.name ?? '';
    phoneController.text = widget.user.phone ?? '';
    emailController.text = widget.user.email ?? '';
  }

  // ================= IMAGE PICKER =================
  void pickimagedialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Update Profile Photo',
            style: TextStyle(
              fontFamily: 'BalsamiqSansBold',
              color: Colors.pink.shade800,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.image, color: Colors.pink.shade300),
                title: Text(
                  'Choose from Gallery',
                  style: TextStyle(fontFamily: 'Nunito'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  openGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.pink.shade300),
                title: Text(
                  'Take Photo',
                  style: TextStyle(fontFamily: 'Nunito'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  openCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> openGallery() async {
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 800,
    );

    if (picked != null) {
      setState(() {
        profileImage = File(picked.path);
      });
    }
  }

  Future<void> openCamera() async {
    final XFile? picked = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 800,
    );

    if (picked != null) {
      setState(() {
        profileImage = File(picked.path);
      });
    }
  }

  // ================= UPDATE PROFILE =================
  void showUpdateDialog() {
    // Validation
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please enter your name",
            style: TextStyle(fontFamily: 'Nunito'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please enter your phone number",
            style: TextStyle(fontFamily: 'Nunito'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (phoneController.text.trim().length < 10 || 
        phoneController.text.trim().length > 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please enter a valid phone number (10-11 digits)",
            style: TextStyle(fontFamily: 'Nunito'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Update Profile',
            style: TextStyle(
              fontFamily: 'BalsamiqSansBold',
              color: Colors.pink.shade800,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to update your profile?',
                style: TextStyle(fontFamily: 'Nunito'),
              ),
              SizedBox(height: 10),
              Text(
                'Name: ${nameController.text}',
                style: TextStyle(fontFamily: 'Nunito'),
              ),
              Text(
                'Phone: ${phoneController.text}',
                style: TextStyle(fontFamily: 'Nunito'),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontFamily: 'Nunito',
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.pinkAccent.shade100,
              ),
              onPressed: () {
                Navigator.pop(context);
                updateProfile();
              },
              child: Text(
                'Update',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'NunitoBold',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      String newName = nameController.text.trim();
      String newPhone = phoneController.text.trim();
      String imageBase64 = "";
      
      if (profileImage != null) {
        imageBase64 = base64Encode(profileImage!.readAsBytesSync());
      }

      final response = await http.post(
        Uri.parse('${MyConfig.baseUrl}/pawpal/api/update_profile.php'),
        body: {
          'user_id': widget.user.userId.toString(),
          'name': newName,
          'phone': newPhone,
          'email': widget.user.email ?? '',
          'image': imageBase64,
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        
        if (jsonResponse['success'] == true || jsonResponse['status'] == 'success') {
          widget.user.name = newName;
          widget.user.phone = newPhone;
          
          if (jsonResponse['new_image'] != null) {
            widget.user.image = jsonResponse['new_image'];
          }

          await saveUserSession(widget.user);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                jsonResponse['message'] ?? "Profile updated successfully!",
                style: TextStyle(fontFamily: 'Nunito'),
              ),
              backgroundColor: Colors.green,
            ),
          );

          setState(() {
            profileImage = null;
          });

          Navigator.pop(context, widget.user);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                jsonResponse['message'] ?? "Update failed",
                style: TextStyle(fontFamily: 'Nunito'),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error: ${e.toString()}",
            style: TextStyle(fontFamily: 'Nunito'),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // ================= LOAD PROFILE =================
  void loadProfile() {
    http
        .get(
          Uri.parse(
            '${MyConfig.baseUrl}/pawpal/api/get_user_details.php?userid=${widget.user.userId}',
          ),
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(response.body);
            if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
              User user = User.fromJson(jsonResponse['data'][0]);
              widget.user = user;
              setState(() {
                nameController.text = widget.user.name ?? '';
                phoneController.text = widget.user.phone ?? '';
                emailController.text = widget.user.email ?? '';
              });
              saveUserSession(widget.user);
            }
          }
        });
  }

  Future<void> saveUserSession(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', jsonEncode(user.toJson()));
    } catch (e) {
      print('Error saving user session: $e');
    }
  }

  void resetToOriginal() {
    setState(() {
      nameController.text = widget.user.name ?? '';
      phoneController.text = widget.user.phone ?? '';
      emailController.text = widget.user.email ?? '';
      profileImage = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Changes reset to original values',
          style: TextStyle(fontFamily: 'Nunito'),
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width > 600
        ? 600.0
        : MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, widget.user);
          },
        ),
        title: Text(
          "My Profile",
          style: TextStyle(fontSize: 25, fontFamily: 'BalsamiqSansBold'),
        ),
        backgroundColor: Colors.pinkAccent.shade100,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  
                  // Profile Image
                  GestureDetector(
                    onTap: () => pickimagedialog(),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.pink.shade300,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pink.shade100,
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: buildProfileImage(),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.pinkAccent.shade100,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // User Name Display
                  Text(
                    widget.user.name ?? "Guest",
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'BalsamiqSansBold',
                      color: Colors.pink.shade800,
                    ),
                  ),
                  
                  SizedBox(height: 5),
                  
                  // User Email Display
                  Text(
                    widget.user.email ?? "No email",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Nunito',
                      color: Colors.grey.shade600,
                    ),
                  ),
                  
                  SizedBox(height: 30),
                  
                  // Name TextField
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name *',
                      prefixIcon: Icon(Icons.person, color: Colors.pink.shade300),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: Colors.pink.shade400,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 15),
                  
                  // Phone TextField
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number *',
                      prefixIcon: Icon(Icons.phone, color: Colors.pink.shade300),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: Colors.pink.shade400,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 15),
                  
                  // Email TextField (Read-only)
                  TextField(
                    controller: emailController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: Icon(Icons.email, color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),
                  
                  SizedBox(height: 10),
                  
                  // Read-only notice for email
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Email cannot be changed",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Nunito',
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 30),
                  
                  // Update Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent.shade100,
                      minimumSize: Size(width, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4,
                    ),
                    onPressed: isLoading ? null : () {
                      showUpdateDialog();
                    },
                    child: isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save, size: 22, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'Update Profile',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'NunitoBold',
                                ),
                              ),
                            ],
                          ),
                  ),
                  
                  SizedBox(height: 15),
                  
                  // Clear Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      minimumSize: Size(width, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: () {
                      resetToOriginal();
                    },
                    child: Text(
                      'Reset Changes',
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 16,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProfileImage() {
    if (profileImage != null) {
      return Image.file(profileImage!, fit: BoxFit.cover);
    }
    
    if (widget.user.image != null && widget.user.image!.isNotEmpty) {
      return Image.network(
        '${MyConfig.baseUrl}/pawpal/assets/profileImage/${widget.user.image}'
        '?v=${DateTime.now().millisecondsSinceEpoch}',
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(color: Colors.pink),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return buildInitialsAvatar();
        },
      );
    }
    
    return buildInitialsAvatar();
  }

  Widget buildInitialsAvatar() {
    String initials = widget.user.name?.isNotEmpty == true
        ? widget.user.name![0].toUpperCase()
        : 'U';
    
    return Container(
      color: Colors.pink.shade200,
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: 60,
            fontFamily: 'BalsamiqSansBold',
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }
}