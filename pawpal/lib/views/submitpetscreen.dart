import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/mainscreen.dart';

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
  List<String> categories = [
    'Adoption',
    'Donation Request',
    'Help/Rescue',
    'Other',
  ];
  //controllers
  TextEditingController petNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  //screen size
  late double width, height;
  //image
  File? image1, image2, image3; // mobile
  //default pet type and category
  String selectedPets = 'Other';
  String selectedCategory = 'Other';
  //location
  late Position location;
  //image picker
  ImagePicker picker = ImagePicker();

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
    } else {
      width = width;
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreen(user: widget.user!),
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
                  //Pet image
                  // Image preview row
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () => pickimagedialog(1),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 254, 183, 208),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: image1 != null
                                ? Image.file(image1!, fit: BoxFit.cover)
                                : Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                    color: Colors.pink.shade300,
                                  ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => pickimagedialog(2),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 254, 183, 208),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: image2 != null
                                ? Image.file(image2!, fit: BoxFit.cover)
                                : Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                    color: Colors.pink.shade300,
                                  ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => pickimagedialog(3),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 254, 183, 208),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: image3 != null
                                ? Image.file(image3!, fit: BoxFit.cover)
                                : Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                    color: Colors.pink.shade300,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),
                  //Pet Name Textfield
                  TextField(
                    controller: petNameController,
                    decoration: InputDecoration(
                      labelText: 'Pet Name',
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
                      labelText: 'Pet Type',
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
                  // Category Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Submission Category',
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
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 10),
                  // Location TextField
                  TextField(
                    maxLines: 3,
                    controller: locationController,
                    decoration: InputDecoration(
                      labelText: 'Location',
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

                  SizedBox(height: 10),
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent.shade100,
                      minimumSize: Size(width, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: () {
                      clearAll();
                    },
                    child: Text(
                      'Clear',
                      style: TextStyle(
                        color: Colors.white,
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

  void pickimagedialog(int imageNumber) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  openGallery(imageNumber);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera),
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
        descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all fields"),
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

    // Image validation: mobile uses image
    if (image1 == null && image2 == null && image3 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select an image"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validation for location
    if (locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please click the location icon to retrieve address"),
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
          title: const Text('Pet Submission'),
          content: const Text(
            'Are you sure you want to submit all the details?',
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.pinkAccent.shade100,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
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
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);

            if (resarray['success'] == true) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(resarray['message']), // Green success message
                  backgroundColor: Colors.green,
                ),
              );

              // Navigate back to main
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(user: widget.user!),
                ),
              );
            } else {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    resarray['message'] ?? "Submission failed",
                  ), // Red fail message
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
        });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //test where location service is enabled or not
      //if not
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
    descriptionController.clear();
    locationController.clear();

    setState(() {
      selectedPets = 'Other';
      selectedCategory = 'Other';
    });

    // Clear images
    image1 = null;
    image2 = null;
    image3 = null;
  }
}
