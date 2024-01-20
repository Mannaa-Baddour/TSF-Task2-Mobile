import 'package:banking_app/pages/customers.dart';
import 'package:flutter/material.dart';
import 'package:banking_app/pages/home.dart';

class RootPage extends StatefulWidget {
  final int page;

  const RootPage({Key? key, this.page=0}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  late int currentPage;
  List<Widget> pages = const [
    HomePage(),
    CustomersPage(),
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      currentPage = widget.page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "BankIO",
          style: TextStyle(
              color: Color(0xFF00214E),
              fontSize: 36,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              shadows: [
                Shadow(
                  color: Color(0xFF282460),      // Choose the color of the shadow
                  blurRadius: 2.0,          // Adjust the blur radius for the shadow effect
                  offset: Offset(2.0, 2.0), // Set the horizontal and vertical offset for the shadow
                ),
              ]
          ),
        ),
      ),
      body: pages[currentPage],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_rounded),
            label: "Customers",
          ),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}