import 'package:flutter/material.dart';

class MyGoalWalletScreen extends StatefulWidget {
  const MyGoalWalletScreen({super.key});

  @override
  State<MyGoalWalletScreen> createState() => _MyGoalWalletScreenState();
}

class _MyGoalWalletScreenState extends State<MyGoalWalletScreen> {
  //read and control the inputs: target amount, saving per week, starting balance
  TextEditingController targetAmount = TextEditingController();
  TextEditingController saving = TextEditingController();
  TextEditingController balance = TextEditingController();
  //declare the default goal type
  String selectGoalType = "Others";

  //declaration for track if a field has an error
  bool targetError = false;
  bool savingError = false;
  bool balanceError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Goal Wallet App',
          style: TextStyle(
            color: Colors.brown.shade900,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.amber[50],
        elevation: 0, //remove default shadow (to blend with the background)
      ),
      //Container
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.brown.shade200, width: 3),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            width: 450,

            //Text Title
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "My Goal Wallet Saving Calculator",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade800,
                  ),
                ),
                SizedBox(height: 18),

                //TextField Target amount
                Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        "Target Amount",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade800,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 250, // fixed width for the TextField
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: targetAmount,
                        onChanged: (value) {
                          if (targetError &&
                              double.tryParse(value) != null &&
                              double.tryParse(value)! > 0) {
                            setState(() => targetError = false);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Enter your target amount",
                          hintStyle: TextStyle(fontSize: 14),
                          //when the field is NOT focused
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: targetError
                                  ? Colors.red.shade400
                                  : Colors.brown.shade400,
                              width: 2,
                            ),
                          ),
                          //when the user is typing (field focused)
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: targetError
                                  ? Color.fromARGB(255, 207, 58, 56)
                                  : Colors.brown.shade400,
                              width: 2,
                            ),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/target.png',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),

                //TextField Saving per Week
                Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        "Saving per Week",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade800,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: saving,
                        onChanged: (value) {
                          if (savingError &&
                              double.tryParse(value) != null &&
                              double.tryParse(value)! > 0) {
                            setState(() => savingError = false);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Enter your planning saving",
                          hintStyle: TextStyle(fontSize: 14),
                          //when the field is NOT focused
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: savingError
                                  ? Colors.red.shade400
                                  : Colors.brown.shade400,
                              width: 2,
                            ),
                          ),
                          //when the user is typing (field focused)
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: savingError
                                  ? Color.fromARGB(255, 207, 58, 56)
                                  : Colors.brown.shade400,
                              width: 2,
                            ),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/saving.png',
                              width: 25,
                              height: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),

                //TextField Balance
                Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        "Starting Balance",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade800,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: balance,
                        onChanged: (value) {
                          if (balanceError &&
                              double.tryParse(value) != null &&
                              double.tryParse(value)! >= 0) {
                            setState(() => balanceError = false);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Enter your starting balance",
                          hintStyle: TextStyle(fontSize: 14),
                          //when the field is NOT focused
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: balanceError
                                  ? Colors.red.shade400
                                  : Colors.brown.shade400,
                              width: 2,
                            ),
                          ),
                          //when the user is typing (field focused)
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: balanceError
                                  ? const Color.fromARGB(255, 207, 58, 56)
                                  : Colors.brown.shade400,
                              width: 2,
                            ),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/start.png',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),

                //DropDownButton Goal type
                Row(
                  children: [
                    Text(
                      "Goal Type",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown.shade800,
                      ),
                    ),
                    SizedBox(width: 45),
                    DropdownButton<String>(
                      value: selectGoalType,
                      items:
                          <String>[
                            'Emergency Funds',
                            'Vacation',
                            'Gadget',
                            'Education',
                            'Others',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        selectGoalType = newValue!;
                        setState(() {});
                      },
                    ),
                  ],
                ),
                SizedBox(height: 15),

                //ElevatedButton Calculate
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => calculateWeeks(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown.shade800,
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Calculate',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),

                    //ElevatedButton Reset
                    ElevatedButton(
                      onPressed: () {
                        targetAmount.clear();
                        saving.clear();
                        balance.clear();
                        selectGoalType = 'Others';
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown.shade800,
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Reset',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void calculateWeeks() {
    //updating the declaration earlier at the class level. (rebuild the UI)
    setState(() {
      targetError = false;
      savingError = false;
      balanceError = false;
    });

    //convert the string to a number
    //invalid or empty input is treated as 0 (must be >0)
    double target = double.tryParse(targetAmount.text) ?? 0;
    double savePerWeek = double.tryParse(saving.text) ?? 0; //must be >0
    double? startBalance = double.tryParse(balance.text); //allow 0

    //error handling
    bool hasError = false;

    if (target <= 0) {
      targetError = true;
      hasError = true; //to mark that validation failed
    }

    if (savePerWeek <= 0) {
      savingError = true;
      hasError = true;
    }

    if (startBalance == null || startBalance < 0) {
      balanceError = true;
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    //calculation part
    //how much more money is needed to reach the target
    double remaining = target - startBalance!;
    //exact number of weeks needed to reach the target
    double exactWeeks = remaining / savePerWeek;
    //floor(whole number of weeks (drops the decimal)
    int fullWeeks = exactWeeks.floor();
    int extraDays = ((exactWeeks - fullWeeks) * 7).ceil();

    //output result (already reached the target)
    if (remaining <= 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.amber[50],
          title: Text(
            "Goal Status",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.brown.shade800,
            ),
          ),
          content: Text(
            "You already reached your target.",
            style: TextStyle(fontSize: 14, color: Colors.brown.shade900),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'OK',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
    //output result (weeks needed)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.amber[50],
        title: Text(
          "Goal Calculation Result",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.brown.shade800,
          ),
        ),
        content: Text(
          "Weeks needed to reach RM ${target.toStringAsFixed(2)} for $selectGoalType:\n"
          "$fullWeeks week(s) + $extraDays day(s)",
          style: TextStyle(fontSize: 14, color: Colors.brown.shade900),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown.shade800, // brown color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'OK',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
