import 'package:foodapp/pages/admin/admin_login.dart';
import 'package:foodapp/pages/checkout.dart';
import 'package:foodapp/pages/homepages.dart';
import 'package:foodapp/pages/order.dart';
import 'package:foodapp/pages/profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});
  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late HomePages home;
  late Profile profile;
  late AdminLogin adminLogin;
  late CheckOut checkOut;
  late Order order;

  @override
  void initState() {
    // final user = Provider.of<UserProvider>(context, listen: false);
    home = HomePages();
    profile = Profile();
    adminLogin = AdminLogin();
    checkOut = CheckOut();
    order = Order(
      // userId: user.getUidData(),
    );
    pages = [home, checkOut, order,  profile, adminLogin,];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          height: 60,
          color: Colors.transparent,
          buttonBackgroundColor: Color.fromARGB(255, 11, 226, 154),
          backgroundColor: Colors.transparent,
          animationDuration: Duration(milliseconds: 300),
          onTap: (int index) {
            setState(() {
              currentTabIndex = index;
            });
          },
          items: [
            Icon(
              Icons.home_outlined,
              size: 30,
              color: Colors.black,
            ),
            Icon(
              Icons.shopping_cart,
              size: 30,
              color: Colors.black,
            ),
            Icon(
              Icons.wallet_giftcard_outlined,
              size: 30,
              color: Colors.black,
            ),
            Icon(
              Icons.person_outlined,
              size: 30,
              color: Colors.black,
            ),
            Icon(
              Icons.admin_panel_settings_rounded,
              size: 30,
              color: Colors.black,
            ),
          ]),
      body: pages[currentTabIndex],
    );
  }
}
