import 'package:flutter/material.dart';

class AddUser extends StatelessWidget {
  const AddUser({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Add User",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const Expanded(
                      child: TextField(
                    decoration: InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        )),
                  ))
                ],
              )
            ],
          )),
    );
  }
}
