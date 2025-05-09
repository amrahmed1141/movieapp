/*import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';
import 'package:movieapp/constant.dart';
import 'package:movieapp/constants/stripe.dart';
import 'package:movieapp/model/time.dart';
import 'package:movieapp/services/firebase/database.dart';
import 'package:movieapp/services/locals/shared_preference.dart';
import 'package:random_string/random_string.dart';

class Details extends StatefulWidget {
  final String name, image, category, details, price;
  Details(
      {required this.name,
      required this.image,
      required this.category,
      required this.details,
      required this.price});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int quantity = 1, total = 0;
  int _selectedDateIndex = -1;
  int _selectedTimeIndex = -1;

  String? currentDate, currentTime;

  String? id, userName;

  getTheSharedPref() async {
    id = await SharedPrefercenceHelper().getUserId();
    userName = await SharedPrefercenceHelper().getUserName();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    total = int.parse(widget.price);
    getTheSharedPref();
  }

  List<String> getFormattedDates() {
    final now = DateTime.now();
    final formatter = DateFormat('EEE d');
    return List.generate(7, (index) {
      final date = now.add(Duration(days: index));
      return formatter.format(date);
    });
  }

  Map<String, dynamic>? paymentIntent;
  @override
  Widget build(BuildContext context) {
    final dates = getFormattedDates();
    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: Container(
          child: Stack(
        children: [
          Image.network(
            widget.image,
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Container(
            margin: const EdgeInsets.only(left: 30, top: 45),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: appBackgroundColor,
                borderRadius: BorderRadius.circular(30)),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 2.4),
              decoration: const BoxDecoration(
                  color: appBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30))),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.category,
                      style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.details,
                      style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: dates.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDateIndex = index;
                                currentDate = dates[index];
                              });
                            },
                            child: Container(
                              width: 60,
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: _selectedDateIndex == index
                                      ? buttonColor
                                      : grey),
                              child: Center(
                                child: Text(dates[index],
                                    style: TextStyle(
                                        color: _selectedDateIndex == index
                                            ? Colors.black
                                            : Colors.white)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: time.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedTimeIndex = index;
                                currentTime = time[index].time;
                                // Update selected index
                              });
                            },
                            child: Container(
                              width: 90,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 9.0),
                              decoration: BoxDecoration(
                                color: _selectedTimeIndex == index
                                    ? buttonColor
                                    : grey,
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                  color: Colors.white54,
                                  width: 1.0,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  time[index].time,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: _selectedTimeIndex == index
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white)),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  quantity = quantity + 1;
                                  total = total + int.parse(widget.price);
                                  setState(() {});
                                },
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                quantity.toString(),
                                style: const TextStyle(
                                    fontSize: 21,
                                    color: buttonColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (quantity > 1) {
                                    quantity = quantity - 1;
                                    total = total - int.parse(widget.price);
                                    setState(() {});
                                  }
                                },
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            makePayment(total.toString());
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                                color: buttonColor,
                                borderRadius: BorderRadius.circular(25)),
                            child: Column(children: [
                              Text(
                                '\$' + total.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Book Now',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ]),
                          ),
                        )
                      ],
                    )
                  ]),
            ),
          )
        ],
      )),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'USD');
      //Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent?['client_secret'],
                  // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
                  // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Amr'))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet(amount);
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet(String amount) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        String uid = randomAlphaNumeric(5);
        Map<String, dynamic> userBooking = {
          'Movie': widget.name,
          'movieImage': widget.image,
          'Price': total.toString(),
          'Quantity': quantity.toString(),
          'Date': currentDate,
          'Time': currentTime,
          'QR': uid,
          'user':userName
        };
        await DatabaseService().AddUserBookingDetails(userBooking, id!);
        await DatabaseService().addQrId(uid);
       
        // Remove any focus to prevent unwanted highlights
        FocusScope.of(context).unfocus();

        // Close any existing overlays/dialogs before proceeding
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Booking Successfully"),
            duration: Duration(seconds: 2),
          ),
        );

        // Show success dialog
        showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text("Payment Successful"),
                  ],
                ),
              ],
            ),
          ),
        );

        // Force UI update to remove any yellow highlights
        setState(() {});

        // Reset paymentIntent after completion
        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error: $error \nStackTrace: $stackTrace');
      });
    } on StripeException catch (e) {
      print('StripeException: $e');

      // Close any existing overlays/dialogs
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      // Show cancellation message
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Text("Payment Cancelled"),
        ),
      );
    } catch (e) {
      print('Unexpected Error: $e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretkey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;

    return calculatedAmout.toString();
  }
}*/
