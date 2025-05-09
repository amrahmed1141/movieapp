import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  Future AddUserDetails(Map<String, dynamic> userData, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userData);
  }

  Future<QuerySnapshot> getUserByEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
  }

  Future<Stream<QuerySnapshot>> getMoviesItem(String name) async {
    return await FirebaseFirestore.instance.collection(name).snapshots();
  }

  Future AddUserBookingDetails(Map<String, dynamic> userData, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('Booking')
        .add(userData);
  }

  Future<Stream<QuerySnapshot>> getUserBooking(String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('Booking')
        .snapshots();
  }

Future addQrId(String qrid) async{
  return await FirebaseFirestore.instance
      .collection('AllQrCode')
      .doc('829qQzfVQYjvrbpWXo9l')
      .update({'QRCode': FieldValue.arrayUnion([qrid])});
}




}
