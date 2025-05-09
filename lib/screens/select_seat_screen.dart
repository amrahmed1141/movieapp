import 'dart:convert';
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
import 'package:movieapp/widgets/seat_widget.dart';

class SelectSeatScreen extends StatefulWidget {
  final String movieName, movieImage, movieCategory, movieDetails, moviePrice;
  
  const SelectSeatScreen({
    super.key,
    required this.movieName,
    required this.movieImage,
    required this.movieCategory,
    required this.movieDetails,
    required this.moviePrice,
  });

  @override
  State<SelectSeatScreen> createState() => _SelectSeatScreenState();
}

class _SelectSeatScreenState extends State<SelectSeatScreen> {
  final selectedSeat = ValueNotifier<List<String>>([]);
  int _selectedDateIndex = -1;
  int _selectedTimeIndex = -1;
  String? currentDate, currentTime;
  String? id, userName;
  Map<String, dynamic>? paymentIntent;

  getTheSharedPref() async {
    id = await SharedPrefercenceHelper().getUserId();
    userName = await SharedPrefercenceHelper().getUserName();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
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

  String calculateTotalPrice() {
    final basePrice = int.parse(widget.moviePrice);
    final seatCount = selectedSeat.value.length;
    return (basePrice * seatCount).toString();
  }

  @override
  Widget build(BuildContext context) {
    final dates = getFormattedDates();
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Movie Booking',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: appBackgroundColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ValueListenableBuilder<List<String>>(
            valueListenable: selectedSeat,
            builder: (context, value, _) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      color: buttonColor,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      alignment: Alignment.center,
                      child: Text(
                        "Screen",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    for (int i = 1; i <= 6; i++) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int j = 1; j <= 8; j++) ...[
                            SeatWidget(
                              seatNumber: '${String.fromCharCode(i + 64)}$j',
                              width: (MediaQuery.of(context).size.width - 48 - 66) / 8,
                              height: (MediaQuery.of(context).size.width - 48 - 66) / 8,
                              isAvailable: i != 6,
                              isSelected: value.contains('${String.fromCharCode(i + 64)}$j'),
                              onTap: () {
                                if (value.contains('${String.fromCharCode(i + 64)}$j')) {
                                  selectedSeat.value = List.from(value)
                                    ..remove('${String.fromCharCode(i + 64)}$j');
                                } else {
                                  selectedSeat.value = List.from(value)
                                    ..add('${String.fromCharCode(i + 64)}$j');
                                }
                              },
                            ),
                            if (j != 8) SizedBox(width: j == 4 ? 16 : 6),
                          ]
                        ],
                      ),
                      if (i != 6) const SizedBox(height: 7),
                    ],
                    const Expanded(child: SizedBox()),
                    const SeatInfoWidget()
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(48)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Select date',
                      style: TextStyle(
                        color: buttonColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: SizedBox(
                      height: 85,
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
                                    : Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  dates[index],
                                  style: TextStyle(
                                    color: _selectedDateIndex == index
                                        ? Colors.black
                                        : buttonColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: SizedBox(
                      height: 45,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: time.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedTimeIndex = index;
                                currentTime = time[index].time;
                              });
                            },
                            child: Container(
                              width: 90,
                              margin: const EdgeInsets.symmetric(horizontal: 10.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 9.0),
                              decoration: BoxDecoration(
                                color: _selectedTimeIndex == index
                                    ? buttonColor
                                    : Colors.white,
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
                                        : buttonColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ValueListenableBuilder<List<String>>(
                          valueListenable: selectedSeat,
                          builder: (context, value, _) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '\$${calculateTotalPrice()}',
                                  style: const TextStyle(
                                    color: buttonColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 34,
                                  ),
                                ),
                                if (value.isNotEmpty)
                                  Text(
                                    '${value.length} seats selected',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        MaterialButton(
                          onPressed: () {
                            if (selectedSeat.value.isNotEmpty) {
                              makePayment(calculateTotalPrice());
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please select at least one seat"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          color: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          child: const Text(
                            'Book Now',
                            style: TextStyle(color: white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'USD');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent?['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Amr'))
          .then((value) {});

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
          'Movie': widget.movieName,
          'movieImage': widget.movieImage,
          'Price': amount,
          'Seats': selectedSeat.value.join(', '),
          'Date': currentDate,
          'Time': currentTime,
          'QR': uid,
          'user': userName
        };
        await DatabaseService().AddUserBookingDetails(userBooking, id!);
        await DatabaseService().addQrId(uid);
       
        FocusScope.of(context).unfocus();

        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Booking Successfully"),
            duration: Duration(seconds: 2),
          ),
        );

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

        setState(() {});

        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error: $error \nStackTrace: $stackTrace');
      });
    } on StripeException catch (e) {
      print('StripeException: $e');

      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

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
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }
} 