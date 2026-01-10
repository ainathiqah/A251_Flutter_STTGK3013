import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/pets.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/shared/mydrawer.dart';
import 'package:pawpal/views/petDetailScreen.dart';
import 'package:pawpal/views/submitpetscreen.dart';

class MyPetsScreen extends StatefulWidget {
  final User user;
  const MyPetsScreen({super.key, required this.user});

  @override
  State<MyPetsScreen> createState() => _MyPetsScreenState();
}

class _MyPetsScreenState extends State<MyPetsScreen> {
  List<Pets> petList = [];
  List<Pets> filteredPets = [];
  String status = "Loading...";

  List<String> filterList = ['All', 'Cat', 'Dog', 'Rabbit'];
  String selectedFilter = 'All';

  TextEditingController searchController = TextEditingController();

  late double screenWidth, screenHeight;

  @override
  void initState() {
    super.initState();
    loadPets();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if (screenWidth > 600) {
      screenWidth = 600;
    }

    return Scaffold(
      drawer: MyDrawer(user: widget.user),
      appBar: AppBar(
        title: Text(
          'My Pets',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontFamily: 'BalsamiqSansBold',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.pinkAccent.shade100,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: Colors.white, size: 30),
            onPressed: () {
              loadPets();
            },
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: screenWidth,
          child: Column(
            children: [
              // Search and Filter Section with pink theme
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                decoration: BoxDecoration(
                  color: Colors.pinkAccent.shade100,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: searchController,
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                hintText: "Search pets...",
                                hintStyle: TextStyle(color: Colors.grey),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.pinkAccent.shade100,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                              ),
                              onChanged: (value) => applyFilters(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedFilter,
                              icon: Icon(
                                Icons.filter_list,
                                color: Colors.pinkAccent.shade100,
                              ),
                              style: TextStyle(
                                color: Colors.black87,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedFilter = newValue!;
                                });
                                applyFilters();
                              },
                              items: filterList.map<DropdownMenuItem<String>>((
                                String value,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
              Expanded(
                child: filteredPets.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.pets,
                              size: 60,
                              color: Colors.pink.shade100,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              status,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 10, bottom: 80),
                        itemCount: filteredPets.length,
                        itemBuilder: (BuildContext context, int index) {
                          List<String> images = [];
                          if (filteredPets[index].imagePaths != null &&
                              filteredPets[index].imagePaths!.isNotEmpty) {
                            images = filteredPets[index].imagePaths!.split(
                              ', ',
                            );
                          }

                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            color: (index % 2 == 0)
                                ? Colors.pink.shade50
                                : Color.fromARGB(255, 255, 201, 220),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsScreen(
                                      petData: filteredPets[index],
                                      user: widget.user,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  // Pet Image
                                  Hero(
                                    tag: "pet_${filteredPets[index].petId}",
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                      ),
                                      child: Container(
                                        width: 110,
                                        height: 110,
                                        color: Colors.grey[200],
                                        child: images.isEmpty
                                            ? Icon(
                                                Icons.pets,
                                                size: 40,
                                                color: Colors.grey[400],
                                              )
                                            : Image.network(
                                                '${MyConfig.baseUrl}/pawpal/assets/petImage/${images.first}',
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return Icon(
                                                        Icons
                                                            .image_not_supported,
                                                        size: 40,
                                                        color: Colors.grey[400],
                                                      );
                                                    },
                                              ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Details
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        horizontal: 8.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            filteredPets[index].petName
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'NunitoBold',
                                              color: Colors.pink.shade800,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: getPetTypeColor(
                                                    filteredPets[index].petType
                                                        .toString(),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  filteredPets[index].petType
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                    fontFamily: 'Nunito',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              if (filteredPets[index].petAge !=
                                                      null &&
                                                  filteredPets[index]
                                                      .petAge!
                                                      .isNotEmpty)
                                                Text(
                                                  'Age: ${filteredPets[index].petAge ?? "Not specified"}',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontFamily: 'Nunito',
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),

                                          // Adoption Status
                                          // In MyPetsScreen.dart - update the badge section:
                                          if (filteredPets[index]
                                                  .adoptionStatus ==
                                              'adopted')
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.indigo.shade400,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.pets,
                                                    size: 12,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    "Adopted",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontFamily: 'Nunito',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          else if (filteredPets[index]
                                                  .adoptionStatus ==
                                              'pending')
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors
                                                    .orange
                                                    .shade400, // Orange for pending
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.schedule,
                                                    size: 12,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    "Pending Adoption",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontFamily: 'Nunito',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: Colors.pink.shade300,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubmitPetScreen(user: widget.user),
            ),
          );
        },
        backgroundColor: Colors.pinkAccent.shade100,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Color getPetTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'dog':
        return Colors.brown.shade400;
      case 'cat':
        return Colors.orange.shade400;
      case 'bird':
        return Colors.blue.shade400;
      case 'rabbit':
        return Colors.green.shade400;
      case 'fish':
        return Colors.cyan.shade400;
      default:
        return Colors.pink.shade300;
    }
  }

  void loadPets() {
    petList.clear();
    setState(() {
      status = 'Loading...';
    });

    http
        .get(
          Uri.parse(
            '${MyConfig.baseUrl}/pawpal/api/get_my_pets.php?user_id=${widget.user.userId}',
          ),
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(response.body);
            if (jsonResponse['success'] == true &&
                jsonResponse['data'] != null &&
                jsonResponse['data'].isNotEmpty) {
              petList.clear();
              for (var item in jsonResponse['data']) {
                petList.add(Pets.fromJson(item));
              }
              setState(() {
                filteredPets = List.from(petList);
                status = "";
              });
              applyFilters();
            } else {
              setState(() {
                petList.clear();
                filteredPets.clear();
                status = "No pets available";
              });
            }
          } else {
            setState(() {
              status = "Failed to load data.";
            });
          }
        })
        .catchError((error) {
          setState(() {
            status = "Error: ${error.toString()}";
          });
        });
  }

  void applyFilters() {
    String searchText = searchController.text.toLowerCase();

    setState(() {
      filteredPets = petList.where((pet) {
        bool matchesSearch =
            pet.petName!.toLowerCase().contains(searchText) ||
            searchText.isEmpty;

        bool matchesFilter =
            selectedFilter == "All" ||
            pet.petType!.toLowerCase() == selectedFilter.toLowerCase();

        return matchesSearch && matchesFilter;
      }).toList();

      status = filteredPets.isEmpty ? "No matching pets found" : "";
    });
  }
}
