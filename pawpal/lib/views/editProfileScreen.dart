import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pawpal/myconfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? image;
  String? uploadImage;
  ImagePicker picker = ImagePicker();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadFreshUserData();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'BalsamiqSansBold',
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.pinkAccent.shade100,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile image
            Center(
              child: GestureDetector(
                onTap: pickimagedialog,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.pink.shade100,
                      child: buildProfileImage(),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent.shade100,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Icon(Icons.camera_alt, size: 24, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              widget.user.name ?? "User",
              style: TextStyle(
                fontSize: 28,
                fontFamily: 'BalsamiqSansBold',
                color: Colors.pink.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    inputField("Name", nameController, Icons.person_outline, false),
                    const SizedBox(height: 16),
                    inputField("Phone", phoneController, Icons.phone_outlined, false),
                    const SizedBox(height: 16),
                    inputField("Email", emailController, Icons.email_outlined, false),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 4,
                        ),
                        onPressed: _isSaving ? null : _updateProfile,
                        child: _isSaving
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
                                    "Save Changes",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: 'NunitoBold',
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadFreshUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      nameController.text = prefs.getString('name') ?? widget.user.name ?? '';
      phoneController.text =
          prefs.getString('phone') ?? widget.user.phone ?? '';
      emailController.text =
          prefs.getString('email') ?? widget.user.email ?? '';
    });
    
    try {
      final response = await http.get(
        Uri.parse(
          '${MyConfig.baseUrl}/pawpal/api/get_user_details.php?userid=${widget.user.userId}',
        ),
      );
      
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success') {
          var userData = jsonResponse['data'][0];
          setState(() {
            nameController.text = userData['name'] ?? nameController.text;
            phoneController.text = userData['phone'] ?? phoneController.text;
            emailController.text = userData['email'] ?? emailController.text;

            if (userData['image_profile'] != null &&
                userData['image_profile'].toString().isNotEmpty) {
              uploadImage = userData['image_profile'];
              prefs.setString('profile_image', uploadImage!);
            } else {
              uploadImage = null;
              prefs.remove('profile_image');
            }
          });
        }
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  Future<void> _updateProfile() async {
    String newName = nameController.text.trim();
    String newPhone = phoneController.text.trim();
    String newEmail = emailController.text.trim();

    if (newName.isEmpty || newPhone.isEmpty || newEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please fill in all fields",
            style: TextStyle(fontFamily: 'Nunito'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    if (newPhone.length < 10 || newPhone.length > 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please enter a valid phone number (10-11 digits)",
            style: TextStyle(fontFamily: 'Nunito'),
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(newEmail)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please enter a valid email address",
            style: TextStyle(fontFamily: 'Nunito'),
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    setState(() {
      _isSaving = true;
    });

    String base64Image = "";
    if (image != null) {
      base64Image = base64Encode(image!.readAsBytesSync());
    }

    try {
      final response = await http.post(
        Uri.parse('${MyConfig.baseUrl}/pawpal/api/update_profile.php'),
        body: {
          "user_id": widget.user.userId.toString(),
          "name": newName,
          "phone": newPhone,
          "email": newEmail,
          "image": base64Image,
        },
      );
      
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true || data['status'] == 'success') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('name', newName);
          await prefs.setString('phone', newPhone);
          await prefs.setString('email', newEmail);

          // Update the user object
          widget.user.name = newName;
          widget.user.phone = newPhone;
          widget.user.email = newEmail;

          if (data['new_image'] != null) {
            await prefs.setString('profile_image', data['new_image']);
            setState(() {
              uploadImage = data['new_image'];
              image = null;
            });
            widget.user.image = data['new_image'];
          }

          // Save full user object
          await prefs.setString('current_user', jsonEncode(widget.user.toJson()));

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Profile updated successfully",
                style: TextStyle(fontFamily: 'Nunito'),
              ),
              backgroundColor: Colors.green,
            ),
          );
          
          // Return updated user to previous screen
          Navigator.pop(context, widget.user);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                data['message'] ?? "Update failed",
                style: TextStyle(fontFamily: 'Nunito'),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Failed to update profile. Please try again.",
              style: TextStyle(fontFamily: 'Nunito'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Connection failed: $e",
            style: TextStyle(fontFamily: 'Nunito'),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  Widget buildProfileImage() {
    // If user picked a new image
    if (image != null) {
      return CircleAvatar(
        radius: 80,
        backgroundColor: Colors.pink.shade100,
        backgroundImage: FileImage(image!),
      );
    }

    // If image exists on server
    if (uploadImage != null && uploadImage!.isNotEmpty) {
      return CircleAvatar(
        radius: 80,
        backgroundColor: Colors.pink.shade100,
        child: ClipOval(
          child: Image.network(
            '${MyConfig.baseUrl}/pawpal/assets/profileImage/$uploadImage'
            '?v=${DateTime.now().millisecondsSinceEpoch}',
            width: 160,
            height: 160,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.pink,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => _getInitialText(),
          ),
        ),
      );
    }
    
    // Show initials
    return CircleAvatar(
      radius: 80,
      backgroundColor: Colors.pink.shade200,
      child: _getInitialText(),
    );
  }

  Widget inputField(
    String label,
    TextEditingController controller,
    IconData icon,
    bool isPassword,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Nunito',
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.pink.shade400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.pink.shade400, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Nunito',
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  Widget _getInitialText() {
    String initial = widget.user.name != null && widget.user.name!.isNotEmpty
        ? widget.user.name![0].toUpperCase()
        : "?";
    
    return Center(
      child: Text(
        initial,
        style: TextStyle(
          fontSize: 64,
          fontFamily: 'BalsamiqSansBold',
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  void pickimagedialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              Text(
                "Add Profile Photo",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'BalsamiqSansBold',
                  color: Colors.pink.shade800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Choose image source",
                style: TextStyle(
                  fontFamily: 'Nunito',
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 24),

              _imageOption(
                icon: Icons.camera_alt_outlined,
                label: "Take Photo",
                onTap: () {
                  Navigator.pop(context);
                  openCamera();
                },
              ),

              const SizedBox(height: 16),

              _imageOption(
                icon: Icons.photo_library_outlined,
                label: "Choose from Gallery",
                onTap: () {
                  Navigator.pop(context);
                  openGallery();
                },
              ),

              const SizedBox(height: 16),
              
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _imageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.pink.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.pink.shade100, width: 1),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
              color: Colors.pinkAccent.shade100,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'NunitoBold',
                color: Colors.pink.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            Icon(
              Icons.chevron_right,
              color: Colors.pink.shade300,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openCamera() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  Future<void> openGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }
}