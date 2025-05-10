import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/pages/admin/QrScannerWidget.dart';

class QrPage extends StatefulWidget {
  const QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  final String collectionName = 'AllQrCode';
  final String documentId = '829qQzfVQYjvrbpWXo9l';
  final String arrayName = 'QRCode';
  List<dynamic>? array;

  Future<List?> fetchQrCode() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(documentId)
          .get();
      if (snapshot.exists) {
        array = snapshot[arrayName];
        return array;
      } else {
        throw 'documnet doesnt exist';
      }
    } catch (e) {
      print('Error fetching QR code: $e');
      return [];
    }
  }

  @override
  void initState() {
    fetchQrCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: const EdgeInsets.only(top: 95),
          child: Column(
            children: [
              Image.asset(
                'assets/images/qr-code.png',
                width: 500,
                height: 500,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 60,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              QrCodeScanner(qrcodedata: array!)));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Button color
                  foregroundColor: Colors.white, // Text color
                  padding: const EdgeInsets.symmetric(
                      horizontal: 60, vertical: 20), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  elevation: 3, // Button shadow
                ),
                child: const Text(
                  "Scan QR code",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )),
    );
  }
}
