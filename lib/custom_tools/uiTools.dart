import 'package:first_flutter_app/pages/StartUpPage.dart';
import 'package:flutter/material.dart';

class Uitools {
  const Uitools();

  Widget imgBtnTitleContainer(
    String title,
    String imgDir,
    VoidCallback onPressed,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          btn1(imgDir, onPressed),
        ],
      ),
    );
  }

  OutlinedButton btn1(String imgDir, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.teal[100],
        padding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child: Image.asset(imgDir, width: 80, height: 80),
    );
  }
}
