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

  OutlinedButton itemRemoveBtn(VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.red[100],
        shape: const CircleBorder(),

        padding: EdgeInsets.zero,
        minimumSize: const Size(40, 40),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Image.asset("images/trash.png", width: 15, height: 15),
    );
  }

  OutlinedButton itemEditBtn(VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.green[100],
        shape: const CircleBorder(),

        padding: EdgeInsets.zero,
        minimumSize: const Size(40, 40),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Image.asset("images/pencil.png", width: 15, height: 15),
    );
  }
}
