import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
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
                          child:
                              Image.asset('assets/image/icon.png', height: 15),
                        ),
                        ListTile(
                          onTap: () {},
                          horizontalTitleGap: 0.0,
                          leading: Image.asset(
                            'assets/image/dashboard.png',
                            color: Colors.white54,
                            height: 16,
                          ),
                          title: const Text('DashBoard'),
                        ),
                        ListTile(
                          onTap: () {},
                          horizontalTitleGap: 0.0,
                          leading: Image.asset(
                            'assets/image/adduser.png',
                            color: Colors.white54,
                            height: 16,
                          ),
                          title: const Text('Add User'),
                        ),
                        ListTile(
                          onTap: () {},
                          horizontalTitleGap: 0.0,
                          leading: Image.asset(
                            'assets/image/dashboard.png',
                            color: Colors.white54,
                            height: 16,
                          ),
                          title: const Text('DashBoard'),
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
