import 'package:flutter/material.dart';

class Uitools {
  Uitools() {}

  Container imgBtnTitleContainer(String title, String imgDir) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.pink[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [Text(title), SizedBox(height: 10), btn1(imgDir)],
      ),
    );
  }

  OutlinedButton btn1(String imgDir) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.teal[50],
        padding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),

      onPressed: () {},

      child: Image.asset(imgDir, width: 80.0, height: 80.0),
    );
  }
}
