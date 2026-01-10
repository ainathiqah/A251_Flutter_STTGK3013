import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/myPetScreen.dart';

class SubmitPetScreen extends StatefulWidget {
  final User? user;
  const SubmitPetScreen({super.key, required this.user});

  @override
  State<SubmitPetScreen> createState() => _SubmitPetScreenState();
}

class _SubmitPetScreenState extends State<SubmitPetScreen> {
  late User user;
  //list of pet types and categories
  List<String> petTypes = ['Dog', 'Cat', 'Bird', 'Rabbit', 'Fish', 'Other'];
  List<String> categories = ['Adoption', 'Donation Request', 'Help/Rescue'];
  List<String> genderOptions = ['Male', 'Female', 'Unknown'];
  List<String> healthOptions = [
    'Healthy',
    'Minor Issues',
    'Medical Treatment Needed',
    'Special Needs',
    'Unknown',
  ];

  //controllers
  TextEditingController petNameController = TextEditingController();
  TextEditingController petAgeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  //screen size
  late double width, height;

  //image
  File? image1, image2, image3; // mobile

  //default selections
  String selectedPets = 'Other';
  String selectedCategory = 'Adoption';
  String selectedGender = 'Unknown';
  String selectedHealth = 'Healthy';

  //location
  late Position location;

  //image picker
  ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    if (width > 600) {
      width = 600;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MyPetsScreen(user: widget.user!),
              ),
            );
          },
        ),
        title: Text(
          "Pet Submission",
          style: TextStyle(fontSize: 25, fontFamily: 'BalsamiqSansBold'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),

                  // Image preview row
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildImageContainer(1),
                        _buildImageContainer(2),
                        _buildImageContainer(3),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),

                  // Pet Name Textfield
                  TextField(
                    controller: petNameController,
                    decoration: InputDecoration(
                      labelText: 'Pet Name *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Pet Type Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedPets,
                    decoration: InputDecoration(
                      labelText: 'Pet Type *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    items: petTypes.map((String selectPet) {
                      return DropdownMenuItem<String>(
                        value: selectPet,
                        child: Text(selectPet),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPets = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 10),

                  // Pet Age TextField
                  TextField(
                    controller: petAgeController,
                    decoration: InputDecoration(
                      labelText: 'Pet Age (e.g., 2 years) *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Gender Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    decoration: InputDecoration(
                      labelText: 'Gender *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    items: genderOptions.map((String gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGender = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 10),

                  // Health Condition Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedHealth,
                    decoration: InputDecoration(
                      labelText: 'Health Condition *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    items: healthOptions.map((String health) {
                      return DropdownMenuItem<String>(
                        value: health,
                        child: Text(health),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedHealth = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 10),

                  // Category Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Submission Category *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    items: categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 10),

                  // Description TextField
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description *',
                      hintText:
                          'Describe the pet\'s personality, habits, special needs...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    maxLines: 4,
                  ),
                  SizedBox(height: 10),

                  // Location TextField
                  TextField(
                    maxLines: 3,
                    controller: locationController,
                    decoration: InputDecoration(
                      labelText: 'Location *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.location_on_rounded,
                          color: Colors.pinkAccent.shade100,
                        ),
                        onPressed: () async {
                          location = await _determinePosition();
                          List<Placemark> placemarks =
                              await placemarkFromCoordinates(
                                location.latitude,
                                location.longitude,
                              );
                          Placemark place = placemarks[0];
                          locationController.text =
                              "${place.street},\n${place.postalCode},${place.locality},\n${place.administrativeArea}, ${place.country}";
                          setState(() {});
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Submit Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent.shade100,
                      minimumSize: Size(width, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: () {
                      showSubmitDialog();
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

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
                      clearAll();
                    },
                    child: Text(
                      'Clear All',
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
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

  Widget _buildImageContainer(int imageNumber) {
    return GestureDetector(
      onTap: () => pickimagedialog(imageNumber),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 254, 183, 208)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: _getImage(imageNumber) != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(_getImage(imageNumber)!, fit: BoxFit.cover),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      size: 30,
                      color: Colors.pink.shade300,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Image $imageNumber",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.pink.shade300,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  File? _getImage(int imageNumber) {
    switch (imageNumber) {
      case 1:
        return image1;
      case 2:
        return image2;
      case 3:
        return image3;
      default:
        return null;
    }
  }

  void pickimagedialog(int imageNumber) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Image $imageNumber'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.image, color: Colors.pink.shade300),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  openGallery(imageNumber);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera, color: Colors.pink.shade300),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  openCamera(imageNumber);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> openGallery(int imageNumber) async {
    final picker = ImagePicker();

    // limit to 3 images
    if (image1 != null && image2 != null && image3 != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can only select up to 3 images'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked == null) return;

    setState(() {
      if (imageNumber == 1) {
        image1 = File(picked.path);
      } else if (imageNumber == 2) {
        image2 = File(picked.path);
      } else if (imageNumber == 3) {
        image3 = File(picked.path);
      }
    });
  }

  Future<void> openCamera(int imageNumber) async {
    final picker = ImagePicker();

    final XFile? picked = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (picked == null) return;

    setState(() {
      if (imageNumber == 1) {
        image1 = File(picked.path);
      } else if (imageNumber == 2) {
        image2 = File(picked.path);
      } else if (imageNumber == 3) {
        image3 = File(picked.path);
      }
    });
  }

  void showSubmitDialog() {
    // Validation for empty fields
    if (petNameController.text.trim().isEmpty ||
        petAgeController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all required fields (*)"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validation for age
    if (petAgeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter pet age"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validation for description
    if (descriptionController.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Description must be at least 10 characters"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Image validation
    if (image1 == null && image2 == null && image3 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select at least one image"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Confirm dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Submit Pet Details',
            style: TextStyle(
              fontFamily: 'BalsamiqSansBold',
              color: Colors.pink.shade800,
            ),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text('Are you sure you want to submit this pet?',
            style: TextStyle(fontFamily: 'Nunito', fontSize: 16),),
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
                style: TextStyle(color: Colors.grey.shade800),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.pinkAccent.shade100,
              ),
              onPressed: () {
                Navigator.pop(context);
                submitPet();
              },
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void submitPet() async {
    String petName = petNameController.text.trim();
    String petType = selectedPets;
    String petCategory = selectedCategory;
    String petAge = petAgeController.text.trim();
    String petGender = selectedGender;
    String petHealth = selectedHealth;
    String description = descriptionController.text.trim();
    String img1 = "";
    String img2 = "";
    String img3 = "";

    if (image1 != null) {
      img1 = base64Encode(image1!.readAsBytesSync());
    }
    if (image2 != null) {
      img2 = base64Encode(image2!.readAsBytesSync());
    }
    if (image3 != null) {
      img3 = base64Encode(image3!.readAsBytesSync());
    }

    http
        .post(
          Uri.parse('${MyConfig.baseUrl}/pawpal/api/submit_pet.php'),
          body: {
            'user_id': widget.user!.userId.toString(),
            'pet_name': petName,
            'pet_type': petType,
            'pet_age': petAge,
            'pet_gender': petGender, // Added gender
            'pet_health': petHealth, // Added health condition
            'category': petCategory,
            'description': description,
            'image1': img1,
            'image2': img2,
            'image3': img3,
            'lat': location.latitude.toString(),
            'lng': location.longitude.toString(),
          },
        )
        .then((response) {
          print(response.body);

          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(response.body);

            if (jsonResponse['success'] == true) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    jsonResponse['message'] ?? 'Pet submitted successfully!',
                  ),
                  backgroundColor: Colors.green,
                ),
              );

              // Navigate back to my pets screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyPetsScreen(user: widget.user!),
                ),
              );
            } else {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(jsonResponse['message'] ?? "Submission failed"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } else {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Submit pets failed: ${response.statusCode}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        })
        .catchError((error) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: $error"),
              backgroundColor: Colors.red,
            ),
          );
        });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  void clearAll() {
    // Clear all text fields
    petNameController.clear();
    petAgeController.clear();
    descriptionController.clear();
    locationController.clear();

    // Reset dropdowns
    setState(() {
      selectedPets = 'Other';
      selectedCategory = 'Adoption';
      selectedGender = 'Unknown';
      selectedHealth = 'Healthy';
    });

    // Clear images
    setState(() {
      image1 = null;
      image2 = null;
      image3 = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All fields cleared'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
