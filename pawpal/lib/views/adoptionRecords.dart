import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/shared/mydrawer.dart';
import 'package:intl/intl.dart';

class AcceptAdoption extends StatefulWidget {
  final User user;
  const AcceptAdoption({super.key, required this.user});

  @override
  State<AcceptAdoption> createState() => _AcceptAdoptionState();
}

class _AcceptAdoptionState extends State<AcceptAdoption> {
  List<Map<String, dynamic>> adoptionList = [];
  List<Map<String, dynamic>> filteredAdoptions = [];
  String status = "Loading...";
  bool isLoading = true;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAdoptionRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(user: widget.user),
      appBar: AppBar(
        title: Text(
          'Adoption Records',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontFamily: 'BalsamiqSansBold',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.pinkAccent.shade100,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white, size: 30),
            onPressed: () {
              loadAdoptionRequests();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Section
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
                Container(
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
                      hintText: "Search requests...",
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.pinkAccent.shade100,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Colors.pinkAccent.shade100,
                              ),
                              onPressed: () {
                                searchController.clear();
                                applyFilters();
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) => applyFilters(),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),

          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.pinkAccent.shade100,
                    ),
                  )
                : filteredAdoptions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.pets,
                                size: 60, color: Colors.pink.shade100),
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
                        itemCount: filteredAdoptions.length,
                        itemBuilder: (BuildContext context, int index) {
                          final request = filteredAdoptions[index];
                          return adoptionCard(request, index);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget adoptionCard(Map<String, dynamic> request, int index) {
    String adoptionStatus = request['adoption_status'] ?? 'pending';
    bool isOwner = (request['owner_id']?.toString() ==
        widget.user.userId?.toString());

    Color getStatusColor(String status) {
      switch (status) {
        case 'adopted':
          return Colors.green;
        case 'rejected':
          return Colors.red;
        case 'cancelled':
          return Colors.grey;
        case 'pending':
        default:
          return Colors.orange;
      }
    }

    String getStatusText(String status) {
      switch (status) {
        case 'adopted':
          return "ADOPTED";
        case 'rejected':
          return "REJECTED";
        case 'cancelled':
          return "CANCELLED";
        case 'pending':
        default:
          return "PENDING";
      }
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: adoptionStatus == 'adopted'
          ? Colors.green.shade50
          : adoptionStatus == 'rejected'
              ? Colors.red.shade50
              : adoptionStatus == 'cancelled'
                  ? Colors.grey.shade100
                  : (index % 2 == 0)
                      ? Colors.pink.shade50
                      : Color.fromARGB(255, 255, 201, 220),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Pet Name and Role
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request['pet_name'] ?? "Unknown Pet",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink.shade800,
                          fontFamily: 'NunitoBold',
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${request['pet_type'] ?? 'Pet'} • Age: ${request['pet_age'] ?? 'Age not specified'}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ],
                  ),
                ),
                // User Role Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isOwner ? Colors.purple.shade400 : Colors.teal.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isOwner ? "MY PET" : "I REQUESTED",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'NunitoBold',
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Status Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: getStatusColor(adoptionStatus).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: getStatusColor(adoptionStatus)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    adoptionStatus == 'adopted'
                        ? Icons.check_circle
                        : adoptionStatus == 'rejected'
                            ? Icons.cancel
                            : adoptionStatus == 'cancelled'
                                ? Icons.block
                                : Icons.hourglass_empty,
                    color: getStatusColor(adoptionStatus),
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    getStatusText(adoptionStatus),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: getStatusColor(adoptionStatus),
                      fontFamily: 'NunitoBold',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // User Info
            Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      isOwner ? Colors.purple.shade200 : Colors.teal.shade200,
                  radius: 16,
                  child: Icon(
                    isOwner ? Icons.pets : Icons.person,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isOwner
                            ? "Requester: ${request['requester_name'] ?? 'Unknown'}"
                            : "Owner: ${request['owner_name'] ?? 'Unknown'}",
                        style: TextStyle(
                          fontSize: 15,
                          color: isOwner
                              ? Colors.purple.shade700
                              : Colors.teal.shade700,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isOwner && request['requester_email'] != null)
                        Text(
                          request['requester_email'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            fontFamily: 'Nunito',
                          ),
                        ),
                      if (!isOwner && request['owner_email'] != null)
                        Text(
                          request['owner_email'] ?? 'No email provided',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            fontFamily: 'Nunito',
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            // Motivation Message
            if (request['motivation'] != null &&
                request['motivation'].isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    isOwner ? "Requester's message:" : "Your message:",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      fontFamily: 'NunitoBold',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.pink.shade100),
                    ),
                    child: Text(
                      request['motivation'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),

            // Footer with Date
            const SizedBox(height: 8),
            Container(
              padding: EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Requested: ${formatDate(request['request_date'])}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.pink.shade600,
                      fontFamily: 'NunitoBold',
                    ),
                  ),
                  if (adoptionStatus == 'pending' && isOwner)
                    Text(
                      "Waiting for your action",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade600,
                        fontFamily: 'NunitoBold',
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadAdoptionRequests() async {
    setState(() {
      isLoading = true;
      status = "Loading...";
    });

    try {
      final response = await http.get(
        Uri.parse(
          '${MyConfig.baseUrl}/pawpal/api/get_adoption_requests.php?user_id=${widget.user.userId}',
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['success'] == true) {
          adoptionList = List<Map<String, dynamic>>.from(jsonResponse['data']);
          setState(() {
            filteredAdoptions = List.from(adoptionList);
            status = adoptionList.isEmpty ? "No adoption records found" : "";
            isLoading = false;
          });
          applyFilters();
        } else {
          setState(() {
            adoptionList = [];
            filteredAdoptions = [];
            status = jsonResponse['message'] ?? "No records found";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          status = "Failed to load records";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        status = "Error: $e";
        isLoading = false;
      });
    }
  }

  void applyFilters() {
    String searchText = searchController.text.toLowerCase();

    setState(() {
      filteredAdoptions = adoptionList.where((request) {
        return searchText.isEmpty ||
            (request['pet_name'] != null &&
                request['pet_name'].toString().toLowerCase().contains(
                      searchText,
                    )) ||
            (request['requester_name'] != null &&
                request['requester_name'].toString().toLowerCase().contains(
                      searchText,
                    )) ||
            (request['owner_name'] != null &&
                request['owner_name'].toString().toLowerCase().contains(
                      searchText,
                    )) ||
            (request['pet_type'] != null &&
                request['pet_type'].toString().toLowerCase().contains(
                      searchText,
                    )) ||
            (request['motivation'] != null &&
                request['motivation'].toString().toLowerCase().contains(
                      searchText,
                    )) ||
            (request['adoption_status'] != null &&
                request['adoption_status'].toString().toLowerCase().contains(
                      searchText,
                    ));
      }).toList();

      status = filteredAdoptions.isEmpty ? "No matching records found" : "";
    });
  }

  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}