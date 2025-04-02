import 'package:cramx_v0_0_1/auth/auth_service.dart';
import 'package:cramx_v0_0_1/pages/dashboard_page.dart';
import 'package:cramx_v0_0_1/pages/generatecards_page.dart';
import 'package:cramx_v0_0_1/pages/login_page.dart';
import 'package:cramx_v0_0_1/pages/profile_page.dart';
import 'package:cramx_v0_0_1/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authService = AuthService();
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    DashboardPage(),
    GeneratecardsPage(),
    ProfilePage(),
  ];

  final List<String> _titles = [
    "Dashboard",
    "Create New Deck",
    "Profile"
  ];

  void logout() async {
    await authService.signOut();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Color backgroundColor = isDarkMode ? Color(0xFF202123) : Color(0xFFF7F7F8);
    Color appBarColor = isDarkMode ? Color(0xFF202123) : Color(0xFFF7F7F8);
    Color textColor = isDarkMode ? Color(0xFFECECF1) : Color(0xFF2C2C2F);
    Color iconColor = textColor;
    Color navBarColor = isDarkMode ? Color(0xFF202123) : Color(0xFFF7F7F8);
    Color activeTabColor = Color(0xFF10A37F);
    Color tabBackgroundColor = isDarkMode ? Color(0xFF444654) : Color(0xFFE0E0E5);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(_titles[_selectedIndex], style: TextStyle(color: textColor)),
        backgroundColor: appBarColor,
        iconTheme: IconThemeData(color: iconColor),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'info',
                child: SizedBox(
                  width: 100,
                  child: Text('More Info')
                ) 
              ),
              const PopupMenuItem(
                child: SizedBox(
                  width: 100,
                  child: Text('Log out')
                )
              )
            ]
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: isDarkMode ? Color(0xFF202123) : Color(0xFFF7F7F8),
              ),
              child: Image.asset(
                isDarkMode ? 'assets/logo_dark.jpg' : 'assets/logo_light.jpg',
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: iconColor),
              title: Text('Settings', style: TextStyle(color: textColor)),
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder:  (context) => SettingsPage())
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: iconColor),
              title: Text('More Info', style: TextStyle(color: textColor)),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Version 1.0.7",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: Container(
        color: navBarColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: GNav(
            backgroundColor: navBarColor,
            color: iconColor,
            activeColor: activeTabColor,
            tabBackgroundColor: tabBackgroundColor,
            gap: 8,
            padding: const EdgeInsets.all(12),
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              });
            },
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.add_circle_outline,
                text: 'New Deck',
              ),
              GButton(
                icon: Icons.person,
                text: "Profile",
              )
            ],
          ),
        ),
      ),
    );
  }
}
