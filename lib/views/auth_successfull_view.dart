import 'package:flutter/material.dart';

class auth_successfull_view extends StatelessWidget {
  const auth_successfull_view({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'authentication_successfull',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}
