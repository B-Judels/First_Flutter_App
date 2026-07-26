import 'package:flutter/material.dart';

class Uitools {
  Uitools() {}

  Container imgBtnTitleContainer(String title, String imgDir) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 1.0),
      ),
      child: Column(
        children: [Text(title), SizedBox(height: 10), btn1(imgDir)],
      ),
    );
  }

  OutlinedButton btn1(String imgDir) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.teal[100],
        padding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),

      onPressed: () {},

      child: Image.asset(imgDir, width: 80.0, height: 80.0),
    );
  }
}
