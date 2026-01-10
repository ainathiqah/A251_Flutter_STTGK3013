import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/shared/mydrawer.dart';
import 'package:intl/intl.dart';

class DonationHistory extends StatefulWidget {
  final User user;
  const DonationHistory({super.key, required this.user});

  @override
  State<DonationHistory> createState() => _DonationHistoryState();
}

class _DonationHistoryState extends State<DonationHistory> {
  List<Map<String, dynamic>> donationList = [];
  List<Map<String, dynamic>> filteredDonations = [];
  String status = "Loading...";
  bool isLoading = true;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadDonationHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(user: widget.user),
      appBar: AppBar(
        title: Text(
          'Donation History',
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
              loadDonationHistory();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Section with pink theme (same as MainScreen)
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
                      hintText: "Search donations...",
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
                : filteredDonations.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.volunteer_activism,
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
                    itemCount: filteredDonations.length,
                    itemBuilder: (BuildContext context, int index) {
                      final donation = filteredDonations[index];
                      return donationCard(donation, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget donationCard(Map<String, dynamic> donation, int index) {
    Color getDonationTypeColor(String type) {
      switch (type.toLowerCase()) {
        case 'food':
          return Colors.orange.shade400;
        case 'medical':
          return Colors.red.shade400;
        case 'shelter':
          return Colors.blue.shade400;
        default:
          return Colors.teal.shade400;
      }
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: (index % 2 == 0)
          ? Colors.pink.shade50
          : Color.fromARGB(255, 255, 201, 220),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Type and Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: getDonationTypeColor(donation['donation_type']),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    donation['donation_type'],
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'NunitoBold',
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  "RM ${double.parse(donation['amount'].toString()).toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink.shade800,
                    fontFamily: 'NunitoBold',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Description
            if (donation['description'] != null &&
                donation['description'].toString().isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    donation['description'],
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      fontFamily: 'Nunito',
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),

            // Pet Info (if available)
            if (donation['pet_name'] != null)
              Row(
                children: [
                  Icon(Icons.pets, size: 18, color: Colors.pink.shade600),
                  const SizedBox(width: 8),
                  Text(
                    "For: ${donation['pet_name']}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.pink.shade700,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 12),

            // Footer with Date and ID
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  formatDate(donation['donation_date']),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.pink.shade600,
                    fontFamily: 'NunitoBold',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadDonationHistory() async {
    setState(() {
      isLoading = true;
      status = "Loading...";
    });

    try {
      final response = await http.get(
        Uri.parse(
          '${MyConfig.baseUrl}/pawpal/api/get_donation_history.php?user_id=${widget.user.userId}',
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['success'] == true) {
          donationList = List<Map<String, dynamic>>.from(jsonResponse['data']);
          setState(() {
            filteredDonations = List.from(donationList);
            status = donationList.isEmpty ? "No donations found" : "";
            isLoading = false;
          });
          applyFilters();
        } else {
          setState(() {
            donationList = [];
            filteredDonations = [];
            status = jsonResponse['message'] ?? "No donations found";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          status = "Failed to load donation history";
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
      filteredDonations = donationList.where((donation) {
        return searchText.isEmpty ||
            (donation['description'] != null &&
                donation['description'].toString().toLowerCase().contains(
                  searchText,
                )) ||
            (donation['pet_name'] != null &&
                donation['pet_name'].toString().toLowerCase().contains(
                  searchText,
                )) ||
            (donation['donation_type'] != null &&
                donation['donation_type'].toString().toLowerCase().contains(
                  searchText,
                ));
      }).toList();

      status = filteredDonations.isEmpty ? "No matching donations found" : "";
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
