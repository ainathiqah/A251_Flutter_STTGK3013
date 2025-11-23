import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/loginscreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  late double height, width;
  bool passwordVisible = true;
  bool confirmPasswordVisible = true;
  bool isLoading = false;
  late User user;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    print(width);
    if (width > 400) {
      width = 400;
    } else {
      width = width;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: SizedBox(
              width: width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset('assets/images/pawpal.png', scale: 2),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person, color: Colors.pinkAccent.shade100),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email, color: Colors.pinkAccent.shade100),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: passwordController,
                    obscureText: passwordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock, color: Colors.pinkAccent.shade100),
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (passwordVisible) {
                            passwordVisible = false;
                          } else {
                            passwordVisible = true;
                          }
                          setState(() {});
                        },
                        icon: Icon(Icons.visibility),
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: confirmPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock, color: Colors.pinkAccent.shade100),
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (confirmPasswordVisible) {
                            confirmPasswordVisible = false;
                          } else {
                            confirmPasswordVisible = true;
                          }
                          setState(() {});
                        },
                        icon: Icon(Icons.visibility),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      prefixIcon: Icon(Icons.phone, color: Colors.pinkAccent.shade100),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent.shade100,
                      ),
                      onPressed: registerDialog,
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account?  ',
                        style: TextStyle(color: Colors.brown.shade800),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: Colors.pinkAccent.shade100,
                              fontWeight: FontWeight.w700,
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
        ),
      ),
    );
  }

  void registerDialog() {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String phone = phoneController.text.trim();

    // Validate non-empty, valid email, password length ≥ 6
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        phone.isEmpty) {
      SnackBar snackBar = const SnackBar(
        content: Text('Please fill in all fields'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if (password != confirmPassword) {
      SnackBar snackBar = const SnackBar(
        content: Text('Passwords do not match'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      SnackBar snackBar = const SnackBar(
        content: Text('Please enter a valid email address'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters long'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
      SnackBar snackBar = const SnackBar(
        content: Text('Phone number must contain digits only'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Register this account?'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.pinkAccent.shade100,
            ),
            onPressed: () {
              Navigator.pop(context);
              registerUser(name, email, password, phone);
            },
            child: Text('Register', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.pinkAccent.shade100,
            ),
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
        content: Text('Are you sure you want to register this account?'),
      ),
    );
  }

  void registerUser(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    setState(() {
      isLoading = true;
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Registering...'),
            ],
          ),
        );
      },
      barrierDismissible: false,
    );
    await http
        .post(
          Uri.parse('${MyConfig.baseUrl}/pawpal/api/register_user.php'),
          body: {
            'name': name,
            'email': email,
            'password': password,
            'phone': phone,
          },
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            //print(jsonResponse);
            if (resarray['status'] == 'success') {
              if (!mounted) return;
              SnackBar snackBar = const SnackBar(
                content: Text('Registration successful'),
                backgroundColor: Colors.green,
              );
              if (isLoading) {
                if (!mounted) return;
                Navigator.pop(context); // Close the loading dialog
                setState(() {
                  isLoading = false;
                });
              }
              Navigator.pop(context); // Close the registration dialog
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            } else {
              if (!mounted) return;
              SnackBar snackBar = SnackBar(content: Text(resarray['message']));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          } else {
            if (!mounted) return;
            SnackBar snackBar = const SnackBar(
              content: Text('Registration failed. Please try again.'),
              backgroundColor: Colors.red,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        })
        .timeout(
          Duration(seconds: 10),
          onTimeout: () {
            if (!mounted) return;
            SnackBar snackBar = const SnackBar(
              content: Text('Request timed out. Please try again.'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        );

    if (isLoading) {
      if (!mounted) return;
      Navigator.pop(context); // Close the loading dialog
      setState(() {
        isLoading = false;
      });
    }
  }
}
