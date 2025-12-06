import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http show get;
import 'package:intl/intl.dart';
import 'package:pawpal/models/pets.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/shared/mydrawer.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //pets list
  List<Pets> listPets = [];
  //screen size
  late double screenWidth, screenHeight;
  //status
  String status = "Loading...";
  //page navigation declaration
  int numofpage = 1, curpage = 1, numofresult = 0;
  var color;
  //list image paths
  List<String> images = [];

  DateFormat formatter = DateFormat('dd/MM/yyyy hh:mm a');

  @override
  void initState() {
    super.initState();
    loadPets('');
  }

  Color getPetTypeColor(String type) {
    switch (type) {
      case 'Dog':
        return Colors.brown.shade400;
      case 'Cat':
        return Colors.orange.shade400;
      case 'Bird':
        return Colors.blue.shade400;
      case 'Rabbit':
        return Colors.green.shade400;
      case 'Fish':
        return Colors.cyan.shade400;
      default:
        return Colors.grey.shade500;
    }
  }

  Color getPetCategoryColor(String type) {
    switch (type) {
      case 'Adoption':
        return Colors.purple.shade300;
      case 'Donation Request':
        return Colors.teal.shade300;
      case 'Help/Rescue':
        return Colors.red.shade300;
      default:
        return Colors.grey.shade500;
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if (screenWidth > 600) {
      screenWidth = 600;
    } else {
      screenWidth = screenWidth;
    }

    return Scaffold(
      drawer: MyDrawer(user: widget.user),
      appBar: AppBar(
        title: Text(
          "PawPal",
          style: TextStyle(fontSize: 25, fontFamily: 'BalsamiqSansBold'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearchDialog();
            },
          ),
          IconButton(
            onPressed: () {
              loadPets('');
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: screenWidth,
          child: Column(
            children: [
              listPets.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.find_in_page_rounded, size: 64, color: Colors.pink.shade100),
                            SizedBox(height: 12),
                            Text(
                              status,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ), // space from AppBar
                        itemCount: listPets.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (listPets[index].imagePaths != null &&
                              listPets[index].imagePaths!.isNotEmpty) {
                            images = listPets[index].imagePaths!.split(', ');
                          }
                          return Card(
                            color: (index % 2 == 0)
                                ? Colors.pink.shade50
                                : const Color.fromARGB(255, 255, 201, 220), //zebra theme for card
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 85, // adjust height
                                    child: images.isEmpty
                                        ? const Center(
                                            child: Icon(
                                              Icons.broken_image_rounded,
                                              size: 70,
                                              color: Colors.pinkAccent,
                                            ),
                                          )
                                        : Center(
                                            child: Row(
                                              mainAxisSize: MainAxisSize
                                                  .min, // shrink to fit images
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: images.map((img) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                      ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    child: Image.network(
                                                      '${MyConfig.baseUrl}/pawpal/assets/petImage/$img',
                                                      width: 85,
                                                      height: 85,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                  ),
                                  const SizedBox(width: 12),

                                  //Pet Name
                                  Text(
                                    listPets[index].petName.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'NunitoBold',
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  // Pet Type
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: getPetTypeColor(
                                            listPets[index].petType.toString(),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          listPets[index].petType.toString(),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontFamily: 'Nunito',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8,), 

                                      // Category
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: getPetCategoryColor(
                                            listPets[index].category.toString(),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          listPets[index].category.toString(),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontFamily: 'Nunito',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  // Description
                                  Text(
                                    listPets[index].description.toString(),
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        85,
                                        84,
                                        84,
                                      ),
                                      fontSize: 14,
                                      fontFamily: 'Nunito',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void loadPets(String searchQuery) {
    listPets.clear();
    setState(() {
      status = 'Loading...';
    });
    http
        .get(
          Uri.parse(
            '${MyConfig.baseUrl}/pawpal/api/get_my_pets.php?user_id=${widget.user.userId}&search=$searchQuery',
          ),
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(response.body);
            if (jsonResponse['success'] == true &&
                jsonResponse['data'] != null &&
                jsonResponse['data'].isNotEmpty) {
              listPets.clear();
              for (var item in jsonResponse['data']) {
                listPets.add(Pets.fromJson(item));
              }
              setState(() {
                status = "";
              });
            } else {
              setState(() {
                listPets.clear();
                status = "No submission yet";
              });
            }
          } else {
            setState(() {
              status = "Failed to load data.";
            });
          }
        });
  }

  void showSearchDialog() {
    TextEditingController searchController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search'),
          content: TextField(
            controller: searchController,
            decoration: InputDecoration(hintText: 'Enter search query'),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Search'),
              onPressed: () {
                String search = searchController.text;
                if (search.isEmpty) {
                  loadPets('');
                } else {
                  loadPets(search);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
