import 'package:flutter/material.dart';

class AmmoScreen extends StatelessWidget {
  const AmmoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Ammo',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}