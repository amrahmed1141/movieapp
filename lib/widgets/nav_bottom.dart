import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:movieapp/constant.dart';
import 'package:movieapp/pages/users/booking.dart';
import 'package:movieapp/pages/users/home.dart';
import 'package:movieapp/pages/users/profile.dart';

class NavigationBottom extends StatefulWidget {
  const NavigationBottom({super.key});

  @override
  State<NavigationBottom> createState() => _NavigationBottomState();
}

class _NavigationBottomState extends State<NavigationBottom> {
  int currentIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late Home homePage;
  late Booking booking;
  late Profile profile;

  @override
  void initState() {
    homePage = const Home();
    booking = const Booking();
    profile = const Profile();

    pages = [homePage, booking, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: pages[currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: Container(
          decoration: BoxDecoration(
            color: appBackgroundColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: GNav(
              backgroundColor: buttonColor,
              color: Colors.white,
              activeColor: Colors.white,
              selectedIndex: currentIndex,
              rippleColor: buttonColor!,
              hoverColor: buttonColor!,
              tabShadow: [
                BoxShadow(color: buttonColor.withOpacity(0.5), blurRadius: 4)
              ],
              haptic: true,
              tabBorderRadius: 12,
              tabBackgroundColor: Colors.white.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              curve: Curves.easeInOut,
              tabMargin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              duration: const Duration(milliseconds: 300),
              iconSize: 24,
              onTabChange: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                  textStyle: TextStyle(fontSize: 12),
                ),
                GButton(
                  icon: Icons.book,
                  text: 'Booking',
                  textStyle: TextStyle(fontSize: 12),
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                  textStyle: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
