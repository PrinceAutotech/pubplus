import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Dashboard extends StatelessWidget {
  const Dashboard(
      {super.key,});
  //
  // final String title, svgSrc;
  //
  // final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Drawer(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DrawerHeader(
                        child: Image.asset('assets/image/icon.png',
                        height: 15),
                      ),
                      ListTile(
                        onTap: () {},
                        horizontalTitleGap: 0.0,
                        leading: Image.asset(
                          "assets/image/dashboard.png",
                          color: Colors.white54,
                          height: 16,
                        ),
                        title: const Text("DashBoard"),
                      ),
                      ListTile(
                        onTap: () {},
                        horizontalTitleGap: 0.0,
                        leading: Image.asset(
                          "assets/image/adduser.png",
                          color: Colors.white54,
                          height: 16,
                        ),
                        title: const Text("Add User"),
                      ),
                      ListTile(
                        onTap: () {},
                        horizontalTitleGap: 0.0,
                        leading: Image.asset(
                          "assets/image/dashboard.png",
                          color: Colors.white54,
                          height: 16,
                        ),
                        title: const Text("DashBoard"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                color: Colors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }
}
