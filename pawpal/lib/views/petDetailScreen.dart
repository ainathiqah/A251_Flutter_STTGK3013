import 'package:flutter/material.dart';
import 'package:pawpal/models/pets.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/adoptionScreen.dart';
import 'package:pawpal/views/donationScreen.dart';

class DetailsScreen extends StatefulWidget {
  final User? user; // nullable for guest
  final Pets? petData;
  const DetailsScreen({super.key, required this.user, required this.petData});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    // Get images
    List<String> images = [];
    if (widget.petData?.imagePaths != null &&
        widget.petData!.imagePaths!.isNotEmpty) {
      images = widget.petData!.imagePaths!.split(', ');
    }

    // Determine which button to show based on category
    final category = widget.petData?.category?.toLowerCase() ?? '';
    final isAdoptionCategory = category == 'adoption';
    final isDonationCategory =
        category == 'donation request' || category == 'help/rescue';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pet Details",
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'BalsamiqSansBold',
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.pinkAccent.shade100,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Pet Image - This handles 1-4 images nicely
              SizedBox(
                height: images.length == 1
                    ? 250
                    : 200, // Taller for single image
                child: images.isNotEmpty
                    ? images.length == 1
                          ? Center(
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.grey.shade100,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 10,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      '${MyConfig.baseUrl}/pawpal/assets/petImage/${images[0]}',
                                      fit: BoxFit.cover,
                                      height: 250,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.pink.shade300,
                                              ),
                                            );
                                          },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              height: 250,
                                              color: Colors.grey.shade200,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.image_not_supported,
                                                      size: 50,
                                                      color:
                                                          Colors.grey.shade400,
                                                    ),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      'Image not available',
                                                      style: TextStyle(
                                                        color: Colors
                                                            .grey
                                                            .shade500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : GridView.count(
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: images.length <= 2 ? 2 : 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 1,
                              children: images.map((image) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.shade100,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      '${MyConfig.baseUrl}/pawpal/assets/petImage/$image',
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.pink.shade300,
                                              ),
                                            );
                                          },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey.shade200,
                                              child: Center(
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  size: 30,
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
                    : Center(
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80),
                            color: Colors.pink.shade100,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.pink.shade100,
                                Colors.pink.shade200,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pink.withOpacity(0.3),
                                blurRadius: 15,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.pets,
                            size: 70,
                            color: Colors.pink.shade400,
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 20),

              // Pet Name with Style
              Center(
                child: Text(
                  widget.petData?.petName ?? "Unknown Pet",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'BalsamiqSansBold',
                    color: Colors.pink.shade800,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Pet Details Card
              Card(
                color: Colors.pink.shade50,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pet Type, Age and Category Chips
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          detailChip(
                            icon: Icons.pets,
                            text: widget.petData?.petType ?? 'default',
                            color: getPetTypeColor(widget.petData?.petType),
                          ),
                          detailChip(
                            icon: Icons.cake,
                            text: widget.petData?.petAge ?? 'Not specified',
                            color: Colors.green.shade400,
                          ),
                          detailChip(
                            icon: Icons.category,
                            text: widget.petData?.category ?? 'Adoption',
                            color: getCategoryColor(widget.petData?.category),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Description
                      Text(
                        "About ${widget.petData?.petName ?? "this pet"}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NunitoBold',
                          color: Colors.pink.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.petData?.description ??
                            'No description available',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 85, 84, 84),
                          fontFamily: 'Nunito',
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Posted By (only for logged in users)
                      if (widget.user != null)
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue.shade100),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.person, color: Colors.blue.shade700),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Posted by",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue.shade600,
                                        fontFamily: 'Nunito',
                                      ),
                                    ),
                                    Text(
                                      widget.petData?.userId ==
                                              widget.user?.userId
                                          ? "You"
                                          : widget.petData?.name ??
                                                'Unknown Owner',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade800,
                                        fontFamily: 'NunitoBold',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // ACTION BUTTONS SECTION
              Text(
                "What would you like to do?",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BalsamiqSansBold',
                  color: Colors.pink.shade800,
                ),
              ),
              SizedBox(height: 20),

              // Check if user can adopt/donate
              if (widget.petData?.userId == widget.user?.userId)
                // User owns this pet
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange.shade700),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "This is your own pet. You cannot adopt or donate to your own pet.",
                          style: TextStyle(
                            color: Colors.orange.shade800,
                            fontFamily: 'Nunito',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else if (widget.user == null)
                // Guest user
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.amber.shade700,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Please login to adopt or donate",
                              style: TextStyle(
                                color: Colors.amber.shade800,
                                fontFamily: 'Nunito',
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Navigate to login screen - you'll need to handle this
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Login Now",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'NunitoBold',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                // User can adopt/donate - show appropriate button based on category
                Column(
                  children: [
                    // For Adoption category
                    if (isAdoptionCategory)
                      Column(
                        children: [
                          if (widget.petData?.adoptionStatus == 'adopted')
                            // Pet is already adopted
                            Container(
                              margin: EdgeInsets.only(bottom: 16),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.pets,
                                      size: 50,
                                      color: Colors.indigo.shade400,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "This pet has been adopted",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.indigo.shade700,
                                        fontFamily: 'NunitoBold',
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Adopted by ${widget.user?.name ?? 'someone'}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                        fontFamily: 'Nunito',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else if (widget.petData?.adoptionStatus == 'pending')
                            // Pet has pending adoption request
                            Container(
                              margin: EdgeInsets.only(bottom: 16),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.orange.shade200,
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.schedule,
                                      size: 50,
                                      color: Colors.orange.shade400,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Adoption Request Pending",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.orange.shade700,
                                        fontFamily: 'NunitoBold',
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "This pet has pending adoption requests.\nThe owner is reviewing them.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.orange.shade600,
                                        fontFamily: 'Nunito',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else if (widget.petData?.adoptionStatus ==
                              'available')
                            // Pet is available for adoption - show adopt button
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdoptionScreen(
                                        user: widget.user!,
                                        petData: widget.petData,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pinkAccent.shade100,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.favorite, color: Colors.white),
                                    SizedBox(width: 10),
                                    Text(
                                      "Request to Adopt",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'NunitoBold',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          SizedBox(height: 10),
                        ],
                      ),

                    // Show Donate button for Donation/Help/Rescue category
                    if (isDonationCategory)
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DonationScreen(
                                  user: widget.user!,
                                  petData: widget.petData,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.volunteer_activism,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Donate",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'NunitoBold',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Show message if category doesn't match any action
                    if (!isAdoptionCategory && !isDonationCategory)
                      Container(
                        margin: EdgeInsets.only(bottom: 16),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Center(
                          child: Text(
                            "No actions available for this category",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontFamily: 'Nunito',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                    SizedBox(height: 10),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget detailChip({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.only(right: 4),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
              fontFamily: 'Nunito',
            ),
          ),
        ],
      ),
    );
  }

  Color getPetTypeColor(String? type) {
    switch (type?.toLowerCase()) {
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
        return Colors.grey.shade500;
    }
  }

  Color getCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'adoption':
        return Colors.purple.shade300;
      case 'donation request':
        return Colors.teal.shade300;
      case 'help/rescue':
        return Colors.red.shade300;
      case 'help':
        return Colors.red.shade300;
      case 'rescue':
        return Colors.red.shade300;
      default:
        return Colors.grey.shade500;
    }
  }

  // NEW: Helper functions for adoption status
  Color getAdoptionStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'adopted':
        return Colors.indigo.shade400;
      case 'pending':
        return Colors.orange.shade400;
      case 'available':
        return Colors.green.shade400;
      default:
        return Colors.grey.shade500;
    }
  }

  IconData getAdoptionStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'adopted':
        return Icons.pets;
      case 'pending':
        return Icons.schedule;
      case 'available':
        return Icons.favorite;
      default:
        return Icons.pets;
    }
  }

  String getAdoptionStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'adopted':
        return "Adopted";
      case 'pending':
        return "Pending Review";
      case 'available':
        return "Available for Adoption";
      default:
        return "Status Unknown";
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
