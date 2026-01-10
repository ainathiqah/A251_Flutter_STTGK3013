import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/pets.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/mainscreen.dart';

class DonationScreen extends StatefulWidget {
  final User? user; // nullable for guest
  final Pets? petData;
  const DonationScreen({super.key, required this.user, required this.petData});

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  // Donation form variables
  String? selectedDonationType;
  TextEditingController donationAmountController = TextEditingController();
  TextEditingController donationDescriptionController = TextEditingController();
  String? validationMessage;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    // Get images
    List<String> images = [];
    if (widget.petData?.imagePaths != null &&
        widget.petData!.imagePaths!.isNotEmpty) {
      images = widget.petData!.imagePaths!.split(', ');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Donation",
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

              // Pet Image
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
                      // Pet Type and Age
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
                      const SizedBox(height: 16),

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
              const SizedBox(height: 24),

              // Check if user can donate
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
                          "This is your own pet. You cannot donate to yourself.",
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
                              "Please login to make a donation.",
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
                // User can donate - show form
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Make a Donation",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'BalsamiqSansBold',
                        color: Colors.pink.shade800,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Choose how you want to help ${widget.petData?.petName ?? "this pet"}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontFamily: 'Nunito',
                      ),
                    ),
                    SizedBox(height: 20),

                    // Donation Type Selection
                    Text(
                      "Donation Type *",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nunito',
                        color: Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(height: 10),

                    // Donation Type Buttons
                    Row(
                      children: [
                        Expanded(
                          child: donationTypeButton(
                            type: 'Food',
                            icon: Icons.restaurant,
                            selected: selectedDonationType == 'Food',
                            onTap: () {
                              setState(() {
                                selectedDonationType = 'Food';
                                donationAmountController.clear();
                                validationMessage = null;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: donationTypeButton(
                            type: 'Medical',
                            icon: Icons.medical_services,
                            selected: selectedDonationType == 'Medical',
                            onTap: () {
                              setState(() {
                                selectedDonationType = 'Medical';
                                donationAmountController.clear();
                                validationMessage = null;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: donationTypeButton(
                            type: 'Money',
                            icon: Icons.money,
                            selected: selectedDonationType == 'Money',
                            onTap: () {
                              setState(() {
                                selectedDonationType = 'Money';
                                donationDescriptionController.clear();
                                validationMessage = null;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Conditional Fields based on Donation Type
                    if (selectedDonationType == 'Money')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Amount (RM) *",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito',
                              color: Colors.grey.shade800,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: donationAmountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Enter amount in RM",
                              prefixIcon: Icon(
                                Icons.attach_money,
                                color: Colors.pink.shade300,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.pink.shade200,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.pink.shade400,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 16,
                            ),
                            onChanged: (value) {
                              setState(() {
                                validationMessage = null;
                              });
                            },
                          ),
                        ],
                      )
                    else if (selectedDonationType == 'Food' ||
                        selectedDonationType == 'Medical')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Description *",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito',
                              color: Colors.grey.shade800,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "What ${selectedDonationType?.toLowerCase()} donation are you providing?",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontFamily: 'Nunito',
                            ),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: donationDescriptionController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText:
                                  "e.g., 5kg dog food, flea treatment, vaccination",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.pink.shade200,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.pink.shade400,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 16,
                            ),
                            onChanged: (value) {
                              setState(() {
                                validationMessage = null;
                              });
                            },
                          ),
                        ],
                      ),

                    SizedBox(height: 20),

                    // Validation message
                    if (validationMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          validationMessage!,
                          style: TextStyle(
                            color: Colors.red.shade600,
                            fontFamily: 'Nunito',
                            fontSize: 14,
                          ),
                        ),
                      ),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isSubmitting
                            ? null
                            : () {
                                _validateAndSubmitDonation();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: _isSubmitting
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                "Submit Donation",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'NunitoBold',
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
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

  Widget donationTypeButton({
    required String type,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? Colors.pinkAccent.shade100 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Colors.pinkAccent.shade200 : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? Colors.white : Colors.grey.shade600),
            SizedBox(height: 8),
            Text(
              type,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
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
      default:
        return Colors.grey.shade500;
    }
  }

  void _validateAndSubmitDonation() {
    setState(() {
      validationMessage = null;
    });

    if (selectedDonationType == null) {
      setState(() {
        validationMessage = "Please select a donation type";
      });
      return;
    }

    if (selectedDonationType == 'Money') {
      if (donationAmountController.text.isEmpty) {
        setState(() {
          validationMessage = "Please enter donation amount";
        });
        return;
      }

      double? amount = double.tryParse(donationAmountController.text);
      if (amount == null || amount <= 0) {
        setState(() {
          validationMessage = "Please enter a valid amount";
        });
        return;
      }
    } else if (selectedDonationType == 'Food' ||
        selectedDonationType == 'Medical') {
      if (donationDescriptionController.text.isEmpty) {
        setState(() {
          validationMessage = "Please enter donation description";
        });
        return;
      }

      if (donationDescriptionController.text.length < 5) {
        setState(() {
          validationMessage = "Description should be at least 5 characters";
        });
        return;
      }
    }

    showDonationConfirmationDialog();
  }

  void showDonationConfirmationDialog() {
    String details = '';

    if (selectedDonationType == 'Money') {
      details = 'Amount: RM${donationAmountController.text}';
    } else {
      details = 'Description: ${donationDescriptionController.text}';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Confirm Donation",
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
                "Are you sure you want to submit ${selectedDonationType?.toLowerCase()} donation for ${widget.petData?.petName ?? "this pet"}?",
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                details,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
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
                style: TextStyle(color: Colors.grey.shade800),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.pinkAccent.shade100,
              ),
              onPressed: () {
                Navigator.pop(context);
                submitDonation();
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

  Future<void> submitDonation() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      Map<String, String> body = {
        'user_id': widget.user!.userId.toString(),
        'pet_id': widget.petData!.petId.toString(),
        'donation_type': selectedDonationType!,
        'status': 'pending',
        'donation_date': DateTime.now().toString(),
      };

      if (selectedDonationType == 'Money') {
        body['amount'] = donationAmountController.text;
        body['description'] =
            'Monetary donation: RM${donationAmountController.text}';
      } else {
        body['description'] = donationDescriptionController.text;
        body['amount'] = '0'; // For food/medical, amount is 0
      }

      final response = await http.post(
        Uri.parse('${MyConfig.baseUrl}/pawpal/api/submit_donation.php'),
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Donation submitted successfully!',
                style: TextStyle(fontFamily: 'Nunito'),
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );

          // Clear form
          setState(() {
            selectedDonationType = null;
            donationAmountController.clear();
            donationDescriptionController.clear();
          });

          // Navigate back to home screen after delay
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreen(user: widget.user!),
              ),
            );
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                jsonResponse['message'] ?? 'Donation submission failed',
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
              'Failed to submit donation. Please try again.',
              style: TextStyle(fontFamily: 'Nunito'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e', style: TextStyle(fontFamily: 'Nunito')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  void dispose() {
    donationAmountController.dispose();
    donationDescriptionController.dispose();
    super.dispose();
  }
}
