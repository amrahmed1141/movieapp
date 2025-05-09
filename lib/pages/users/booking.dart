import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/constant.dart';
import 'package:movieapp/services/firebase/database.dart';
import 'package:movieapp/services/locals/shared_preference.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  Stream? bookignStream;

  String? id, userName;

  getTheSharedPref() async {
    id = await SharedPrefercenceHelper().getUserId();
    userName = await SharedPrefercenceHelper().getUserName();
    setState(() {});
  }

  getOnTheLoad() async {
    await getTheSharedPref();
    bookignStream = await DatabaseService().getUserBooking(id!);
    setState(() {});
  }

  @override
  void initState() {
    getOnTheLoad();
    super.initState();
  }

  Widget allBooking() {
    return StreamBuilder(
      stream: bookignStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Container(
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(children: [
                      Center(
                        child: QrImageView(
                          data: ds['QR'],
                          version: QrVersions.auto,
                          size: 120,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              ds['movieImage'],
                              fit: BoxFit.fill,
                              width: 100,
                              height: 100,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    ds['user'],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.movie),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    ds['Movie'],
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.group),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        ds['Seats'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.monetization_on),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        ds['Price'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.alarm),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    ds['Time'],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.calendar_month),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    ds['Date'],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      )
                    ]),
                  );
                })
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
          margin: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              const Center(
                child: Text(
                  'Booking',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                  child: Container(
                      padding:
                          const EdgeInsets.only(left: 10, top: 20, right: 10),
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          color: appBackgroundColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              topLeft: Radius.circular(30))),
                      child: Column(
                        children: [Expanded(child: allBooking())],
                      )))
            ],
          )),
    );
  }
}
